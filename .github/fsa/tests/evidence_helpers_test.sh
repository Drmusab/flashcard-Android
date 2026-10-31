#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later
# Isolated helper tests with synthetic APK/tools; not Android build evidence.
set -euo pipefail
root=$(git rev-parse --show-toplevel)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
export FSA_EVIDENCE_DIR="$tmp/evidence" ANDROID_HOME="$tmp/sdk"
mkdir -p "$ANDROID_HOME/build-tools/1" "$tmp/apks"
printf 'not a real apk\n' > "$tmp/apks/test.apk"
helper="$root/.github/fsa/apk_identity.sh"
if bash "$helper" "$tmp/absent" FullDebug >/dev/null; then echo 'missing APK accepted' >&2; exit 1; fi
if bash "$helper" "$tmp/apks" FullDebug >/dev/null; then echo 'missing tools accepted' >&2; exit 1; fi
cat > "$ANDROID_HOME/build-tools/1/aapt2" <<'SCRIPT'
#!/bin/bash
echo "package: name='com.example.debug' versionCode='1' versionName='1'"
SCRIPT
cat > "$ANDROID_HOME/build-tools/1/apksigner" <<'SCRIPT'
#!/bin/bash
echo 'Signer #1 certificate DN: CN=Android Debug, O=Android, C=US'
echo 'Signer #1 certificate SHA-256 digest: 0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef'
SCRIPT
chmod +x "$ANDROID_HOME/build-tools/1/"*
bash "$helper" "$tmp/apks" FullDebug >/dev/null
grep -q 'result=IDENTITY_CAPTURED' "$FSA_EVIDENCE_DIR/apk-identity.txt"
cat >> "$ANDROID_HOME/build-tools/1/apksigner" <<'SCRIPT'
echo 'Signer #2 certificate DN: CN=Other, O=Example'
echo 'Signer #2 certificate SHA-256 digest: 0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef'
SCRIPT
if bash "$helper" "$tmp/apks" FullDebug >/dev/null; then echo 'mixed signers accepted' >&2; exit 1; fi
sed -i '/Signer #2/d' "$ANDROID_HOME/build-tools/1/apksigner"
sed -i 's/CN=Android Debug/CN=Other/' "$ANDROID_HOME/build-tools/1/apksigner"
if bash "$helper" "$tmp/apks" FullDebug >/dev/null; then echo 'non-debug DN accepted' >&2; exit 1; fi
sed -i 's/CN=Other/CN=Android Debug/; $a exit 1' "$ANDROID_HOME/build-tools/1/apksigner"
if bash "$helper" "$tmp/apks" FullDebug >/dev/null; then echo 'failed apksigner accepted' >&2; exit 1; fi
rm "$ANDROID_HOME/build-tools/1/apksigner"
cat > "$ANDROID_HOME/build-tools/1/apksigner" <<'SCRIPT'
#!/bin/bash
echo 'Signer #1 certificate DN: CN=Android Debug, O=Android, C=US'
echo 'Signer #1 certificate SHA-256 digest: 0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef'
SCRIPT
chmod +x "$ANDROID_HOME/build-tools/1/apksigner"
echo 'exit 1' >> "$ANDROID_HOME/build-tools/1/aapt2"
if bash "$helper" "$tmp/apks" FullDebug >/dev/null; then echo 'failed aapt2 accepted' >&2; exit 1; fi
harness="$root/.github/fsa/run_evidence_command.sh"
bash "$harness" gradle-version printf 'Gradle 9.8.0\n' >/dev/null
bash "$harness" retry printf 'first\n' >/dev/null
if bash "$harness" retry bash -c 'echo second; exit 7' >/dev/null; then echo 'failure exit lost' >&2; exit 1; fi
grep -q 'Gradle 9.8.0' "$FSA_EVIDENCE_DIR/commands.tsv"
grep -q first "$FSA_EVIDENCE_DIR/retry.log"
grep -q second "$FSA_EVIDENCE_DIR/retry-attempt-2.log"
echo 'PASS: synthetic helper tests (no Android SDK/APK/test execution)'
