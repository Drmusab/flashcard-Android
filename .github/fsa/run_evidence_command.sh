#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later
#
# FSA-00R1 evidence harness.
#
# Runs exactly one build command and records machine-checkable provenance for it:
# command, git SHA, operating system, JDK, Gradle version, exit code, duration,
# log location and a failure category. The record is appended to
# "$FSA_EVIDENCE_DIR/commands.tsv" so evidence can be diffed and audited without
# trusting prose. The command's own output is preserved verbatim in a per-command
# log file; the harness never rewrites or filters build output.
#
# Usage: run_evidence_command.sh <label> <command> [args...]

set -uo pipefail

if (( $# < 2 )); then
    echo "usage: $0 <label> <command> [args...]" >&2
    exit 64
fi

label=$1
shift

evidence_dir=${FSA_EVIDENCE_DIR:-fsa-evidence}
mkdir -p "$evidence_dir"

slug=$(printf '%s' "$label" | tr -cs 'A-Za-z0-9._-' '-' | sed -e 's/^-//' -e 's/-$//')
log_file="$evidence_dir/${slug}.log"
# Retries must not overwrite the logs referenced by earlier command records.
if [[ -e "$log_file" ]]; then
    attempt=2
    while [[ -e "$evidence_dir/${slug}-attempt-${attempt}.log" ]]; do
        attempt=$((attempt + 1))
    done
    log_file="$evidence_dir/${slug}-attempt-${attempt}.log"
fi
records="$evidence_dir/commands.tsv"
readable_command="$*"

now_utc() { date -u +%FT%TZ; }

git_sha=$(git rev-parse HEAD 2>/dev/null || echo "unknown")
git_ref=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")

jdk_vendor="unknown"
jdk_version="unknown"
if command -v java >/dev/null 2>&1; then
    java_line=$(java -version 2>&1 | head -n 1)
    jdk_version=$java_line
    case "$java_line" in
        *Temurin*|*temurin*) jdk_vendor="Eclipse Temurin" ;;
        *JetBrains*|*jetbrains*|*JBR*) jdk_vendor="JetBrains" ;;
        *OpenJDK*|*openjdk*) jdk_vendor="OpenJDK (vendor unspecified)" ;;
        *) jdk_vendor="unknown" ;;
    esac
fi
if [[ -n "${JAVA_HOME:-}" ]] && [[ -x "$JAVA_HOME/bin/java" ]]; then
    jdk_home_line=$("$JAVA_HOME/bin/java" -version 2>&1 | head -n 1)
    jdk_version="$jdk_home_line (JAVA_HOME=$JAVA_HOME)"
fi

os_description=$(uname -srm 2>/dev/null || echo "unknown")

# The Gradle version is only observable once the distribution has been fetched.
gradle_version="not-yet-known"
if [[ -f "$evidence_dir/gradle-version.log" ]]; then
    detected=$(grep -m 1 -E '^Gradle [0-9]' "$evidence_dir/gradle-version.log" 2>/dev/null || true)
    if [[ -n "$detected" ]]; then
        gradle_version=$detected
    fi
fi

if [[ ! -f "$records" ]]; then
    printf 'label\tcommand\tgit_sha\tbranch\tos\tjdk_vendor\tjdk\tgradle\texit_code\tduration_s\tstarted_utc\tfailure_category\tlog\n' > "$records"
fi

started=$(now_utc)
start_epoch=$(date -u +%s)

: # errexit is not enabled: the exit code is captured below, on purpose
"$@" > >(tee "$log_file") 2>&1
exit_code=$?
wait 2>/dev/null || true

duration=$(( $(date -u +%s) - start_epoch ))
# For the version command itself, use the just-captured output rather than
# leaving a successful first invocation marked as not-yet-known.
if [[ "$label" == "gradle-version" ]]; then
    detected=$(grep -m 1 -E '^Gradle [0-9]' "$log_file" 2>/dev/null || true)
    if [[ -n "$detected" ]]; then gradle_version=$detected; fi
fi

case "$exit_code" in
    0) failure_category="NONE" ;;
    *)
        # Classification is deliberately conservative: it only names categories that the
        # captured log actually supports, and never upgrades a failure to a pass.
        if grep -qE 'Could not download|SSLHandshakeException|SSL peer shut down|EOFException|Could not GET|UnknownHostException|Connection (timed out|refused)' "$log_file"; then
            failure_category="ENVIRONMENT_ERROR (dependency/distribution acquisition)"
        elif grep -qE 'Could not resolve all (files|dependencies)|Could not find [^ ]+\.|Failed to resolve' "$log_file"; then
            failure_category="DEPENDENCY_RESOLUTION_ERROR"
        elif grep -qE 'Unsupported class file major version|no matching toolchains|Toolchain|JVM target|Unsupported Java' "$log_file"; then
            failure_category="TOOLCHAIN_ERROR"
        elif grep -qE '^e: |Compilation error|error: cannot find symbol' "$log_file"; then
            failure_category="SOURCE_COMPILATION_ERROR"
        elif grep -qE 'AAPT|Android resource linking failed|resource .* not found' "$log_file"; then
            failure_category="ANDROID_RESOURCE_ERROR"
        elif grep -qE "Could not create task|Configuration cache problems|A problem occurred (configuring|evaluating)" "$log_file"; then
            failure_category="CONFIGURATION_ERROR"
        else
            failure_category="UNKNOWN"
        fi
        ;;
esac

printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$label" "$readable_command" "$git_sha" "$git_ref" "$os_description" \
    "$jdk_vendor" "$jdk_version" "$gradle_version" "$exit_code" "$duration" \
    "$started" "$failure_category" "$log_file" >> "$records"

summary_line="FSA evidence | ${label} | exit=${exit_code} | ${duration}s | ${failure_category} | log=${log_file} | sha=${git_sha}"
echo "$summary_line"

if [[ -n "${GITHUB_STEP_SUMMARY:-}" ]]; then
    {
        echo "### \`${label}\`"
        echo
        echo "| field | value |"
        echo "| --- | --- |"
        echo "| command | \`${readable_command}\` |"
        echo "| git SHA | \`${git_sha}\` |"
        echo "| os | \`${os_description}\` |"
        echo "| jdk | \`${jdk_vendor}\` — \`${jdk_version}\` |"
        echo "| gradle | \`${gradle_version}\` |"
        echo "| exit code | **${exit_code}** |"
        echo "| duration | ${duration}s |"
        echo "| failure category | ${failure_category} |"
        echo "| log | \`${log_file}\` |"
        echo
    } >> "$GITHUB_STEP_SUMMARY"
fi

exit "$exit_code"
