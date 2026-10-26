# FSA-01 handoff — WITHHELD pending FSA-00 lock

**Not an authorization to start FSA-01.** FSA-00 is **BLOCKED**, per [final decision](FSA-00-FINAL-LOCK.md). This file records the stop condition and future scope only; no Study-Agent inventory, code copying, classification or integration has been performed.

## What can be inherited now

- Audited revision `f8212252540fe104663e935d4c582e9ad499ec89` has the same production/build/test source as reference `a7121c11c6e11d9c6ba34518784156fba1701e29`; only FSA-00B documentation differs.
- Source pins and native Reviewer-to-libanki mutation boundary were inspected; no PC scheduler/Study-Agent adapter was added.
- Build, tests, APK, device behavior, storage isolation and FSA-00A reconciliation are **not proven**. These cannot become assumptions of FSA-01.

## Preconditions to activate

Close mandatory blockers in [residual risks](FSA-00C-RESIDUAL-RISKS.md), reconcile original evidence, and obtain an evidence-backed independent FSA-00 lock decision. No production migration is authorized before that decision.

## Conditional next scope (after legitimate lock only)

**FSA-01A — Study-Agent Migration Discovery & Component Classification**, within FSA-01.
Reference: `Drmusab/Study-Agent-Client`; not imported or audited as migration work in FSA-00C.

Future classification vocabulary:

- REUSE AS-IS
- REFACTOR FOR ANKIDROID
- ADAPT TO NATIVE REVIEWER
- REPLACE WITH ANKIDROID IMPLEMENTATION
- REMOVE
- DEFER

Candidate families supplied by the mission—not verified paths or classifications yet—include `core/voice/tts`, `core/voice/stt`, `core/audio`, `core/models/VoiceCommand`, `core/voice/StudyVoiceTurnGate`, StudySession coordination, AudioRouteManager, SpeechOrchestrator, RecognitionOrchestrator, AI Provider integration and AI Study UI.

Authority must remain:

```text
Anki Studio Agent → AnkiDroid Native Reviewer → AnkiDroid/libanki → Anki Scheduler/FSRS
```

Explicitly excluded from any automatic migration:

- `PcAnkiBackend`
- `PcAnkiAvailabilitySource`
- PC Backend Registry
- PC Custom Study Adapter
- AnkiConnect Scheduler Integration
- Remote PC Review Queue
- Duplicate FSRS / Anki Rating Engine
- Dual-scheduler/backend-selection migration and automatic cross-backend failover

Voice/AI must use future authorized native Reviewer boundaries, not substitute scheduling authority. Old GATE 21 multi-backend assumptions are not inherited. Optional PC AI computation is a separate future decision, not PC Anki integration. Release identity/signing/storage policy remains FSA-02 work.
