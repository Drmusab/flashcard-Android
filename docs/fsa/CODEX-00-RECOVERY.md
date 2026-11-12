# CODEX-00 — local Android build recovery

Date: 2026-11-12 (Asia/Baghdad). FSA-00 remains **NOT LOCKED**. FSA-01A has not started.

## Repository and preserved evidence

- Observed `origin/main`: `4bfadceba7d91abec270c4b45e95e26dbc294d15`.
- Development branch: `codex/fsa00-recovery`, in the isolated `.recovery/checkout` directory.
- The supplied workspace was an archive without Git metadata. Its tracked file contents matched this HEAD; the original archive was preserved.
- GitHub's comparison with baseline `a7121c11c6e11d9c6ba34518784156fba1701e29` showed 23 subsequent commits and 98 changed files. Changes outside `docs/fsa/` were limited to five CI/helper files; application source and build pins were unchanged on entry.
- The recovery checkout is shallow. The baseline comparison above was obtained from GitHub, not from a full local history audit.
- FSA-00B/C source findings remain historical source evidence. Their failed environment attempts are not Android build results.
- The latest recorded foundation run, [41217279764](https://github.com/Drmusab/flashcard-Android/actions/runs/41217279764), was bound to the observed HEAD. All four jobs had zero executed steps and a billing-lock annotation. No new CI run or billing change was attempted.
- Existing FSA documents were not rewritten. The original FSA-00A and complete 33-Gate roadmap were not supplied or located in the repository; their original paths/provenance were requested.

## Recovered local environment

The Windows host now executes the unchanged toolchain: Gradle 9.8.0, JetBrains JDK/javac 21.0.11, AGP 9.4.1, project Kotlin 2.4.20, and compile SDK 37.0. AGP selected build-tools 36.0.0 and installed platform-tools 37.0.1.

Official JDK, command-line tools and Gradle downloads were checksum-verified. Java uses the Windows trusted certificate store; TLS verification was not disabled. The unchanged Gradle distribution was cached through the Windows downloader after Java wrapper download timeouts.

The task-created Gradle cache was copied to `D:\AnkiStudioRecovery-01a1cc75\gradle-home`, its file inventory verified, and Gradle executed from that copy before the original recovery cache was removed. This recovered system-drive space without changing project pins or existing user caches. The recovery activation script is outside the Git checkout at `.recovery/activate.ps1`.

The persistent buildSrc TestKit cache is also on D:, reached through the ignored `buildSrc/build/test-kit` directory junction. No existing user files were overwritten.

## Confirmed defect and correction

The first FullDebug unit-test attempt exposed two failed import-confirmation cases. Investigation and a new real-file-copy regression confirmed that URI-encoding the entire cache path encodes the Windows drive/separators, and also changes directories containing spaces, Unicode or percent characters.

Package preparation now encodes only the filename and preserves the native cache directory. The existing filename sanitization, traversal guard, CSV path, import selection and confirmation behavior remain in place. The regression copies disposable APKG/COLPKG content into a temporary cache directory and checks the actual destination and contents. The confirmation test retains its dialog count, main-thread, type, path and visibility assertions.

- New regression before the production fix: **1 test, 1 failure**, exit 1.
- Both complete import test classes after the fix: **43 tests, 0 failures, 0 errors, 0 skips**, exit 0.

The first buildSrc test run also exposed a Windows fixture cleanup error: the catalog-refresh assertions passed, but JUnit could not delete a temporary project containing the reused Gradle daemon's locked cache/DLL files. `VersionCatalogsTest` now uses the persistent `build/test-kit` cache, matching the other TestKit fixtures. Its catalog-value and same-daemon assertions remain unchanged. The targeted test passed after this fixture-only correction; production catalog lookup code was not changed.

The additional standalone buildSrc style check found generated Kotlin DSL plugin/accessor sources included in ktlint inputs, with zero authored-source violations. The [plugin's file filter](https://github.com/JLLeitschuh/ktlint-gradle#configuration) now excludes the build output directory. Effective inputs contained 24 authored files and no generated files. A temporary authored spacing violation was rejected, then removed; lint rules were not disabled. A fully rescanned final run cleared stale incremental generated/probe results and passed.

## Executed verification

- Baseline `:AnkiDroid:assembleFullDebug`: **PASS**, exit 0; 212 tasks, 11m 42s. Four ABI APKs produced before the import fix.
- Baseline APK binary identity and signatures: **PASS** for all four ABIs; package `com.ichi2.anki.debug`, version `2.26.0alpha7-debug` / `22600107`, Android debug certificate. SHA-256 hashes were recorded.
- `robolectricSdkDownload`: **PASS**, exit 0; all 13 configured instrumented runtimes cached.
- FullDebug unit tests after the fix: **PASS**, 3,898 cases across 465 suites, 0 failures/errors, 85 skips. The complete task finished before the batch moved on to PlayDebug preparation.
- PlayDebug unit tests: **PASS**, 3,898 cases across 465 suites, 0 failures/errors, 85 skips.
- `jacocoUnitTestReport`: **PASS**, exit 0, with fresh tests and generated HTML/XML reports. Validation used the existing `-PbuildTime=1794435639296` property to keep build metadata stable; no toolchain pin or coverage policy was changed.
- `lintAll ktlintCheck lint-rules:test`: **PASS**, exit 0; 549 actionable tasks.
- Initial `-p buildSrc test`: **FAIL**, 29 cases, 1 fixture cleanup failure, 1 existing Windows skip. The targeted catalog fixture passed after correction.
- Final `-p buildSrc test ktlintCheck --rerun-tasks --no-watch-fs`: **PASS**, exit 0; 29 cases, 0 failures/errors, 1 existing Windows skip, all 20 selected tasks executed. The local rescan flags avoid stale filesystem/incremental results; no permanent watcher setting was changed.
- `lint-rules:test`: **PASS**, 118 cases, 0 failures/errors, 1 skip.
- The first known-failing broad unit invocation was intentionally cancelled after its failures were localized. A subsequent verification invocation was cancelled during configuration to relocate the cache. Neither is a passing suite result.
- An interrupted combined batch reported a JaCoCo failure without retaining its final exception detail. A report-only diagnostic excluded test producers and was **not** acceptance evidence. The subsequent normal JaCoCo invocation, with its existing forced-fresh-test policy intact, passed; the earlier failure was not reproduced.

Raw command logs, exit records, regression XML and APK identity records are retained locally in the outer workspace's `.recovery/evidence` directory. They have not been uploaded as GitHub CI artifacts.

## Committed source and final APKs

Recovery code commit: `1ca8fcc1c631c4000ae63ed53ee949a6cce78b33` on `codex/fsa00-recovery`. Five source/test/configuration files changed: 41 insertions and 3 deletions. The repository pre-commit hook passed. `main` was not modified or pushed.

Final `:AnkiDroid:assembleFullDebug` from that clean tracked source: **PASS**, exit 0, 1m 4s; 212 tasks, 7 executed and 205 up-to-date. `BuildConfig.GIT_COMMIT_HASH` records the code commit above; build-time epoch millis are `1794491043771`.

All four final APKs passed binary identity and signature verification: `com.ichi2.anki.debug`, version `2.26.0alpha7-debug` / `22600107`, with the same Android debug certificate as the baseline. Artifacts are under `AnkiDroid/build/outputs/apk/full/debug/` in the recovery checkout. SHA-256:

- `AnkiDroid-full-arm64-v8a-debug.apk` (76,103,344 bytes): `197F6626818DA37A4759254C7CA6286085CF5B56D2859F968CB35DF04A293F63`
- `AnkiDroid-full-armeabi-v7a-debug.apk` (72,383,656 bytes): `083035E000E6AACF5D37846E8BE4C13B971F410F169AB149A3824623A4345754`
- `AnkiDroid-full-x86_64-debug.apk` (78,047,754 bytes): `128B6D8417C92CEDBEB678BAAC607427AE4260B125D7D182795245EC9C6B954B`
- `AnkiDroid-full-x86-debug.apk` (76,951,608 bytes): `8AF420885FF0D513DE5B25F4D4B5C2763E9BF9ED949BAEBA2BDA936CDE4734D9`

This recovery note is committed separately after the APK build; its documentation-only commit does not alter application/build inputs. No redundant rebuild is claimed for that documentation-only revision.

## Remaining gate conditions and safety

Disposable-emulator launch, Reviewer ratings/undo, lifecycle, navigation, persistence and actual collection-path isolation have **not** been verified. No APK has been installed and no device collection has been accessed. A distinct debug package ID is not proof of storage isolation; resolve and verify the disposable collection path before any collection write. Sync verification still requires a disposable authorized account or resolution of the existing contract.

No PC Adapter, PC BackendRegistry, AnkiConnect scheduling, remote PC queue, duplicate FSRS, separate scheduler or cross-backend failover was introduced. Native Reviewer/libanki scheduling and undo remain unchanged. No production collection, upstream merge, release identity or release signing configuration was touched. FSA-01A remains held until mandatory FSA-00 requirements and original historical evidence are satisfied.
