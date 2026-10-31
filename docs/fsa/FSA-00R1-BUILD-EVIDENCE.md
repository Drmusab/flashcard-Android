# FSA-00R1 — Build evidence

**Evaluated revision:** `ca446d8712e3a9b01050c536c26e3869220f0415` · **Date:** 2026-10-31 UTC
**Result: FullDebug build NOT EXECUTED. Failure class: `ENVIRONMENT_ERROR` (dependency/distribution acquisition).**
No APK exists. No claim of success is made anywhere in this document.

Evidence: [`docs/fsa/evidence/00r1/`](evidence/00r1/) — command matrix and verbatim logs in
[`05-logs/`](evidence/00r1/05-logs/), environment probe in [04](evidence/00r1/04-jvm-and-wrapper.txt),
network matrix in [03](evidence/00r1/03-network-probe.txt).

---

## 1. Toolchain pins re-verified against the current source (B-01)

| Pin | Source of truth | Value | Status |
| --- | --- | --- | --- |
| Gradle distribution | `gradle/wrapper/gradle-wrapper.properties` | `9.8.0` (`-bin.zip`, `networkTimeout=10000`, `retries=3`) | unchanged, matches record |
| Android Gradle Plugin | `gradle/libs.versions.toml:26` | `9.4.1` | unchanged |
| Kotlin | `gradle/libs.versions.toml:105` | `2.4.20` | unchanged |
| compileSdk / targetSdk / minSdk | `gradle/libs.versions.toml:2,14,10` | `37` / `36` / `24` | unchanged |
| Gradle daemon JVM | CI: `actions/setup-java` jetbrains `21`; local sandbox: Temurin 25 JRE-only | pinned JetBrains 21 **not provisionable here** | see §2 |
| Robolectric SDK downloader | `buildSrc/src/main/kotlin/ankidroid.plugins.robolectric-downloader.gradle.kts` | task `robolectricSdkDownload` exists | task name confirmed |
| Repositories | `settings.gradle.kts` | `google()`, `mavenCentral()`, `gradlePluginPortal()`, `jitpack.io` | unchanged, no mirror added |

Nothing was substituted, downgraded or bypassed (B-02 explicit prohibitions honoured). The diff against the
reference baseline for all non-`docs` paths is empty
([01](evidence/00r1/01-repository-state.txt)), so the pins above are the baseline's pins.

---

## 2. Execution attempts at this revision (C-03 / C-04)

All six `§C-03` commands plus the wrapper diagnostic were executed through the new evidence harness, so each line
below is a real process with a real exit code, not a plan.

| # | Command | Exit | Duration | Failure category | Log |
| --- | --- | --- | --- | --- | --- |
| 1 | `./gradlew --version` | **1** | 8 s | `ENVIRONMENT_ERROR` | [gradle-version.log](evidence/00r1/05-logs/gradle-version.log) |
| 2 | `./gradlew robolectricSdkDownload` | **1** | 7 s | `ENVIRONMENT_ERROR` | [robolectric-sdk-download.log](evidence/00r1/05-logs/robolectric-sdk-download.log) |
| 3 | `./gradlew :AnkiDroid:assembleFullDebug` | **1** | 7 s | `ENVIRONMENT_ERROR` | [assemble-full-debug.log](evidence/00r1/05-logs/assemble-full-debug.log) |
| 4 | `./gradlew :AnkiDroid:testFullDebugUnitTest` | **1** | 8 s | `ENVIRONMENT_ERROR` | [test-full-debug-unit.log](evidence/00r1/05-logs/test-full-debug-unit.log) |
| 5 | `./gradlew jacocoUnitTestReport` | **1** | 7 s | `ENVIRONMENT_ERROR` | [jacoco-unit-test-report.log](evidence/00r1/05-logs/jacoco-unit-test-report.log) |
| 6 | `./gradlew lintAll ktlintCheck lint-rules:test` | **1** | 8 s | `ENVIRONMENT_ERROR` | [lint-all-ktlint-lint-rules-test.log](evidence/00r1/05-logs/lint-all-ktlint-lint-rules-test.log) |
| 7 | `./gradlew -p buildSrc test` | **1** | 7 s | `ENVIRONMENT_ERROR` | [buildsrc-test.log](evidence/00r1/05-logs/buildsrc-test.log) |

Machine-readable record: [`05-logs/commands.tsv`](evidence/00r1/05-logs/commands.tsv) (columns: label, command,
git SHA, branch, OS, JDK vendor, JDK, Gradle, exit code, duration, start time UTC, failure category, log).

### First meaningful error (B-03 classification)

```text
Caused by: java.io.EOFException: SSL peer shut down incorrectly
    at java.base/sun.security.ssl.SSLSocketInputRecord.read(...)
Caused by: java.io.IOException: Unable to download from
    https://services.gradle.org/distributions/gradle-9.8.0-bin.zip
    at org.gradle.wrapper.Download.download(...)
    at org.gradle.wrapper.Install.createDist(...)
```

Classification: **`ENVIRONMENT_ERROR` — dependency/distribution acquisition.** Not a source, resource,
configuration or toolchain defect. The Gradle wrapper *launcher* runs (a JVM starts, wrapper code executes, the
download is attempted three times with backoff), and fails before any build script is evaluated, so:

* `AnkiDroid/build/` was never created;
* no Gradle task was ever configured or executed;
* therefore no Gradle task outcome can be reported as pass, fail or skip for this revision.

### Why the sandbox cannot host the build even with a JVM

| Missing capability | Observation |
| --- | --- |
| Compiler | the only obtainable JVM (Temurin 25 JRE from `pypi.org`/`jdk4py`, an approved host) has **no `javac` and no `jmods`** — [04](evidence/00r1/04-jvm-and-wrapper.txt) |
| Gradle distribution | `services.gradle.org` blocked at TLS (curl exit 35) — [03](evidence/00r1/03-network-probe.txt) |
| Maven/Google/JitPack/plugin portal | `repo.maven.apache.org`, `repo1.maven.org`, `maven.google.com`, `dl.google.com`, `plugins.gradle.org`, `jitpack.io` all blocked — [03](evidence/00r1/03-network-probe.txt) |
| Toolchain provisioning | `api.foojay.io` blocked; GitHub release binaries (`objects.githubusercontent.com`) blocked — [03](evidence/00r1/03-network-probe.txt) |
| Android SDK | absent, and `dl.google.com` is the only legitimate source: unobtainable |

No proxy, mirror, TLS-verification bypass or dependency substitution was attempted, per B-02.

---

## 3. APK identity (C-05)

| Field | Result |
| --- | --- |
| APK produced | **NO** — repository-wide search for `*.apk` returned nothing; `AnkiDroid/build` does not exist |
| File path | n/a |
| Size / SHA-256 | n/a — `apk_identity.sh` reports `result=NOT_PRODUCED` and exits 1 rather than fabricating values ([10](evidence/00r1/10-harness-selftest.txt)) |
| Application ID (source expectation only) | `com.ichi2.anki`, `applicationIdSuffix = ".debug"` for the debug build type → `com.ichi2.anki.debug` (`AnkiDroid/build.gradle.kts:101,187`) |
| Version (source expectation only) | `versionName = "2.26.0alpha7"`, `versionCode = 22600107` (`AnkiDroid/build.gradle.kts:133,135`), `versionNameSuffix = "-debug"` |
| Signing certificate (source expectation only) | debug build type → `signingConfig = debug`; the `release` config (line 221) and `tools/fallback-release-keystore.jks` are out of scope for this variant and are not referenced by the new workflow ([08](evidence/00r1/08-identity-invariants.txt)) |
| Build variant | `fullDebug` (flavor `full` × build type `debug`) |
| Output location the CI step will inspect | `AnkiDroid/build/outputs/apk/full/debug/` |

Source expectations are labelled as such on purpose: an APK identity claim requires an APK. Once
`.github/workflows/fsa-foundation-ci.yml` runs, `apk_identity.sh` records path, size, SHA-256, `aapt2 badging`
(application id, version name/code) and `apksigner --print-certs` fingerprints into `fsa-evidence/apk-identity.txt`.

---

## 4. What the new CI workflow will produce, and under what guard-rails

| Requirement | Implementation | Status today |
| --- | --- | --- |
| Compile FullDebug | `bash .github/fsa/run_evidence_command.sh "assemble-full-debug" ./gradlew :AnkiDroid:assembleFullDebug --daemon` | configured, **never executed** (Actions not running) |
| Unit tests | `test-full-debug-unit`, then aggregate `jacoco-unit-test-report` | configured, never executed |
| Lint / style / lint-rule tests | `lintAll ktlintCheck lint-rules:test` | configured, never executed |
| Build-logic tests | `./gradlew -p buildSrc test` (8 test classes present in `buildSrc/src/test/kotlin/com/ichi2/anki/gradle`) | configured, never executed |
| Evidence capture | `commands.tsv` + verbatim logs + `$GITHUB_STEP_SUMMARY` table per command | harness self-tested locally ([10](evidence/00r1/10-harness-selftest.txt)) |
| Artifacts | `fsa-build-evidence`, `fsa-unit-test-evidence`, `fsa-lint-evidence`, `fsa-consolidated-evidence` (debug APK + reports only) | not produced |
| Security | `contents: read`, `persist-credentials: false`, only `GITHUB_TOKEN`, no keystore/release/publish step, no AVD, no collection | audited ([07](evidence/00r1/07-ci-workflow-safety.txt)) |

---

## 5. Verdict

| Field | Result |
| --- | --- |
| GRADLE WRAPPER EXECUTES | **NO** — launcher runs, distribution acquisition fails (`ENVIRONMENT_ERROR`) |
| DEPENDENCIES RESOLVE | **NO** — every required host blocked in this sandbox |
| FULLDEBUG BUILDS | **NOT EXECUTED** |
| APK PRODUCED | **NO** |
| APK IDENTITY MEASURED | **NO** — expectations recorded from source only |
| CAPABLE RUNNER | exists (GitHub-hosted Ubuntu) but is gated on owner actions O-1…O-5 in [CI diagnostics §2.3](FSA-00R1-CI-DIAGNOSTICS.md#23-exact-owner-actions-nothing-here-can-be-done-by-arena) |

Build evidence for FSA-00 therefore remains **BLOCKED**. This round contributes a working evidence pipeline and a
verified diagnosis, not a passing build.
