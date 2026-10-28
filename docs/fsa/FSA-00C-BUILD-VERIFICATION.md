# FSA-00C — Build and toolchain verification

> **Historical snapshot:** This document describes the 2026-10-25 audit at `f821225…`, not the current checkout. For the 2026-10-28 independent reassessment and current gate decision, see [FSA-00C-R2 reassessment](FSA-00C-R2-INDEPENDENT-REASSESSMENT.md). Historical findings and evidence below are preserved.

**Revision:** `f8212252540fe104663e935d4c582e9ad499ec89`.
**Date:** 2026-10-25 UTC. Evidence IDs resolve in [entry report](FSA-00C-ENTRY-AND-EVIDENCE.md).
**Outcome: BLOCKED before JVM startup, not a demonstrated compiler/test defect.**

## Source pins versus execution

| Item | Source evidence | Runtime result |
| --- | --- | --- |
| Gradle 9.8.0 | `gradle/wrapper/gradle-wrapper.properties:3` | BLOCKED; wrapper shell ran, Gradle JVM did not |
| AGP 9.4.1 | `gradle/libs.versions.toml:26`; buildSrc dependency | Pinned; resolution/compatibility unverified |
| Kotlin 2.4.20 | Catalog line 105; buildSrc explicitly selects catalog KGP | Pinned; resolution/compilation unverified |
| Default daemon JetBrains JDK 21 | `gradle/gradle-daemon-jvm.properties`; foojay resolver 1.0.0 in settings | No vendor/patch version observed; daemon never started |
| Supported build JVM range 21–25 | `build.gradle.kts:203–240` | Source guard, not a compatibility test |
| Android compile SDK 37, minor 0 | Catalog lines 2–3; app convention plugin lines 18–19 | Missing SDK |
| target/min/API-module min SDK | 36 / 24 / 16 in catalog | Source only |
| Build-tools | No explicit `buildToolsVersion` found in tracked Gradle scripts | Required AGP-selected version **unknown** until capable-host Gradle output; no guessed patch version |
| Native backend | `io.github.david-allison:anki-android-backend:0.1.72-anki26.09.3` and same-version testing artifact | Not resolved/downloaded |
| Robolectric | 4.17; downloader registers `robolectricSdkDownload` | Not resolved; no generated dependency-path properties |

Daemon criteria select the JVM independently of the shell's `JAVA_HOME`. A future run must save `java -version`, `./gradlew --version`, and build/daemon diagnostics showing actual vendor, version and resolution. No downgrade, `updateDaemonJvm`, pin edit or toolchain override was made.

## Host and dependency readiness

E02 records Debian 12 x86_64, 2 CPUs, 3.8 GiB total RAM (3.6 GiB available at observation), no swap, ~20 GiB free disk. No Java, javac, Gradle, adb, sdkmanager, emulator, apkanalyzer, aapt2 or apksigner was found on PATH. `JAVA_HOME`, `ANDROID_HOME`, `ANDROID_SDK_ROOT`, `GRADLE_USER_HOME` are unset; no `local.properties`, usual SDK/JDK directories, Gradle user cache or `/dev/kvm` exists. The cgroup-v2 limit files queried were absent: do not infer a cgroup memory limit from this.

The 3 GiB daemon heap (`gradle.properties`) plus 2 GiB-per-unit-test-fork allocation (`build.gradle.kts`) risks exceeding available RAM. No OOM occurred because execution never reached Java. Disk capacity alone does not establish readiness.

Repositories are Google Maven, Maven Central, Gradle Plugin Portal and JitPack (`settings.gradle.kts`, `buildSrc/build.gradle.kts`, app build). E06 probes Gradle distribution, Android SDK index, Google AGP POM, Maven native-backend POM, plugin portal, JitPack and pinned foojay redirect. **All seven return curl exit 35, HTTP 000, TLS SSL_ERROR_SYSCALL.** These are access failures, not 404s or proof of dependency incompatibility. The sandbox's restricted network cannot support the standard toolchain installation. No unapproved mirrors, dependency substitutions, repackaged JDKs or networking workarounds were used. Run on an authorized capable host instead.

`BackendDependencies.kt` supports an existing opt-in `local_backend=true`; without `local.properties` the published pinned artifact is selected. No local backend was substituted. Repository policy enforcement is commented out (`repositoriesMode`), and the wrapper has no `distributionSha256Sum`; no tracked dependency-verification metadata/lockfile was found by E07's scan. These inherited integrity limitations were not “fixed” by changing baseline configuration. Dependency graph and artifact trust remain unverified until resolution is captured on the capable host.

## Actual commands and results

All commands below were executed individually; complete outputs/times are in **E03**. `java -version` in E02 exits **127** (command not found).

| Exact command | Exit | Result |
| --- | --- | --- |
| `./gradlew --version` | 1 | BLOCKED |
| `./gradlew robolectricSdkDownload` | 1 | BLOCKED |
| `./gradlew :AnkiDroid:assembleFullDebug` | 1 | BLOCKED |
| `./gradlew :AnkiDroid:testFullDebugUnitTest` | 1 | BLOCKED |
| `./gradlew jacocoUnitTestReport` | 1 | BLOCKED |
| `./gradlew lintAll ktlintCheck lint-rules:test` | 1 | BLOCKED |
| `./gradlew -p buildSrc test` | 1 | BLOCKED |

Each emits:

```text
ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.

Please set the JAVA_HOME variable in your environment to match the
location of your Java installation.
```

**No Gradle task executed.** There is no Gradle SDK diagnostic, dependency graph, compiler diagnostic, test XML/HTML, lint output or build-logic result. Counts of passed/failed/skipped tests are **unavailable**, not inferred from source files. E05's exact-HEAD Actions query returned zero runs; no historical/remote green result is substituted.

### Canonical task and static-check audit

- `full` + `debug` is defined in the app build; debug suffix `.debug` and universal ABI output are configured. No task-list invocation succeeded, so task validity is source/CI-corroborated only.
- `tests_unit.yml:177,181` runs Robolectric preparation and aggregate `jacocoUnitTestReport`. Both aggregate and explicit FullDebug commands were attempted here, not treated as interchangeable test counts.
- `lint.yml:53,73` runs buildSrc tests and `lintAll ktlintCheck lint-rules:test`. `lintAll` selects FullDebug for the app and default lint for other modules (`build.gradle.kts:184–200`).
- AndroidLint convention: `abortOnError=true`, warnings as errors, release/test-source checks, `lint-release.xml`; existing `UElementAsPsi` suppression and CI-only `WrongThread`/`ThreadConstraint` suppressions remain unchanged. JVM lint convention also configures UElementAsPsi, LogConditional and informational WrongThread. `.editorconfig` is the existing formatting policy.
- No `lint-baseline*.xml` file was found. `lint-release.xml` is a rule-severity/ignore configuration, **not** a measured clean lint result. Existing scoped ignores remain in force. The generated baseline profile is not a lint baseline.
- Android lint errors, Kotlin formatting errors, custom-rule test failures, warnings and actually ignored findings: **UNAVAILABLE** because checks never ran. No rule was disabled for this audit.

## Artifact evidence and reproducibility

| Required artifact field | Observation |
| --- | --- |
| APK path / size / SHA-256 | **NOT PRODUCED**; repository APK search empty |
| Application ID / version / build variant from binary | Unavailable; source expects `com.ichi2.anki.debug`, `2.26.0alpha7-debug`, code `22600107`, FullDebug |
| Signing certificate fingerprint | Unavailable; no APK or signer execution |
| Merged manifest / resolved dependencies | Unavailable |
| Repeat-build comparison | BLOCKED; no first APK |

Source hashes in E07 match FSA-00B, but do not prove APK reproducibility. No claim of bit-for-bit determinism, signature validity or artifact supply-chain verification is made.

## Capable-host rerun contract (NOT executed here)

1. Preserve this exact source revision and record clean status/diffs. Do not merge upstream. Use this session's fixed branch where operating in Arena; do not create another branch here.
2. Use supported JetBrains JDK 21 and Android SDK tooling from authorized vendors on a host with adequate memory (at least 8 GiB recommended, more for emulator/concurrent test forks). Record actual vendor/patch, host resources, SDK location, environment overrides and installed SDK packages; never record secrets. Make standard vendor/dependency endpoints accessible under authorized network policy.
3. Run `java -version`, `./gradlew --version`; verify the actual daemon. Install platform 37 through the standard SDK manager; use Gradle output to identify the exact required build-tools. Do not guess a patch or downgrade pins. Accept SDK licenses through the normal authorized process.
4. Rerun all seven commands above, preserving individual exits/full logs; retain actual XML/HTML/lint reports. Record dependency resolution and any permitted local host settings. Keep `local_backend` disabled for this baseline.
5. Discover actual APKs (for example `find AnkiDroid/build/outputs -name '*.apk'`), then record each artifact's size, `sha256sum`, `apkanalyzer manifest application-id/version-name/version-code` or `aapt2 dump badging`, and `apksigner verify --print-certs`. Use actual discovered paths. Do not distribute release/fallback-signed artifacts.
6. Rebuild with equivalent recorded inputs before making a reproducibility claim; compare hashes and investigate differences, distinguishing ZIP/signing metadata from source changes. Do not assume differences are harmless.
7. Only then execute [disposable-device verification](FSA-00C-DEVICE-VERIFICATION.md). Attach evidence for the independent reviewer; successful build alone cannot unlock the gate.
