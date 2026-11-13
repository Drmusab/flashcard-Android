# FSA-01B approved-scope proposal — documentation only

**Status: PROPOSED, NOT APPROVED. No FSA-01B work has begun.** Date 2026-11-13, Asia/Baghdad. This requested filename describes a proposal for owner approval, not an approval granted by Codex. The [R1 verdict](FSA-01A-INDEPENDENT-REVIEW.md) is **FSA-01A: CHANGES_REQUIRED**; findings remain in the [register](FSA-01A-FINDINGS-REGISTER.md).

## Purpose and entry conditions

Keep FSA-01 as **Source Audit & Migration Inventory**. FSA-01B should refine and reconcile the migration inventory, dependency boundaries and architectural preparation. It must not implement a production Native Reviewer Intent Guard, even behind a flag or with fake command input. Original sequence01C–G labels are unapproved implementation proposals, not additions to the project roadmap.

Before a separately authorized 01B task: owner reviews R1, agrees to the bounded documentation scope, and identifies the authoritative roadmap revision if available. Standalone Anki_Studio_Agent_Fork_Gates_Roadmap.md was not found during R1; the owner's current scope statement and historical FSA-00A section3 are the available authority. Do not reconstruct missing roadmap content. Exact FSA-06/07/08 titles and their full entry criteria must be reconciled before later implementation.

FSA-00 remains LOCKED. Reuse accepted application/build evidence; no foundation rerun is a prerequisite to editing documents. Copying rights remain blocked by unresolved first-party/dependency provenance; that hold permits documentation analysis but no code/test/asset transfer.

## Allowed scope, if the owner later authorizes this proposal

1. Revise the six discovery documents to resolve R1-001 through R1-007 while retaining their source pins and historical evidence. Correct every implementation-gate column and clearly identify current versus proposed behavior.
2. Repair high-risk per-file responsibilities, dependencies, actual call sites, component-local permissions and proposed destination. Preserve one primary technical classification, add separate copy-clearance status, and distinguish references from direct test assertions.
3. Extend the dependency boundary to material server providers/review persistence and Android manifest/network-security/resources; classify remote Anki authority as excluded and provider-only reference logic as deferred. Record what remains uninspected.
4. Produce a source/license provenance register: exact revision/artifact, author/origin evidence, license or permission basis, third-party notices, modifications and COPY_BLOCKED/CLEARED status. Do not clear absent evidence or assume repository ownership covers contributions/assets.
5. Document the future Reviewer/media/microphone interface and failure semantics below. Compare both native command surfaces; record which integration seam is proposed and which still needs a future experiment.
6. Add explicit future network, cancellation, focus/completion, gesture and asynchronous dispatch scenarios to the verification map, with objective expected native effects and gate prerequisites. Test plans remain NOT EXECUTED.
7. Produce a reviewable documentation diff, trace every finding to a proposed correction or explicit unresolved hold, and obtain owner review before any implementation task.

## Out of scope

No production/native adapter, guard, microphone, recognizer, service, UI affordance, test source, new module/dependency, schema, manifest, scheduler/FSRS, collection/sync, provider or persistence change. No build/device/authentication is needed for documentation preparation. No PR publication, merge, feature migration or automatic gate advancement. No PC adapter/registry, AnkiConnect scheduling, remote PC queue, cross-backend Anki failover, second scheduler/FSRS or parallel rating/answer commit path.

## Future interface requirements to document, not implement

| Contract element | Proposed semantics and native boundary |
|---|---|
| Presentation snapshot | Native profile/collection identity, card ID, presentation epoch, actual question/answer side and lifecycle owner. Native redisplay/Undo/switch creates a new epoch even if card ID is identical. This is an observation, not a second queue/session truth. |
| Voice request | Capture recognition/request generation and presentation/side identity; first action allowlist is Reveal and four native ratings. Free answer text and provider suggestions are advisory data, not mutation commands. Pending confirmations expire with native context. |
| Action validation | Revalidate on native/UI owner thread immediately before dispatch; reject stale/cancelled/unsupported requests and ratings on question side. Native buttons/auto-advance/navigation invalidate obsolete voice work. Reveal requests do not pre-authorize a later rating; answer side requires a fresh valid intent. |
| Dispatch/acknowledgement | Delegate once through the established native command/action workflow. Separate requested, handled/accepted and actual native completion/failure/cancellation; executeCommand's handled Boolean is not a transaction receipt. Resolve native results through existing operation/state observation, never a separate commit coordinator. A consumed live rating intent cannot retry/replay itself after interruption. |
| Persistence/Undo | Native undoableOp/libanki are the only write authority. No durable voice rating journal, duplicate transaction or independent interval calculation. After process death drop old intent/confirmation/retry state and reconstruct only from native state. Manual retry needs fresh explicit user intent and current context. |
| Media readiness | Observe both native sound and native TTS, including playback still draining/cancelling. Represent Completed/Cancelled/Failed distinctly; a finally completion callback alone does not permit listening. Revalidate epoch/side after the acoustic gap. Keep one native engine/media lifecycle; document the still-missing shared focus/readiness seam. |
| Recognition ownership | Main-thread recognizer ownership and generation-bound callbacks, owned delayed retry jobs, explicit offline/network policy, single terminal result and microphone permission/recording exclusion. Cancel/destroy and expire pending work on lifecycle/profile/presentation changes. |
| Privacy/network | Allowlisted diagnostics omit card/answer/transcript/audio/secrets. STT transcript logging in source is separately opt-in and defaults false; general debugLogging=true is not the same switch. Native AndroidTtsPlayer logs field text at Timber debug level, so sink reuse alone is not proof of a content-free path. Later network services require deliberate consent/trust/key/retention policy, typed failures and zero review mutations on provider failure. |

These are data/behavior requirements, not a Kotlin API or implemented state machine. No new durable owner or second answer transaction is proposed.

## Alignment with FSA-06/07/08

The table proposes allocation of future work to the requested native Reviewer integration track; it does not assert unavailable roadmap titles or approve implementation. Historical FSA-00A explicitly places voice Reviewer contracts at FSA-06 onward. Reconcile exact stage responsibilities against the full roadmap before starting any stage.

| Track | Documentation prepared in 01B | Future work only after that stage's separate approval |
|---|---|---|
| **FSA-06 native integration boundary** | Both Reviewer dispatch seams, identity/phase contract, operation/Undo authority, native media/focus ownership gaps and failure meanings. | A bounded native adapter/turn guard and the media readiness seam, with targeted native tests. No scheduler rewrite or second playback owner. |
| **FSA-07 voice consumption/integration** | Grammar/confidence/confirmation mapping, STT generation/cancel/offline policy and permission/UI contracts that consume the FSA-06 boundary. | Recognition/voice intents delivered through the approved native boundary, with permission/lifecycle/gesture and stale-result tests. Voice remains disabled on any unverified Reviewer surface. |
| **FSA-08 integrated study-loop acceptance** | End-to-end scenarios covering native audio->gap->mic->command, manual/native action races, physical routing, interruptions/restart and native review-record outcomes. | Whole-loop/device acceptance and any separately authorized automatic behavior after predecessor evidence passes. Background or cloud/AI features require their own approved roadmap scope. |

Preserve dependency ordering as named work packages: specify native identity/command boundary first; resolve sole media/focus/mic ownership before TTS-to-STT handoff; establish generation/cancellation/privacy before recognition can request native actions; then verify automatic handoff/routing and whole-loop behavior. Advisory AI and background policy must not bypass those prerequisites. No 01C–G numbering is adopted here. If the owner wants a different roadmap, prepare an explicit architecture-change proposal with old/new gate scope, dependencies, acceptance evidence and impact; approval is required before adopting it.

## Possible later proof of concept

After an explicitly authorized future experiment, a disposable fake-input harness could deliver Reveal/Again/Hard/Good/Easy intent descriptions to a fake native boundary, inject stale/duplicate/side/lifecycle events and record expected dispatch decisions. Its acceptance would be zero collection writes, no microphone/network, no source copying without clearance and no production registration. A later true native integration experiment must separately verify real operation outcomes and counts; a fake cannot prove native safety.

**No harness, prototype, test or production guard is implemented in R1 or approved by this document.**

## Exit and stop

A future 01B documentation pass exits with reconciled inventory/dependency/licensing/contract/test maps and an owner-reviewed scope decision. Unresolved copying rights remain explicit holds; only cleared items can enter a later transfer task. Gate transitions are not inferred from document counts or link checks. This R1 task stops at independent review and owner bundle delivery, with **FSA-01A: CHANGES_REQUIRED** and **FSA-00 LOCKED preserved**.
