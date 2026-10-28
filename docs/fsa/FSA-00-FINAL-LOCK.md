# FSA-00C — Independent baseline audit and final gate decision

> **FSA-00: BLOCKED — NOT LOCKED.**
> Source equivalence and source-level architecture checks pass. Mandatory build,
> test, artifact, device and data-isolation evidence does not exist. FSA-00A
> reconciliation is blocked. FSA-01 production migration is **NOT AUTHORIZED**.

**Audit date:** 2026-10-25 UTC. **Authority:** FSA-00C only, no feature migration.
**Prepared with:** Arena.ai Agent Mode; maintainer acceptance is not implied.

## 1. Repository

| Contract field | Observed result |
| --- | --- |
| Target repository | `Drmusab/flashcard-Android` |
| HEAD | `f8212252540fe104663e935d4c582e9ad499ec89` |
| Branch | `arena/8214a12a-flashcard-android` |
| Worktree status | Clean on initial inspection; only new audit documentation/evidence at completion. No application/build modifications or existing work discarded. |
| Baseline commit | `a7121c11c6e11d9c6ba34518784156fba1701e29` |
| Upstream HEAD (observed snapshot) | `fe6577031a7c2a875981f963c36aea5c5fe529bf` |
| Fork divergence | **2 ahead / 17 behind** that upstream snapshot; common ancestor = reference baseline |
| Source comparison | Exactly one added FSA-00B report, 463 lines; all non-report tracked files identical to baseline |
| History limitation | Shallow. Reference object fetched for local tree diff; ancestry/divergence from GitHub compare, not local full-history proof |

[E01/E04/E05](FSA-00C-ENTRY-AND-EVIDENCE.md#evidence-index) record exact Git/API commands. No upstream merge, branch switch, commit, push, PR action or workflow dispatch was performed. Source and signing policies remain frozen.

## 2. Prerequisite evidence

```text
FSA-00A:             BLOCKED — original unavailable in accessible evidence
FSA-00B:             PARTIAL — source/results corroborated; corrections recorded
HISTORICAL EVIDENCE: NOT RECONCILED — original FSA-00A missing
```

[Entry/reconciliation report](FSA-00C-ENTRY-AND-EVIDENCE.md) describes the searches, historical limitations and explicit corrections. The original FSA-00B file is preserved unchanged. Its documentation merge and automated PR review are not Android build evidence.

## 3. Build verification

| Field | Result | Actual evidence |
| --- | --- | --- |
| GRADLE | **BLOCKED** | E03 `./gradlew --version` exit 1 before Java startup; source pin 9.8.0 |
| JDK | **BLOCKED** | E02 `java -version` exit 127; source pins JetBrains daemon 21, accepted build JVM range 21–25 |
| ANDROID SDK | **BLOCKED** | E02 no SDK/tools; E06 SDK endpoint TLS failure; compile SDK 37 source pin only |
| FULLDEBUG BUILD | **BLOCKED** | E03 `:AnkiDroid:assembleFullDebug` exit 1, no compiler execution |
| UNIT TESTS | **BLOCKED** | Explicit FullDebug and aggregate JaCoCo commands each exit 1; no XML/HTML results |
| LINT | **BLOCKED** | Correct `lintAll ktlintCheck lint-rules:test` command exit 1; no findings measured |
| BUILD LOGIC | **BLOCKED** | `./gradlew -p buildSrc test` exit 1 |
| APK ARTIFACT | **NOT PRODUCED** | E02/E07 APK search empty; no size/hash/package/signature verified from binary |

Robolectric preparation also exits 1. All seven wrapper attempts have the same missing-Java message; **no Gradle task ran**. AGP 9.4.1 and Kotlin 2.4.20 are verified source pins, not executed compatibility results. Dependency probes failed at TLS (curl 35/HTTP 000); that is not a dependency-version defect. Exact commands and a capable-host rerun contract are in [build verification](FSA-00C-BUILD-VERIFICATION.md).

## 4. Android device verification

| Field | Actual result/evidence |
| --- | --- |
| APP LAUNCH | **BLOCKED** — no target/APK, E02/E03 |
| DECK ACCESS | **BLOCKED** — no test deck opened |
| ANSWER REVEAL | **BLOCKED** — neither front nor back observed |
| AGAIN / HARD / GOOD / EASY | **BLOCKED** — no rating executed |
| UNDO | **BLOCKED** — no before/after state |
| PROCESS RECREATION | **BLOCKED** — lifecycle behavior unexecuted |
| COLLECTION ISOLATION | **BLOCKED** — selected runtime path unknown; source exposes shared-storage risk |
| SYNC TEST | **UNVERIFIED — TEST ACCOUNT NOT AUTHORIZED**; no parent-contract waiver granted |

Session end, restart/persistence, navigation and coexistence are also BLOCKED. There was no install, collection access or production sync. [Device report](FSA-00C-DEVICE-VERIFICATION.md) separates observed results from the pending safe procedure.

## 5. Architecture safety

| Field | Result and qualification |
| --- | --- |
| NATIVE SCHEDULER | **UNCHANGED** in source; runtime rating/undo still blocked |
| PC ANKI ADAPTER | **ABSENT** in inspected source; excluded |
| ANKICONNECT SCHEDULING | **ABSENT** in inspected source; excluded |
| SECOND FSRS | **ABSENT** as a separate engine; existing Fsrs version-display wrapper and unsupported DummyScheduler are not alternate engines |
| STUDY-AGENT MIGRATION | **NOT STARTED** |
| RELEASE IDENTITY | **UNCHANGED** — release `com.ichi2.anki`, debug `.debug`; release collision/key risks remain |
| USER DATA SAFETY | **BLOCKED** for Android coexistence/isolation certification. No user collection was touched by this audit. |

[Architecture audit](FSA-00C-ARCHITECTURE-AUDIT.md) traces legacy and ViewModel reviewers, native answer construction/commit, undo, lifecycle limits, manifests, test storage, release fallback signing and all 14 invariants. It does not substitute source evidence for runtime evidence.

## 6. Independent audit matrix

**PASS means the stated scope only.** Evidence IDs link through the [entry index](FSA-00C-ENTRY-AND-EVIDENCE.md#evidence-index). Risk IDs, responsible roles and closure actions are in the [risk register](FSA-00C-RESIDUAL-RISKS.md). “No execution” is an explicit missing result, not success. No implementation FAIL was established by the blocked commands.

| Audit ID / subject | Result | Source evidence | Execution evidence | Defect or limitation | Remediation | Residual risk |
| --- | --- | --- | --- | --- | --- | --- |
| AUDIT-00C-01 Fork/upstream identity | **PASS** | Origin and GitHub parent/source metadata | E01/E04 identity and heads, E05 compare | Remote snapshot can advance | Preserve exact SHAs; reobserve for future gate | R-13 |
| AUDIT-00C-02 Baseline integrity | **PASS** | Reference and HEAD trees; nine matching hashes | E05 local diff excludes only B report, exit 0; E07 hashes | Local ancestry remains shallow | Retain API ancestry evidence; use full-history host for reproduction | R-13 |
| AUDIT-00C-03 Worktree/branch safety | **PASS** | Fixed Arena branch, unchanged tracked baseline | E01 and E10 status/diff | Historical foundation-name acceptance unresolved, not unsafe worktree | Keep fixed branch; obtain owner contract acceptance | R-10 |
| AUDIT-00C-04 FSA-00A/B reconciliation | **BLOCKED** | B report present; A absent | E01/E04/E05/E09 searches, PR/release inspection | No original A; B only partially independently reconcilable | Obtain original with provenance and reconcile | R-04 |
| AUDIT-00C-05 Version integrity | **PASS** (pins only) | Wrapper/catalog/daemon criteria/root bounds/buildSrc | E07 hashes; E08 numbered source | Actual JVM/Gradle resolution blocked | Execute pinned toolchain on capable host | R-01/R-02 |
| AUDIT-00C-06 SDK/dependency readiness | **BLOCKED** | SDK 37, repository/backend definitions | E02 inventory, E06 seven TLS failures | No SDK; exact build-tools unresolved; dependencies unavailable | Standard SDK/authorized network; capture resolution | R-02/R-09/R-11 |
| AUDIT-00C-07 APK compilation | **BLOCKED** | FullDebug configuration exists | E03 assemble exit 1 | JVM never started; no compiler verdict | Execute frozen FullDebug build | R-01/R-02/R-05 |
| AUDIT-00C-08 Unit-test integrity | **BLOCKED** | FullDebug and aggregate CI tasks | E03 tests/JaCoCo/Robolectric exit 1; no XML | No measured test outcomes | Run both requested scopes, collect actual XML/HTML | R-05 |
| AUDIT-00C-09 Lint/style | **BLOCKED** | lintAll/config/editor rules and lint.yml | E03 correct command exit 1 | Errors/warnings/ignored findings unmeasured | Run unchanged rules, retain reports | R-05 |
| AUDIT-00C-10 Build-logic tests | **BLOCKED** | buildSrc test configuration and lint CI | E03 buildSrc test exit 1 | Test sources do not prove execution | Run buildSrc tests with SDK where fixtures need it | R-05 |
| AUDIT-00C-11 APK identity/signing/hash | **BLOCKED** | Source debug ID/signing expectations | E02/E07 no APK; tools absent | No binary/package/certificate evidence | Inspect actual built APK using Android tools and hash it | R-05/R-07 |
| AUDIT-00C-12 Native scheduler authority | **PASS** (source) | Reviewer/ViewModel → undoableOp → libanki/backend; E08 | E05 unchanged tree; E07 exclusion scan | Backend binary and runtime not verified | Preserve authority; complete artifact and device evidence | R-03/R-05 |
| AUDIT-00C-13 Rating/undo behavior | **BLOCKED** | Native rating/undo pipeline inspected | E02 no target; no Android execution | No rating/undo/lifecycle state observations | Disposable Reviewer matrix including repeat-input/lifecycle | R-03 |
| AUDIT-00C-14 Data/storage isolation | **BLOCKED** | PUBLIC preference, shared root, nested test path | E08/E09 source; no runtime path or paired installs | Distinct IDs do not isolate collections | Verify all selected paths/accounts before any mutation | R-06/R-12 |
| AUDIT-00C-15 No PC adapter/second scheduler | **PASS** (source) | E07 exclusions; Fsrs display wrapper/DummyScheduler; native pipeline | E05 exact production equivalence; E07/E09 scans/reads | No binary dependency audit | Keep exclusions; resolve authentic pinned backend | R-02/R-11 |
| AUDIT-00C-16 No feature migration | **PASS** | No reference-client additions to production/build | E05 tree diff; E10 docs-only changes | Future migration must not inherit runtime PASS | Keep FSA-01 withheld | No new migration risk introduced |
| AUDIT-00C-17 No unauthorized upstream merge | **PASS** | HEAD unchanged, no production divergence from reference | E01/E05/E10; reference fetch only | 17 upstream commits not evaluated as baseline | No synchronization during baseline tests | R-13 |
| AUDIT-00C-18 Truthful lock decision | **PASS** | This report distinguishes source/actual execution/missing evidence | E02/E03/E06, final matrices and E10 | Gate remains blocked; no optional waiver authority | Close mandatory rows with new evidence then independent review | All unresolved gate blockers |

## 7. Authoritative verification matrix

| Verification ID | Result | Evidence / acceptance limitation |
| --- | --- | --- |
| VER-00C-01 Current HEAD recorded | **PASS** | E01/E05/E10: `f8212252540fe104663e935d4c582e9ad499ec89` |
| VER-00C-02 Baseline reachable or equivalent source | **PASS** | E05 fetched reference tree; exact diff plus GitHub ancestor comparison; not full local ancestry |
| VER-00C-03 No unexplained production changes | **PASS** | E05 only historical B report added; E10 audit-only additions |
| VER-00C-04 Fork/upstream relation | **PASS** | E04 fork metadata; E05 2 ahead/17 behind/common ancestor |
| VER-00C-05 FSA-00A reconciliation | **BLOCKED** | Original report not located; explicitly recorded, not recreated |
| VER-00C-06 FSA-00B classification | **PASS** | Classified PARTIAL, not a passing Android build; corrections in entry report |
| VER-00C-07 JDK and daemon verified | **BLOCKED** | E02 Java 127; actual vendor/patch/daemon unknown |
| VER-00C-08 Gradle wrapper executes Gradle | **BLOCKED** | E03 shell wrapper exits 1 before JVM; source pin alone insufficient |
| VER-00C-09 Dependencies resolve | **BLOCKED** | E06 TLS failures; Gradle resolution never started |
| VER-00C-10 Robolectric preparation | **BLOCKED** | E03 exit 1; no dependency-path output |
| VER-00C-11 FullDebug APK builds | **BLOCKED** | E03 exit 1; no artifact |
| VER-00C-12 Unit tests execute/pass | **BLOCKED** | E03 explicit and aggregate exit 1; no XML results |
| VER-00C-13 Lint/style execute/pass | **BLOCKED** | E03 exit 1; no Android/ktlint/custom-rule outcome |
| VER-00C-14 Build logic executes/passes | **BLOCKED** | E03 exit 1 |
| VER-00C-15 APK hash/identity | **BLOCKED** | E02/E07 no APK or signing tools |
| VER-00C-16 Disposable collection verified | **BLOCKED** | No target, selected path or dataset |
| VER-00C-17 App launches | **BLOCKED** | No APK installation/launch |
| VER-00C-18 Deck access | **BLOCKED** | No device test |
| VER-00C-19 Question/answer reveal | **BLOCKED** | No rendering observation |
| VER-00C-20 Native ratings | **BLOCKED** | No Again/Hard/Good/Easy execution |
| VER-00C-21 Undo | **BLOCKED** | No before/after state |
| VER-00C-22 Lifecycle state | **BLOCKED** | No restart/process-recreation evidence |
| VER-00C-23 Official data untouched | **BLOCKED** for device acceptance | No user data accessed here, but mandatory coexistence/path/data proof on Android unavailable |
| VER-00C-24 Provider/deep-link risks identified | **PASS** (identification only) | E08/E09 manifest/filepaths/storage; routing and binary verification still blocked |
| VER-00C-25 No PC Anki Adapter | **PASS** (source) | E05/E07 exclusions and unchanged production tree |
| VER-00C-26 No AnkiConnect scheduling | **PASS** (source) | E07 code/config scan; E08 native path |
| VER-00C-27 No alternate FSRS | **PASS** (source) | E08/E09 native delegation, version-display wrapper, unsupported DummyScheduler |
| VER-00C-28 No unauthorized migration | **PASS** | E05/E10 documentation-only scope |
| VER-00C-29 No release-signing violation | **PASS** (conduct) | No release build/install/distribution or signing change; source risks retained, not approved |
| VER-00C-30 Exact commands/results included | **PASS** | E01–E10; missing outputs clearly marked; no fabricated artifacts/test counts |

**12 PASS (scope-limited), 18 BLOCKED.** No source-only PASS satisfies a blocked runtime/build row.

## 8. Residual risks and closure ownership

The [complete residual-risk register](FSA-00C-RESIDUAL-RISKS.md) is an integral part of this decision: R-00C-01 through R-00C-13 each specifies severity, evidence, consequence, owner role, required action and whether it blocks lock. It also reassesses all historical B-01–B-08 blockers.

Immediate gate blockers: missing JDK/SDK/dependency access; absent APK/test/lint/build-logic results; no disposable device/Reviewer/data-isolation evidence; missing FSA-00A; unresolved sync/parent-contract and historical branch acceptance. RAM is an unproven readiness risk, not an implementation failure. Release identity/public-key distribution risks remain explicit FSA-02 constraints, not reasons to change identity during this audit.

## 9. Final gate lock decision — Case B

```text
FSA-00:                       BLOCKED
SOURCE AUDIT:                 PASS (source equivalence and scoped architecture only)
TOOLCHAIN PINS:                VERIFIED FROM SOURCE
ANDROID BUILD:                BLOCKED / UNVERIFIED
MANDATORY TESTS:               BLOCKED / UNVERIFIED
APK:                          NOT PRODUCED
DEVICE TESTS / REVIEWER:       BLOCKED / UNVERIFIED
USER DATA ISOLATION:           BLOCKED / UNVERIFIED
FSA-00A RECONCILIATION:         BLOCKED
PC ANKI ADAPTER:               EXCLUDED
GATE LOCK:                    PROHIBITED WITH CURRENT EVIDENCE
NEXT ACTION:                  EXECUTE BASELINE BUILD ON CAPABLE HOST,
                              RECONCILE ORIGINAL EVIDENCE, THEN VERIFY
                              DISPOSABLE ANDROID SAFETY/REVIEWER
FSA-01 PRODUCTION MIGRATION:   NOT AUTHORIZED
```

No actual compiler/test defect was established; failures are prerequisite/launcher/network failures. No mandatory requirement or sync test was unilaterally waived. No bit-for-bit APK reproducibility claim is made.

The [FSA-01 handoff](FSA-01-HANDOFF.md) is **withheld**, containing conditional scope/exclusions only. **After a legitimate FSA-00 lock**, the next gate is **FSA-01A — Study-Agent Migration Discovery & Component Classification**. This audit does not execute it.
