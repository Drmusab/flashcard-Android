# FSA-01A dependency and ownership map

**Source:** `0976d1c48080e74926f1a86d2c472edb9128b7ca`. **Target:** `81fdb7c6581c96939cf7e4ec24201d923e717556`. Source paths below start at `app/src/main/java/com/studyagent/client/`; the [inventory](FSA-01A-COMPONENT-INVENTORY.md) provides exact pinned file links.

## Active source wiring

`StudyAgentApp.onCreate -> ServiceLocator.initialize -> DefaultAppContainer` constructs both Android speech/audio services and external/remote study infrastructure. The container must not migrate wholesale.

1. `di/AppContainer.kt:718–741`: AndroidTtsEngineAdapter -> DefaultSpeechOrchestrator with its own AudioFocusController; AndroidSpeechRecognitionBackend -> DefaultSpeechRecognitionOrchestrator. Its can-open-mic predicate checks source TTS speaking/queue state, not native card audio/profile/presentation.
2. AudioRouteManager device callbacks/broadcasts -> AudioRouteSnapshotFactory -> StudyAudioRouteCoordinator/StudyAudioModeResolver -> route flows. These represent availability/policy; the manager does not physically select the capture/output route. Source UI wording is not hardware verification.
3. `di/AppContainer.kt:808–849`: active StudySessionMachineRepository -> StudySessionMachine -> serialized StudyEvent -> StudyReducer -> state/effects. Voice passes through StudyVoiceTurnGate/recognition and interpreted commands return to the machine. Anki effects use AnkiStudyEffectExecutor, registry, review/action ledgers and durable session-lock store. Replace this authoritative study machine with native Reviewer.
4. `ui/screens/study/StudyScreen.kt:475–480` binds PushToTalkButton to StudyViewModel. `StudyViewModel.kt:221–239` delegates start/finish recognition; release itself does not submit. `StudyScreen.kt:190,681` mounts AudioRouteIndicator/VoiceWaveVisualizer. Reuse interaction ideas after native lifecycle/gesture tests, not the source study screen.
5. VoiceCommandInterpreter uses source context/confidence. `core/study/SpokenCommandRouter.kt:29–32` maps ratings to source UserRateCard events; `StudyViewModel.kt:100–102` calls the source rating repository. Neither is native dispatch. Native side/identity must be checked again regardless of interpreter confidence.

## Forbidden dependency graph

The local source Anki path is an **external application adapter**: repository -> core/anki contracts -> data/anki/ankidroid/AnkiDroidBackend -> provider gateways/ContentResolver -> installed AnkiDroid. AnkiDroidApiContract pins exported 2.24.1 behavior. The fork owns its collection/backend internally.

`di/AppContainer.kt:479,491` creates DataStoreReviewCommitStore/DataStoreReviewerActionStore. AnkiStudyEffectExecutor consumes ledgers, session locks, routing and reconciliation. SubmissionLedger adds in-memory rating/answer ACK state; SessionReconciler uses server-wins card/progression and PcRatingReplayPolicy. Remove all independent rating/transaction/remote-session ownership, durable or in-memory.

WebSocketAgentConnection and ProtocolMessages carry start_session/submit_answer/rate_card, correlation and reconnect. Dashboard/Control repositories/UI depend on them. No legacy message envelope, ACK replay or cross-backend recovery enters the target. Future AI transport must be incapable of scheduler commands.

## Live versus legacy or incomplete

- `di/AppContainer.kt:597–601` registers **only ankiDroidBackend**. PC_AGENT identities/modes exist, but no concrete production PcAnkiBackend class was found.
- `data/anki/remote/PcAnkiAvailabilitySource.kt` implements connection-epoch readiness and has tests, but no production constructor call site was found. It remains excluded.
- `di/AppContainer.kt:855` constructs legacyStudySessionRepository, not the main active property. Its VoiceHandoffController gap wrapper lacks the stronger post-delay stillValid check. Keep the StudyVoiceTurnGate concept, not both wrappers.
- ProviderBackendRouter has no production constructor call site. RemoteSpeechBackend belongs to that optional bundle; RemoteTtsTransport is an interface and its documented WebSocketRemoteTtsTransport implementation was not found. Streaming is not demonstrated working.
- AppSettings cloud/provider controls are not fully wired by AppSettings-to-TtsSettings mapping; provider/cloud and language fields cannot be assumed active from UI options.
- `AnkiStudyEffectExecutor.kt:52,361–400` has an optional evaluator defaulting null; absence returns evaluator_unavailable and manual review. AppContainer does not supply one. DTOs/server-fed feedback do not prove a working local LLM/tutor provider.

## Proposed native ownership

```text
Native profile/collection + Reviewer presentation/side + lifecycle
  -> bounded transient voice turn/cancellation state
  -> native media completion -> gap -> revalidate -> microphone
  -> generation-bound STT result -> typed intent
  -> native identity/side/single-consumption guard
  -> established Reviewer command/action path
  -> undoableOp -> libanki -> native scheduler/FSRS
```

Native CardMediaPlayer/AndroidTtsPlayer and compat focus own card audio. Native recording and SpeechRecognizer need exclusive microphone ownership. Use native preferences and bounded redacted diagnostics. Optional AI is a consented advisory branch, never rating truth.

The transient consumption guard prevents duplicate live dispatch; it is not a durable rating ledger. After process recreation discard old requests and rebuild only from native state. Undo/reappearance of the same card creates a new presentation epoch.

See [native reuse](FSA-01A-NATIVE-REUSE-MATRIX.md), [exclusions](FSA-01A-EXCLUSION-AUDIT.md) and [verification](FSA-01A-VERIFICATION-PLAN.md).
