# FSA-01A migration sequence — R2 roadmap reconciliation

**FSA-01A: CHANGES_REQUIRED. FSA-01B: NOT STARTED.** Owner-supplied roadmap inspected 2026-11-13, Asia/Baghdad. This corrects the missing-roadmap limitation recorded at 0dff170; that prior documentation/bundle remains preserved.

## Authoritative roadmap evidence

The owner supplied `D:/flashcard-Android-main/flashcard-Android-main/docs/Anki_Studio_Agent_Fork_Gates_Roadmap.md`. Its exact SHA-256 is `34ac42269c91c61d3a7c618c886e254c92ac8079c8e353a5061a9f5bd01ef4d1` (142,719 bytes). The file describes a proposed architecture/implementation plan, not executed evidence. All 33 index entries,33 detailed gates and 99 A/B/C prompts were checked. The original file is unchanged; no gate or prerequisite is added, removed or reordered. A verbatim reference copy is included only in the owner review bundle, not the application source.

FSA-01B's specific prompt (lines186-187) requires file-by-file migration inventory and says not to port production code. Its generic IMPLEMENTATION label/boilerplate does not authorize a production guard; the current owner instruction reinforces this. FSA-01C remains the existing inventory verification/audit phase; retired provisional implementation labels do not replace it.

## Original33-Gate index — unchanged reference

| Gate | Phase | Exact roadmap title | Exact prerequisites |
|---|---|---|---|
| FSA-00 | A | Fork Baseline & Reproducible Build | None |
| FSA-01 | A | Source Audit & Migration Inventory | FSA-00 |
| FSA-02 | A | Fork Product Identity & Installation Isolation | FSA-00 |
| FSA-03 | A | Target Architecture Contract Lock | FSA-01,FSA-02 |
| FSA-04 | A | Quality Gates & CI Infrastructure | FSA-00,FSA-03 |
| FSA-05 | B | Extension Module Skeleton & Feature Flags | FSA-03,FSA-04 |
| FSA-06 | B | Reviewer Integration Surface | FSA-05 |
| FSA-07 | B | Turn Identity & Reveal-State Contract | FSA-06 |
| FSA-08 | B | Single-Authority Rating Gateway | FSA-06,FSA-07 |
| FSA-09 | B | Non-Rating Reviewer Actions | FSA-06,FSA-07 |
| FSA-10 | C | TTS Reuse & Speech Output | FSA-07,FSA-05 |
| FSA-11 | C | STT Engine & Microphone Permissions | FSA-07,FSA-05 |
| FSA-12 | C | Voice Command Grammar & Disambiguation | FSA-09,FSA-11 |
| FSA-13 | C | Voice Session Coordinator & Echo Protection | FSA-10,FSA-11,FSA-12 |
| FSA-14 | C | Hands-Free Study MVP | FSA-08,FSA-10,FSA-11,FSA-12,FSA-13 |
| FSA-15 | C | Audio Routing, Bluetooth & Interruptions | FSA-14 |
| FSA-16 | C | Background & Lock-Screen Voice Study | FSA-14,FSA-15 |
| FSA-17 | D | AI Provider Architecture — No PC Adapter | FSA-03,FSA-05 |
| FSA-18 | D | AI Context Privacy & Reveal Security | FSA-07,FSA-17 |
| FSA-19 | D | Typed & Spoken Answer Submission | FSA-11,FSA-18 |
| FSA-20 | D | AI Answer Evaluation & Validation | FSA-18,FSA-19 |
| FSA-21 | D | AI Explanations, Hints & Feedback | FSA-20 |
| FSA-22 | D | Constrained AI Tutor Conversation | FSA-21 |
| FSA-23 | D | Integrated AI Study UI | FSA-20,FSA-21,FSA-22 |
| FSA-24 | E | Evidence-Based Learning Insights | FSA-20,FSA-23 |
| FSA-25 | E | AI-Assisted Notes & Card Suggestions | FSA-21,FSA-23 |
| FSA-26 | E | Library & Navigation Integration | FSA-23,FSA-25 |
| FSA-27 | E | Voice/AI Settings & Personalization | FSA-16,FSA-17,FSA-23 |
| FSA-28 | F | Offline Degradation & Session Recovery | FSA-16,FSA-17,FSA-27 |
| FSA-29 | F | Security, Privacy, Backup & Licensing | FSA-02,FSA-18,FSA-25,FSA-28 |
| FSA-30 | F | UX, Arabic/English & Accessibility Lock | FSA-23,FSA-26,FSA-27 |
| FSA-31 | F | Performance, Endurance & Fault Injection | FSA-28,FSA-29,FSA-30 |
| FSA-32 | F | Release, Upstream Maintenance & Future Gates | FSA-31 |

## Correct implementation allocation, not authorization

| Work / safety boundary | Original gate and source evidence | Existing prerequisite / scope |
|---|---|---|
| Native read-only events and narrow Reviewer action seam | FSA-06 — Reviewer Integration Surface, lines354-387 | FSA-05. Native action path only; if a safe callback is unclear, stop the rating portion rather than inventing one. |
| Native turn generation, exact reveal side, stale/recreated/Undo identity | FSA-07 — Turn Identity & Reveal-State Contract, lines391-425 | FSA-06. Tests include A-B-A and late callbacks; no pre-reveal answer leak. |
| Rating admission/one-shot guard and delegation to native rating | FSA-08 — Single-Authority Rating Gateway, lines429-462 | FSA-06,FSA-07. This is the proper production rating-guard stage, not FSA-01B. No ledger, direct scheduler call or fabricated interval. |
| Native TTS/readiness/queue cancellation | FSA-10 — TTS Reuse & Speech Output, lines509-540 | FSA-07,FSA-05. Reuse existing native owners; no competing source manager. |
| Foreground recognizer and mic/permission/callback safety | FSA-11 — STT Engine & Microphone Permissions, lines544-579 | FSA-07,FSA-05. Initially explicit tap-to-speak; transcripts are data, not commands. |
| EN/AR intent grammar/ambiguity | FSA-12 — Voice Command Grammar & Disambiguation, lines583-616 | FSA-09,FSA-11. Closed intent policy and current command/answer mode. |
| Audio-state/echo/generation coordination | FSA-13 — Voice Session Coordinator & Echo Protection, lines620-657 | FSA-10,FSA-11,FSA-12. This owns the future audio state machine, not FSA-01B. |
| First end-to-end native voice loop | FSA-14 — Hands-Free Study MVP, lines661-698 | FSA-08,FSA-10,FSA-11,FSA-12,FSA-13. Real disposable-deck device evidence. |
| Extended routing/Bluetooth/interruptions | FSA-15 — Audio Routing, Bluetooth & Interruptions, lines702-737 | FSA-14. Physical-device route matrix; unsupported hardware remains blocked, not a new prerequisite edge delaying all foreground STT. |
| Background/screen-off | FSA-16 — Background & Lock-Screen Voice Study, lines741-773 | FSA-14,FSA-15. Explicit start/notification/platform restrictions. |
| Advisory provider/privacy, settings, recovery and distribution | FSA-17/18,27,28,29,32 respectively | Exact prerequisites are in the unchanged index. Rights clearance is required before copying; FSA-29 does not postpone that obligation. |

FSA-10 and FSA-11 share FSA-07/FSA-05 prerequisites; neither is silently made a prerequisite of the other. Their supported readiness joins at FSA-13. Phone MVP acceptance is FSA-14; extended Bluetooth/route certification remains FSA-15. Unknown audio paths cannot enable automatic listening, but that safety restriction does not rewrite the 33-Gate dependency graph. Source DEFER/provider/local-lexicon ideas remain scope/rights-dependent, not automatic feature approval.

## Current scope and stop

This task only reconciles FSA-01A documentation. [FSA-01B proposal](FSA-01B-APPROVED-SCOPE-PROPOSAL.md) has corrected-scope-only approval; FSA-01B execution remains unauthorized. The [audio contract](FSA-01A-AUDIO-OWNERSHIP-CONTRACT.md) and [V01-V12 test allocation](FSA-01A-VERIFICATION-PLAN.md) specify later work; no harness, source copy or implementation is started. Existing native Reviewer -> libanki -> native scheduler/FSRS and all architectural exclusions remain mandatory.

**R1-001:** roadmap/scope reconciliation is now verified; explicit owner scope-only approval now completes its original acceptance, so it is RESOLVED. No next-gate execution is authorized. **R1-002:** no license grant was found in the supplied folder; copying remains BLOCKED FOR COPYING. **R1-006:** exact test-stage mapping now follows the original roadmap and is RESOLVED as documentation; all future tests stay NOT EXECUTED. No roadmap amendment is proposed. Any future boundary change requires an explicit architecture decision and owner approval. Stop at this report/bundle; do not begin FSA-01B or merge/publish.
