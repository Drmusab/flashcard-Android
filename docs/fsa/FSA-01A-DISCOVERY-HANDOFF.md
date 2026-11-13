# FSA-01A — discovery handoff

**Prepared 2026-11-13, Asia/Baghdad. Status: ready for a separately initiated discovery task.** [CODEX-05](CODEX-05-HISTORICAL-EVIDENCE-CLOSURE.md) locks FSA-00 using the verified original and retained executed evidence. This handoff supersedes the dated prerequisites in [the historical FSA-01 handoff](FSA-01-HANDOFF.md); that document remains unchanged. No FSA-01A inventory or production migration has been executed.

## Frozen inputs

- Repository: `Drmusab/flashcard-Android`; isolated branch: `codex/fsa00-recovery`.
- Historical source discovery: `a7121c11c6e11d9c6ba34518784156fba1701e29`; original [FSA-00A](FSA-00A_Baseline_Discovery_Report.md), discovery date 2026-10-25, SHA-256 `4b9d7fef3c3166eede26b3e753d892d54f81f61959e0e606747e7d315935935b`.
- Tested code: `1ca8fcc1c631c4000ae63ed53ee949a6cce78b33`; APK source: `7653676c30374b8270f9be57871dacae0cc41d9a`. Subsequent CODEX-01–05 changes are documentation only. Preserve the APK/source relationship.
- Verified x86_64 APK SHA-256: `4f373c2d3e1699e04fc0db5425f016260e44a4cb356aed9a8c65745d4f763102`; all four ABI identities/signatures remain in the [CODEX-01 receipt](evidence/codex01/codex01-apk-receipt.json).
- Exact accepted scope and references: [final acceptance matrix](evidence/codex05/acceptance-matrix.json), [closure](evidence/codex05/closure.json), [historical reconciliation](CODEX-05-HISTORICAL-EVIDENCE-CLOSURE.md).
- Toolchain: JetBrains JDK 21.0.11, Gradle 9.8.0, AGP 9.4.1, Kotlin 2.4.20, SDK 37, selected build-tools 36.0.0, native backend `0.1.72-anki26.09.3`. Task-local activation and tools remain outside Git under the outer `.recovery` and task-created D:/L: locations. Preserve existing caches/evidence; disk space is limited.

## Discovery task and expected deliverables

Inspect `Drmusab/Study-Agent-Client` as reference source only, recording its exact inspected revision. Do not infer portability or passing fork tests from that repository's historical tests. Produce a source-linked inventory for TTS, STT, command grammar/interpreter, voice-turn gating, audio routing, session coordination, voice models, AI-provider interfaces and study UI.

For each component record responsibility, dependencies, state ownership, persistence, threading/lifecycle, permissions, network/data flows, reusable tests, native counterpart, proposed destination, risks and one justified classification:

- **REUSE AS-IS**
- **REFACTOR FOR ANKIDROID**
- **ADAPT TO NATIVE REVIEWER**
- **REPLACE WITH ANKIDROID IMPLEMENTATION**
- **REMOVE**
- **DEFER**

These are classification options, not pre-approved decisions. Deliver the inventory, native integration map, bounded later implementation slices and acceptance criteria for review before any code transfer.

## Native authority and required design boundaries

Inspect both existing reviewer surfaces: `Reviewer.kt` / `reviewer/AnswerButtons.kt` and `ui/windows/reviewer/ReviewerViewModel.kt`. Map existing display/media/navigation lifecycles and command validation before proposing hooks. Ratings and Undo must continue through the validated native Reviewer command path, `undoableOp`, libanki and the native scheduler/backend. Direct scheduler calls from a parallel voice controller are not an approved integration.

Any future action must identify the current card and voice turn, validate question/answer phase, reject stale results, suppress TTS self-triggering, handle repeated user intent without duplicate ratings, and cancel obsolete work across navigation/process restoration. Do not persist a second rating ledger or claim the existing lifecycle test proves future voice correctness.

Inspect existing `TtsVoices.kt`, media playback, microphone ownership and recording paths before importing orchestration. Resolve TTS/STT handoff, focus, headset/speaker routing, cancellation and permission behavior. Screen-off/background microphone support requires a separate service-type, platform-policy and device acceptance analysis. AI evaluation remains advisory; provider privacy/network consent is later-gate work. Medical vocabulary is optional user configuration.

## Carry-forward limitations

- **FSA-02 before independent distribution:** release application ID/signing, key custody, provider/permission identities, shared storage defaults, chooser/deep-link/import routing, backup/telemetry identity, licensing and source disclosures. Do not install a custom release over official AnkiDroid or distribute fallback-signed builds.
- Foundation acceptance used explicit disposable app-private paths. Do not assume Debug's ID isolates public collections. Verify collection/media/backup paths before any future write. No user-owned collection was accessed in FSA-00.
- CODEX-04 used a text-only disposable sync sample. Production-scale/media sync, physical devices, exhaustive note types and all UI destinations remain outside that test. Temporary test credentials and certificate settings were removed; future authentication requires private native UI entry again.
- The optional connected instrumentation suite, clean-machine reproduction and bit-identical APK determinism have no PASS claim. GitHub Actions availability was not repaired; valid local evidence remains the basis of this gate. Rerun only checks affected by later source changes or a demonstrated issue.
- Do not reuse old upstream divergence counts as current. The recovery checkout is shallow; acquire history only when the next task needs it. Do not merge upstream automatically or reset `main`.

## Permanent exclusions

No PC Anki Adapter or PC backend registry, AnkiConnect scheduling, second FSRS/dual scheduler, remote PC review queue, parallel rating persistence or cross-backend failover. Do not transfer legacy backend-selection or Anki-transport architecture. Native AnkiDroid remains the sole study/review authority.

**CODEX-05 ends with FSA-00 LOCKED and this prepared handoff. Production implementation requires its own scoped task; none begins automatically.**
