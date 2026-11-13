# FSA-01A-R1 independent architecture review

**Verdict: FSA-01A: CHANGES_REQUIRED.** Review date: 2026-11-13, Asia/Baghdad. FSA-00 remains **LOCKED**. FSA-01B has not been authorized or started.

The native-authority direction is sound, but the discovery is not ready to authorize code transfer. Required changes concern gate scope, unresolved copying rights, incomplete native audio seams, misleading per-file metadata, omitted non-Kotlin dependencies and explicit failure tests. See the seven actionable items in [findings register](FSA-01A-FINDINGS-REGISTER.md). The [FSA-01B scope proposal](FSA-01B-APPROVED-SCOPE-PROPOSAL.md) is documentation-only and awaits approval; its filename does not grant approval.

## Evidence and review limits

Reviewed all six original documents from discovery commit `1128b1ed97928af95749d12b74298b4a8de4c598` on `codex/fsa01a-discovery`: component inventory, dependency map, native reuse matrix, exclusion audit, migration sequence and verification plan. The originals remain byte-for-byte unchanged. File/link counts are indexing checks only; they were not used as architectural evidence.

This is a separate source-based audit pass by Codex in the same chat that authored the discovery, not a claim of a different human reviewer, outside counsel or an organizationally independent team. Source sampling focused on the high-risk paths below; it does not certify every one of the 382 classifications or every transitive dependency.

- Study-Agent snapshot: `0976d1c48080e74926f1a86d2c472edb9128b7ca`, L:/AnkiStudioRecovery-01a1cc75/fsa01a-study-agent-source. It is shallow: a merge author's name is not proof of original authorship or ownership of each file.
- Target recovery baseline: `81fdb7c6581c96939cf7e4ec24201d923e717556`, now D:/flashcard-Android-main/flashcard-Android-main/.recovery/checkout, clean. Review work remains L:/AnkiStudioRecovery-01a1cc75/fsa01a-docs.
- Application/build diff against accepted APK source `7653676c30374b8270f9be57871dacae0cc41d9a` is empty. [CODEX-05](CODEX-05-HISTORICAL-EVIDENCE-CLOSURE.md) and all 16 mandatory PASS entries in its acceptance matrix remain unchanged. Original FSA-00A SHA-256 remains `4b9d7fef3c3166eede26b3e753d892d54f81f61959e0e606747e7d315935935b`.
- Standalone Anki_Studio_Agent_Fork_Gates_Roadmap.md was not found in either tracked tree, the moved project, existing L: workspaces or current attachments. GitHub connector was unavailable; public root-path fetch returned 404. No roadmap was reconstructed. The owner's current instruction defines FSA-01 as audit/inventory; historical FSA-00A section3 explicitly reserves voice Reviewer integration for FSA-06 onward. Exact FSA-07/08 titles/full roadmap dependencies remain unverified.

No builds, test execution, device session, authentication, source fixes, schema changes, release work or merges occurred. Source tests were inspected only. Git's attempted lazy fetch of sparse server blobs failed certificate validation; no verification bypass was used. Missing server files were read at the same pinned commit using ordinary Windows HTTPS trust; no provider service was called and no key was accessed.

The review bundle contains these nine documents only. Native source, target licenses and FSA-00 evidence are referenced from the pinned checkouts; they are not redistributed inside this documentation archive. An existing earlier bundle at the L: workspace root is preserved separately.

## High-risk source sampling

Paths below are relative to app/src/main/java/com/studyagent/client/ in the pinned source unless marked target. Exact lines/evidence and corrections are in the register.

| Area | Independently observed | Assessment |
|---|---|---|
| STT/grammar | CommandNormalizer separates aggressive command normalization from conservative answer cleanup. VoiceCommandInterpreter branches on source context; exact rating with unknown confidence may execute. VoiceCommandManager supplies uncontextualized IDs. | Algorithmic reuse of normalizer is reasonable after rights clearance; interpreter/facade require native identity/side adaptation. REUSE_AS_IS does not mean authorization to copy. |
| STT cancellation/offline | Backend shared listener reads current activeTurn; orchestrator delayed retry is not stored as an owned retry job. On-device preference can select SYSTEM; policy permits fallback. | Existing static risks are supported. Fake request-ID tests do not exercise callback retagging by Android backend or cancellation in the retry gap. No runtime defect was reproduced. |
| TTS/queue | DefaultSpeechOrchestrator owns queue/engine/focus and continues after focus denial; SpeechQueue holds bounded utterances, not review cards. SpeechTextPreprocessor expands raw cloze. Medical pronunciation is called on the active local speech path. | Replace competing card playback ownership; do not mislabel the utterance queue as a second scheduler. Optional local lexicon is distinct from unwired cloud routing. |
| Bluetooth/voice gate | AudioRouteManager enumerates devices and infers likely input; StudyVoiceTurnGate checks speech/route/validity before and after the gap. | Adaptation direction is sound; actual capture/output selection and native lifecycle remain unproven. |
| Native audio | Target CardMediaPlayer branches separately to SoundTagPlayer and AndroidTtsPlayer. Focus grant check belongs to SoundTagPlayer; completion callback also runs on cancellation. | Native reuse is preferred, but a successful safe-to-listen event and shared focus policy are not already demonstrated by those classes. R1-003. |
| Review authority | ReviewCommitCoordinator exposes commit/retry/recover; DataStoreReviewCommitStore persists a distinct snapshot. SessionReconciler has PC replay/server-owned progression. | REMOVE is supported. Do not transplant native-adapter ratings through this graph. |
| Backend/AI | AppContainer registers only external AnkiDroid backend. PcAnkiAvailabilitySource has no production constructor usage found. Evaluator defaults null; router/transport are not wired into active Android TTS. Python server providers do exist. | Exclusions are correct; absence of wired Android providers is narrower than absence of provider implementations repository-wide. R1-005. |
| Native/UI | Native Reviewer commands/undoableOp and alternate ViewerAction path are distinct. PTT source binds press, release and tap callbacks, and ignores cancellation result of tryAwaitRelease. | Preserve native dispatch and both surfaces' boundaries. Future gesture/processing/cancel behavior needs targeted tests, not copy approval from UI existence. |

## Native scheduling and collection authority

No implementation diff exists in this review or original discovery. The proposed authority chain remains **native AnkiDroid Reviewer -> libanki -> native scheduler/FSRS**. The accepted architecture must exclude source session/review queues, backend registry/resolution/failover, PC adapter/AnkiConnect rating protocol, review/action ledgers and all alternate mutation transactions. A future live presentation-consumption guard may suppress duplicate dispatch but must not persist/replay ratings or independently commit an answer.

Native Undo/current collection state is authoritative after interruption. Future AI feedback is advisory; suggested ratings must not bypass the guarded native command path. An audio utterance queue or transient voice phase is not itself a scheduler, but neither can own current-card progression. The source's second-FSRS prohibition is an architectural requirement; no standalone duplicate FSRS algorithm was located in sampled client code.

## Licensing and provenance review

**Code copying remains BLOCKED for every Study-Agent component until its applicable rights and dependencies are cleared.** GitHub repository ownership, a merge author and availability to read code do not establish a redistribution grant. The original L1 warning correctly withheld permission; R1 does not waive it.

Target COPYING is GPLv3; relevant native Kotlin headers specify GPL-3.0-or-later. REUSE.toml provides a collective attribution, not proof of individual copyright transfer. Target api/COPYING.LESSER carries LGPLv3; LICENSES includes Apache-2.0 and LGPL/GPL texts. [Copyright-header policy](../contributing/copyright-headers.md) requires preserving existing notices. Do not relabel all files/dependencies as GPL merely because the main application is GPL.

No tracked LICENSE/COPYING/NOTICE/REUSE license declaration was found in the source tree at the inspected revision, and no app-main SPDX/copyright grant was found. Establish author/origin history and owner authority to grant the intended license, including contributions, tests, icons, lexicons and copied snippets. The shallow snapshot cannot close that provenance requirement.

Actual declared dependencies were inspected in source app/build.gradle.kts. These primary records establish declared license families, not a cleared resolved SBOM:

| Dependency/provenance checked | Declared license / limitation | Required treatment before copying or distribution |
|---|---|---|
| AndroidX core1.13.1, activity-compose1.9.0, lifecycle-runtime-ktx2.8.3, compose-bom2024.06.00, navigation-compose2.7.7, datastore-preferences1.1.1, security-crypto1.1.0-alpha06 | Apache-2.0 in each exact-version Google Maven POM; e.g. [Core POM](https://dl.google.com/dl/android/maven2/androidx/core/core-ktx/1.13.1/core-ktx-1.13.1.pom). BOM license does not clear every resolved Compose artifact/transitive. | Retain required licenses/notices/attribution; inspect actual selected artifacts. Reuse target versions, not source toolchain/pins. |
| Coroutines1.8.1; serialization1.6.3 | [Coroutines license](https://raw.githubusercontent.com/Kotlin/kotlinx.coroutines/1.8.1/LICENSE.txt), [serialization license](https://raw.githubusercontent.com/Kotlin/kotlinx.serialization/v1.6.3/LICENSE.txt): Apache-2.0. | Account for runtime/transitive artifacts and source modifications; no automatic copying grant for application code using them. |
| OkHttp/logging/mockwebserver4.12.0 | [Versioned OkHttp license](https://raw.githubusercontent.com/square/okhttp/parent-4.12.0/LICENSE.txt): Apache-2.0. Mockwebserver is test scope; Okio/Kotlin and other transitive records still need capture. | Retain notices for retained artifacts; no legacy PC transport migration merely to reuse networking. |
| Turbine1.1.0, test-only | [Exact Maven POM](https://repo.maven.apache.org/maven2/app/cash/turbine/turbine/1.1.0/turbine-1.1.0.pom): Apache-2.0. | Distinguish test-source reuse, test tooling and shipped runtime. |
| JUnit4.13.2, test-only | Cached exact POM and [versioned license](https://raw.githubusercontent.com/junit-team/junit4/r4.13.2/LICENSE-junit.txt): EPL-1.0. | Do not blanket-relicense as GPL or assume shipped runtime. Assess actual copied source/distribution separately; preserve required notices/source obligations when applicable. |
| org.json20240303, test-only | [Versioned source license](https://raw.githubusercontent.com/stleary/JSON-java/20240303/LICENSE): public-domain declaration. | Do not infer older JSON-license terms or resolve local legal applicability from this one declaration; retain provenance and exact artifact metadata. |
| Target io.github.david-allison:anki-android-backend:0.1.72-anki26.09.3 | Existing cached exact POM declares GPLv3. This is not an audit of all bundled Rust/native dependencies. | Preserve accepted backend; carry full corresponding-source/native dependency obligations to distribution review. Do not infer an entire backend SBOM or blanket AGPL/GPL scope from one POM. |

Under [Apache-2.0 section4](https://www.apache.org/licenses/LICENSE-2.0), retain the license, relevant copyright/attribution and supplied NOTICE material, and mark modified files. Target GPLv3 COPYING sections4–6 govern applicable notices, modified works and corresponding source for conveyed binaries; LGPL's additional terms apply where relevant. Exact obligations follow the component and how it is conveyed, not whether code was generated or renamed. Source app/build.gradle.kts excludes META-INF AL2.0/LGPL2.1 files; that setting does not demonstrate that notices are supplied elsewhere and must not be copied as a compliance solution.

No full dependency resolution or license compatibility clearance was performed. Remaining review includes Kotlin/AGP/Gradle/tooling records, exact Compose/icon/runtime/test artifact notices, transitives, source assets/lexicon origins and provider-service/voice rights. Block copying each unresolved item; first-party permission cannot override third-party terms. This hold does not reopen accepted FSA-00 runtime/build evidence and does not block documentation-only remediation.

## Test strategy and exit

The existing plan correctly separates source assertions, retained foundation evidence and unexecuted future tests. Sampled source tests cover cancelled old request IDs, stale acoustic gap, route-loss results and context-sensitive commands. They do not prove real Android callback generation, native TTS focus, physical Bluetooth or native transaction behavior. Add the explicit network, callback-result, PTT cancellation and native dispatch-ack cases in R1-003/R1-006. Keep stale-card, reveal, duplicate rating, permissions, echo and lifecycle criteria.

**FSA-01A: CHANGES_REQUIRED.** Preserve the six originals as the reviewed snapshot. Revise their scope/mapping and metadata through a reviewable follow-up, resolve source-copy permissions before transfer, and seek owner review of the bounded documentation-only FSA-01B proposal. No migration approval, production guard, merge or publication follows from this review.
