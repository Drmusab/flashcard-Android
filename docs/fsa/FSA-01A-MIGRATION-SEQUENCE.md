# FSA-01A proposed migration sequence

**FSA-01A: COMPLETE — source discovery/documentation, 2026-11-13. Inventory awaits owner review. FSA-01B has not started.** Later numbering is provisional; this sequence grants no implementation authority.

## Entry and exit

[CODEX-05](CODEX-05-HISTORICAL-EVIDENCE-CLOSURE.md) records FSA-00 LOCKED. Entry recovery HEAD is `81fdb7c6581c96939cf7e4ec24201d923e717556`, branch codex/fsa00-recovery; application/build source matches accepted APK source `7653676c30374b8270f9be57871dacae0cc41d9a`. Source master inspected at `0976d1c48080e74926f1a86d2c472edb9128b7ca`; public target main was not assumed equivalent.

The [inventory](FSA-01A-COMPONENT-INVENTORY.md) covers every production Kotlin file and supporting/rejected dependencies. The [dependency map](FSA-01A-DEPENDENCY-MAP.md) distinguishes active/legacy/unwired paths; [native matrix](FSA-01A-NATIVE-REUSE-MATRIX.md), [exclusion audit](FSA-01A-EXCLUSION-AUDIT.md) and [verification plan](FSA-01A-VERIFICATION-PLAN.md) define reuse, risks and future tests. No production code, build configuration or historical report was modified. No application/build/test was run for discovery.

## Proposed first implementation slice: FSA-01B

**Native Reviewer typed-intent/card-turn guard using fake command input only.** Prerequisite: owner reviews this inventory and separately authorizes implementation. Establish source ownership/licensing before copying any source code/tests/assets. Newly authored native code still requires its own scoped task.

1. Define only Reveal, Again, Hard, Good and Easy requests. Capture native collection/profile, card ID, presentation epoch, side and request generation. Same card after Undo/redisplay is a new presentation.
2. On the native/UI owner thread, validate current identity/side; require answer side for ratings. Consume the presentation's rating request before launching asynchronous native dispatch. Manual rating invalidates pending voice intent; no second scheduler call or durable ledger.
3. Delegate once through established Reviewer commands, preserving undoableOp, libanki, native scheduling/FSRS, Undo and error handling. Voice code must not call scheduler APIs directly.
4. Invalidate work on presentation/side/card change, navigation, pause/destroy, collection/profile switch, manual action and cancel. Process restoration drops obsolete intent/confirmation/retry state; never replay ratings.
5. Target the established Reviewer surface first. Alternate ReviewerViewModel/ViewerAction remains voice-disabled until its guarded native seam/parity tests are included. No native UI replacement.

Acceptance: targeted five-intent, pre-reveal rejection, duplicate/late result, same-card new epoch, manual-vs-voice race, failed/cancelled native operation, Undo, lifecycle/profile switch and restoration tests. Inspect native transaction/review counts and preserved scheduling authority. Keep feature disabled outside the verified seam. No microphone, new TTS manager, cloud, service, schema or production migration in this slice.

## Later dependency order

| Proposed gate | Prerequisites | Bounded scope / acceptance |
|---|---|---|
| **01C: native media bridge** | Reviewed/passing 01B; rights for copied logic | Observe CardMediaPlayer/AndroidTtsPlayer completion/cancel/focus; retain AV/TTS tags/rendered side/voices. Test all audio settles, focus denial/loss, interruption, hidden-answer/cloze/RTL/media and cleanup. No parallel engine/queue. |
| **01D: foreground push-to-talk** | 01B+01C; explicit permission/privacy policy | Adapt grammar/recognition/settings/native controls. Generation-bound listener and owned retry cancellation; offline-only versus consented system/network policy. Test EN/AR ambiguity/confidence, permission/model/service failure, single terminal result, audio exclusion, tap/hold cancel and native dispatch. |
| **01E: automatic handoff/routing** | 01D; native media readiness | Adapt turn gate/gap/route policies. Verify actual Bluetooth/wired/speaker capture/output, disconnect/reconnect, calls, generations and self-echo on physical hardware. Automatic listening remains opt-in until acceptance; heuristics are not echo cancellation. |
| **01F: background/screen-off** | Explicit product scope, platform review, 01E | Design native service ownership, mic/mediaPlayback FGS types/permissions, while-in-use restrictions, notifications, power/privacy. Target API/device tests; do not transplant START_STICKY/two-hour wake-lock policy. |
| **01G: advisory AI/lexicons/cloud** | Provider/privacy/key custody/licensing scope and turn contract | AI-only request/result boundary, consent, redaction, cancellation, manual fallback and bounded cache retention. Medical hints user-configured; provider suggestions cannot autonomously rate/advance. Unwired remote transport is not an implemented provider. |
| **FSA-02: release/distribution** | Existing handoff requirements before independent distribution | Release application/provider/permission identity, signing/keys, storage/import/deep-link/backup/telemetry and license/source notices. Debug/fallback-signed foundation is not an independent release. |

Run checks affected by each actual diff and targeted native regression; do not rerun foundation suites by default. Preserve accepted APK/evidence and disposable private data. No PC adapter/registry, AnkiConnect scheduling, second FSRS, remote PC queue, cross-backend failover, parallel rating persistence or unauthorized upstream merge enters any slice.

**Stop: discovery complete. Inventory review and separate implementation authorization come next.**
