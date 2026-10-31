# FSA-00R1 — Emulator and native-Reviewer evidence

**Evaluated revision:** `ca446d8712e3a9b01050c536c26e3869220f0415` · **Date:** 2026-10-31 UTC
**Result: every runtime item is BLOCKED. No device, emulator or instrumentation run was performed, because no APK
exists and no CI job can be scheduled.**

| Prerequisite | Status | Basis |
| --- | --- | --- |
| APK to install | **ABSENT** | [BUILD evidence §3](FSA-00R1-BUILD-EVIDENCE.md) |
| Emulator runner | **UNAVAILABLE** — GitHub-hosted AVD requires an Actions run; the sandbox has no Android SDK, no `/dev/kvm`, and `dl.google.com` is unreachable | [03](evidence/00r1/03-network-probe.txt) |
| Instrumentation configuration | exists in-tree (`tests_emulator.yml`), **never executed** | [06](evidence/00r1/06-ci-static-validation.txt) |

---

## 1. Disposable-data contract (D-01) — restated, because it is the highest-severity risk

A distinct package name does **not** imply distinct storage. Verified again at this revision
([08](evidence/00r1/08-identity-invariants.txt)):

* Debug identity: `com.ichi2.anki.debug` (`applicationIdSuffix = ".debug"`, `AnkiDroid/build.gradle.kts:187`).
* Collection root: `SetupStorage.kt:127-138` — `getDefaultAnkiDroidDirectory()` returns
  `legacyAnkiDroidDirectory(directoryName)` for `AnkiDroidFolder.PUBLIC`, i.e.
  `File(Environment.getExternalStorageDirectory(), "AnkiDroid")` — **the same public directory** a production
  AnkiDroid install may use.
* `CollectionHelper.kt` only nests an `androidTest` subdirectory under whichever root is configured; it does not
  isolate from a shared public root.

Therefore the following is mandatory **before the first write** on any device or emulator, and none of it has
been performed:

1. Prove the selected path is disposable *at runtime* — read back
   `getDefaultAnkiDroidDirectory()`/`CollectionHelper.getCollectionPath()` on the test build and assert the parent
   is inside the emulator's own `/storage/emulated/0/Android/data/com.ichi2.anki.debug/…` (app-private) or a
   freshly created isolated directory, and assert `id -u`/package owner is the debug package.
2. Force `AnkiDroidFolder.APP_PRIVATE` (or an explicit test-only directory) before any collection is opened.
3. Assert the directory is empty before the first write and record its absolute path in the evidence log.
4. Where the public root cannot be proven disposable, the run must be **aborted**, not attempted.
5. `adb shell settings put global hide_error_dialogs 1` and `bash .github/disable_art_metrics.sh` are used by the
   inherited workflow and are safe to reuse.

No user-owned collection was opened, created, migrated or synchronized in this round — and none can be, until the
steps above are executed and recorded.

---

## 2. Required native-Reviewer functionality (D-02) — current status

| # | Check | Status |
| --- | --- | --- |
| 1 | App launches | **BLOCKED** — no APK |
| 2 | Deck Picker opens | **BLOCKED** |
| 3 | Creates / opens a disposable deck | **BLOCKED** |
| 4 | Displays the front of a card | **BLOCKED** |
| 5 | Reveals the answer | **BLOCKED** |
| 6 | Records **Again** | **BLOCKED** — native path source-verified, runtime unproven |
| 7 | Records **Hard** | **BLOCKED** |
| 8 | Records **Good** | **BLOCKED** |
| 9 | Records **Easy** | **BLOCKED** |
| 10 | Undo works | **BLOCKED** |
| 11 | Test collection persists | **BLOCKED** |
| 12 | Survives lifecycle recreation | **BLOCKED** |
| 13 | Normal navigation destinations open | **BLOCKED** |
| 14 | Official AnkiDroid data untouched | **BLOCKED** (nothing installed, so trivially true on the host; *unproven* for a future run) |
| 15 | Sync against a disposable account | **NOT ATTEMPTED — no authorized test account**; not part of R1 scope |

Source-level facts remain as recorded in FSA-00C and re-checked here: `Reviewer.kt:1580-1590` routes
`answerCardInner(rating)` through `undoableOp(this) { sched.answerCard(state, rating) }`, and
`libanki/.../sched/Scheduler.kt:172` `answerCard(input: CardAnswer)` delegates to `col.backend.answerCard(input)`.
One native authority, no duplicate scheduler, no second FSRS, no rating adapter
([08](evidence/00r1/08-identity-invariants.txt)). These are source facts and are **not** behaviour evidence.

---

## 3. Instrumentation route (D-03) — decided, not executed

`tests_emulator.yml` already contains the only tested emulator setup in this repository: KVM udev rules,
`insightsengineering/disk-space-reclaimer`, AVD cache (`actions/cache`), `sdkmanager` install of
`build-tools;37.0.0`, system image `android-36;google_apis;x86_64`, `reactivecircus/android-emulator-runner@a421e438…`
with `-no-window -gpu swiftshader_indirect`, `disable-animations: true`, and the Gradle entry point
`TEST_RELEASE_BUILD=true ./gradlew jacocoAndroidTestReport` (with `.github/disable_art_metrics.sh` and
`adb shell settings put global hide_error_dialogs 1` first, per `.github/workflows/README.md`).

Decision: **reuse it unchanged** rather than inventing a second emulator configuration. No emulator job was added
to `fsa-foundation-ci.yml` for this reason. Dispatch plan once Actions executes:

```bash
gh workflow run tests_emulator.yml --ref arena/a6008955-flashcard-android -f iterations=1
```

with the API-36 `google_apis` phone job as the baseline target (the API-37/16 KB and tablet variants are required
only for scheduled/manual matrix coverage, and their system images are a separate download cost).

Two honest caveats for whoever runs it:

* `tests_emulator.yml` sets `TEST_RELEASE_BUILD: true`, i.e. its instrumentation target is the **release** build
  type with the in-tree fallback keystore, not `fullDebug`. FSA-00's runtime evidence must therefore state which
  variant was exercised; mixing an APK from `fullDebug` with instrumentation results from a release build would be
  a misattribution.
* The emulator suite's existing instrumentation tests do **not** assert the fourteen D-02 Reviewer behaviours
  above. Passing the suite proves the app builds, installs, boots and its automated instrumentation works — it does
  not prove Again/Hard/Good/Easy/undo/persistence. Those require either a dedicated disposable-collection
  instrumentation test (new test code — out of scope for R1) or a documented manual session on a disposable
  emulator, with screenshots and the recorded collection path.

Emulator/runtime evidence for FSA-00 therefore remains **BLOCKED**, with a concrete route and a concrete gap.

---

**Current-revision follow-up (2026-10-31):** See [FSA-00R1 current-revision follow-up](FSA-00R1-CURRENT-REVISION-FOLLOWUP.md). This report above remains historical evidence for its stated revision; the follow-up records later GitHub runs and current blockers.
