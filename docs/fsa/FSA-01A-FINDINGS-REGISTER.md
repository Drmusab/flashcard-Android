# FSA-01A-R1 findings register

**Verdict: FSA-01A: CHANGES_REQUIRED.** 2026-11-13, Asia/Baghdad. Seven findings: three HIGH, three MEDIUM, one LOW. Severity describes migration/review risk, not a reproduced defect in the verified FSA-00 application. All remain OPEN against discovery commit `1128b1ed97928af95749d12b74298b4a8de4c598`; these review documents propose corrections but do not silently rewrite the six originals.

Source paths S below are exact paths below `app/src/main/java/com/studyagent/client/` at `0976d1c48080e74926f1a86d2c472edb9128b7ca`. Target paths T start at repository root at `81fdb7c6581c96939cf7e4ec24201d923e717556`. Original inventory row IDs are stable within 1128b1e. Related primary license records and the sample assessment are in [independent review](FSA-01A-INDEPENDENT-REVIEW.md).

## R1-001 — HIGH — Gate numbering silently advances implementation into source audit

**Location:** FSA-01A-MIGRATION-SEQUENCE.md, section Proposed first implementation slice: FSA-01B and Later dependency order; COMPONENT-INVENTORY, Gate column; VERIFICATION-PLAN, Target gap/gate; NATIVE-REUSE-MATRIX N1/N1b.

**Evidence:** The sequence proposes building the native five-intent guard in 01B, media bridge in 01C, push-to-talk in 01D and subsequent features in 01E–G. Calling numbering provisional does not reconcile it with FSA-01's source-audit purpose. Historical `docs/fsa/FSA-00A_Baseline_Discovery_Report.md` section3 explicitly says Contract for FSA-06 onward for voice actions entering validated Reviewer commands. The current owner instruction reserves FSA-01B for inventory/dependency/architecture preparation. The standalone roadmap was not available; exact later gate titles must not be invented.

**Risk:** A review of inventory could be mistaken for permission to implement Reviewer behavior before its roadmap gate and prerequisites.

**Correction:** Replace the01B implementation proposal with the documentation-only scope in [scope proposal](FSA-01B-APPROVED-SCOPE-PROPOSAL.md). Move future contract implementation to the native Reviewer integration track beginning FSA-06, and record proposed consumption/whole-loop verification against FSA-07/08 pending the actual roadmap. Use named work packages, not new01C–G implementation gates, until explicitly approved. Preserve interface-before-media-readiness-before-recognition-before-automatic-loop dependency order. Any reordered roadmap needs a separately identified owner-approved architecture change.

**Closure:** All six documents' Gate references agree with the approved roadmap/scope; owner reviews the correction. No production guard in 01B. **Status: OPEN; code implementation not authorized.**

## R1-002 — HIGH — Copying rights remain unresolved; dependency declarations are not a complete license clearance

**Location:** COMPONENT-INVENTORY section Reading the inventory/L1 and every reuse candidate; source root tree and `app/build.gradle.kts` dependency/packaging blocks; target COPYING, REUSE.toml, api/COPYING.LESSER, LICENSES and docs/contributing/copyright-headers.md.

**Evidence:** No tracked source LICENSE/COPYING/NOTICE/REUSE declaration or app-main copyright/license grant was found. Source history is shallow; last merge author/repository owner does not establish authorship of each component. L1 correctly withholds transfer rights, but no per-origin copy-clearance record exists. Actual direct dependency records include Apache-2.0 families, JUnit EPL-1.0 and JSON public-domain declaration; target contains LGPL API material as well as GPL application code. Source packaging excludes META-INF AL2.0/LGPL2.1; no corresponding complete notices artifact was demonstrated. The review report records exact dependency examples and limitations.

**Risk:** Owner-written, contributed, third-party, test and asset content could be copied under an unsupported blanket grant; license texts/notices or source obligations could be lost. Public readability is not a redistribution license.

**Correction:** Add a copy-status field separate from the primary technical classification. Set every unresolved source component/test/asset to COPY_BLOCKED. Obtain an applicable grant from actual rightsholders, record provenance and exceptions, map retained exact artifacts/transitives and preserve required notices/attribution/changed-file markers. Reuse target dependencies, not source Gradle pins. Do not label an unresolved component approved for transfer because its algorithm is suitable. Do not claim this review produced a complete SBOM or legal compatibility determination.

**Closure:** Documented first-party rights and applicable dependency/asset obligations clear each copied item. Pure documentation preparation can proceed separately; no code is transferred while unresolved. **Status: OPEN; copying BLOCKED.**

## R1-003 — HIGH — Native audio reuse does not yet define a safe completion/focus seam

**Location:** NATIVE-REUSE-MATRIX N2/N2b; COMPONENT-INVENTORY C190/C195/C207; DEPENDENCY-MAP Proposed native ownership; VERIFICATION-PLAN source focus risk.

**Evidence:** T `AnkiDroid/src/main/java/com/ichi2/anki/cardviewer/CardMediaPlayer.kt:245–255` invokes onMediaGroupCompleted in finally, including cancellation. At263–276, SoundOrVideoTag delegates to SoundTagPlayer, while TTSTag directly delegates to ttsPlayer. T `AnkiDroid/src/main/java/com/ichi2/anki/cardviewer/SoundTagPlayer.kt:133–139` contains the focus-grant check, but T `AnkiDroid/src/main/java/com/ichi2/anki/AndroidTtsPlayer.kt:141–188` speaks through TextToSpeech without this SoundTagPlayer focus gate. Therefore SoundTagPlayer's focus behavior is not automatic coverage of native TTS. Source S `core/voice/tts/DefaultSpeechOrchestrator.kt:513–515,559` counts focus denial but can continue to engine.speak, so copying that policy is also unsuitable.

**Risk:** A future bridge that treats generic group completion as successful playback could open the mic after cancel/error or under insufficient focus/ownership. REPLACE_WITH_NATIVE alone does not define the missing handoff semantics.

**Correction:** Retain native engine/media ownership, but document explicit observed outcomes Completed/Cancelled/Failed and owner/presentation identity. A bare finally callback must never authorize listening. Define how native sound and TTS jointly expose current playback, settled cancellation and focus state, including API24 compatibility; extension points remain proposals. Gate mic opening on current identity, successful permitted transition and exclusive audio/mic ownership. Do not add another TTS engine manager. No target defect fix is authorized by this review.

**Closure:** Revised seam specification and later targeted acceptance cases distinguish success/cancellation/failure, focus denial/loss and stale callbacks for both audio branches. **Status: OPEN; design correction required before later voice implementation.**

## R1-004 — MEDIUM — Several per-file rows describe incidental declarations or inherit misleading policy metadata

**Location:** COMPONENT-INVENTORY, especially C091, C108, C175/C176, C186, C196, C198, C291 and C375; Shared flow/permission policies.

**Evidence:** C175 assigns P1 microphone/recognizer lifecycle to pure CommandNormalizer, whose body S `core/voice/stt/CommandNormalizer.kt:14–115` uses Kotlin/java.text and no Android service. C176's responsibility describes a terminal result type instead of the orchestrator. C186 describes VoiceTurnBlock rather than the gate. C291 describes an audio-choice helper instead of the DI root; C375 focuses on backend-lock metadata instead of the ViewModel's rating/reveal/PTT/repository interactions. C198's P3 audio-only policy omits its RemoteTtsTransport dependency/network implications. C196 gives a generic unwired-remote rationale and Future AI-only destination, although S `core/voice/tts/DefaultSpeechOrchestrator.kt:495–496` actively invokes MedicalPronunciationProcessor locally. A missing cloud router does not explain that local lexicon's status.

**Risk:** A file count can hide incomplete responsibility/dependency analysis, and inherited required future safeguards can be mistaken for current source behavior. A local optional feature can be coupled unnecessarily to a cloud/AI gate.

**Correction:** Keep exactly one primary technical category per item but repair named responsibilities and actual runtime collaborators/callers. Separate permissions required by the component itself from caller/runtime prerequisites, and current lifecycle from proposed target requirements. For C175 retain conditional algorithmic REUSE_AS_IS with P0 and copy hold; C174/C176 remain REFACTOR; interpreter/gate remain ADAPT; competing TTS ownership remains REPLACE; ledgers remain REMOVE. C196 may remain DEFER as an optional **local** lexicon with its true active caller, independent of remote provider availability. Record direct tested assertions separately from lexical references; do not change every category mechanically.

**Closure:** Focused semantic revision of high-risk candidate rows and their concrete keep/drop/split dependencies; an explicit example traces every retained candidate to native owner or a still-missing seam. **Status: OPEN.**

## R1-005 — MEDIUM — Kotlin-only inventory omits material provider and integration dependencies

**Location:** COMPONENT-INVENTORY Frozen inputs/scope; DEPENDENCY-MAP Live versus legacy or incomplete; source repository tree outside app-main Kotlin.

**Evidence:** At the same source commit, `server/tts/openai_provider.py` defines OpenAiTtsProvider (line117), urllib HTTP access (66–70) and synthesize (224); `server/tts/elevenlabs_provider.py` defines ElevenLabsTtsProvider (159), HTTP requests (128/218) and synthesize (264). `server/tts/http_server.py:42–52` defines TtsMediaHttpServer with default require_auth=False; its module explicitly serves plain HTTP. `server/mock_pc_agent.py` and `server/review_commit_store.py` exist in the pinned tree. Android's ProviderBackendRouter remains unwired and no concrete RemoteTtsTransport implementation was located; that narrow finding is supported. Providers existing on the server is a separate fact, not proof that Android streaming works.

**Risk:** Provider protocol, trust, credential custody, server persistence and source obligations could enter later work without inventory decisions. No license grant was established for those files either.

**Correction:** Extend inventory boundaries explicitly to the relevant Python provider/transport/review-store dependencies and manifest/network-security/resources, without claiming all non-Kotlin content was audited. Proposed primary treatment: DEFER provider/PCM/AI-only server reference code pending privacy/rights/interface design; REMOVE existing remote-Anki mock/review-store authority from migration. Do not copy the plain-HTTP/default-auth server into the target. Document actual key custody/API/stream/cache dependencies and separate provider service/voice rights from code rights. No API call or server process is needed for this source audit.

**Closure:** Explicit decisions and dependency edges exist for these files/resources, with inspected versus uninspected scope stated. **Status: OPEN.**

## R1-006 — MEDIUM — Failure strategy needs explicit network and native acknowledgement scenarios

**Location:** VERIFICATION-PLAN Source test map and Required native acceptance; NATIVE-REUSE-MATRIX N1; source UI gesture code.

**Evidence:** The plan covers stale identity, reveal, duplicate ratings, cancellation, permissions and echo well. Network handling is expressed mainly as offline policy or generic future provider failures, without explicit mid-request/mid-stream/late-result outcomes. S `ui/components/PushToTalkButton.kt:137–149` invokes press/release and tap paths; tryAwaitRelease's cancellation result is ignored, and isProcessing does not guard pointer input there. Source `ui/screens/study/StudyScreen.kt:475–481` supplies callbacks without an enabled argument. T `AnkiDroid/src/main/java/com/ichi2/anki/AbstractFlashcardViewer.kt:864–882` starts asynchronous work; a handled executeCommand Boolean is not a durable successful rating receipt. The sample source STT chaos cancellation test uses already-labelled fake backend IDs, not the actual shared Android listener.

**Risk:** UI cancellation could be treated as submission, late network results could survive a turn change, or command handling could be mistaken for committed review success. These are static design/test gaps, not executed failures.

**Correction:** Specify future tests for no network/DNS/TLS/timeout, disconnect before result or after first PCM bytes, cancelled/late response after native card change, and fallback preserving manual review with zero remote/native rating writes from provider failure. Preserve TLS validation; do not blindly retry paid synthesis after partial delivery. Specify hold versus tap versus cancelled gesture and processing-disabled behavior; exactly one intended start/finish/dispatch. Define native action requested/accepted/completed/failed/cancelled semantics without inventing a second commit path or ledger. Add real-backend listener-generation/retry-delay tests, native completion/focus cases from R1-003, and native review-record assertions. All remain proposed/not executed.

**Closure:** Concrete arrange/action/expected-result cases are assigned to the actual future roadmap gates; source tests, retained foundation PASS and unexecuted tests stay clearly distinct. **Status: OPEN.**

## R1-007 — LOW — Workspace provenance must reflect the owner move

**Location:** COMPONENT-INVENTORY Frozen inputs/scope: authoritative C: checkout and shared object-store statement.

**Evidence:** Current clean accepted recovery checkout is D:/flashcard-Android-main/flashcard-Android-main/.recovery/checkout at 81fdb7c. L: discovery HEAD 1128b1e reads successfully; its previously recorded .git/objects/info/alternates file is absent in the current workspace. Thus the earlier dated shared-store description must not be treated as current configuration. C: had about 3.74GiB free, D: 15.89GiB, L: 9.49GiB at review entry; all new outputs remained L:.

**Correction:** Preserve historical location statements as dated observations; append current canonical paths and validate object availability before later work. Do not move environments, repoint Git object stores, clear caches or rewrite original evidence during this review. The new review records current paths.

**Closure:** Owner-facing handoff/current receipt uses D: recovery and L: discovery paths, with the old C: reference explicitly historical. **Status: OPEN against original snapshot; current-path correction recorded in R1.**

## Findings versus confirmed boundaries

No proposed architecture intentionally adds a second scheduler/FSRS or ledger; the exclusion direction is retained. The guard and scope proposal remain **documents**, not implementations. The independent pass supports native command reuse, removal of source transaction/PC authority, adaptation of bounded voice policies, and refusal to copy unresolved source. Licensing remains a copying hold; FSA-00 lock stays unchanged. See the scope proposal for review-only closure order. No finding is closed by 382 file rows or 429 resolvable links.
