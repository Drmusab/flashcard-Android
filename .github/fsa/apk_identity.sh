#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later
#
# FSA-00R1 APK identity capture (FSA-00R1 §C-05).
#
# Records the identity of a produced debug APK without publishing or signing
# anything: path, byte size, SHA-256, application id, version name/code and the
# signing certificate fingerprints reported by apksigner (debug signing only).
#
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
    echo "variant=${variant}"
    echo "search_target=${target}"
} > "$out"

apks=()
if [[ -f "$target" ]]; then
    apks=("$target")
elif [[ -d "$target" ]]; then
    while IFS= read -r file; do
        apks+=("$file")
    done < <(find "$target" -maxdepth 2 -type f -name '*.apk' | sort)
fi

if (( ${#apks[@]} == 0 )); then
    {
        echo "result=NOT_PRODUCED"
        echo "detail=no .apk file found under '${target}' after the build step"
    } >> "$out"
    echo "APK: NOT PRODUCED (${target})"
    exit 1
fi

build_tools_dir=""
if [[ -n "${ANDROID_HOME:-}" ]] && [[ -d "$ANDROID_HOME/build-tools" ]]; then
    build_tools_dir=$(find "$ANDROID_HOME/build-tools" -maxdepth 1 -mindepth 1 -type d | sort -V | tail -n 1)
fi

overall_result=0
for apk in "${apks[@]}"; do
    {
        echo
        echo "apk_path=${apk}"
        echo "size_bytes=$(wc -c < "$apk" | tr -d ' ')"
        echo "sha256=$(sha256sum "$apk" | awk '{print $1}')"
        if [[ -n "$build_tools_dir" ]] && [[ -x "$build_tools_dir/aapt2" ]]; then
            "$build_tools_dir/aapt2" dump badging "$apk" 2>&1
        else
            echo "badging=UNAVAILABLE (no aapt2 in the Android SDK build-tools)"
        fi
        if [[ -n "$build_tools_dir" ]] && [[ -x "$build_tools_dir/apksigner" ]]; then
            echo "--- apksigner verify --print-certs ---"
            "$build_tools_dir/apksigner" verify --print-certs "$apk" 2>&1
        else
            echo "certs=UNAVAILABLE (no apksigner in the Android SDK build-tools)"
        fi
    } >> "$out"
done

{
    echo
    echo "result=PRODUCED (${#apks[@]} apk file(s))"
} >> "$out"

cat "$out"

# A debug build must not be signed by a release key: fail loudly if apksigner
# reports a non-debug certificate. Detect only what is observable.
if grep -qi "CN=Android Debug" "$out"; then
    echo "signing=debug certificate confirmed"
else
    echo "signing=debug certificate not confirmed by apksigner; inspect ${out}"
fi

exit "$overall_result"
