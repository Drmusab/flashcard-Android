# FSA-00C — Architecture audit and scope verification

> **Current snapshot:** `45b58a9` on 2026-10-29. For gate decision see [FSA-00 final lock](FSA-00-FINAL-LOCK.md) and [R3 reassessment](FSA-00C-R3-INDEPENDENT-REASSESSMENT.md). Prior snapshot at `f821225…` preserved as historical.

**Revision:** `45b58a96dd161efb65339f4f8f1c6ef5d1138da1`.
**Date:** 2026-10-29 UTC. Evidence: [R3-07 source audit](evidence/00c-r3/07-source-audit.txt), [R3-06 scans](evidence/00c-r3/06-integrity-and-scans.txt), [R3-01/05 repo](evidence/00c-r3/01-repository.txt), manifest/pipeline excerpts inline.
**Scope:** FSA-00 baseline-only – audit only, no Study-Agent migration, no PC Anki, no scheduler rewrite.

## 1. Native Reviewer and scheduler authority

**Finding: Unchanged in inspected source; runtime proof still BLOCKED.**

### Legacy reviewer path (still present)

`AnkiDroid/src/main/java/com/ichi2/anki/AbstractFlashcardViewer.kt:864-890`

```
answerCard(rating) → preventSimultaneousExecutions(ANSWER_CARD) → inAnswer guard → displayAnswerIndicator → stopCardMediaPlayer → currentEase = rating → answerCardInner → updateCardAndRedraw()
answerCardInner: withCol { sched.answerCard(currentCard!!, rating) }  // direct backend via libanki
```

`Reviewer.kt:1580-1605` overrides `answerCardInner`:

```kotlin
override suspend fun answerCardInner(rating: Rating) {
  val state = queueState!!; val cardId = currentCard!!.id
  Timber.d("answerCardInner: $cardId $rating")
  var wasLeech = false
  undoableOp(this) {
    sched.answerCard(state, rating).also { wasLeech = sched.stateIsLeech(state.states.again) }
  }.also { previousCardId = cardId; if (rating==AGAIN && wasLeech) showSnackbar(leechMessage) }
  timebox = withCol { timeboxReached() }; if (notNull) dealWithTimeBox(timebox)
}
```

Key properties: undoable operation boundary, native `sched.answerCard` (libanki `sched` wrapping `backend`), stateIsLeech check after commit, previousCardId saved after operation, timebox dialog after. No Study-Agent adapter, no remote queue, no second scheduler. Invariants INV-00C-01/02/03/07 held in source (see invariants table).

`AbstractFlashcardViewer.kt:796-799` undo routes to `tryUndo()` checking native undo availability and invoking collection undo; `ReviewerViewModel.kt:400-403` similar. `Collection.kt:1260-1272` undo delegates to `backend.undo()` and clears caches. `Reviewer.kt:289-292` saves previousCard identity, not rating commit; ViewModel saves `KEY_PREVIOUS_CARD_ID` after operation (R3-07). No duplicate rating triggered by lifecycle restoration in inspected code – but **not proof against double input/process death**; those require blocked device tests.

### Modern ReviewerViewModel path (Compose/navigator)

`ReviewerViewModel.kt:192-193` `answerCard(rating)` maps to `ViewerAction.ANSWER_AGAIN/HARD/GOOD/EASY`; `527-541` `answerCardInternal`:

```kotlin
private suspend fun answerCardInternal(rating: Rating) {
  mutationSignal.await()
  state = queueState.await() ?: return; card = currentCard.await()
  answer = withCol { sched.answerCard(card=card, states=state.states, rating) }
  undoableOp(handler=this) { sched.answerCard(answer) }
  answerFeedbackFlow.emit(rating); savedStateHandle[KEY_PREVIOUS_CARD_ID]=card.id
  wasLeech = withCol { sched.stateIsLeech(answer.newState) }; if (wasLeech) onLeech(isSuspended)
  updateCurrentCard()
}
```

Commit is via `sched.answerCard(answer)` inside `undoableOp` – same native backend authority, not UI direct DB writes. `actionFeedbackFlow` and `answerFeedbackFlow` are UI feedback, not second scheduling databases.

Native custom scheduling JS hooks already exist (`Reviewer.kt:1640-1676`, ViewModel state-mutation methods, `cardStateCustomizer`) – these are **inherited Anki customization**, not Study-Agent/PC backend. Do not describe baseline as having no scheduling customization whatsoever; the authority remains backend.

Backend is pinned artifact `0.1.72-anki26.09.3`; its binary contents not downloaded/reverse-audited here; source delegation ≠ binary verification (INV-00C-01 qualified).

## 2. Exclusion and scope audit

**Finding: All excluded architectures remain absent in inspected source; Study-Agent migration not started.**

- **Exact tree diff (R3-01/06):** `git diff --name-only a7121c11..HEAD | grep -v docs/fsa` → empty. No fork production additions.
- **Case-insensitive symbol scan (R3-06):** `grep -Rin "PcAnki|AnkiConnect|RatingCommit|DualScheduler|SecondFsrs|StudyAgent|Study-Agent|Remote.*Queue|BackendRegistry"` → no hits.
- **Reference repository:** `Drmusab/Study-Agent-Client` not present in repo; no core/voice/tts/stt/audio/models/Orchestrator/Provider symbols introduced.

Specific architectural exclusions (permanent unless product owner issues new decision):

- **PC Anki Adapter / PC Backend Registry / PC Custom Study Adapter:** absent as new components; excluded. No `PcAnkiBackend`, `PcAnkiAvailabilitySource`, `PC Backend Registry` symbols.
- **AnkiConnect scheduling / Remote PC Review Queue / Automatic cross-backend failover:** absent; excluded.
- **Second FSRS / Dual Scheduler:** No separate engine. `AnkiDroid/.../scheduling/Fsrs.kt` is display wrapper:

```kotlin
object Fsrs { val version = FsrsVersion(BackendBuildConfig.FSRS_VERSION); val displayVersion: String? get() = version.displayString }
value class FsrsVersion(val libraryVersion: String) { val displayString: String? get() = when(libraryVersion) {"0.6.4"->"FSRS 4.5"; "1.4.3","2.0.3"->"FSRS 5"; "4.1.1","5.1.0","5.2.0","6.3.0","6.6.2"->"FSRS 6"; else->null}}
```

It displays native backend version, not implements FSRS. `libanki/sched/DummyScheduler.kt:12` `class DummyScheduler(val col: Collection) : Scheduler` throws for unsupported old v1/v2 scheduling, not functioning engine.

- **UI direct DB writes from additions / duplicate scheduling adapter:** No UI additions exist in fork diff; inspected rating paths commit through `libanki/backend`; not a claim that entire pre-existing app never accesses DB.
- **Upstream sync:** None. HEAD frozen; 6 ahead are docs/evidence only; 141 upstream commits not merged (R3-05).

Backend binary trust remains unverified until dependency capture on capable host – source delegation is not binary audit.

## 3. Identity, storage, permissions and backup surfaces (source-derived, not APK)

These are **expectations from source**, not installation findings – runtime verification BLOCKED.

| Surface | FullDebug | Release / official collision & residual risk |
| --- | --- | --- |
| App ID | `com.ichi2.anki.debug` (suffix `.debug` line 187) | Fork release defaults to `com.ichi2.anki` (101); unchanged – collision with official if distributed → signature mismatch, must not suggest uninstalling official → FSA-02 must define independent ID |
| Version | `2.26.0alpha7-debug`, code `22600107` (133-135) | Release `2.26.0alpha7`; ABI version overrides exist (310-322) |
| Cards provider | `com.ichi2.anki.debug.flashcards` | `${applicationId}.flashcards` (manifest 633); exported `CardContentProvider` validates caller permission in code; not relying on ID alone |
| FileProvider | `com.ichi2.anki.debug.apkgfileprovider` | `${applicationId}.apkgfileprovider` (642); not exported, `grantUriPermissions true`; actual grants need runtime review (`filepaths.xml` includes broad `external-path .` plus cache/export/shared-deck) |
| Permission | `com.ichi2.anki.debug.permission.READ_WRITE_DATABASE` (dangerous) | `${applicationId}`-derived (45); distinct name but code-level permission check still required |
| API contract | Debug suffix `.debug` (`api/build.gradle.kts:28`) | `ANKI_PACKAGE_NAME` distinct per variant; authority derivation `FlashCardsContract.getAuthority(packageName)` overloads for parallel builds |
| Instrumentation | `com.ichi2.anki.tests` (`AnkiDroid/build.gradle.kts:94-98` `testApplicationId`) | Not flavor-suffixed; not a production coexistence guarantee |
| Deep links / import | `anki://x-callback-url/browser`, `http/https` BROWSABLE, `application/apkg|colpkg|vnd.anki|x-apkg`, CSV/TSV, images SEND/VIEW | Can compete with official; wrong handler choice can import into unintended collection → must verify before import |
| File grants | `res/xml/filepaths.xml` includes `external-path .` | App IDs do not isolate shared files; actual grants/caller behavior needs runtime review |
| Android backup | `allowBackup="true"` (manifest 98) | No explicit `fullBackupContent`/`dataExtractionRules`/backup agent in tracked manifests; merged/library surfaces & reverse via backup APK unverified → never restore personal backup in tests |
| Collection storage | May use shared public `AnkiDroid` dir | `InitialActivity 263-355` / `SetupStorage legacyAnkiDroidDirectory 119-147` / `CollectionHelper 152-195` → PUBLIC for legacy/full permission sets; app-private is supported branch **not guaranteed for FullDebug** → runtime path must be verified before mutations |
| Signing | Default debug keystore (`~/.android/debug.keystore`) AGP | Release uses env `KEYSTOREPATH` else checked-in fallback `tools/fallback-release-keystore.jks` (`d1d3fb7d…` hash, passwords public) → never distribute fallback-signed release |
| Telemetry | ACRA `https://ankidroid.org/acra/report`, analytics dummy key | Fork crash attribution remains upstream-oriented; do not capture secrets |

`InitialActivity` chooses PUBLIC for legacy/external-manager; `SetupStorage.legacyAnkiDroidDirectory` uses shared external-storage root + `AnkiDroid` → `/storage/emulated/0/AnkiDroid` on typical primary-user emulated storage. On typical emulator this is the first-run default if permission granted – **must be overridden to disposable path before any mutation**. Full flavor retains `MANAGE_EXTERNAL_STORAGE` while `play` strips it.

Instrumentation runner appends `androidTest` beneath configured root (`CollectionHelper:186-195`) – not protection for personal root. Use entirely disposable environment for both UI and instrumentation tests.

## 4. Release safety policy (audit-only, no distribution)

- No APK built/signed/installed/distributed; no signing identity changed.
- Never distribute release signed with publicly known fallback key – even if installation works, passwords are public source (intentionally not recopied here; location cited in `AnkiDroid/build.gradle.kts:176-182`).
- Never install fork release over official, never suggest uninstalling official to bypass mismatch – protects app-private data and shared collection.
- Source debug ID separation ≠ collection isolation – require device evidence before claiming coexistence.
- Independent distribution identity, key custody, authorities/intent routing, telemetry and backup/storage policy belong to **FSA-02** – this report records blockers, does not implement.

## 5. Invariants (14)

| Invariant | Audit disposition (source vs runtime) |
| --- | --- |
| INV-00C-01 Exclusive native scheduling | **Held in source** – both Reviewer paths via `sched.answerCard` inside `undoableOp`; binary/runtime proof BLOCKED |
| INV-00C-02 No FSRS behavior change | **Held** – exact source diff empty outside docs |
| INV-00C-03 No second scheduling DB | **No addition** – source diff + mutation audit |
| INV-00C-04 No PC Anki Adapter | **Source exclusion held** – zero symbols |
| INV-00C-05 No AnkiConnect integration | **Source exclusion held** |
| INV-00C-06 No Study-Agent code copy | **Held** – exact diff outside docs/fsa empty |
| INV-00C-07 Rating/undo semantics intact | **Source unchanged**; behavioral verification BLOCKED (requires device) |
| INV-00C-08 User collections untouched | **No collection/device operation performed**; isolation verification BLOCKED |
| INV-00C-09 IDs do not imply isolation | **Explicit constraint retained** – public AnkiDroid dir can still be selected |
| INV-00C-10 No fallback-key distribution | **Held** – no artifact/distribution |
| INV-00C-11 No unauthorized upstream merge | **Held** – frozen HEAD/tree (6 ahead docs only) |
| INV-00C-12 No unavailable PASS | **Build/device BLOCKED**, not PASS |
| INV-00C-13 Executed evidence for lock | **No lock claimed**; R3 transcripts retained |
| INV-00C-14 No unverified handoff claims | **Handoff withheld**; FSA-01 not authorized |

**CI corroboration:** Workflows unchanged – `lint.yml:73` `lintAll ktlintCheck lint-rules:test`, `tests_unit.yml:177,181` `robolectricSdkDownload` + `jacocoUnitTestReport`, `tests_emulator.yml` instrumentation. No workflow run for exact HEAD (R3-05).

