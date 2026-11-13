# FSA-01A migration sequence — R2 corrected scope

**FSA-01A: CHANGES_REQUIRED. FSA-01B: NOT STARTED.** Documentation remediation 2026-11-13, Asia/Baghdad. This replaces the implementation scheduling proposed at 1128b1e; that prior version remains in Git history and the preserved R1 bundle.

## Roadmap authority and unresolved evidence

FSA-01 remains Source Audit & Migration Inventory. FSA-01B is documentation-only. The former implementation labels 01C–G are withdrawn; no replacement gates are inserted into the original 33-Gate roadmap. Historical [FSA-00A section3](FSA-00A_Baseline_Discovery_Report.md) places native voice Reviewer contracts at **FSA-06 onward**. The owner specifically identifies FSA-06/07/08 as the later integration track.

The standalone Anki_Studio_Agent_Fork_Gates_Roadmap.md is still unavailable. R2 searched the existing workspaces and the public main tree at 4bfadceba7d91abec270c4b45e95e26dbc294d15 (complete tree response, no roadmap path). No 33-Gate schedule, titles or acceptance criteria were reconstructed. Exact allocation across FSA-06/07/08 and all predecessor requirements must be confirmed against the original before implementation. **R1-001 remains OPEN for full roadmap reconciliation and owner review**, although the invalid FSA-01 implementation proposal is removed from every current discovery document.

## Current documentation work and proposed FSA-01B

This R2 task only corrects FSA-01A findings, source metadata, audio ownership, rights holds and future test specifications. It does not activate FSA-01B. The [FSA-01B proposal](FSA-01B-APPROVED-SCOPE-PROPOSAL.md) remains PROPOSED, NOT APPROVED; its scope is review of the bounded inventory/dependency/contracts and remaining architecture evidence. No native intent guard, fake harness, test source, playback/recognition code or feature flag may be implemented in that gate.

A future Native Reviewer Intent Guard is a **design requirement for the FSA-06-onward integration track**, subject to the original roadmap and separate owner authorization. Its interface must identify profile/collection/card/presentation/side and request generation, revalidate at native dispatch, reject stale/pre-reveal/duplicate actions, observe asynchronous native outcomes, and preserve undoableOp/libanki. No direct scheduler writes, second queue, replayable rating store or answer commit coordinator.

## Dependency ordering — work packages, not new gates

| Order / package | Architectural prerequisite | Future acceptance allocation |
|---|---|---|
| D1: inventory/rights/contracts | Existing pinned source and native boundary inspection. Separate technical category from copying rights. | FSA-01A remediation and any separately authorized documentation-only FSA-01B; no code transfer. |
| D2: native Reviewer boundary | Approved roadmap entry, licensing for any copied expression, native identity/side/operation semantics. | Future FSA-06-onward integration; exact stage allocation OPEN. Validate reveal/four-rating dispatch and native Undo without parallel persistence. |
| D3: native media/focus/mic ownership | D2 contract; [audio ownership contract](FSA-01A-AUDIO-OWNERSHIP-CONTRACT.md) includes native tags, legacy ReadText, video/JS and existing recording. | Before any automatic handoff; physical/engine acceptance belongs to the roadmap's actual audio/integration stages, not an invented FSA-01 subgate. |
| D4: foreground recognition/grammar/UI | D2 and supported D3 readiness, explicit permission/privacy/offline policy, generation-bound callbacks/owned retries. | Later authorized voice integration, including FSA-07/08 where prescribed by the original. No voice on unverified native surfaces/paths. |
| D5: automatic handoff/routing | D3+D4 proven on supported engines/devices; acoustic and exclusive mic readiness. | Later whole-loop acceptance; identity/route/lifecycle changes invalidate work. Availability does not prove Bluetooth capture route. |
| D6: optional background/advisory AI/lexicon | D2–D5 as applicable, explicit product/provider/privacy/FGS/key/service-rights scope. Local optional lexicon is independent of cloud routing. | Existing roadmap gates only, exact assignment pending original. No background or provider acceptance from source existence. |

Native prerequisites retain their logical order; the table is not approval to reorder the33-Gate roadmap. Independent release identity/signing/storage/licensing obligations remain at the existing FSA-02 boundary documented in the FSA-00 handoff. No release, PR merge or production migration is authorized here.

## Architecture-decision rule and stop

**R2 boundary clarification: no roadmap amendment is proposed or enacted.** If any future task needs to move a feature/gate, first submit a named architecture decision showing the original 33-Gate revision/hash, old/new scope and prerequisites, evidence impacts, risks and explicit owner decision. No silent change or inferred approval is valid.

[Findings register](FSA-01A-FINDINGS-REGISTER.md) records actual closure and residual holds. Source copying remains BLOCKED FOR COPYING where rights are unresolved. Preserve native Reviewer -> libanki -> native scheduler/FSRS and every permanent exclusion. Stop after R2 documentation review; no prototype or FSA-01B work follows automatically.
