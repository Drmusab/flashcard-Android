# FSA-01B approved-scope proposal — R2 documentation boundary

**CORRECTED SCOPE APPROVED ONLY; FSA-01B EXECUTION NOT AUTHORIZED. FSA-01B NOT STARTED.** 2026-11-13, Asia/Baghdad. The owner explicitly answered **“Approve corrected scope only”** for the correction documented in commit 037fb25. This closes R1-001 only. Current verdict remains **FSA-01A: CHANGES_REQUIRED**, with R1-002 OPEN / BLOCKED FOR COPYING. Roadmap reconciliation and R1-006 test allocation remain evidenced. The decision does not authorize source copying, implementation, testing, publishing or merging.

## Fixed scope

FSA-01 is Source Audit & Migration Inventory. A separately authorized FSA-01B can review/finalize the migration inventory, dependency mapping, architecture contracts and unresolved provenance. It must not implement the Native Reviewer Intent Guard or any production feature, even disabled or driven by fake input. No code/test/asset copy or independent reimplementation is authorized.

The original 33-Gate roadmap remains controlling. The owner-supplied file is now located and hashed; [sequence](FSA-01A-MIGRATION-SEQUENCE.md) reproduces its unchanged index. FSA-06 is Reviewer Integration Surface; FSA-07 is Turn Identity & Reveal-State Contract; FSA-08 is Single-Authority Rating Gateway. Voice/media/recognition integration is FSA-10 through16. Retired provisional implementation labels are not adopted; FSA-01C retains its original inventory audit role. No stage is authorized by providing the file.

## Entry and possible documentation outputs

Owner review of the corrected scope is completed; authorization to begin FSA-01B remains separate and has not been given. Copying holds are independent of technical classifications; documentation can be reviewed while rights remain unresolved, but no hold is waived. FSA-00 LOCKED evidence is reused without Android test reruns.

Potential outputs, if later authorized:

1. Review the now-verified original 33-Gate roadmap/hash and reconciled work-package/test assignments, without changing its stages or prerequisites.
2. Review every relevant candidate's keep/drop/split dependency boundary, native owner or missing seam, current versus future lifecycle, and direct versus lexical test evidence. R2 provides the candidate boundary register and supplemental server/resource coverage.
3. Complete origin/rightsholder/grant and artifact-notice records. Mark unresolved entries BLOCKED FOR COPYING; repository/contributor names alone cannot clear them.
4. Review the [audio ownership contract](FSA-01A-AUDIO-OWNERSHIP-CONTRACT.md) and [verification plan](FSA-01A-VERIFICATION-PLAN.md) as specifications. Record owner choices or remaining design holds before later implementation.
5. Produce a reviewable documentation decision/handoff. Approval of an inventory does not authorize a feature, source transfer, build, test suite, distribution, publication or merge.

## Future Reviewer interface — document only

A future adapter would accept a typed request bound to native profile/collection/card/presentation/side and request generation. Start with Reveal and native Again/Hard/Good/Easy requests; a question-side rating is invalid. Native state is checked at dispatch and every asynchronous boundary; Undo/redisplay of the same card creates a new epoch. Manual actions, pause/navigation, route/focus/permission change and profile switch invalidate old work.

Separate requested/handled from native completion/failure/cancellation. Delegate once through established Reviewer or the alternate native ViewModel action seam where separately verified, preserving undoableOp/libanki and native persistence. Do not implement a second commit path, scheduler/FSRS, card queue, shadow rating journal or replay. After process recreation discard old voice work and read native state. A suggestion/transcript/provider failure cannot write a review.

Only existing native audio owners create playback engines. The future transient voice coordinator observes a single native lease boundary covering supported native tags, ReadText, video/JS and recording; it cannot acquire a competing focus request or add another playback manager. Unknown output/completion/route remains automatic-listen blocked. Cancellation/error/stale callbacks cannot become successful handoff events. Transition IDs A01–A13 and future verification IDs V01–V12 define this contract; no state machine is implemented.

## Verified later integration allocation

| Gate / exact title | Native responsibility | Prerequisites |
|---|---|---|
| FSA-06 — Reviewer Integration Surface | Read-only presentation events and narrow native action seam. | FSA-05 |
| FSA-07 — Turn Identity & Reveal-State Contract | Native identity, generation, reveal phase and stale/cancel handling. | FSA-06 |
| FSA-08 — Single-Authority Rating Gateway | Actual production rating admission/one-shot guard and native delegation. | FSA-06,FSA-07 |
| FSA-10 / FSA-11 | TTS output and foreground STT/mic respectively, initially independent supported paths. | Both FSA-07,FSA-05 |
| FSA-12 / FSA-13 / FSA-14 | Grammar, voice-session/echo coordinator, then integrated hands-free MVP. | Exact original prerequisites in the sequence index. |
| FSA-15 / FSA-16 | Extended routing/Bluetooth, then approved background/lock-screen operation. | FSA-14; then FSA-14,FSA-15 respectively. |

No implementation belongs to FSA-01B. Preserve the exact 33-Gate graph: do not invent FSA-10 -> FSA-11 dependence or require future extended Bluetooth certification before every foreground STT task. Supported output/mic non-overlap is still mandatory before a voice loop starts. Any real schedule/boundary amendment needs an explicit owner-approved architecture decision.

## Possible later experiment, not part of FSA-01B

A future separately authorized disposable fake-input experiment could examine stale/duplicate/side/lifecycle decisions with zero collection writes and no mic/network. It must not be registered into production, use unresolved copied tests/code, or be treated as proof of real native transaction/audio safety. No experiment or prototype is implemented or authorized in R2 or this proposal.

## Exit and stop

Reviewable architecture documentation and an explicit owner scope decision are the only potential FSA-01B outputs. Preserve FSA-00 source/evidence, native scheduling/FSRS and all exclusions: no PC adapter/registry, AnkiConnect scheduling, remote PC queue, cross-backend Anki failover or parallel rating/answer persistence. Stop at R2 report/bundle; no FSA-01B, merge, publication or migration begins.
