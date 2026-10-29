# FSA-00C — Device and data-safety verification

> **Current snapshot:** `45b58a9` on 2026-10-29. For the gate decision see [FSA-00 final lock](FSA-00-FINAL-LOCK.md) and [R3 reassessment](FSA-00C-R3-INDEPENDENT-REASSESSMENT.md). Prior snapshot at `f821225…` preserved below as historical.

**Revision:** `45b58a96dd161efb65339f4f8f1c6ef5d1138da1`.
**Date:** 2026-10-29 UTC. Evidence: [R3-02](evidence/00c-r3/02-environment.txt), [R3-03](evidence/00c-r3/03-gradle-attempts.txt), [R3-08](evidence/00c-r3/08-device-and-isolation.txt), [R3-07](evidence/00c-r3/07-source-audit.txt) (storage/reviewer excerpts).

## Outcome: BLOCKED – no device/APK/target; no production data touched

No emulator or test device exists in this sandbox; no APK was produced; no installation, launch, rating, undo, navigation, lifecycle or sync was executed. Every row below is **BLOCKED** or **UNVERIFIED**, not PASS. Protecting official AnkiDroid user data takes precedence over completing device checks in an unfit environment.

## 1. Host readiness (R3-02/08)

- **Android SDK / platform 37:** absent – `ANDROID_HOME`/`ANDROID_SDK_ROOT` unset, no `local.properties`, no `sdkmanager`/`adb`/`emulator` on PATH (R3-02 exits 127).
- **Emulator / device:** absent – `adb: command not found` (R3-08 exit 127), no `/dev/kvm`, no `emulator` binary.
- **APK artifact:** not produced – `AnkiDroid/build` does not exist; `find . -name *.apk` empty (R3-02/08).
- **Memory:** 3.8 GiB total, no swap – marginal vs daemon `-Xmx3072M` + parallel test forks (see build verification). No OOM observed.
- **Conclusion:** Mandatory device verification cannot proceed here. Network-bound build prerequisites (ch. build verification) must be resolved first to produce an APK, then device verification on a capable host.

## 2. Device verification matrix — BLOCKED (procedure defined, not executed)

Expected host: **fresh emulator or disposable device profile**, **FullDebug** variant (package `com.ichi2.anki.debug`), **disposable collection** (never first-run pointing at production `/AnkiDroid`), **no production AnkiWeb account**.

| # | Check | Status | Procedure for re-run (what passing evidence would contain) |
| --- | --- | --- | --- |
| D-1 | App launch (cold start, first-run storage setup) | **BLOCKED** | Install `AnkiDroid-full-universal-debug.apk` (plus optional ABI split) on fresh emulator; launch; choose **app-private/disposable** folder when prompted; capture logcat + screenshot of DeckPicker. R3: no APK, no install. |
| D-2 | Deck access | **BLOCKED** | DeckPicker lists/creates decks without crash; create deck + note on disposable collection; restart app; confirm persistence. |
| D-3 | Question reveal (show answer) | **BLOCKED** | Start review; tap Show Answer; confirm front/back render in WebView. |
| D-4 | Native rating (Again/Hard/Good/Easy) | **BLOCKED** | Rate card via each button; confirm next card + due counts change; pipeline is source-verified `Reviewer.kt:1580→undoableOp→sched.answerCard` and `ReviewerViewModel.kt:527→sched.answerCard→undoableOp` (R3-07) – runtime still unproven. |
| D-5 | Undo | **BLOCKED** | Undo last rating; confirm card/counts restored via `tryUndo()`→`backend.undo()` path. |
| D-6 | Navigation (Browser, Editor, Settings, Stats) | **BLOCKED** | Traverse destinations; no crashes in logcat. |
| D-7 | Coexistence vs official | **BLOCKED** | Both `com.ichi2.anki.debug` and official `com.ichi2.anki` installed; launch each; verify separate data – but see R-06 warning: package separation ≠ storage isolation. |
| D-8 | Sync (disposable data only) | **UNVERIFIED** | Only with explicitly authorized throwaway AnkiWeb test account + isolated data; verify local integrity after sync; **never** production collection. No such account provided – correctly not attempted. No waiver granted. |
| D-9 | Session end / persistence | **BLOCKED** | End session, restart app, verify collection state preserved. |
| D-10 | Process recreation | **BLOCKED** | Trigger config change/process death; verify Reviewer state survives via SavedState/navigator, no duplicate rating. |

Optional automation on capable host: `:AnkiDroid:connectedFullDebugAndroidTest` (default `testBuildType debug` unless `TEST_RELEASE_BUILD=true` which then uses `:connectedPlayReleaseAndroidTest` via `.github/run_emulator_tests.py` per `build.gradle.kts:258` and `tests_emulator.yml:112,294`) – after disposable-environment safeguards.

## 3. Critical risk: separate Application ID ≠ guaranteed separate collection storage

> **This risk blocks the gate regardless of successful build.**

**Verified in source:** The FullDebug package `com.ichi2.anki.debug` (suffix in `AnkiDroid/build.gradle.kts:187`) is distinct, authorities/permissions templated as `${applicationId}` (manifest `631-649`), Contract derives via `BuildConfig.ANKI_PACKAGE_NAME` with overloads (`api/build.gradle.kts:24-28`).

**BUT** storage selection can still choose a **shared public directory**:

- `InitialActivity.kt:263-355` + `startup/SetupStorage.kt:119-147` + `CollectionHelper.kt:152-195` show logic: if `PREF_COLLECTION_PATH` unset, startup chooses a default. **Full flavor retains `MANAGE_EXTERNAL_STORAGE`** (only `play` removes it via `src/play/AndroidManifest.xml`); `legacyAnkiDroidDirectory` uses primary shared/external storage root + `AnkiDroid` – on typical primary-user emulated storage this is `/storage/emulated/0/AnkiDroid`.
- `InitialActivity` chooses **PUBLIC** for legacy/external-manager permission sets; app-private external storage is another supported branch **but not guaranteed for FullDebug** (R3-07).
- Instrumentation runner (`com.ichi2.testutils.NewCollectionPathTestRunner`) installs `TestingApplication` which sets `isInstrumentationTest`; `CollectionHelper.kt:186-195` then appends `androidTest` beneath the **configured** collection root – if that root is the shared public folder, tests still operate under a public tree. Do **not** treat this as protection for personal data.

**Required on capable host:** Explicitly verify selected storage location **before** any rating/note/import/sync – use a disposable folder (e.g. app-private external or isolated emulator storage). Do not operate on `/storage/emulated/0/AnkiDroid` if owned by production installation. Record chosen path in evidence.

## 4. Other isolation surfaces (source-derived expectations, runtime unverified)

| Surface | FullDebug | Release/official collision & risk |
| --- | --- | --- |
| Cards provider authority | `com.ichi2.anki.debug.flashcards` | Release uses `com.ichi2.anki.flashcards`; same permission model, exported provider permission check in code (R3-07) |
| FileProvider authority | `com.ichi2.anki.debug.apkgfileprovider` | `${applicationId}.apkgfileprovider`; not exported, URI grants |
| Custom permission | `com.ichi2.anki.debug.permission.READ_WRITE_DATABASE` | Dangerous level; distinct name but permission-protected provider still validates caller in code |
| Deep links / import handlers | `anki://x-callback-url/browser`, `http/https` BROWSABLE, SEND/VIEW for `apkg/colpkg/vnd.anki/x-apkg`, CSV/TSV, images | Can compete with official install – choosing wrong handler can open/import into unintended collection |
| File grants | `res/xml/filepaths.xml` includes broad `external-path .` plus cache/export/shared-deck | Runtime grant behavior needs review; package IDs do not isolate shared files |
| Android backup | `android:allowBackup="true"` (manifest 98); no explicit `fullBackupContent`/`dataExtractionRules`/agent in tracked manifests | Merged/library surfaces & platform restore unverified – do not restore personal Android backup in tests |
| Collection backups | `BackupManager` operates next to collection | Must verify backup destination ≠ production before any mutation; no restore attempted |

## 5. Release and sync safety for this audit

- No APK built/signed/installed/distributed; no signing identity changed.
- Never distribute release signed with publicly known fallback keystore (`tools/fallback-release-keystore.jks`, hash `d1d3fb7d48bcec155c86f92eca757775bc047fceaba42b5fe369e98d08ac80ea` – passwords public in build scripts; intentionally not recopied into diagnostics).
- Never install fork release over official, never suggest uninstalling official to bypass signature mismatch.
- No AnkiWeb sync performed; sync test remains UNVERIFIED until explicitly authorized disposable account + data and documented account isolation. A written optional waiver may be accepted only if parent Gate contract explicitly permits it – not present here.

## 6. What must be proven before lock

On a capable host with SDK 37 and sufficient memory:

1. Produce actual APK(s) and record size/hash/package/version/signing per [build verification](FSA-00C-BUILD-VERIFICATION.md) contract.
2. On fresh emulator/disposable profile, verify D-1..D-10 matrix with logcat/screenshots and actual storage path evidence.
3. Demonstrate coexistence with official AnkiDroid **without** sharing real collections.
4. Only with authorized disposable account, demonstrate sync with isolated data and local integrity after sync.

Only then can device verification move from BLOCKED to PASS. Historical device matrix was similarly BLOCKED – consistent.

