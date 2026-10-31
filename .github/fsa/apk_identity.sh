#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later
# Record actual APK identity; incomplete or unverifiable identity is not success.
# Usage: apk_identity.sh <apk-search-directory|apk-file> [variant-label]
set -uo pipefail

if (( $# < 1 )); then
    echo "usage: $0 <apk-search-directory|apk-file> [variant-label]" >&2
    exit 64
fi

target=$1
variant=${2:-unknown}
evidence_dir=${FSA_EVIDENCE_DIR:-fsa-evidence}
mkdir -p "$evidence_dir"
out="$evidence_dir/apk-identity.txt"
{
    echo "# FSA-00R1 APK identity"
    echo "captured_utc=$(date -u +%FT%TZ)"
    echo "git_sha=$(git rev-parse HEAD 2>/dev/null || echo unknown)"
    echo "variant_label=${variant} (caller-supplied; verify against build output)"
    echo "search_target=${target}"
} > "$out"

apks=()
if [[ -f "$target" ]]; then
    apks=("$target")
elif [[ -d "$target" ]]; then
    while IFS= read -r file; do apks+=("$file"); done < <(find "$target" -maxdepth 2 -type f -name '*.apk' | sort)
fi
if (( ${#apks[@]} == 0 )); then
    echo 'result=NOT_PRODUCED' >> "$out"
    cat "$out"
    exit 1
fi

build_tools_dir=""
sdk=${ANDROID_HOME:-${ANDROID_SDK_ROOT:-}}
if [[ -n "$sdk" && -d "$sdk/build-tools" ]]; then
    build_tools_dir=$(find "$sdk/build-tools" -maxdepth 1 -mindepth 1 -type d | sort -V | tail -n 1)
fi
result=0
for apk in "${apks[@]}"; do
    {
        echo
        echo "apk_path=${apk}"
        echo "size_bytes=$(wc -c < "$apk" | tr -d ' ')"
        echo "sha256=$(sha256sum "$apk" | awk '{print $1}')"
    } >> "$out"
    if [[ -x "$build_tools_dir/aapt2" ]]; then
        badging=$("$build_tools_dir/aapt2" dump badging "$apk" 2>&1)
        status=$?
        printf '%s\n' "$badging" >> "$out"
        if (( status != 0 )) || ! grep -Eq "^package: name='[^']+' versionCode='[^']+' versionName='[^']+'" <<< "$badging"; then
            echo 'badging=INCOMPLETE_OR_FAILED' >> "$out"
            result=1
        fi
    else
        echo 'badging=UNAVAILABLE (aapt2 missing)' >> "$out"
        result=1
    fi
    if [[ -x "$build_tools_dir/apksigner" ]]; then
        certs=$("$build_tools_dir/apksigner" verify --print-certs "$apk" 2>&1)
        status=$?
        printf '%s\n' "$certs" >> "$out"
        dn_count=$(grep -ciE '^Signer #[0-9]+ certificate DN:' <<< "$certs" || true)
        digest_count=$(grep -ciE '^Signer #[0-9]+ certificate SHA-256 digest: ([0-9a-f]{64}|([0-9a-f]{2}:){31}[0-9a-f]{2})[[:space:]]*$' <<< "$certs" || true)
        non_debug=$(grep -iE '^Signer #[0-9]+ certificate DN:' <<< "$certs" | grep -cvi 'CN=Android Debug' || true)
        if (( status != 0 || dn_count == 0 || digest_count != dn_count )); then
            echo 'signature=INCOMPLETE_OR_FAILED' >> "$out"
            result=1
        elif (( non_debug != 0 )); then
            echo 'signature=DEBUG_CERTIFICATE_NOT_CONFIRMED' >> "$out"
            result=1
        else
            echo 'signature=VERIFIED_DEBUG_DN (compare fingerprint against expected debug key; DN alone does not prove key provenance)' >> "$out"
        fi
    else
        echo 'signature=UNAVAILABLE (apksigner missing)' >> "$out"
        result=1
    fi
done
if (( result == 0 )); then
    echo "result=IDENTITY_CAPTURED (${#apks[@]} apk file(s); provenance requires independent review)" >> "$out"
else
    echo 'result=IDENTITY_INCOMPLETE_OR_FAILED' >> "$out"
fi
cat "$out"
exit "$result"
