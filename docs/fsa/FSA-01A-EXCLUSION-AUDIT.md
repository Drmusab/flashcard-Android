# FSA-01A exclusion audit

**Inspection only; no source files deleted or migrated.** Source revision `0976d1c48080e74926f1a86d2c472edb9128b7ca`; exact file decisions/references are in the [inventory](FSA-01A-COMPONENT-INVENTORY.md).

| Permanent exclusion | Located source / actual status | Treatment |
|---|---|---|
| PC adapter/registry/cross-backend failover | core/anki/AnkiBackendRegistration, Resolver/Resolver2/Selector, BackendResolutionRequest/Result, BackendPreference, AnkiBackendDescriptor and related context/status contracts. AppContainer 597–601 currently registers only the local external AnkiDroid adapter. | REMOVE selection/routing/identity graph. A registry with one backend is still redundant inside native AnkiDroid. |
| PcAnkiBackend | No concrete production class found; PC_AGENT enum/IDs and legacy mode contracts exist. | Do not invent an active implementation claim; prohibit future introduction. |
| PcAnkiAvailabilitySource | data/anki/remote/PcAnkiAvailabilitySource.kt implements epoch readiness; source tests exist, no production constructor caller found. | REMOVE from migration despite tests. |
| AnkiConnect scheduling/remote PC review queue | ProtocolMessages, MessageFactory, RequestCoordinator, ProtocolJson, WebSocketAgentConnection; StudyReducer/SessionReconciler/StudySnapshot carry remote current-card/session/replay state. AnkiConnect itself is not an Android implementation located here; this protocol requests remote study/rating. | REMOVE legacy transport/schema and remote authority. Future AI-only contracts must have no review queue/rating/undo command or scheduler fallback. |
| Parallel rating persistence | core/anki/ReviewCommit*.kt, ReviewerAction*.kt; data/anki/DataStoreReviewCommitStore.kt, DataStoreReviewerActionStore.kt; core/study/SubmissionLedger.kt, CommitTruthDiagnostics, RatingCommitRecoveryUi/UiState; AnkiStudyEffectExecutor. | REMOVE IDs/ACK replay, commit/reconciliation/routing, stores and transaction UI. Native undoableOp/libanki owns persistence. Transient intent consumption must not become a durable replay ledger. |
| Parallel note mutation infrastructure | core/anki/create/NoteCreation*, core/anki/edit/NoteMutation*, DataStore stores, external write permits/gateways. | REMOVE transaction graph; existing native editor operations own mutations. No editor feature is needed for first voice slice. |
| Durable external session locks | StudySessionBackendLock, StudySessionLockStore, data/preferences/StudySessionLockDataStore, backend preference repositories, ownership projections. | REMOVE. Native profile/collection/presentation invalidates voice work; no cross-backend continuation. |
| Dual scheduler/second FSRS | No standalone second FSRS algorithm located in inspected production Kotlin. The risk is competing session/commit ownership, not a demonstrated duplicate FSRS implementation. | Preserve Native Reviewer -> libanki -> native scheduler/FSRS; REMOVE/REPLACE competing source authority even where it delegates interval calculation. |

## Dependency containment

ADAPT_TO_NATIVE_REVIEWER does not authorize copying its dependency graph:

- VoiceCommandManager loses StudyState mapping/uncontextualized IDs. SpokenCommandRouter loses StudyEvent dispatch; CardTurn loses server identity/authority. Replace inputs with native identity/phase and established native actions.
- STT models/settings lose server/session assumptions; confirmation and retries expire with presentation. Grammar cannot mutate the collection.
- StudyVoiceTurnGate receives native media/lifecycle state without StudySessionMachine. Native playback owns completion; acoustic timing does not require server controls.
- REFACTOR settings/diagnostics must remove AnkiBackendRegistry, backend selection, durable transaction and reconnect/server imports. Merely hiding UI strings is insufficient.
- DEFER remote/cloud speech does not authorize PC Anki transport. Future services are consented advisory providers; no fallback may change review backend or persist ratings remotely.

## Architecture status

This six-document change touches no production Reviewer, scheduler, FSRS, collection, sync, manifest or build implementation. It merges no upstream changes and introduces no excluded component. This is source discovery, not runtime proof that future code cannot violate these boundaries. Future acceptance must inspect real imports/calls and exercise cancellation/races before enabling voice.

## R2 server/resource closure and unchanged authority

The [supplemental inventory](FSA-01A-COMPONENT-INVENTORY.md#r2-supplemental-non-kotlin-dependency-register) explicitly excludes server/mock_pc_agent.py, server/review_commit_store.py and associated remote-review launch/client/contract fixtures. Their rate_card/ReviewCommitProcessor/file persistence cannot be copied as a second answer/rating path. Server-only TTS provider/PCM/cache/stream/media modules are deferred reference dependencies; no PC review command, unauthenticated/plain-HTTP media policy, source key custody or rating replay enters a future AI-only contract.

Source manifest, network security, backup/resource and old Gradle declarations are now individually classified. Existing native owners replace the source shell, not vice versa. Preserve current target manifest/build/source and FSA-00 evidence. Copy-status fields and [license matrix](FSA-01A-LICENSE-PROVENANCE-MATRIX.md) block unresolved transfer; DEFER/REUSE is not permission.

[Audio ownership contract](FSA-01A-AUDIO-OWNERSHIP-CONTRACT.md) defines only transient voice/audio coordination. Its proposed states select no review card, compute no schedule/FSRS, persist no rating and commit no answer. Native Reviewer -> libanki -> native scheduler/FSRS remains sole authority. Existing ReadText/video/JS/native TTS paths must be observed or automatic listening remains blocked; adding another source playback/focus manager is not a solution.

FSA-01B remains documentation-only under the [corrected sequence](FSA-01A-MIGRATION-SEQUENCE.md). No original 33-Gate roadmap alteration, upstream merge, feature migration or exception to any permanent exclusion is enacted by R2.
