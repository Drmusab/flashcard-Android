# FSA-00C — Independent baseline reassessment and gate decision

> **FSA-00: BLOCKED — NOT LOCKED.** Source equivalence and the scoped source architecture audit are supported. The required build, tests, APK, Android Reviewer and collection-isolation evidence is missing. FSA-00A reconciliation is blocked. **FSA-01 production migration is not authorized.**

**Observation date:** 2026-10-28 UTC. **Authority:** FSA-00C audit only. This is a new assessment of the repository state, not a claim that the preceding FSA-00C audit was executed at this HEAD. The prior reports and their evidence are preserved as historical snapshots. No application, build, dependency, manifest, identity, signing or scheduler change is made here. Owner roles below are suggested responsibilities, not confirmed assignments.

## 1. Repository and provenance

| Field | Result |
| --- | --- |
| Target | `Drmusab/flashcard-Android`, GitHub parent/source `ankidroid/Anki-Android` |
| Audited HEAD | `99d339e48c93d7b9c63113cb702574981e5cff30` |
| Branch | `arena/657ed7e0-flashcard-android` |
| Worktree | Clean on entry. This reassessment adds this report and R2 evidence, and adds historical-snapshot notices to existing reports; no pre-existing changes were discarded. See current `git status --short` for the live worktree. |
| Origin | `https://github.com/Drmusab/flashcard-Android.git`; no configured upstream remote |
| Reference | `a7121c11c6e11d9c6ba34518784156fba1701e29`; baseline object fetched by SHA for tree comparison, without merge or branch switch |
| Upstream snapshot | `4561666d03b7be6ac262ebf307d0f7a110e3cf09`, observed 2026-10-28 |
| Fork divergence | GitHub compare: **4 ahead / 88 behind** that upstream SHA, merge base `a7121c11c6e11d9c6ba34518784156fba1701e29`. These are snapshot counts, not a complete inventory of upstream changes. |
| History | Shallow checkout; `HEAD` and fetched baseline trees are available, but local ancestry is incomplete. GitHub compare supplies the common ancestor and divergence; it is not a local full-history proof. |
| Baseline comparison | `git diff --name-status a7121c11… HEAD` lists **18 added files, all under `docs/fsa/`**: FSA-00B, seven prior FSA-00C/handoff documents, and ten prior evidence transcripts. Excluding that directory the diff is empty. Production Kotlin/Java, tests, build configuration, manifests, resources and dependencies are unchanged. |

At observation, remote `main` and audited HEAD matched. The four fork-only commits shown by the API are the two documentation commits and their merge commits. No upstream synchronization was performed. GitHub reported no workflow runs for the exact audited HEAD or in the fork at the time of inspection; a documentation merge is not build evidence. R2 worktree modifications are also documentation/evidence only, not part of the audited HEAD.

### Evidence index

All paths are relative to this document. Timestamps, commands and exit codes are retained where captured. `R2-03` includes a first shallow-check label returning 2 due to absent optional paths and a subsequent corrected check; `R2-04` similarly includes a corrected host check. A shell pipeline's final exit code is not treated as proof that every subcommand succeeded. The fallback password literals in the source excerpt are intentionally redacted; the source location is cited.

| ID | Evidence | Contents |
| --- | --- | --- |
| R2-01 | [Exact commands, initial environment](evidence/00c-r2/01-wrapper-exact-commands.txt) | `java -version` and seven requested wrapper invocations, exits and output |
| R2-02 | [Wrapper with temporary JVM](evidence/00c-r2/02-wrapper-with-jvm.txt) | Same seven invocations with a separately provisioned Temurin runtime, including actual wrapper TLS errors |
| R2-03 | [Repository and upstream](evidence/00c-r2/03-repository-and-upstream.txt) | Git state, baseline tree diff, GitHub metadata/compare, CI and prerequisite searches |
| R2-04 | [Environment and network](evidence/00c-r2/04-environment-and-network.txt) | JVM provenance, tool and SDK inventory, host resources, endpoint probes |
| R2-05 | [Source audit](evidence/00c-r2/05-source-audit.txt) | Numbered Reviewer, scheduler, identity, storage and CI excerpts; exclusion scans |
| R2-06 | [Integrity and reconciliation](evidence/00c-r2/06-integrity-and-reconciliation.txt) | Source hashes, prior snapshot provenance, output search and inherited integrity posture |
| Historical | [FSA-00B](FSA-00B-fork-baseline-build-verification.md), [prior FSA-00C entry](FSA-00C-ENTRY-AND-EVIDENCE.md), [prior final decision](FSA-00-FINAL-LOCK.md) | Earlier observations and their original linked transcripts, not current-head execution results |

## 2. Prerequisite and documentation reconciliation

- **FSA-00A: BLOCKED.** The original discovery report was not found by repository/workspace filename and content searches, available PR/release inspection, or any attachment supplied in this session. This is not a claim that no private archive exists. Its findings cannot be attributed, compared or recreated without the original and provenance.
- **FSA-00B: PARTIAL.** The report is present; its source pins, baseline identity, nine SHA-256 anchors and blocked build conclusion are corroborated by current source and fresh attempts (R2-03–06). This is not independent recovery of every original execution log. Its original observation was at `a7121c11…`, not the current HEAD.
- **Historical evidence: NOT RECONCILED in full**, because FSA-00A is absent. The prior FSA-00C audit at `f821225…` was merged via PR #2 and is a separate historical snapshot; its `2 ahead / 17 behind` and one-report-only diff were valid for its cited snapshot, not current HEAD. Its blocked result is consistent with the present result.

Explicit qualifications, preserving the original documents:

1. FSA-00B §5.1 and actual CI `.github/workflows/lint.yml:73` specify `ktlintCheck`; FSA-00B §5.2 and `.github/workflows/README.md:16` use `ktLintCheck`. The correctly spelled command was attempted in this reassessment; neither spelling in the historical attempt reached task resolution.
2. FSA-00B's blanket “any ≥17 launcher” statement is not established as an unlimited compatibility guarantee. The source selects a JetBrains 21 daemon independently of `JAVA_HOME` and enforces a daemon JVM range of 21–25. The actual daemon here never started.
3. The instrumentation collection path is an `androidTest` subdirectory of the *configured* collection root, not inherently an isolated device. No personal root should be used. An absent `upstream` remote does not itself make a URL-based merge impossible; no-merge evidence is the frozen Git/tree and command record.
4. The earlier suggested sync waiver requires explicit parent-contract authority; none is available here. The historical foundation-branch naming requirement also needs owner/contract clarification. This fixed session branch was not changed or recreated. Any host memory adjustment must be recorded, not hidden.
5. Current catalog pins AGP 9.4.1 despite a stale adjacent comment referring to 9.0.1 (`gradle/libs.versions.toml:24–26`); the actual catalog value, not the comment, is the source pin. SDK/build-tools compatibility remains untested.

Contributor and architecture context includes `CONTRIBUTING.md`, `AI_POLICY.md`, `docs/development/gradle-daemon-jvm.md`, actual unit/lint/emulator workflows and the prior source audit. No upstream contribution, remote workflow dispatch or PR operation was performed.

## 3. Toolchain and actual build verification

| Item | Source / observation | Result |
| --- | --- | --- |
| Gradle | `gradle/wrapper/gradle-wrapper.properties` pins 9.8.0; no `distributionSha256Sum` | **BLOCKED** — wrapper JAR launched with a JVM but distribution download failed TLS; Gradle itself never ran |
| JDK / daemon | `gradle/gradle-daemon-jvm.properties`: JetBrains 21; root guard 21–25 | **BLOCKED** — clean environment had no Java; temporary Eclipse Adoptium Temurin 21.0.8+9 runtime ran the wrapper, but is not the pinned JetBrains daemon and lacks `javac`. Daemon vendor/version/resolution not observed |
| AGP / Kotlin | Catalog pins 9.4.1 / 2.4.20 | Source pins verified; dependency resolution and compatibility unverified |
| Android SDK | compile 37/minor 0, target 36, minimum 24; no SDK manager or installed platform observed | **BLOCKED** — no Gradle SDK diagnostic or exact AGP-selected build-tools patch established |
| Dependencies / Robolectric | Google Maven, Maven Central, Plugin Portal and JitPack declared; backend `0.1.72-anki26.09.3`, Robolectric 4.17 | **BLOCKED** — no dependency graph or downloaded backend/SDK. Endpoint failures do not prove dependency incompatibility |
| APK / metadata | No APK found (R2-06) | **NOT PRODUCED** — path, size, hash, binary package/version/variant and certificate fingerprint unavailable; no bit-for-bit reproducibility claim |

The host inventory (R2-04) found Debian Linux x86-64, 2 CPUs, 3.8 GiB RAM, no swap, ~20 GiB free disk, no Android tools, emulator or `/dev/kvm`. Memory is a readiness risk, not an observed OOM. Standard Gradle/Google/Maven/Plugin Portal/JitPack/Foojay endpoints failed network probes; GitHub, PyPI and npm registry were reachable. No unauthorized mirror or dependency substitution was used. The temporary JVM was installed outside the checkout from the PyPI `jdk4py` 21.0.8.2 wheel; its SHA-256 matched PyPI's published digest (`85addfcb57c7051dad6145b9f816fc519337e9a0c705ef01edc9dc7818ee0356`). This establishes only the observed launcher, not trusted build inputs or the pinned daemon.

### Commands and results

Each command below was executed twice, independently, without changing project configuration. Initial environment: `java -version` exit **127**, all seven wrapper commands exit **1** with no Java on PATH. Supplementary run: `JAVA_HOME=/home/user/.audit-tools/jdk/jdk4py/java-runtime`, `java -version` exit **0**, reporting Temurin 21.0.8+9; each wrapper command exit **1** after four failed TLS handshake attempts downloading `gradle-9.8.0-bin.zip`. R2-01/R2-02 retain exact outputs. **No Gradle task, compiler, test or lint check executed.**

| Exact command | Clean env | Temporary JVM | Acceptance |
| --- | ---: | ---: | --- |
| `./gradlew --version` | 1 | 1 | BLOCKED |
| `./gradlew robolectricSdkDownload` | 1 | 1 | BLOCKED |
| `./gradlew :AnkiDroid:assembleFullDebug` | 1 | 1 | BLOCKED |
| `./gradlew :AnkiDroid:testFullDebugUnitTest` | 1 | 1 | BLOCKED |
| `./gradlew jacocoUnitTestReport` | 1 | 1 | BLOCKED |
| `./gradlew lintAll ktlintCheck lint-rules:test` | 1 | 1 | BLOCKED |
| `./gradlew -p buildSrc test` | 1 | 1 | BLOCKED |

No executed test counts, XML/HTML results, Android lint errors/warnings, ktlint findings or custom lint test results exist. Existing lint configuration and suppressions, including `lint-release.xml`, are not a measured clean result. No rules, pins, signing or backend were changed to bypass failures. The repository's existing optional local backend mechanism was not activated. Repository enforcement is commented out and no tracked verification metadata/lockfile or wrapper checksum was found (R2-06); downloaded dependency provenance and absence of substitution cannot be confirmed until actual resolution is inspected.

## 4. Android device and Reviewer verification

No SDK, `adb`, emulator, device or installable APK was available. No install, collection opening, note creation, import, rating, backup/restore or sync was performed; no user collection was accessed by this audit. This fact does **not** certify coexistence or runtime storage isolation.

| Field | Actual result and missing evidence |
| --- | --- |
| Disposable environment, selected collection/media/backup path | **BLOCKED** — no device or selected path |
| App launch | **BLOCKED** — no install/launch |
| Deck access | **BLOCKED** — no test deck |
| Question and answer reveal | **BLOCKED** — no rendering observed |
| Again / Hard / Good / Easy | **BLOCKED** — no ratings executed |
| Undo | **BLOCKED** — no before/after state |
| Process recreation, restart, session end, persistence, navigation | **BLOCKED** — no runtime session |
| Official/debug coexistence and collection isolation | **BLOCKED** — no paired installation or runtime storage proof |
| Sync | **UNVERIFIED — TEST ACCOUNT NOT AUTHORIZED**; no production sync or waiver |

Safe rerun requires a fresh emulator or dedicated disposable device/profile with no personal accounts, restored data or production collection. Before *any* mutation, establish the actual collection, media and backup paths for both apps; abort if either points to user-owned/shared production data. Use a known disposable deck, verify front/back, each rating and undo, single commit per deliberate input, rapid input and lifecycle restoration, session end, navigation and restart. Run instrumentation only after verifying its configured root. Preserve actual logs, result XML and state comparisons without personal data. The detailed pending protocol is in the [historical device report](FSA-00C-DEVICE-VERIFICATION.md); it is a plan, not executed evidence. Sync requires an explicitly authorized isolated account or a written waiver expressly permitted by the parent contract; none is asserted here.

## 5. Architecture and safety

| Field | Result and qualification |
| --- | --- |
| Native scheduler | **UNCHANGED in source** — legacy Reviewer calls `sched.answerCard(state, rating)` inside `undoableOp` (`Reviewer.kt:1580–1589`); libanki delegates to `col.backend.answerCard` (`Scheduler.kt:130–172`). External backend binary and runtime behavior remain unverified. |
| Reviewer ViewModel | `answerCardInternal` builds a `CardAnswer` then commits via `undoableOp { sched.answerCard(answer) }` (`ReviewerViewModel.kt:527–543`); the similarly named extension builds the answer rather than making another backend commit. Native undo reaches collection/backend undo. Runtime duplicate input, undo and process restoration remain blocked. |
| PC Anki adapter / AnkiConnect scheduling | **ABSENT in inspected source**, based on unchanged baseline tree, targeted code scan and native path inspection; a negative symbol search is not proof about external binaries. |
| Second FSRS / dual scheduler | **No separate engine introduced in inspected source.** Existing `Fsrs.kt` reports the native backend version; `DummyScheduler` is not a functioning second scheduler. Inherited native custom-scheduling JS hooks exist and are not a Study-Agent backend. |
| Study-Agent migration | **NOT STARTED** — no production diff or copied client component identified. |
| Release identity | **UNCHANGED in source:** release `com.ichi2.anki`; debug suffix yields `com.ichi2.anki.debug`. No binary identity or certificate was verified. |
| User-data safety | **BLOCKED for device acceptance**; no user data was touched during this audit. Different application IDs do not ensure collection-storage isolation. |

Source manifest uses `${applicationId}.flashcards` for the exported card provider and `${applicationId}.apkgfileprovider` for FileProvider, and an application-ID-derived database permission; debug/release identities therefore differ in source. Manifest includes deep-link/import handlers and `allowBackup`; `res/xml/filepaths.xml` includes broad external-path grants. Merged manifest, routing, permissions and restore behavior are not verified from an APK or device. `InitialActivity` can prefer PUBLIC storage and `SetupStorage` resolves it under the shared external root; on common devices that can be `/storage/emulated/0/AnkiDroid`. The instrumentation subdirectory can still be inside that root (R2-05). Never mutate a production root.

Release defaults to the official package ID and the build script contains a publicly known fallback release keystore. **Do not distribute a fallback-signed release, install a fork release over an official installation, or uninstall the official app to bypass a signature mismatch.** Independent distribution identity, key custody, provider/permission identity, routing and backup policy belong to FSA-02; no release signing policy change is authorized here.


### Critical invariants — present assessment

| Invariant | Disposition |
| --- | --- |
| INV-00C-01 Native Anki authority | Held in inspected source; external backend binary and runtime unverified |
| INV-00C-02 No FSRS behavior change | No source change relative to baseline; runtime behavior not verified |
| INV-00C-03 No second scheduling database | No addition in baseline diff; source boundary inspected |
| INV-00C-04 No PC Anki adapter | No matching addition in inspected source; external binaries not audited |
| INV-00C-05 No AnkiConnect scheduling | No matching integration in inspected source |
| INV-00C-06 No Study-Agent code copied | No production changes or client import identified |
| INV-00C-07 Reviewer rating/undo semantics intact | Source unchanged; behavioral acceptance BLOCKED |
| INV-00C-08 Production collections untouched | No collection operation in this audit; device isolation acceptance BLOCKED |
| INV-00C-09 Separate IDs do not guarantee storage isolation | Explicitly retained as a pre-mutation safety requirement |
| INV-00C-10 No fallback-key production distribution | No distribution occurred; public fallback remains a release risk |
| INV-00C-11 No unauthorized upstream merge | None during this audit; frozen tree and remote comparison recorded |
| INV-00C-12 No unavailable test reported PASS | Build, test and device checks remain BLOCKED |
| INV-00C-13 Lock claims require executed evidence | No lock claimed; command transcripts retained |
| INV-00C-14 FSA-01 cannot inherit unverified claims | Handoff explicitly withheld; runtime claims remain unverified |

## 6. Independent audit matrix

**PASS is limited to the scope explicitly stated** and never substitutes for a blocked build/runtime check. Evidence IDs above provide source and execution records. No compiler or implementation defect was demonstrated by the prerequisite failures.

| Audit ID | Result | Source and execution evidence | Limitation / remediation | Residual risk |
| --- | --- | --- | --- | --- |
| AUDIT-00C-01 Fork/upstream identity | PASS | R2-03 metadata, `ls-remote`, GitHub compare | Snapshot may advance; preserve SHAs | R-13 |
| AUDIT-00C-02 Baseline commit integrity | PASS (tree) | R2-03 exact diff and subtree identities; R2-06 hashes | Shallow ancestry; full-history reproduction if needed | R-13 |
| AUDIT-00C-03 Worktree/branch safety | PASS | R2-03 entry status, fixed branch; current changes docs only | Historical branch-name contract unresolved; seek owner clarification | R-10 |
| AUDIT-00C-04 FSA-00A/B reconciliation | BLOCKED | R2-03 searches; R2-06 B hashes; B report | A unavailable, B partially corroborated; obtain original with provenance | R-04 |
| AUDIT-00C-05 Version integrity | PASS (source pins only) | R2-04 catalog, wrapper and daemon criteria; R2-06 hashes | Actual daemon unverified; run pinned JDK on capable host | R-01 |
| AUDIT-00C-06 SDK/dependency readiness | BLOCKED | R2-04 source/repositories and host probes; R2-02 download failure | No SDK/resolution; supply authorized host/network, capture graph | R-02/R-11 |
| AUDIT-00C-07 APK compilation | BLOCKED | Source variant configuration; R2-01/02 assemble exit 1 | No Gradle/compiler; run FullDebug unchanged | R-05 |
| AUDIT-00C-08 Unit-test integrity | BLOCKED | R2-05 CI tasks; R2-01/02 test and JaCoCo exit 1 | No tests/XML; run both scopes and retain results | R-05 |
| AUDIT-00C-09 Lint/style | BLOCKED | R2-05 CI command; R2-01/02 lint exit 1 | No findings measured; execute correct spelling, retain reports | R-05 |
| AUDIT-00C-10 Build-logic tests | BLOCKED | R2-05 buildSrc CI; R2-01/02 exit 1 | No tests run; execute with required SDK | R-05 |
| AUDIT-00C-11 APK identity/signing/hash | BLOCKED | App build source and R2-06 empty artifact search | No binary or cert; inspect actual artifact with Android tools | R-05/R-07 |
| AUDIT-00C-12 Native scheduler authority | PASS (inspected source) | R2-05 Reviewer/ViewModel/libanki, R2-03 unchanged tree | External binary/runtime unverified; complete build/device tests | R-03/R-05 |
| AUDIT-00C-13 Rating/undo behavior | BLOCKED | R2-05 native source; R2-04 no device | No runtime rating/undo/lifecycle observation; execute disposable matrix | R-03 |
| AUDIT-00C-14 Data/storage isolation | BLOCKED | R2-05 public-root and instrumentation-path source; no runtime path | App IDs do not isolate files; verify disposable paths and paired installs | R-06/R-12 |
| AUDIT-00C-15 No PC adapter/second scheduler | PASS (inspected source) | R2-03 unchanged tree; R2-05 negative scans and native boundary | External artifact not examined; authenticate and inspect resolution | R-02/R-11 |
| AUDIT-00C-16 No feature migration | PASS (source diff) | R2-03 baseline diff; R2-05 scan | Future migration still unauthorized; retain scope exclusions | R-05 |
| AUDIT-00C-17 No unauthorized upstream merge | PASS | R2-03 frozen HEAD/tree, compare, reference-object fetch only | Upstream has moved; do not synchronize baseline automatically | R-13 |
| AUDIT-00C-18 Truthful gate decision | PASS (reporting) | R2-01–06 and matrices in this report | Mandatory evidence absent; retain BLOCKED until independent re-review | R-01–06/R-08 |

## 7. Authoritative verification matrix

| Verification ID | Result | Evidence / acceptance limitation |
| --- | --- | --- |
| VER-00C-01 Current HEAD | PASS | R2-03: `99d339e48c93d7b9c63113cb702574981e5cff30` |
| VER-00C-02 Baseline reachable or equivalent source | PASS | Reference tree fetched and compared; GitHub ancestry, not full local history |
| VER-00C-03 No unexplained production changes | PASS | R2-03 only `docs/fsa/` differs from baseline |
| VER-00C-04 Fork/upstream relation | PASS | R2-03 metadata and 4 ahead / 88 behind snapshot |
| VER-00C-05 FSA-00A reconciled | BLOCKED | Original not accessible; explicitly recorded |
| VER-00C-06 FSA-00B classified | PASS | Partial corroboration and corrections in §2; not a build PASS |
| VER-00C-07 JDK and daemon verified | BLOCKED | Temurin launcher observed; pinned JetBrains daemon never resolved |
| VER-00C-08 Gradle wrapper executes Gradle | BLOCKED | Wrapper JAR launched but distribution download failed; Gradle did not start |
| VER-00C-09 Dependencies resolve | BLOCKED | R2-02/04 network failure before resolution |
| VER-00C-10 Robolectric preparation | BLOCKED | R2-01/02 exit 1; no task execution |
| VER-00C-11 FullDebug APK builds | BLOCKED | R2-01/02 exit 1; no APK |
| VER-00C-12 Unit tests execute/pass | BLOCKED | Both requested test commands exit 1, no results |
| VER-00C-13 Lint/style execute/pass | BLOCKED | Correct command exit 1, no lint output |
| VER-00C-14 Build logic executes/passes | BLOCKED | `-p buildSrc test` exit 1 |
| VER-00C-15 APK hash/identity | BLOCKED | No artifact or binary metadata |
| VER-00C-16 Disposable collection verified | BLOCKED | No device, selected path or dataset |
| VER-00C-17 App launches | BLOCKED | No install/launch |
| VER-00C-18 Deck access | BLOCKED | No device session |
| VER-00C-19 Question/answer reveal | BLOCKED | No display observation |
| VER-00C-20 Native ratings | BLOCKED | No Again/Hard/Good/Easy execution |
| VER-00C-21 Undo | BLOCKED | No before/after evidence |
| VER-00C-22 Lifecycle state | BLOCKED | No process recreation/restart evidence |
| VER-00C-23 Official data untouched | BLOCKED for device acceptance | No collection accessed in this audit; runtime coexistence/path isolation not verified |
| VER-00C-24 Provider/deep-link risks identified | PASS (identification only) | R2-05 manifest/storage source; runtime routing unverified |
| VER-00C-25 No PC Anki adapter | PASS (inspected source) | R2-03/05 |
| VER-00C-26 No AnkiConnect scheduling | PASS (inspected source) | R2-03/05 |
| VER-00C-27 No alternate FSRS | PASS (inspected source) | R2-03/05; backend binary unverified |
| VER-00C-28 No unauthorized migration | PASS | Source diff and scope inspection |
| VER-00C-29 No release-signing violation | PASS (audit conduct) | No release built, installed or distributed; release risks remain |
| VER-00C-30 Exact commands/results reported | PASS | R2-01–06, failures and missing evidence explicitly distinguished |

**12 scope-limited PASS; 18 BLOCKED.** No blocked runtime/build requirement is satisfied by source inspection.

## 8. Residual risks and closure plan

| Risk ID | Severity | Evidence / consequence | Owner | Required action | Blocks gate lock? |
| --- | --- | --- | --- | --- | --- |
| R-01 | Critical | R2-01/02: no pinned JetBrains daemon verified; only temporary non-pinned launcher | Build/platform maintainer | Use supported JetBrains JDK 21; capture launcher and actual daemon vendor/version | YES |
| R-02 | Critical | R2-02/04: distribution, SDK and repositories unavailable; build/dependencies unknown | Build infrastructure owner | Provide authorized standard vendor/network access, SDK platform 37 and required build tools determined from real Gradle output; capture dependency graph | YES |
| R-03 | Critical | R2-04: no device/APK; Reviewer/runtime behavior unknown | Android QA owner | Use disposable Android target; execute complete device matrix and retain evidence | YES |
| R-04 | High | R2-03: original FSA-00A not found; historical assertions cannot be reconciled | Product owner / original author | Supply original with provenance and independently reconcile | YES |
| R-05 | High | R2-01/02/06: no build, tests, lint, APK or cert; defects and reproducibility unknown | Build maintainer / reviewer | Run all required commands; retain results and artifact hash/identity/signature; compare equivalent rebuild before reproducibility claim | YES |
| R-06 | Critical to data | R2-05: shared public collection and nested instrumentation path possible | Android QA / storage-security owner | Verify actual collection, media, backup and profile paths before mutation; prove disposable coexistence | YES |
| R-07 | High for distribution | R2-05: official release ID and public fallback signing key | Release/security owner (FSA-02) | No fallback distribution or official-overwrite attempt; define independent ID and trusted key custody | NO for safely verified debug-only FSA-00; YES for independent release distribution |
| R-08 | High pending contract | No authorized test sync account or parent waiver evidence | Product owner / QA | Authorize isolated sync or provide a written waiver expressly allowed by parent contract | YES until resolved |
| R-09 | Medium | R2-04: 3.8 GiB RAM/no swap; 3 GiB daemon heap and test forks risk memory pressure; no OOM observed | Infrastructure owner | Use demonstrably capable host and record supported memory/concurrency settings | YES for execution readiness, not a demonstrated code defect |
| R-10 | Low technical / contract uncertainty | R2-03: fixed session branch; historical foundation-name requirement unclear | Product owner / maintainer | Clarify parent contract and accept equivalent isolation if permitted; do not switch/create branches in this session | YES if historical naming is mandatory and unresolved |
| R-11 | Medium | R2-04/06: no wrapper distribution checksum, tracked dependency verification/lockfile, or enforced repositories | Build/security owner | Capture resolved versions and authorized provenance/artifact hashes; review hardening separately | NO by itself; actual dependency verification remains blocked by R-02/R-05 |
| R-12 | High for routing/data | R2-05: intent handlers, broad URI grants and backup surfaces; runtime merged behavior unknown | Android security / QA / FSA-02 owner | Verify merged manifest, routing, restore and permissions with disposable data; resolve identity policy in FSA-02 | YES for mandatory runtime isolation via R-06 |
| R-13 | Low | R2-03: shallow ancestry and moving upstream snapshot | Repository maintainer | Preserve SHAs/API compare; use full history for stronger reproduction without merging | NO; source-tree comparison and remote ancestry evidence available |

**Historical blockers:** B-01 is partially improved (a temporary Temurin launcher exists), but the pinned daemon/full JDK remains unverified; B-02 network, B-03 SDK/device and B-04 original FSA-00A remain blocked. B-05 memory remains a readiness risk, not an observed OOM. B-06 branch-name contract is unresolved on the fixed session branch. B-07 shallow history is mitigated for tree equivalence by the fetched object and API compare, not removed. B-08 storage is mandatory now; release identity/signing remains an explicit FSA-02 constraint.

**Ordered closure:**

1. Obtain original FSA-00A and parent contract; reconcile discovery findings, branch acceptance and sync/waiver authority without rewriting historical evidence.
2. On an authorized capable host, preserve the exact tested revision, source status, toolchain and host settings. Supply JetBrains 21, Android platform 37, adequate resources and standard dependency access. Do not merge upstream or modify pins just to pass.
3. Run the exact commands in §3; preserve each exit/log and real XML/HTML/lint output. Discover real APK paths and record size, SHA-256, package/version/variant and `apksigner verify --print-certs` output. Check dependency provenance/resolution. Repeat an equivalent build before claiming reproducibility; investigate any differing metadata.
4. Only after proving disposable collection/media/backup/account isolation, execute the full Reviewer, undo, lifecycle, navigation, persistence and coexistence matrix. Resolve sync authorization or valid waiver. Never use production accounts or collections.
5. Independently re-review all mandatory results and affected checks; remediate actual defects only under appropriate authorization. Lock only after all mandatory acceptance criteria genuinely pass.

## 9. Final gate decision and conditional handoff

```text
FSA-00:                       BLOCKED — NOT LOCKED
SOURCE AUDIT:                 PASS for equivalence / inspected architecture only
TOOLCHAIN PINS:               VERIFIED FROM SOURCE
ANDROID BUILD / TESTS:        BLOCKED — NO GRADLE TASK RAN
APK:                          NOT PRODUCED
DEVICE / REVIEWER:            BLOCKED
USER DATA ISOLATION:          BLOCKED for Android acceptance
FSA-00A:                      BLOCKED — ORIGINAL UNAVAILABLE
SYNC:                         UNVERIFIED — TEST ACCOUNT NOT AUTHORIZED
PC ANKI ADAPTER:              EXCLUDED from new architecture
FSA-01 PRODUCTION MIGRATION:  NOT AUTHORIZED
NEXT ACTION:                  CAPABLE-HOST BUILD, ORIGINAL EVIDENCE RECONCILIATION,
                              AND DISPOSABLE ANDROID VERIFICATION
```

Only after a legitimate FSA-00 lock is **FSA-01A — Study-Agent Migration Discovery & Component Classification** the next gate. The [conditional handoff](FSA-01-HANDOFF.md) remains withheld; no classification or code migration has been performed. Future classifications may use REUSE AS-IS, REFACTOR FOR ANKIDROID, ADAPT TO NATIVE REVIEWER, REPLACE WITH ANKIDROID IMPLEMENTATION, REMOVE or DEFER. PC Anki adapters/registries, AnkiConnect scheduling, remote PC queues, dual schedulers, second FSRS and automatic cross-backend failover remain excluded. The intended authority stays AnkiDroid native Reviewer → libanki → Anki scheduler/FSRS; optional PC AI computation is a separate future decision.
