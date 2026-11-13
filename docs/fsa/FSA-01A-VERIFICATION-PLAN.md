# FSA-01A verification plan and retained evidence

**Source/test inspection only; future voice acceptance is NOT EXECUTED.** No Gradle build, foundation suite, device run, installation or authentication was needed. The [inventory](FSA-01A-COMPONENT-INVENTORY.md) supplies per-file source/test references at `0976d1c48080e74926f1a86d2c472edb9128b7ca`.

## Evidence retained without rerun

[CODEX-05](CODEX-05-HISTORICAL-EVIDENCE-CLOSURE.md), [matrix](evidence/codex05/acceptance-matrix.json), [provenance](evidence/codex05/provenance.json) and CODEX-01/02/03/04 artifacts remain unchanged. FullDebug and PlayDebug each recorded 3,898 cases, zero failures/errors and 85 skips; lint-rule 118 with one skip; buildSrc 29 with one skip. Accepted x86_64 APK SHA-256: `4f373c2d3e1699e04fc0db5425f016260e44a4cb356aed9a8c65745d4f763102`.

Retained runtime scope: native reveal/four ratings/Undo, API36/WebView133, recreation/genuine process death, explicit app-private official/Debug isolation, local backup/restore, two-installation disposable AnkiWeb upload/download/logical state/restart equality and cleanup. It does not certify future voice, both Reviewer variants independently, physical Bluetooth, production collections/scale/media sync or clean-machine/bit-identical builds. No user-owned collection or credentials were needed here.

## Source test map

Paths below are relative to `app/src/` in Study-Agent. Tests were read/located, **not executed**. Model/reference use is not direct behavioral coverage. Fake backend tests cannot prove actual recognizer callback identity, routing, native transactions or target lifecycle.

| Candidate | Located tests / inspected assertions | Target gap / gate |
|---|---|---|
| Grammar/confidence/normalization | `test/java/com/studyagent/client/stt/VoiceCommandInterpreterTest.kt`, `test/java/com/studyagent/client/VoiceCommandManagerTest.kt`: rating words in answer remain text, alternatives depend on context, low-confidence ratings do not silently reschedule. | Native phase/epoch, Arabic diacritics/orthography/ambiguous اعد, EN/AR variants, unknown confidence, yes/no confirmation expiry, filler/fuzzy safety.01D. |
| STT policy/retry | Same test package `stt/RecognitionPolicyAndVocabularyTest.kt`, SpeechRecognitionOrchestratorTest, SttReliabilityChaosTest: exactly one terminal event, PTT release stops rather than submits, duplicate final/error-after-final/cancel/late partial/concurrent starts. | Real-backend listener generation; cancel during delayed retry; old recognizer callback after a new turn. Offline-only must refuse unsupported on-device recognition without network fallback; model/service/permission failures preserve manual review.01D. |
| Voice gate | `test/.../voice/StudyVoiceTurnGateTest.kt`: queued/speaking audio blocks mic; after-gap stale/pause/end/new speech/route change blocks; same-generation route noise does not cancel. | Feed native media/profile/presentation state; assert zero recognizer starts for each invalidation including same-card redisplay.01C–01E. |
| TTS/helpers | `test/.../tts/`: SpeechOrchestratorTest, SpeechQueueTest, SpeechChunkerTest, MixedLanguageSegmenterTest, MedicalPronunciationProcessorTest, SpeechTextPreprocessorTest, TtsVoiceSelectorTest, VoiceHandoffControllerTest. Sequence/dedup/cancel, engine failure/release and language/rate assertions. | Adapt to native AV/engine ownership; focus denial cannot speak, no hidden-answer/cloze leakage, UTF-16/input limits. Tests do not justify parallel queue/preprocessor ownership.01C; optional lexicon 01G. |
| Audio policies | `test/.../audio/`: StudyAudioModeResolverTest, StudyAudioRouteCoordinatorTest, StudyAudioPreferencesMappingTest, AcousticGapPolicyTest, PhoneModeLoopTest, SelfEchoAndPhoneMetricsTest. Safe-boundary switch, headset loss/required mode, generation and bounded simulated loops. | Physical capture/output routing, Bluetooth permission/reconnect, calls/focus/noise/false echo; simulated loops give no hardware PASS.01E. |
| Command safety ideas | `test/.../study/StudyReducerTest.kt`, SessionInvariantTest, source rating/recovery/architecture tests. | Do not port ledger contracts. Native tests must cover double/stale/pre-reveal/manual race/Undo/restoration with one native review transaction.01B. |
| UI/accessibility | `androidTest/java/com/studyagent/client/ui/StudyControlsInstrumentedTest.kt`: targets, disabled ratings without card, reachable pause/end, idle PTT does not claim mic open. `test/.../ui/StudyPhaseMappingTest.kt` and source design/settings tests. | Native theme/resources, EN/AR/RTL, large text/TalkBack/reduced motion, tap/hold/cancel cannot start twice; truthful mic/route state.01D–01E. |
| Diagnostics/settings | `test/.../data/DiagnosticsExportPrivacyTest.kt`, `androidTest/.../ui/DiagnosticsExportInstrumentedTest.kt`, codec/logger tests referenced in inventory. | Target exports contain no card/answer/transcript/audio/secrets; bounded retention; no backend-selection/durable-rating fields.01D/01G. |
| AI/remote speech | Interfaces/router/backend exist; no wired production provider router/evaluator or concrete RemoteTtsTransport implementation found. | No provider end-to-end PASS. Later consent/key/cache/cancellation/error/contract tests required.01G. |

`test/.../` expands to `test/java/com/studyagent/client/`; `androidTest/.../` to `androidTest/java/com/studyagent/client/`. File-by-file links distinguish located references from actual behavior inspected.

## Source-inspection risks to resolve in the affected implementation gate

These are static migration risks, not executed defect reproductions, and no source fixes were authorized:

- AndroidSpeechRecognitionBackend's shared RecognitionListener (around line468) reads the current activeTurn when emitting events. A late old callback could therefore be tagged with a new request ID; orchestrator ID matching alone does not prove generation safety.
- DefaultSpeechRecognitionOrchestrator schedules a delayed retry in a separate scope.launch after clearing the active request (around445). cancelCurrentTurn returns when no request is active (around226). Own and invalidate the pending retry job/generation, including cancellation during its delay.
- DefaultSpeechOrchestrator records focus denial (around513) but continues toward speech. Native integration must use the existing grant-aware focus path and test denial/loss, not inherit that behavior.
- RecognitionPolicyFactory sets allowNetworkFallback=true (around134); Android prefer-offline hints/on-device preference do not enforce a strict offline promise.
- SelfEchoDetector uses recent spoken-text similarity; it is a suspected-echo heuristic, not acoustic echo cancellation. Device availability likewise does not establish the actual Bluetooth microphone route.

## Required native acceptance before enabling voice

- **No double rating:** duplicate results/confirmations/gestures, concurrent native-button/voice and delayed completion cause at most one transaction per accepted presentation. Count native review records/operations, not a shadow ledger.
- **No stale action:** switch card/side/profile/collection/presentation during STT/TTS/retry/confirmation/gap; old work has no effect. Undo/reappearance gets a new epoch.
- **No pre-reveal rating:** reject all four ratings on question side even with high confidence/source RATING_EXPECTED. Native reveal semantics remain authoritative; no hidden-field speech.
- **Cancellation:** pause/navigation/destroy/manual action/revocation invalidates listener generation, pending retry, gap and confirmation. Restoration never replays a rating or stale automatic mic open.
- **Microphone/focus:** denial/permanent denial/revocation, missing service/model, focus denial/loss, native recorder contention and TTS failure preserve truthful UI/manual fallback and release resources. All native audio must settle before mic opens.
- **Offline/privacy:** prefer-offline is advisory, not proof. Explicit offline-only refuses unsupported on-device operation; system/network requires policy/consent. No implicit card/transcript/audio export.
- **Native authority:** inspect real imports/calls and exercise Undo/libanki state. No voice scheduler/FSRS math, direct rating persistence, remote queue or backend failover. Native state wins after restart/failure.

Cover minimum API 24 and31/33/34/35/36 plus physical hardware. Official references consulted 2026-11-13: [SpeechRecognizer](https://developer.android.com/reference/android/speech/SpeechRecognizer) for main-thread/lifecycle/on-device APIs; [audio focus](https://developer.android.com/media/optimize/audio-focus) for focus and target 35+ foreground requirements; [FGS types](https://developer.android.com/develop/background-work/services/fgs/service-types) for microphone/mediaPlayback/while-in-use restrictions. Recheck at implementation as platform policy changes.

## Documentation verification

Verify 382 unique production paths, one allowed primary category per file, resolvable source/test/target references and only the six Markdown deliverables changed. Confirm original recovery HEAD/worktree and FSA-00A hash unchanged; application/build source still equals accepted APK source. Run git diff --check and retain existing documentation-only precommit hook. These are document/metadata checks, not foundation test reruns. The completed checks found 382 unique classified production paths, one category each and 429 resolvable Markdown links; referenced test paths exist. Authoritative recovery and source worktrees remained clean, the original report digest matched, and application/build diff against accepted APK source was empty.

**FSA-01A: COMPLETE, ready for review. No feature-test PASS asserted. FSA-01B remains unstarted.**
