# FSA-00C — Build and toolchain verification

> **Current snapshot:** `f506261` on 2026-10-29. For the authoritative gate decision see [FSA-00 final lock](FSA-00-FINAL-LOCK.md) and [R4 independent audit](FSA-00C-R4-INDEPENDENT-AUDIT.md). R3 (`45b58a9…`) and `f821225…` snapshots preserved below as historical.

**Revision:** `f506261b8968418a2d98f7bfa796ea61e98e1578`.

> **R4 supersession of the build outcome only in one respect:** the wrapper is no longer unlaunchable. A Temurin 21.0.8 **JRE** obtained from an allowed host (`pypi.org`, `jdk4py`) executes `./gradlew`, which then fails downloading `gradle-9.8.0-bin.zip` with `javax.net.ssl.SSLHandshakeException`. All seven required commands still exit **1**, still before any Gradle task, so every row below stays BLOCKED — but the blocker is now proven to be **artifact acquisition**, not the launcher/JVM. That JRE has no `javac` and is not the pinned JETBRAINS vendor. See [R4-03](evidence/00c-r4/03-jvm-and-gradle.txt), [R4-04](evidence/00c-r4/04-network.txt).
**Date:** 2026-10-29 UTC. Evidence IDs: [R3 index](FSA-00C-R3-INDEPENDENT-REASSESSMENT.md#evidence-index--r3-current) (R3-01..08) and [entry index](FSA-00C-ENTRY-AND-EVIDENCE.md#evidence-index) (E01 etc).
**Outcome: BLOCKED before JVM startup, not a demonstrated compiler/test defect.**

## Source pins versus execution

| Item | Source evidence | Runtime result |
| --- | --- | --- |
| Gradle 9.8.0 | `gradle/wrapper/gradle-wrapper.properties:3` – `gradle-9.8.0-bin.zip`, retries 3, validate true, **no distributionSha256Sum** | BLOCKED; wrapper shell ran, Gradle JVM did not (R3-03 exit 1) |
| AGP 9.4.1 | `gradle/libs.versions.toml:26`; `buildSrc/build.gradle.kts` implements `com.android.tools.build:gradle:9.4.1` (AGP pins KGP transitively) | Pinned; resolution/compatibility unverified – no daemon |
| Kotlin 2.4.20 | Catalog line 105; buildSrc explicitly selects catalog KGP + compose-compiler plugin same version | Pinned; compilation unverified |
| Default daemon JetBrains JDK 21 | `gradle/gradle-daemon-jvm.properties` – JETBRAINS 21, 8 foojay URLs (Linux x86_64 id `0d1a1acdc708062093673f65aa9aba4b`); resolver `org.gradle.toolchains.foojay-resolver-convention:1.0.0` in `settings.gradle.kts` | No vendor/patch observed; daemon never started (R3-02/03 `java -version` 127) |
| Supported build JVM range 21–25 | `build.gradle.kts:203-240` – checks `Jvm.current().javaVersion`, prints daemon-vs-JAVA_HOME mismatch, suggests `updateDaemonJvm` | Source guard, not compatibility test – not executed |
| Android compile SDK 37, minor 0 | Catalog lines 2-3; applied in `buildSrc/.../ankidroid.android.app.gradle.kts:18-19` | Missing SDK – no platform installed (R3-02) |
| target/min/apiMin SDK | 36 / 24 / 16 in catalog | Source only |
| Build-tools | No explicit `buildToolsVersion` in tracked scripts | Required AGP-selected version **unknown** until capable-host Gradle output; do not guess patch |
| Native backend | `io.github.david-allison:anki-android-backend:0.1.72-anki26.09.3` + testing artifact same version (catalog `ankiBackend`) | Not resolved/downloaded (network blocked) |
| Robolectric | 4.17; downloader registers `robolectricSdkDownload` (catalog + `buildSrc/.../robolectric-downloader`) | Not resolved; no generated dependency-path properties |
| ktlint | engine 1.8.0, Gradle plugin 14.2.0 (catalog) | Not executed |
| App version | `2.26.0alpha7`, code `22600107` (`AnkiDroid/build.gradle.kts:133-135`) | Source only |
| Modules | `:anki-common :api :AnkiDroid :baselineprofile :common :common:android :compat :libanki :lint-rules :note-editor :vbpd :widgets` (`settings.gradle.kts`) | Source only |

Daemon criteria selects JVM independently of shell `JAVA_HOME`. A future run must capture `java -version`, `./gradlew --version`, and daemon diagnostics showing actual vendor/version/resolution. No downgrade, `updateDaemonJvm`, pin edit or toolchain override made in this audit. Full history is now available (24,687 commits) vs prior shallow – does not change build outcome.

## Host and dependency readiness

R3-02 records Debian 12 x86_64, 2 CPUs, 3.8 GiB RAM (3.6 available, no swap), ~19 GiB free disk. No java, javac, Gradle, adb, sdkmanager, emulator, apkanalyzer, aapt2 or apksigner on PATH. `JAVA_HOME`, `ANDROID_HOME`, `ANDROID_SDK_ROOT`, `GRADLE_USER_HOME` unset; no `local.properties`, SDK/JDK directories, Gradle cache or `/dev/kvm`. Prior cgroup limit files absent – do not infer limit.

3 GiB daemon heap (`gradle.properties` `org.gradle.jvmargs=-Xmx3072M`) plus 2 GiB-per-unit-test-fork (`build.gradle.kts` `AndroidCoverageInputs` logic reserving daemon heap then splitting rest) risks exceeding available RAM – OOM risk even with JDK (B-05/R-09). No OOM occurred because execution never reached Java. Disk capacity alone does not establish readiness.

Repositories: `google()`, `mavenCentral()`, `gradlePluginPortal()`, `jitpack.io` (`settings.gradle.kts`, `buildSrc/build.gradle.kts`). R3-04 probes Gradle distribution, Android SDK index, Google AGP POM, Maven backend POM, plugin portal, JitPack and foojay redirect – **all six Gradle/Google/Maven/Plugin/JitPack/Foojay return curl 35 HTTP 000 TLS SSL_ERROR_SYSCALL** (network boundary). GitHub/api/pypi/npm return 200. These are access failures, not 404s or proof of incompatibility. Sandbox network cannot support toolchain installation. No unapproved mirrors, substitutions, repackaged JDKs or workarounds used – run on authorized capable host.

`BackendDependencies.kt` supports opt-in `local_backend=true`; without `local.properties` the published pinned artifact is selected – no local backend substituted. `repositoriesMode` commented out, wrapper has no `distributionSha256Sum`, no tracked dependency-verification metadata/lockfile found by R3-06 scan. These inherited integrity limitations were not “fixed” by changing baseline. Dependency graph and artifact trust remain unverified until capable-host capture.

Stale comment adjacent to catalog AGP pin: `Pinned to 9.0.1 until building androidTest in release mode circular dependency issue resolved` (`libs.versions.toml:24`). Actual pin is 9.4.1; comment is stale, not authoritative.

## Actual commands and results

All commands executed individually with timeout 30s; complete outputs in **R3-03**. `java -version` in R3-02 exits **127** (command not found).

| Exact command | Exit | Result |
| --- | --- | --- |
| `./gradlew --version` | 1 | BLOCKED – no JVM |
| `./gradlew robolectricSdkDownload` | 1 | BLOCKED |
| `./gradlew :AnkiDroid:assembleFullDebug` | 1 | BLOCKED |
| `./gradlew :AnkiDroid:testFullDebugUnitTest` | 1 | BLOCKED |
| `./gradlew jacocoUnitTestReport` | 1 | BLOCKED – aggregate CI path (`tests_unit.yml:181`) |
| `./gradlew lintAll ktlintCheck lint-rules:test` | 1 | BLOCKED – correct spelling per `lint.yml:73` |
| `./gradlew -p buildSrc test` | 1 | BLOCKED – 8 tests exist, not executed |

Each emits:

```text
ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.

Please set the JAVA_HOME variable in your environment to match the
location of your Java installation.
```

**No Gradle task executed.** No SDK diagnostic, dependency graph, compiler diagnostic, test XML/HTML, lint output or build-logic result. Counts unavailable, not inferred from source files. R3-05 exact-HEAD Actions query returned zero runs; no remote green substituted.

### Canonical task and static-check audit (source/CI corroborated, execution BLOCKED)

- `full` + `debug` defined in app build; debug suffix `.debug` and universal ABI output configured (`AnkiDroid/build.gradle.kts:185-188` `isUniversalApk = true` alongside ABI splits).
- `tests_unit.yml:177,181` runs Robolectric prep and aggregate `jacocoUnitTestReport`; both aggregate and explicit FullDebug attempted, not interchangeable test counts.
- `lint.yml:53,73` runs buildSrc tests and `lintAll ktlintCheck lint-rules:test`. `lintAll` pins AnkiDroid to lintFullDebug for app and default lint for others (`build.gradle.kts:184-200`).
- AndroidLint: `abortOnError=true`, warnings as errors, release/test-source checks, `lint-release.xml`; existing `UElementAsPsi` suppression and CI-only `WrongThread` suppressions remain unchanged. JVM lint also configures UElementAsPsi/LogConditional. `.editorconfig` is formatting policy.
- No `lint-baseline*.xml` file found (R3-02/06). `lint-release.xml` is rule severity/ignore config, **not** clean result. Existing scoped ignores remain in force. Generated baseline profile `AnkiDroid/src/main/generated/baselineProfiles/baseline-prof.txt` is not a lint baseline.
- Android lint errors, Kotlin formatting errors, custom-rule failures, warnings and actually ignored findings: **UNAVAILABLE** because checks never ran. No rule disabled for this audit.

## Artifact evidence and reproducibility

| Required artifact field | Observation (R3) |
| --- | --- |
| APK path / size / SHA-256 | **NOT PRODUCED**; APK search empty (R3-02) |
| Application ID / version / variant from binary | Unavailable; source expects `com.ichi2.anki.debug`, `2.26.0alpha7-debug`, code `22600107`, FullDebug |
| Signing certificate fingerprint | Unavailable; no APK/signer execution |
| Merged manifest / resolved dependencies | Unavailable |
| Repeat-build comparison | BLOCKED; no first APK |

Source hashes match FSA-00B (§5.4) and R2 (R3-06); they do not prove APK reproducibility. No bit-for-bit determinism, signature validity or supply-chain verification claimed.

### Historical R2 context (preserved)

R2 had a temporary Temurin 21.0.8+9 JVM via `jdk4py` wheel proving wrapper could launch but distribution TLS still failed; R3 intentionally did **not** provision a JVM to preserve clean-boundary evidence – no JVM can be provisioned from allowed hosts without bypassing network policy. Both classify as BLOCKED.

## Capable-host rerun contract (NOT executed here)

1. Preserve exact source revision `45b58a9` and record clean status/diffs. Do not merge upstream (141 behind). Use fixed branch where operating in Arena; do not create another branch here.
2. Use supported JetBrains JDK 21 and Android SDK tooling from authorized vendors on host with ≥8 GiB RAM (more for emulator/forks), adequate disk. Record vendor/patch, host resources, SDK location, env overrides, installed SDK packages; never record secrets. Make standard vendor/dependency endpoints accessible under authorized policy.
3. Run `java -version`, `./gradlew --version`; verify actual daemon. Install platform 37 via SDK manager; use Gradle output to identify exact required build-tools – do not guess patch or downgrade pins. Accept licenses via normal authorized process.
4. Rerun all 7 commands above, preserve individual exits/full logs; retain XML/HTML/lint reports. Record dependency resolution and any permitted local settings. Keep `local_backend` disabled.
5. Discover actual APKs (`find AnkiDroid/build/outputs -name '*.apk'`), then record each artifact's size, `sha256sum`, `apkanalyzer manifest application-id/version-name/version-code` or `aapt2 dump badging`, and `apksigner verify --print-certs`. Use actual paths. Do not distribute release/fallback-signed artifacts.
6. Rebuild with equivalent inputs before reproducibility claim; compare hashes and investigate differences, distinguishing ZIP/signing metadata from source changes. Do not assume harmless.
7. Only then execute [disposable-device verification](FSA-00C-DEVICE-VERIFICATION.md). Attach evidence for independent reviewer; successful build alone cannot unlock gate.

