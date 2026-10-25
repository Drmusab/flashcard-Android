# FSA-00B — Fork Baseline Build & Verification

**Gate:** FSA-00B (FSA-00 Gate Lock input)
**Repository:** `Drmusab/flashcard-Android` (fork of `ankidroid/Anki-Android`)
**Reference baseline:** `a7121c11c6e11d9c6ba34518784156fba1701e29`
**Date of this run:** 2026-10-25
**Execution environment:** Arena sandbox — Debian GNU/Linux 12 (bookworm), x86_64,
2 vCPU, 3.8 GiB RAM, 20 GiB free disk. **Not** the Windows host referenced by the
mission's suggested commands; Linux `./gradlew` equivalents were used where attempted.
**Session branch:** `arena/e0f873f3-flashcard-android` (see §2.3 for the
`feature/fsa-foundation` deviation)

## Gate Lock recommendation: **BLOCKED**

Nothing failed on merit. The source-level baseline is coherent and matches every
version pin the mission expected (§3). However, this sandbox has **no JDK, no
Android SDK, no emulator/device**, and its outbound network allowlist blocks every
host a Gradle build needs (Gradle distribution, Google/Maven/plugin repositories,
foojay toolchain provisioning, GitHub release assets). JDK acquisition was actively
attempted and failed at the network boundary (§4.3). Per mission rules, all
unavailable checks are classified **BLOCKED** or **UNVERIFIED**, never PASS, and no
evidence was fabricated. FSA-00 must not lock until §9's runbook is executed on a
capable host and its evidence attached (§10 lists the exit criteria).

| Area | Result |
| --- | --- |
| Repository / baseline identity | ✅ VERIFIED-SOURCE (§2) |
| Pinned toolchain versions (Gradle/AGP/Kotlin/SDK) | ✅ VERIFIED-SOURCE (§3) |
| FullDebug build | ⛔ BLOCKED — no JVM (§5) |
| Unit tests / lint / build-logic tests | ⛔ BLOCKED — no JVM (§5) |
| APK artifact evidence | ⛔ BLOCKED — no APK produced (§5.3) |
| Device/emulator verification | ⛔ BLOCKED — no adb/emulator/device (§6) |
| Sync verification | ⚪ UNVERIFIED — not attempted; no test account authorized (§6) |
| Identity / coexistence audit | ✅ VERIFIED-SOURCE with open risks (§7) |
| FSA-00A cross-check | ⚪ UNVERIFIED — report not present in repo (§2.4) |
| Non-negotiable rules | ✅ Held (§8) |

---

## 1. Method

Read-only inspection of the current checkout (Git metadata, build scripts, version
catalog, manifests, CI workflows), read-only GitHub API/`ls-remote` queries, network
reachability probes, and best-effort execution attempts of the mission's suggested
Gradle commands. No source, build, manifest, identity, or scheduler files were
modified. The only file added is this report. `main` is unchanged; no commits were
made to it.

## 2. Repository state

### 2.1 HEAD, branch, worktree (executed evidence)

```text
$ git rev-parse HEAD
a7121c11c6e11d9c6ba34518784156fba1701e29
$ git log -1 --oneline --decorate
a7121c1 (grafted, HEAD -> arena/e0f873f3-flashcard-android, origin/main, origin/HEAD, main) feat(card-templates): reposition card types
$ git status --short        # (empty — clean; no uncommitted work to preserve)
$ git worktree list
/home/user/flashcard-Android  a7121c1 [arena/e0f873f3-flashcard-android]
$ git remote -v
origin  https://github.com/Drmusab/flashcard-Android.git (fetch)
origin  https://github.com/Drmusab/flashcard-Android.git (push)
```

- **HEAD is exactly the reference baseline** `a7121c11…`
  (`feat(card-templates): reposition card types`, David Allison, 2026-10-23).
  Local `main`, `origin/main`, and the session branch all point at it. `main` was
  not touched by this run.
- **Worktree was clean** at start and remained clean until this report was added.
  There was no pre-existing uncommitted work to preserve.
- **Checkout is grafted/shallow** (single visible commit). Local history, tags, and
  fork-divergence archaeology are therefore unavailable in this sandbox (B-07).

### 2.2 Origin / upstream configuration

- Only one remote: `origin` → `Drmusab/flashcard-Android`. **No `upstream` remote
  is configured**, so no upstream merge was possible or performed.
- Read-only GitHub API confirms: `fork: true`, parent/source =
  `ankidroid/Anki-Android`, default branch `main`, last pushed 2026-10-25T10:30Z.
- `git ls-remote --heads origin` returns exactly one branch: `main` at the baseline.

### 2.3 `feature/fsa-foundation` — BLOCKED (documented deviation)

The mission asks for `feature/fsa-foundation` from the verified baseline. It does
**not** exist locally or on `origin` (verified via `git ls-remote`). This Arena
session is hard-pinned to branch `arena/e0f873f3-flashcard-android` and may not
create, switch to, or push any other branch; creating `feature/fsa-foundation` is
therefore **BLOCKED in this session (B-06)**. The intent — isolated work off an
unchanged `main` at the exact baseline commit — is satisfied by the session branch.
Maintainer action (§10): create it from the same commit, e.g.
`git switch -c feature/fsa-foundation a7121c11c6e11d9c6ba34518784156fba1701e29`.

### 2.4 FSA-00A prerequisite — UNVERIFIED

No FSA-00A discovery report exists anywhere in this checkout (filename/content
search for `FSA`/`00A`/`discovery` across the tree: no matches). Every fact below
was re-derived directly from source at the baseline commit instead of being
cross-checked against FSA-00A. If FSA-00A lives outside the repo, its claims should
be diffed against §3/§7 before Gate Lock.

## 3. Pinned toolchain — VERIFIED-SOURCE (no versions changed)

All values read from the checkout; no Study-Agent-Client versions were introduced
(none exist in the repo — §8).

| Item | Pinned value | Source of truth |
| --- | --- | --- |
| Gradle | **9.8.0** (`gradle-9.8.0-bin.zip`) | `gradle/wrapper/gradle-wrapper.properties` |
| Android Gradle Plugin | **9.4.1** | `gradle/libs.versions.toml` → `androidGradlePlugin` |
| Kotlin | **2.4.20** | `gradle/libs.versions.toml` → `kotlin` |
| compileSdk / minor | **37 / 0** | `gradle/libs.versions.toml`, applied in `buildSrc/.../ankidroid.android.app.gradle.kts:18-19` |
| targetSdk | **36** | `gradle/libs.versions.toml` (note: not 37) |
| minSdk / apiMinSdk | **24 / 16** | `gradle/libs.versions.toml` |
| Gradle daemon JVM | **JetBrains Runtime, Java 21** (`toolchainVendor=JETBRAINS`, `toolchainVersion=21`, foojay URLs per-OS/arch) | `gradle/gradle-daemon-jvm.properties`; resolver `org.gradle.toolchains.foojay-resolver-convention:1.0.0` in `settings.gradle.kts` |
| Launcher JDK (CI) | JetBrains 21 (`actions/setup-java`, `distribution: jetbrains`, `java-version: 21` in every workflow; `jitpack.yml` pins `21.0.10-jbr`). A ≥17 launcher suffices — Gradle then provisions the pinned daemon toolchain via foojay. | `.github/workflows/*.yml`, `jitpack.yml` |
| Anki backend | `0.1.72-anki26.09.3` | `gradle/libs.versions.toml` → `ankiBackend` |
| Robolectric | 4.17 (+ `robolectricSdkDownload` pre-fetch task; needs network once) | `gradle/libs.versions.toml`, `buildSrc/.../ankidroid.plugins.robolectric-downloader.gradle.kts` |
| ktlint | engine 1.8.0, Gradle plugin 14.2.0 | `gradle/libs.versions.toml` |
| App version | versionName `2.26.0alpha7`, versionCode `22600107` | `AnkiDroid/build.gradle.kts:133-135` |
| Modules | `:anki-common :api :AnkiDroid :baselineprofile :common :common:android :compat :libanki :lint-rules :note-editor :vbpd :widgets` | `settings.gradle.kts` |

Repository configuration (`settings.gradle.kts` + `buildSrc/build.gradle.kts`):
`google()`, `mavenCentral()`, `gradlePluginPortal()`, `jitpack.io`. Every one is
unreachable from this sandbox (§4.2).

Notable: `gradle-wrapper.properties` does **not** pin `distributionSha256Sum`
(fork-baseline inherits upstream's choice; recorded as-is, not changed in this gate).

## 4. Build environment report (this sandbox)

### 4.1 Installed toolchain inventory

| Requirement | Present? | Evidence |
| --- | --- | --- |
| JDK (any) | **No** | `java: command not found`; `JAVA_HOME` unset; no `/usr/lib/jvm` |
| Android SDK (`ANDROID_HOME`, `local.properties`) | **No** | env empty; no `local.properties`; no `adb`/`sdkmanager`/`emulator` on PATH |
| SDK platform/build-tools for API 37 | **No** | (no SDK at all) |
| Emulator / test device | **No** | (no adb) |
| RAM for AGP 9.x + Kotlin 2.4 | Marginal | 3.8 GiB total vs daemon `-Xmx3072M` + parallel/caching in `gradle.properties` — OOM risk even with a JDK (B-05) |

### 4.2 Network reachability probes (executed evidence)

Outbound access is allowlist-restricted (`github.com`, `codeload.github.com`,
`api.github.com`, `registry.npmjs.org`, `pypi.org`, `files.pythonhosted.org`).
Probe results (`000` = connection blocked):

| Host (purpose) | Result |
| --- | --- |
| `services.gradle.org` (Gradle 9.8.0 distribution) | `000` ⛔ |
| `dl.google.com` (`google()` repo + SDK) | `000` ⛔ |
| `repo.maven.apache.org` (Maven Central) | `000` ⛔ |
| `plugins.gradle.org` (plugin portal) | `000` ⛔ |
| `jitpack.io` | `000` ⛔ |
| `api.foojay.io` (daemon JDK provisioning) | `000` ⛔ |
| `deb.debian.org` (apt; `sudo apt-get update`) | Ignored ⛔ |
| `github.com` / `api.github.com` / `pypi.org` / `registry.npmjs.org` | `200` ✅ |

### 4.3 JDK acquisition attempt (executed, failed at network boundary)

Temurin 21.0.13+9 tarball was located via the GitHub API, but the download
redirects `github.com` → `release-assets.githubusercontent.com`, whose TLS
handshake is blocked by the allowlist:

```text
< HTTP/2 302
< location: https://release-assets.githubusercontent.com/...
* OpenSSL SSL_connect: SSL_ERROR_SYSCALL in connection to release-assets.githubusercontent.com:443
curl: (35) OpenSSL SSL_connect: SSL_ERROR_SYSCALL ...
```

Conclusion: no JVM can be provisioned in this sandbox, and even with one, the
Gradle distribution and all dependency repositories are unreachable. Build/test
execution is **BLOCKED (B-01, B-02, B-03)**, independent of code quality.

## 5. Build & test task identification and execution

### 5.1 Actual tasks (source-derived, CI-corroborated)

Variants come from flavor dimension `appStore` (`play` = default, `amazon`,
`full` — *"no restrictions on storage/camera. Distributed on GitHub/F-Droid"*)
× build types (`debug`, `release`, `benchmark`) in `AnkiDroid/build.gradle.kts:184-265`.

| Purpose | Actual command (Linux / Windows `.bat`) | Corroboration |
| --- | --- | --- |
| Toolchain banner | `./gradlew --version` | — |
| **FullDebug APKs** | `./gradlew :AnkiDroid:assembleFullDebug` | Variant `full`+`debug`; debug forces universal APK (`splits.abi.isUniversalApk = true`, line 188) alongside ABI splits |
| **FullDebug unit tests** | `./gradlew :AnkiDroid:testFullDebugUnitTest` | Mission form is valid. Upstream CI runs the aggregate `./gradlew jacocoUnitTestReport` (all modules) after `./gradlew robolectricSdkDownload` (`.github/workflows/tests_unit.yml:177,181`) |
| Lint + style | `./gradlew lintAll ktlintCheck lint-rules:test` | `.github/workflows/lint.yml:73`. ⚠️ Mission suggests `ktLintCheck` (capital L) — the real task is **`ktlintCheck`**; use the CI spelling |
| Build-logic tests | `./gradlew -p buildSrc test` | `.github/workflows/lint.yml` "Test build logic" step (note: buildSrc tests input `../AnkiDroid/build.gradle.kts` + version catalog) |
| Instrumentation (default) | `./gradlew :AnkiDroid:connectedFullDebugAndroidTest` | `testBuildType = "debug"` unless env `TEST_RELEASE_BUILD=true` (`build.gradle.kts:258`, `AnkiDroid/build.gradle.kts:94-98`) |
| Instrumentation (CI emulator path) | `TEST_RELEASE_BUILD=true` + `:AnkiDroid:connectedPlayReleaseAndroidTest` via `.github/run_emulator_tests.py` | `.github/workflows/tests_emulator.yml:112,294` |
| Baseline-profile smoke | `:baselineprofile:connectedBenchmarkBenchmarkAndroidTest` (`ReleaseSmokeTest`) | `tests_emulator.yml:319`; checked-in profile: `AnkiDroid/src/main/generated/baselineProfiles/baseline-prof.txt`. No `lint-baseline*.xml` files exist. |

Instrumentation identity: `testApplicationId = "com.ichi2.anki.tests"`,
runner `com.ichi2.testutils.NewCollectionPathTestRunner` (disposable collection
path — the correct pattern for §6).

### 5.2 Execution attempts — all BLOCKED (verbatim)

Each suggested command was actually run (Linux `./gradlew` ≡ `.\gradlew.bat`).
All fail identically before Gradle starts, exit code **1**:

```text
$ ./gradlew --version
exit_code=1
ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.
Please set the JAVA_HOME variable in your environment to match the
location of your Java installation.
```

| Command | Exit | Classification |
| --- | --- | --- |
| `./gradlew --version` | 1 | ⛔ BLOCKED (B-01) |
| `./gradlew :AnkiDroid:assembleFullDebug` | 1 | ⛔ BLOCKED (B-01→B-03) |
| `./gradlew :AnkiDroid:testFullDebugUnitTest` | 1 | ⛔ BLOCKED (B-01→B-03) |
| `./gradlew lintAll ktLintCheck lint-rules:test` | 1 | ⛔ BLOCKED (B-01→B-03) |
| `./gradlew -p buildSrc test` | 1 | ⛔ BLOCKED (B-01→B-03) |
| Any `connected*AndroidTest` | not run | ⛔ BLOCKED (B-03; pointless without JVM/SDK/device) |

### 5.3 APK artifact evidence

**None.** `AnkiDroid/build/` does not exist; no APK was produced, so no artifact
hashes can be recorded. Expected (source-derived) FullDebug outputs once built:

```text
AnkiDroid/build/outputs/apk/full/debug/AnkiDroid-full-universal-debug.apk
AnkiDroid/build/outputs/apk/full/debug/AnkiDroid-full-{armeabi-v7a,x86,arm64-v8a,x86_64}-debug.apk
```

(naming pattern corroborated by `tools/release.sh` / `tools/parallel-package-release.sh`.)

### 5.4 Baseline file hashes (reproducibility anchors at `a7121c11…`)

```text
3eba5a2745d47a47bd7de72fade92418c8273468abaf5b7f315346821b8e7145  gradle/wrapper/gradle-wrapper.properties
238e777fcddd7e34f9708186085def2abd6e08e658505b38718d79d74c21abd5  gradle/wrapper/gradle-wrapper.jar
100155c4ed9bc9ce22e208dec3836411300971708fae3a598b2e982a8f5a4904  gradle/libs.versions.toml
6bb9a5da683dc48714609e17e7e202a7a3fb5d9bdbbd27b816af9777b9185089  gradle/gradle-daemon-jvm.properties
53419655bae2b351b4f1ecdfe53161c0d5620a10c4ecbdbf5429ffaba38c96db  gradle.properties
00d8bc5fc0ed42258786f94ff8a8f8cc48da7ae22123527167c89a45c0301f33  settings.gradle.kts
ea5724589f1d4de136fe31a50c72533bb9b68a8d7c5e061baceaac83567cc9b8  AnkiDroid/build.gradle.kts
748bda118c75910e7777a1c5c44e8a4cd702bdf02c241dab482e18da6ec99d8d  AnkiDroid/src/main/AndroidManifest.xml
d1d3fb7d48bcec155c86f92eca757775bc047fceaba42b5fe369e98d08ac80ea  tools/fallback-release-keystore.jks
```

## 6. Device verification matrix — BLOCKED (procedure defined, not executed)

No emulator or test device exists in this sandbox. Every row is **BLOCKED**, not
PASS. The re-run must use a **fresh emulator or disposable device profile**, the
**FullDebug** variant (package `com.ichi2.anki.debug`, §7), a **disposable
collection** (never point first-run storage at a production `/AnkiDroid` folder —
see risk R-3), and **no production AnkiWeb account**.

| # | Check | Status | Procedure for re-run |
| --- | --- | --- | --- |
| D-1 | App launch (cold start, first-run storage setup) | ⛔ BLOCKED | Install `AnkiDroid-full-universal-debug.apk`; launch; choose app-private/disposable folder; capture logcat + screenshot |
| D-2 | Deck access (deck picker lists/creates decks) | ⛔ BLOCKED | Create deck + note on disposable collection; restart app; confirm persistence |
| D-3 | Question reveal (show answer) | ⛔ BLOCKED | Start review; tap Show Answer; confirm answer side renders |
| D-4 | Native rating (Again/Hard/Good/Easy via unmodified pipeline) | ⛔ BLOCKED | Rate card; confirm next card + counts change (pipeline: §8) |
| D-5 | Undo | ⛔ BLOCKED | Undo the rating; confirm card/counts restored |
| D-6 | Normal navigation (browser, editor, settings, stats) | ⛔ BLOCKED | Traverse main destinations; no crashes in logcat |
| D-7 | Coexistence spot-check vs official AnkiDroid | ⛔ BLOCKED | Both installed; launch each; confirm separate data (see R-3 storage caveat) |
| D-8 | Sync (disposable data only) | ⚪ UNVERIFIED | Only with an explicitly authorized throwaway AnkiWeb test account; **never** a production collection. No such account was provided for this run — correctly not attempted. |

Optional automation on the re-run host: `:AnkiDroid:connectedFullDebugAndroidTest`
(default) mirrors CI's emulator coverage for the debug test build type.

## 7. Application identity & coexistence audit — VERIFIED-SOURCE

**No release identity was changed in this gate** (audit only), per mission rule.

### 7.1 Identity by variant (from `AnkiDroid/build.gradle.kts` + manifests)

| Attribute | **FullDebug** (this gate's build) | **FullRelease** (fork default) | Official AnkiDroid |
| --- | --- | --- | --- |
| applicationId | `com.ichi2.anki.debug` (suffix `.debug`, line 187) | `com.ichi2.anki` (line 101) | `com.ichi2.anki` |
| versionName | `2.26.0alpha7-debug` | `2.26.0alpha7` | (release-dependent) |
| Signing | AGP default debug key (`~/.android/debug.keystore`) | `KEYSTOREPATH` env, else **`tools/fallback-release-keystore.jks`** (`Test@123`/`my-key`) | Official release key |
| Cards provider authority | `com.ichi2.anki.debug.flashcards` | `com.ichi2.anki.flashcards` | `com.ichi2.anki.flashcards` |
| FileProvider authority | `com.ichi2.anki.debug.apkgfileprovider` | `com.ichi2.anki.apkgfileprovider` | same pattern |
| Custom permission | `com.ichi2.anki.debug.permission.READ_WRITE_DATABASE` (dangerous) | `com.ichi2.anki.permission.READ_WRITE_DATABASE` | identical name |
| API contract package | `ANKI_PACKAGE_NAME=com.ichi2.anki.debug` in debug (`api/build.gradle.kts:24-28`) | `com.ichi2.anki` | `com.ichi2.anki` |

Authorities/permissions are `${applicationId}`-templated
(`AnkiDroid/src/main/AndroidManifest.xml:46-50, 631-649`), and
`FlashCardsContract` derives them from `BuildConfig.ANKI_PACKAGE_NAME` with
`getAuthority(ankiPackageName)` overloads explicitly documented *"for parallel
builds (.A, .B, etc.)"*. A `-PcustomSuffix=` release option exists (line 226) but
was **not** used or altered here.

Other identity surfaces (main manifest): deep links `anki://x-callback-url/browser`,
generic `http/https` BROWSABLE handlers, SEND/VIEW handlers for
`application/apkg|colpkg|vnd.anki|x-apkg`, CSV/TSV/text and image types;
`android:allowBackup="true"`; ACRA endpoint `https://ankidroid.org/acra/report`
in `BuildConfig`; analytics key falls back to a dummy without
`local.properties`/env. The `full` flavor keeps `MANAGE_EXTERNAL_STORAGE` +
`REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` (only `play` strips them,
`AnkiDroid/src/play/AndroidManifest.xml`); there is no `src/full/` overlay.

### 7.2 Coexistence risks (register — no fixes in this gate)

- **R-1 · Release package collision (High).** Any fork *release* build **is**
  `com.ichi2.anki` — the same package as installed official AnkiDroid. Android will
  treat it as an update: with a different signature it fails
  (`INSTALL_FAILED_UPDATE_INCOMPATIBLE`), pushing a user toward uninstall-first,
  which destroys app-private data/preferences. **Never sideload fork release builds
  on a production device in later gates without an identity decision.**
- **R-2 · Publicly-known fallback signing key (High, if ever distributed).**
  Without `KEYSTOREPATH`, release builds sign with the in-repo
  `tools/fallback-release-keystore.jks` whose passwords are printed in the build
  script. Anyone can sign a valid "update" to such an install. Acceptable for
  local testing only; a hazard if an APK leaves the maintainer's machine.
- **R-3 · Shared public collection folder (High for device testing).** Storage
  selection *prefers* the public folder (`InitialActivity.kt:270-272, 348-353` →
  `SetupStorage.kt` `legacyAnkiDroidDirectory()` = `/storage/emulated/0/AnkiDroid`)
  when the app can manage external storage — which the `full` flavor can. A
  FullDebug install (`.debug` package) can therefore open **the same
  `collection.anki2` as official AnkiDroid** if first-run defaults are accepted on
  a shared device: two apps, one collection, backend/locking contention, and sync
  surprises. Package-level coexistence ≠ storage isolation. Device tests must use
  an emulator/disposable profile or explicitly pick an app-private/disposable
  directory (instrumentation's `NewCollectionPathTestRunner` already does this).
- **R-4 · Intent/deep-link competition (Medium).** Even the `.debug` package
  registers the same VIEW/SEND/BROWSABLE filters (apkg/colpkg import, share
  targets, `anki://` callback). Expect chooser dialogs and possible accidental
  imports into the wrong app's collection — which, combined with R-3, could mean
  the production collection.
- **R-5 · Provider/permission name reuse on release (Medium).** Release authority
  `com.ichi2.anki.flashcards` and permission
  `com.ichi2.anki.permission.READ_WRITE_DATABASE` are name-identical to official.
  Third-party API clients cannot distinguish fork-release from official; whichever
  signature installed first owns the permission definition. (Debug variants are
  correctly namespaced.)
- **R-6 · Shared telemetry endpoints (Low).** Fork builds inherit upstream ACRA
  URL; analytics is inert without the real key (dummy fallback). Decide before any
  distributed build whether fork crash reports should go to `ankidroid.org`.

## 8. Non-negotiable rules — attestation

| Rule | Status |
| --- | --- |
| No PC Anki Adapter | ✅ None added; none present |
| No AnkiConnect scheduler integration | ✅ `grep -ri ankiconnect` over app/lib sources: **no matches** |
| No separate FSRS/review scheduler | ✅ None added. Native pipeline located, untouched: `libanki/.../sched/Scheduler.kt` (+ `DummyScheduler.kt`), answered via `Reviewer`/`AbstractFlashcardViewer`/`ReviewerViewModel` `answerCard` path |
| No Study-Agent migration yet | ✅ `grep -ri study-agent/studyagent` over `*.kt/*.kts/*.toml`: **no matches** |
| No changes to native rating pipeline | ✅ Zero source files modified (clean tree + this report only) |
| No unauthorized upstream merge | ✅ No `upstream` remote exists; no fetch/merge performed; `main` unchanged |
| No fabricated evidence | ✅ All execution results are verbatim with exit codes; unavailable checks marked BLOCKED/UNVERIFIED |
| No changes to user Anki data | ✅ Nothing installed, synced, or executed against any collection |

## 9. Reproducible build commands (capable-host runbook)

Prerequisites (Windows host per mission; Linux equivalents identical sans `.bat`):

1. JDK 21 (JetBrains Runtime preferred; any ≥17 launcher works — Gradle
   auto-provisions the pinned JetBrains-21 daemon via foojay on first run;
   requires internet to `api.foojay.io`, `services.gradle.org`, `dl.google.com`,
   Maven Central, plugin portal, JitPack).
2. Android SDK with platform **API 37** (+ build-tools for AGP 9.4.1); set
   `sdk.dir` in `local.properties` or `ANDROID_HOME`. ≥8 GiB RAM recommended.
3. From a clean checkout at `a7121c11…` on the foundation branch:

```powershell
git status --short
git rev-parse HEAD            # expect a7121c11c6e11d9c6ba34518784156fba1701e29
git remote -v

.\gradlew.bat --version                                   # expect Gradle 9.8.0, daemon JVM 21 (JetBrains)
.\gradlew.bat robolectricSdkDownload                      # CI does this before unit tests
.\gradlew.bat :AnkiDroid:assembleFullDebug
.\gradlew.bat :AnkiDroid:testFullDebugUnitTest            # or CI aggregate: jacocoUnitTestReport
.\gradlew.bat lintAll ktlintCheck lint-rules:test         # note: ktlintCheck, not ktLintCheck
.\gradlew.bat -p buildSrc test

# Artifact evidence
Get-FileHash AnkiDroid\build\outputs\apk\full\debug\*.apk -Algorithm SHA256
# + aapt2 dump badging / apksigner verify --print-certs on the universal APK

# Device (fresh emulator, disposable collection only)
.\gradlew.bat :AnkiDroid:connectedFullDebugAndroidTest
```

Attach: full console logs with exit codes, `TEST-*.xml` summaries
(`**/build/test-results/`), lint reports, APK paths + SHA-256 + badging/certs, and
the completed §6 matrix (D-1…D-8) with logcat/screenshots.

## 10. Residual blocker register & Gate exit criteria

| ID | Blocker | Severity | Unblock action |
| --- | --- | --- | --- |
| B-01 | No JDK in sandbox; provisioning blocked (GitHub release-asset TLS) | Gate-blocking here | Run §9 on the Windows/CI host with JDK 21 |
| B-02 | Gradle distribution + all dependency/SDK/foojay hosts blocked by sandbox allowlist | Gate-blocking here | Same as B-01 (open-network host) |
| B-03 | No Android SDK, emulator, or test device in sandbox | Gate-blocking here | Host with SDK 37 + fresh emulator image |
| B-04 | FSA-00A report absent from repo — cross-check UNVERIFIED | Medium | Land FSA-00A in repo (or attach) and diff against §3/§7 |
| B-05 | Sandbox RAM (3.8 GiB) marginal for AGP 9.4/Kotlin 2.4 defaults | Low (here) | ≥8 GiB host, or accept slower single-daemon settings off-record |
| B-06 | `feature/fsa-foundation` not created (Arena session branch pinning) | Low | Maintainer: create from `a7121c11…`; cherry-pick/fast-forward this report |
| B-07 | Grafted/shallow checkout: no local history to audit fork divergence from upstream | Low | Full clone or GitHub compare `ankidroid/Anki-Android...Drmusab/flashcard-Android` when divergence audit is required |
| B-08 | Release coexistence hazards R-1/R-2/R-3 unresolved (identity frozen this gate by mission rule) | High for later gates | Dedicated identity/storage decision **before** any release-variant install or distribution; debug-only testing with disposable storage until then |

**FSA-00 Gate Lock recommendation: BLOCKED.** Convert to PASS only when:

1. §9 executes green on a capable host at `a7121c11…` (FullDebug assemble,
   FullDebug unit tests, `lintAll ktlintCheck lint-rules:test`, `-p buildSrc test`)
   with logs, exit codes, and APK SHA-256/badging attached;
2. §6 D-1…D-7 pass on a disposable emulator/device (D-8 only with an authorized
   throwaway sync account, else explicitly waived as UNVERIFIED);
3. B-04 is closed and B-06's branch exists with `main` still at the baseline.

**Stop. FSA-01 / Study-Agent migration was not started.**

---

## Appendix A — Command log (this run, abridged where noted)

Executed in `/home/user/flashcard-Android`, 2026-10-25. Read-only except §4.3's
download attempt (cleaned up) and this report.

- Git: `status --short` (clean), `rev-parse HEAD`, `log -1`, `branch -a`,
  `remote -v`, `config --get-regexp remote.*/branch.*`, `worktree list`,
  `merge-base --is-ancestor a7121c11… HEAD` (true, HEAD==baseline),
  `ls-remote --heads origin` (only `main`), `ls-remote` for
  `feature/fsa-foundation` (absent), final `status`/`diff` (clean pre-report).
- GitHub API (read-only): repo metadata → fork of `ankidroid/Anki-Android`.
- Source reads: `gradle/wrapper/gradle-wrapper.properties`,
  `gradle/libs.versions.toml`, `gradle/gradle-daemon-jvm.properties`,
  `gradle.properties`, `settings.gradle.kts`, `build.gradle.kts`,
  `AnkiDroid/build.gradle.kts` (namespace/appId/signing/flavors/splits),
  `api/build.gradle.kts`, `FlashCardsContract.kt`, main/play manifests,
  `SetupStorage.kt`, `InitialActivity.kt` (folder selection),
  `buildSrc/build.gradle.kts` + robolectric-downloader plugin, CI workflows
  (`lint.yml`, `tests_unit.yml`, `tests_emulator.yml`), `jitpack.yml`,
  `tools/release.sh` (APK naming).
- Greps: `study-agent|studyagent` (none), `ankiconnect` (none), `answerCard`
  pipeline files, providers/permissions/deep-links in manifest, FSA-00A search
  (none), `lint-baseline*.xml` (none).
- Environment: `uname`, `/etc/os-release`, `nproc`, `free -h`, `df -h`,
  `java -version` (not found), env vars, `which adb/sdkmanager/emulator` (none).
- Network: `curl -sI` probes §4.2; Temurin asset download attempt (`curl` exit 35,
  §4.3); `sudo apt-get update` (all repos Ignored).
- Gradle attempts §5.2: all exit 1 (`JAVA_HOME is not set…`).
- `sha256sum` of pinned build inputs (§5.4).

## Appendix B — Key file references

| Fact | Location |
| --- | --- |
| Gradle 9.8.0 | `gradle/wrapper/gradle-wrapper.properties` (`distributionUrl`) |
| AGP 9.4.1 / Kotlin 2.4.20 / compileSdk 37 / target 36 / min 24 | `gradle/libs.versions.toml` |
| Daemon JVM JetBrains 21 | `gradle/gradle-daemon-jvm.properties` |
| applicationId, version, test id/runner | `AnkiDroid/build.gradle.kts:101,133-138` |
| Release signing (env / fallback keystore) | `AnkiDroid/build.gradle.kts:167-182` |
| Debug `.debug` suffix + universal APK | `AnkiDroid/build.gradle.kts:184-188` |
| `customSuffix` release option | `AnkiDroid/build.gradle.kts:223-228` |
| Flavors `play`/`amazon`/`full` | `AnkiDroid/build.gradle.kts:249-265` |
| ABI splits + versionCode overrides | `AnkiDroid/build.gradle.kts:289-327` |
| `testReleaseBuild` switch | `build.gradle.kts:258-260`, `AnkiDroid/build.gradle.kts:94-98` |
| Providers / permission / deep links / allowBackup | `AnkiDroid/src/main/AndroidManifest.xml:46-50,98,631-649` (+ intent filters passim) |
| Play-only permission stripping | `AnkiDroid/src/play/AndroidManifest.xml` |
| API authority derivation | `api/src/main/java/com/ichi2/anki/FlashCardsContract.kt:100-120`, `api/build.gradle.kts:24-28` |
| Public-folder preference (R-3) | `AnkiDroid/src/main/java/com/ichi2/anki/InitialActivity.kt:270-272,348-353`; `startup/SetupStorage.kt:126-147` |
| Native scheduler / rating path | `libanki/src/main/java/com/ichi2/anki/libanki/sched/Scheduler.kt`; `AnkiDroid/.../Reviewer.kt`, `AbstractFlashcardViewer.kt`, `ui/windows/reviewer/ReviewerViewModel.kt` |
| CI command canon | `.github/workflows/lint.yml:73`, `tests_unit.yml:177,181`, `tests_emulator.yml:112,294,319`, `.github/run_emulator_tests.py:32` |
