# FSA-01 Handoff — Study-Agent Migration Inventory & Component Classification

> **Status:** **WITHHELD** — FSA-00 is **BLOCKED** at `f506261` (R4).
> Build, tests, APK, device Reviewer behavior, storage isolation and FSA-00A reconciliation are **not proven** and cannot become assumptions of FSA-01.
> This handoff contains conditional scope and exclusions only; it is **not** authorization to begin production migration.
> Next gate after verified lock: **FSA-01A — Study-Agent Migration Discovery & Component Classification**.

**As of:** 2026-10-29 UTC, `f506261b8968418a2d98f7bfa796ea61e98e1578` (8 ahead /142 behind upstream `c21570b0…`).
**Authority:** Audit and verification only. No feature migration in FSA-00.
**Evidence:** [R3 reassessment](FSA-00C-R3-INDEPENDENT-REASSESSMENT.md) and predecessor reports – must not be treated as FSA-00 PASS.

## 1. Precondition for activation

FSA-01A may start **only after**:

- FSA-00 independently verified and locked with executed evidence: HEAD recorded, baseline equivalence, toolchain pins confirmed via actual build, FullDebug APK built and hashed/verified, unit + build-logic + lint executions passed with XML/HTML evidence, device Reviewer matrix passed on disposable collection, isolation proven, sync/contract resolved.
- Parent-contract prerequisites: FSA-00A original reconciled with provenance, foundation-branch naming accepted, sync waiver authority documented if applicable.
- No unauthorized upstream merge; baseline `a7121c11c6…` frozen.

Current state: none of the above is satisfied – FSA-01 is **NOT AUTHORIZED**.

## 2. FSA-01A purpose (when unblocked)

Classify each existing `Drmusab/Study-Agent-Client` component against the frozen AnkiDroid baseline (`a7121c11…`):

```text
REUSE AS-IS
REFACTOR FOR ANKIDROID
ADAPT TO NATIVE REVIEWER
REPLACE WITH ANKIDROID IMPLEMENTATION
REMOVE
DEFER
```

Candidate families to inventory (not to copy automatically):

```text
core/voice/tts
core/voice/stt
core/audio
core/models/VoiceCommand
core/voice/StudyVoiceTurnGate
StudySession coordination
AudioRouteManager
SpeechOrchestrator
RecognitionOrchestrator
AI Provider integration
AI Study UI
```

Do **not** transfer old GATE 21 multi-backend assumptions. The native AnkiDroid Reviewer → libanki → Anki scheduler/FSRS authority (INV-00C-01..07) remains exclusive; voice/AI are future advisory/command inputs, not scheduler replacements.

Method after unblock: inventory component-by-component with source location, responsibility, data flow, storage, permissions and test mapping; produce classification matrix with rationale and residual risk; obtain review before any code copy.

## 3. Permanent exclusions (even after unblock)

The following are **out of scope** unless product owner explicitly issues a new architectural decision:

```text
PC ANKI ADAPTER:
EXCLUDED

PC ANKI BACKEND REGISTRY:
EXCLUDED

ANKICONNECT SCHEDULING:
EXCLUDED

PC CUSTOM STUDY ADAPTER:
EXCLUDED

DUAL ANKI SCHEDULER:
PROHIBITED

SECOND FSRS IMPLEMENTATION:
PROHIBITED

REMOTE PC CARD QUEUE:
PROHIBITED

AUTOMATIC CROSS-BACKEND FAILOVER:
PROHIBITED

STUDY-AGENT BACKEND SELECTION MIGRATION (GATE 21):
NOT AUTHORIZED
```

In code terms this excludes (non-exhaustive enumeration, not introduction):

```text
PcAnkiBackend
PcAnkiAvailabilitySource
PC Backend Registry
PC Custom Study Adapter
AnkiConnect Scheduler Integration
Remote PC Review Queue
Duplicate FSRS / Anki Rating Engine
RatingCommit adapter to PC (not the native undoableOp commit)
```

FSA-00C exclusion scans at `45b58a9` (R3-06/07) confirm none of these exist in the new architecture – that must be preserved. Optional **PC-based AI computation** is a separate future architectural topic, not PC Anki integration; it must not be confused with backend adapters. If pursued, it would be an optional AI provider path, not scheduler authority.

## 4. What FSA-01 does NOT inherit

- No claim that AnkiDroid builds without defects – build/test evidence is BLOCKED.
- No claim that Reviewer ratings/undo survive lifecycle without re-rating – runtime unverified.
- No claim that package separation equals storage isolation – runtime path must still be proven disposable.
- No claim that sync is safe without disposable account – sync remains UNVERIFIED.
- No release identity or signing policy – independent distribution belongs to **FSA-02**, not FSA-01.

## 5. Next step when FSA-00 locks

FSA-01A discovery report with per-component classification, exclusion reaffirmation, and explicit mapping of native Reviewer as authoritative study system. No code copy, no scheduler rewrite, no fallback-key distribution. Until then, **do not implement FSA-01**.

