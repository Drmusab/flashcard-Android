# FSA-00C — Native Reviewer and architecture safety audit

> **Historical snapshot:** This document describes the 2026-10-25 audit at `f821225…`, not the current checkout. For the 2026-10-28 independent reassessment and current gate decision, see [FSA-00C-R2 reassessment](FSA-00C-R2-INDEPENDENT-REASSESSMENT.md). Historical findings and evidence below are preserved.

**Audited revision:** `f8212252540fe104663e935d4c582e9ad499ec89`.
**Result: source boundary unchanged; runtime correctness/isolation BLOCKED.**
Evidence E05/E07/E08/E09 is indexed in the [entry report](FSA-00C-ENTRY-AND-EVIDENCE.md).

## 1. Mutation and undo boundaries

The audit covers both existing reviewer implementations, not just a symbol search:

| Source at audited revision | Finding |
| --- | --- |
| `AnkiDroid/src/main/java/com/ichi2/anki/AbstractFlashcardViewer.kt:864–889` | `answerCard(rating)` uses `preventSimultaneousExecutions(ANSWER_CARD)`, checks state, then calls `answerCardInner` and redraws. Its legacy base implementation calls the native scheduler for tests. |
| `AnkiDroid/src/main/java/com/ichi2/anki/Reviewer.kt:1580–1611` | Override obtains current queue state; exactly one `sched.answerCard(state, rating)` in `undoableOp(this)`, followed by leech/previous-card/timebox handling. |
| `AnkiDroid/src/main/java/com/ichi2/anki/ui/windows/reviewer/ReviewerViewModel.kt:192–202,527–552,720–762` | Ratings become ViewerActions; actions execute under `actionsMutex`. `answerCardInternal` awaits state mutation, constructs a CardAnswer, commits via `undoableOp(handler=this) { sched.answerCard(answer) }`, then updates feedback/previous-card state/queue. |
| `AnkiDroid/src/main/java/com/ichi2/anki/utils/ext/Scheduler.kt:11–18` | The first similarly named `sched.answerCard(card, states, rating)` in the ViewModel **only builds the answer and increments an in-memory counter**. It is not a second backend commit. |
| `libanki/src/main/java/com/ichi2/anki/libanki/sched/Scheduler.kt:130–172` | Commit overloads delegate to `col.backend.answerCard`; queue and scheduling states come from native backend. |
| `anki-common/src/main/kotlin/com/ichi2/anki/observability/OpChangesNotifier.kt:20–30` | `undoableOp` executes the collection operation via `withCol`, then notifies change subscribers on Main. It is not a separate scheduler. Undo semantics come from native collection/backend operations. |
| `AnkiDroid/src/main/java/com/ichi2/anki/Undo.kt:16–29,49–61`; `AbstractFlashcardViewer.kt:796–799,1706`; `ReviewerViewModel.kt:400–403` | Viewer undo routes to `tryUndo`, checks native undo availability and invokes collection undo in the same operation-notification boundary. |
| `libanki/src/main/java/com/ichi2/anki/libanki/Collection.kt:1267–1272` | Collection undo delegates to `backend.undo()` and clears relevant caches. |

`Reviewer.kt:289–292` saves previous-card identity, not a rating commit. The ViewModel saves `KEY_PREVIOUS_CARD_ID` after the operation. Existing action serialization is visible; no new lifecycle-triggered rating path was added. **This is not proof against double input, process death or lifecycle replay**: those require the blocked device tests.

Native custom scheduling JavaScript hooks already exist (`Reviewer.kt:1640–1676`, ViewModel state-mutation methods, scheduler `cardStateCustomizer`). They are inherited Anki customization, not a Study-Agent or PC backend. Do not describe this baseline as having no scheduling customization whatsoever. The native backend remains the commit authority; future AI/voice commands cannot add a second rating engine.

## 2. Exclusion and scope audit

E05's exact tree diff establishes no fork production additions. E07's case-insensitive scan of tracked code/configuration finds no `PcAnki`, `AnkiConnect`, `RatingCommit`, `Study-Agent`/`StudyAgent`, remote review/card queue, backend registry or custom-study adapter symbols. Negative symbol searches alone are not exhaustive proof; combined with unchanged baseline trees and the inspected mutation paths, they support the source-only findings below.

- **PC Anki Adapter / PC backend registry / PC custom-study adapter:** absent as new architecture components; excluded.
- **AnkiConnect scheduling / remote PC review queue / automatic cross-backend failover:** absent; excluded.
- **Second FSRS / dual scheduler:** no separate engine introduced. `AnkiDroid/.../scheduling/Fsrs.kt` displays the native backend's FSRS version; it does not implement FSRS. `DummyScheduler` throws for unsupported old v1/v2 scheduling, not a second functioning engine.
- **UI direct database writes from additions / duplicate scheduling adapter:** no UI additions exist in this fork diff; inspected rating paths commit through libanki/backend. This is not a claim that the entire pre-existing application never accesses a database.
- **Study-Agent migration:** not started; no reference client code copied, no inventory/classification implemented.
- **Upstream synchronization:** none. HEAD and production tree frozen; fetch of the reference object was for comparison only.

The backend is a pinned external artifact. Its binary contents were not downloaded or independently reverse-audited here; source delegation is not binary verification.

## 3. Identity, storage, permissions and backup surfaces

These are **source-derived expectations**, not APK or installation findings.

| Surface | FullDebug | Release/official collision and residual risk |
| --- | --- | --- |
| App ID | `com.ichi2.anki.debug` | Fork release defaults to official ID `com.ichi2.anki`; unchanged |
| Version | `2.26.0alpha7-debug`, code `22600107` | Release source `2.26.0alpha7`; ABI release version overrides exist |
| Cards authority | `com.ichi2.anki.debug.flashcards` | `${applicationId}.flashcards`; exported CardContentProvider checks calling permission in code |
| FileProvider authority | `com.ichi2.anki.debug.apkgfileprovider` | `${applicationId}.apkgfileprovider`; not exported, URI grants enabled |
| Permission | `com.ichi2.anki.debug.permission.READ_WRITE_DATABASE` | `${applicationId}`-derived, dangerous protection level; distinct release permission name |
| API contract | Debug `ANKI_PACKAGE_NAME` suffix `.debug` | `api/build.gradle.kts:24–28`; authority derivation must still be checked in merged artifact |
| Instrumentation package | `com.ichi2.anki.tests` | Not suffixed per flavor; a test APK is not a production coexistence guarantee |
| Deep links/import handlers | Existing `anki://x-callback-url/browser`, file/content and HTTP(S) import filters, SEND handlers | Can compete with official install; choosing the wrong handler can open/import into an unintended collection |
| File grants | `res/xml/filepaths.xml` includes broad external-path `.` plus cache/export/shared-deck locations | Actual grants and caller behavior need runtime review; app IDs do not isolate shared files |
| Android backup | `android:allowBackup="true"` | No explicit `fullBackupContent`, `dataExtractionRules` or backup agent found in tracked manifests; merged/library surfaces and platform restore behavior unverified |
| Collection storage | May use shared public `AnkiDroid` directory | `InitialActivity.kt:263–278,305–355`; `startup/SetupStorage.kt:119–147` |
| Signing | Default debug signing configuration; actual certificate unavailable | Release uses environment key if supplied, otherwise checked-in fallback keystore (`AnkiDroid/build.gradle.kts:167–182`) |
| Telemetry | Existing ACRA endpoint; analytics key defaults to dummy when not configured | Fork crash/report attribution remains upstream-oriented; do not capture account/collection secrets |

`InitialActivity` chooses PUBLIC for legacy/external-manager permission sets; `SetupStorage.legacyAnkiDroidDirectory` uses the shared external-storage root plus `AnkiDroid`. On typical primary-user emulated storage this is `/storage/emulated/0/AnkiDroid`. App-private external storage is another supported branch, **not guaranteed for FullDebug**. The full flavor retains broad external-storage permission while play removes it. Runtime path selection, imported/restored paths and profile preferences must be verified before mutations.

The instrumentation runner installs `TestingApplication`, which sets `isInstrumentationTest`; `CollectionHelper.kt:186–195` then appends `androidTest` beneath the configured collection root. Do not treat this as protection for a personal `/AnkiDroid` root. Use an entirely disposable environment for both UI and instrumentation tests.

Android backup/restore, collection backups and package import/export are separate surfaces. Baseline tests must not restore personal Android backups, select personal collection backups, or import user-owned packages. Backup destinations and collection paths require runtime validation; no restore was attempted.

## 4. Release safety policy for this audit

- No APK was built, signed, installed or distributed; no signing identity changed.
- Never distribute a release signed with the publicly known fallback key, even if installation works. Passwords are already public source; they are intentionally not recopied into new diagnostics.
- Never install fork release over official AnkiDroid, and never suggest uninstalling the official app to bypass signature mismatch. Protect its app-private data and shared collection.
- Source debug ID separation is not collection isolation. Require device evidence before claiming coexistence.
- Independent distribution identity, signing custody, authorities, intent routing, telemetry and backup/storage policy belong to **FSA-02**. This report records the blockers; it does not implement those changes.

## 5. Invariants

| Invariant | Audit disposition |
| --- | --- |
| INV-00C-01 exclusive native scheduling | Held in inspected source; binary/runtime proof blocked |
| INV-00C-02 no FSRS behavior change | Held by exact source diff |
| INV-00C-03 no second scheduling database | No addition; source diff and mutation audit |
| INV-00C-04 no PC Anki Adapter | Source exclusion held |
| INV-00C-05 no AnkiConnect integration | Source exclusion held |
| INV-00C-06 no Study-Agent code copy | Held by exact source diff |
| INV-00C-07 rating/undo semantics intact | Source unchanged; behavioral verification BLOCKED |
| INV-00C-08 user collections untouched | No collection/device operation performed; device isolation verification BLOCKED |
| INV-00C-09 IDs do not imply storage isolation | Explicit safety constraint retained |
| INV-00C-10 no fallback-key production distribution | Held; no artifact/distribution |
| INV-00C-11 no unauthorized upstream merge | Held; frozen HEAD/tree |
| INV-00C-12 no unavailable PASS | Build/device checks BLOCKED |
| INV-00C-13 executed evidence for lock | No lock claimed; transcripts retained |
| INV-00C-14 no unverified handoff claims | Handoff withheld; no FSA-01 production authorization |
