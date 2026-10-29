# FSA-00C — Independent baseline audit and final gate decision

> **FSA-00: BLOCKED — NOT LOCKED.**
> Source equivalence and scoped source architecture checks pass.
> Mandatory build, test, artifact, device and data-isolation evidence does not exist.
> FSA-00A reconciliation is blocked. FSA-01 production migration is **NOT AUTHORIZED**.
> **Current snapshot:** `45b58a9` on 2026-10-29. Prior snapshots `f821225…` / `99d339e…` are preserved as historical evidence.
> See [R3 reassessment](FSA-00C-R3-INDEPENDENT-REASSESSMENT.md) for current evidence.

**Audit date:** 2026-10-29 UTC. **Authority:** FSA-00C only, no feature migration.
**Prepared with:** Arena.ai Agent Mode; maintainer acceptance is not implied.

## 1. Repository

| Contract field | Observed result |
| --- | --- |
| Target repository | `Drmusab/flashcard-Android` |
| HEAD | `45b58a96dd161efb65339f4f8f1c6ef5d1138da1` |
| Branch | `arena/1a304a7c-flashcard-android` |
| Worktree status | Clean on entry; R3 adds documentation/evidence only. No prod/build changes, no existing work discarded. See R3-01. |
| Baseline commit | `a7121c11c6e11d9c6ba34518784156fba1701e29` |
| Upstream HEAD (observed) | `210b543e8ff832073e31672494fdaa1e8a2d6549` (ankidroid/Anki-Android main 2026-10-29) |
| Fork divergence | **6 ahead / 141 behind** that upstream SHA; merge base = reference baseline. Snapshot after advanced upstream (was 4/88 at R2). |
| Source comparison | 25 added files, all under `docs/fsa/` (1×FSA-00B + 7 prior audit/handoff + 16 evidence transcripts + R2/R3 reports). Outside docs/fsa diff empty – production, tests, build, manifests, deps identical to baseline. |
| History | Full history available (24,687 commits); previously shallow/grafted, now --unshallow. No ancestry fabrication. |

[R3-01 / R3-05](FSA-00C-R3-INDEPENDENT-REASSESSMENT.md#evidence-index--r3-current) record exact Git/API commands. No upstream merge, branch switch, commit, push, PR action or workflow dispatch performed. Source and signing policies frozen.

Historical: At R2 (`99d339e…`) HEAD and remote main matched; 4 ahead /88 behind, 18 added docs. At `f821225…` 2 ahead /17 behind, 1 added doc. Those counts were valid for cited upstream SHAs, not current upstream.

## 2. Prerequisite evidence

```text
FSA-00A:             BLOCKED — original unavailable in repo / workspace / PRs / attachments
FSA-00B:             PARTIAL — pins, 9 hashes, blocked conclusion corroborated; not full log recovery
HISTORICAL EVIDENCE: NOT RECONCILED — original FSA-00A missing
```

Detailed searches, limitations and corrections in [R3 §2](FSA-00C-R3-INDEPENDENT-REASSESSMENT.md#2-prerequisite-and-documentation-reconciliation) and companion entry report. Original FSA-00B preserved unchanged; its merge and automated PR review are not build evidence. Historical corrections retained: ktlintCheck spelling, daemon JVM range 21–25, instrumentation path caveat, sync waiver authority, branch naming contract.

## 3. Build verification

| Field | Result | Actual evidence |
| --- | --- | --- |
| GRADLE | **BLOCKED** | R3-03: `./gradlew --version` exit 1 before JVM; source pin 9.8.0 verified in wrapper |
| JDK | **BLOCKED** | R3-02/03: `java -version` 127; no java/javac; source pins JetBrains daemon 21, range 21–25, CI jetbrains 21 |
| ANDROID SDK | **BLOCKED** | R3-02: no SDK/tools/local.properties; SDK 37 source pin only, build-tools patch unknown until Gradle SDK diagnostic |
| FULLDEBUG BUILD | **BLOCKED** | R3-03: `:AnkiDroid:assembleFullDebug` exit 1, no compiler execution |
| UNIT TESTS | **BLOCKED** | R3-03: FullDebug and aggregate `jacocoUnitTestReport` each exit 1; no XML/HTML |
| LINT | **BLOCKED** | R3-03: correct `lintAll ktlintCheck lint-rules:test` exit 1; no findings measured |
| BUILD LOGIC | **BLOCKED** | R3-03: `./gradlew -p buildSrc test` exit 1 (8 tests exist, not executed) |
| APK ARTIFACT | **NOT PRODUCED** | R3-02: APK search empty; no size/hash/package/signature from binary |

Robolectric preparation also exit 1. All 7 wrapper attempts have same missing-Java message; **no Gradle task ran**. AGP 9.4.1 / Kotlin 2.4.20 are verified source pins, not executed compatibility. Dependency probes TLS 35/HTTP 000 (R3-04) are boundary failures, not version defects. Exact commands and capable-host rerun contract in [R3 §3](FSA-00C-R3-INDEPENDENT-REASSESSMENT.md#3-toolchain-and-actual-build-verification) and [build verification](FSA-00C-BUILD-VERIFICATION.md).

## 4. Android device verification

| Field | Actual result / evidence |
| --- | --- |
| APP LAUNCH | **BLOCKED** – no APK/target, R3-02/08 |
| DECK ACCESS | **BLOCKED** |
| ANSWER REVEAL | **BLOCKED** |
| AGAIN / HARD / GOOD / EASY | **BLOCKED** – native pipeline source-verified, runtime unproven |
| UNDO | **BLOCKED** |
| PROCESS RECREATION | **BLOCKED** – lifecycle unexecuted |
| COLLECTION ISOLATION | **BLOCKED** – shared-storage risk exposed (InitialActivity/SetupStorage choose public `/AnkiDroid` for full flavor); runtime path unknown |
| SYNC TEST | **UNVERIFIED – TEST ACCOUNT NOT AUTHORIZED** – no parent-contract waiver; no authorized disposable account; correctly not attempted |

Session end, restart/persistence, navigation, coexistence also BLOCKED. No install, collection access or production sync performed. Safe procedure and disposable-environment requirements in [R3 §4](FSA-00C-R3-INDEPENDENT-REASSESSMENT.md#4-device-reviewer-and-data-safety-verification) and [device report](FSA-00C-DEVICE-VERIFICATION.md).

## 5. Architecture safety

| Field | Result and qualification |
| --- | --- |
| NATIVE SCHEDULER | **UNCHANGED** in source; `Reviewer.kt:1580-1600` / `AbstractFlashcardViewer.kt:885-890` / `ReviewerViewModel:527-541` all via `undoableOp` → `backend`/`libanki`; runtime still blocked |
| PC ANKI ADAPTER | **ABSENT** in source; exclusion scan zero hits (R3-06/07) |
| ANKICONNECT SCHEDULING | **ABSENT** – excluded |
| SECOND FSRS | **ABSENT** as separate engine; `Fsrs.kt` is version-display wrapper for backend `6.6.2` build, `DummyScheduler` throws for old v1/v2 |
| STUDY-AGENT MIGRATION | **NOT STARTED** – prod diff empty |
| RELEASE IDENTITY | **UNCHANGED** – release `com.ichi2.anki`, debug `.debug`, templated authorities/permissions; fallback keystore present but no distribution |
| USER DATA SAFETY | **BLOCKED** for coexistence/isolation certification. No user collection touched. Risk: distinct package ID ≠ isolated storage. |

[Architecture audit](FSA-00C-ARCHITECTURE-AUDIT.md) traces legacy and ViewModel reviewers, native commit/undo, lifecycle limits, manifests/providers/deep-links, test storage, fallback signing and all 14 invariants. Source audit alone not substituted for runtime.

## 6. Independent audit matrix

**PASS = stated scope only.** Evidence IDs via R3 index. Risks/owners/closure in [risk register](FSA-00C-RESIDUAL-RISKS.md).

| Audit ID / subject | Result | Source evidence | Execution evidence | Defect / limitation | Remediation | Residual risk |
| --- | --- | --- | --- | --- | --- | --- |
| AUDIT-00C-01 Fork/upstream identity | **PASS** | Origin & GitHub parent/source | R3-01/05 identity/heads/compare | Remote advances | Preserve SHAs; reobserve | R-13 |
| AUDIT-00C-02 Baseline integrity | **PASS** | Reference & HEAD trees; 9 hashes | R3-05/06 diff outside docs/fsa =0; hashes match | Previously shallow, now full | Retain API + diff | R-13 |
| AUDIT-00C-03 Worktree/branch safety | **PASS** | Fixed Arena branch, unchanged baseline | R3-01 status/worktree | Branch-name contract unresolved | Keep branch; obtain acceptance | R-10 |
| AUDIT-00C-04 FSA-00A/B reconciliation | **BLOCKED** | B present; A absent | R3-05 searches | No original A | Obtain original w/ provenance | R-04 |
| AUDIT-00C-05 Version integrity | **PASS (pins)** | Wrapper/catalog/daemon/root bounds/buildSrc | R3-06/07 hashes & excerpts | Daemon resolution blocked | Execute pinned toolchain | R-01/R-02 |
| AUDIT-00C-06 SDK/dependency readiness | **BLOCKED** | SDK 37, repos/backend defs | R3-02 inventory, R3-04 TLS×6 | No SDK; deps unavailable | Standard SDK + authorized net | R-02/R-09/R-11 |
| AUDIT-00C-07 APK compilation | **BLOCKED** | FullDebug config exists | R3-03 exit 1 | No compiler verdict | Frozen FullDebug build | R-01/R-02/R-05 |
| AUDIT-00C-08 Unit-test integrity | **BLOCKED** | FullDebug & aggregate tasks | R3-03 exits 1; no XML | No outcomes | Run both scopes, collect XML | R-05 |
| AUDIT-00C-09 Lint/style | **BLOCKED** | lintAll/config/editor + lint.yml | R3-03 exit 1 | Unmeasured | Run unchanged rules | R-05 |
| AUDIT-00C-10 Build-logic tests | **BLOCKED** | buildSrc test config | R3-03 exit 1 | Sources ≠ execution | Run with SDK where needed | R-05 |
| AUDIT-00C-11 APK identity/signing/hash | **BLOCKED** | Source ID/signing expectations | R3-02 no APK | No binary evidence | Inspect APK with tools & hash | R-05/R-07 |
| AUDIT-00C-12 Native scheduler authority | **PASS (source)** | Viewer→undoableOp→libanki/backend | R3-05 unchanged + R3-06 scan | Backend binary/runtime unproven | Preserve; complete device | R-03/R-05 |
| AUDIT-00C-13 Rating/undo behavior | **BLOCKED** | Native pipeline inspected | R3-02 no target | Behavioral proof requires device | Disposable device matrix | R-03/R-05/R-06 |
| AUDIT-00C-14 Data/storage isolation | **BLOCKED** | AppId/provider & storage sources | R3-02/08 shared-risk exposed | Runtime unproven | Verify path; paired-install test | R-06/R-12 |
| AUDIT-00C-15 No PC Adapter/second scheduler | **PASS (source)** | No adapter symbols; Fsrs/Dummy clarified | R3-06 scan + tree diff | Binary not reverse-audited | Maintain exclusion | R-05 |
| AUDIT-00C-16 No Study-Agent migration in FSA-00 | **PASS** | Exact diff outside docs/fsa empty | R3-05/06 | – | Enforce for FSA-01A | – |
| AUDIT-00C-17 No unauthorized upstream merge | **PASS** | HEAD frozen; 6 ahead from docs only | R3-01/05 logs; upstream 141 behind not merged | – | Do not sync upstream | R-11 |
| AUDIT-00C-18 Truthful verification & lock decision | **PASS** | Only executed evidence cited | R3-01..08 retained | – | Gate remains BLOCKED | – |

Source inspection alone satisfies mandatory runtime/build audits only as BLOCKED.

## 7. Verification matrix

| ID | Check | Result |
| --- | --- | --- |
| VER-00C-01 Current HEAD recorded | **PASS** – R3-01 |
| VER-00C-02 Baseline reachable / equivalence | **PASS** – full history, diff outside docs empty |
| VER-00C-03 No unexplained prod modifications | **PASS** – R3-05/06 |
| VER-00C-04 Fork/upstream relation | **PASS** – R3-05 |
| VER-00C-05 FSA-00A reconciliation | **BLOCKED** – original not located |
| VER-00C-06 FSA-00B evidence | **PARTIAL** – pins/hashes corroborated |
| VER-00C-07 JDK & daemon JVM | **BLOCKED** – 127 (R3-02/03) |
| VER-00C-08 Gradle wrapper executes | **BLOCKED** – exit 1 before Gradle |
| VER-00C-09 Dependencies resolve | **BLOCKED** – TLS 35 (R3-04) |
| VER-00C-10 Robolectric preparation | **BLOCKED** – exit 1 |
| VER-00C-11 FullDebug APK builds | **BLOCKED** – no APK |
| VER-00C-12 Unit tests pass | **BLOCKED** – both scopes exit 1 |
| VER-00C-13 Lint/style pass | **BLOCKED** – exit 1 |
| VER-00C-14 Build-logic tests pass | **BLOCKED** – exit 1 |
| VER-00C-15 APK hash/identity | **BLOCKED** – NOT PRODUCED |
| VER-00C-16 Disposable collection verified | **BLOCKED** – no device |
| VER-00C-17 App launches | **BLOCKED** |
| VER-00C-18 Deck access | **BLOCKED** |
| VER-00C-19 Q/A reveal | **BLOCKED** |
| VER-00C-20 Native ratings | **BLOCKED** – source PASS, runtime BLOCKED |
| VER-00C-21 Undo | **BLOCKED** |
| VER-00C-22 Lifecycle survival | **BLOCKED** |
| VER-00C-23 Official data untouched | **PASS (audit)** – no operation; isolation runtime still BLOCKED |
| VER-00C-24 Provider/deep-link risks | **PASS (source)** – templated authorities, handlers enumerated |
| VER-00C-25 No PC Adapter | **PASS (source)** |
| VER-00C-26 No AnkiConnect | **PASS (source)** |
| VER-00C-27 No alternate FSRS | **PASS (source)** |
| VER-00C-28 No unauthorized migration | **PASS** – exact diff |
| VER-00C-29 No release-signing violation | **PASS (audit)** – no distribution; risk documented |
| VER-00C-30 Exact evidence attached | **PASS** – R3-01..08 |

Mandatory device rows remain BLOCKED; sync waiver not granted.

## 8. Residual risks

| Risk | Severity | Blocks? |
| --- | --- | --- |
| R-01 No JDK/daemon | Critical | **YES** |
| R-02 No SDK/repo TLS | Critical | **YES** |
| R-03 No device/Reviewer runtime | Critical | **YES** |
| R-04 Missing FSA-00A | High | **YES** |
| R-05 No APK/tests/lint artifact | High | **YES** |
| R-06 Shared storage (`/storage/emulated/0/AnkiDroid`) | Critical for data | **YES** |
| R-07 Release ID collision + public fallback key | High for distribution | NO for debug FSA-00; YES for release |
| R-08 Sync waiver/account | High | YES until resolved |
| R-09 RAM 3.8G + 3G daemon + 2G forks | Medium | YES to readiness |
| R-10 Branch naming contract | Low | YES if mandatory |
| R-11 No distribution checksum/lockfile (inherited) | Medium | NO alone |
| R-12 Deep-link/file-grant/backup routing | Medium | YES via R-06 |
| R-13 History now full | Low | NO |

Ordered closure: owner prerequisites → capable host (JetBrains 21, SDK 37, authorized network, adequate memory, disposable Android target) → re-execute 7 commands + collect XML/lint/APK hash/sign/ rebuild → prove disposable storage before mutation, then full Reviewer/lifecycle/coexistence → independent re-review. Never distribute fallback-signed release. See [risk register](FSA-00C-RESIDUAL-RISKS.md).

## 9. Final contract

### Repository

```text
FSA-00C — INDEPENDENT BASELINE AUDIT (R3)

TARGET REPOSITORY:
Drmusab/flashcard-Android

HEAD:
45b58a96dd161efb65339f4f8f1c6ef5d1138da1

BRANCH:
arena/1a304a7c-flashcard-android

WORKTREE STATUS:
Clean on entry; R3 documentation/evidence only. No prod/build changes.

BASELINE COMMIT:
a7121c11c6e11d9c6ba34518784156fba1701e29

UPSTREAM HEAD:
210b543e8ff832073e31672494fdaa1e8a2d6549 (ankidroid/Anki-Android main 2026-10-29)

FORK DIVERGENCE:
6 ahead (docs only) / 141 behind upstream — merge base a7121c11…
```

### Prerequisite Evidence

```text
FSA-00A:
BLOCKED — not located in repo/workspace/PRs; no attachment; not recreated

FSA-00B:
PARTIAL — located at docs/fsa/FSA-00B-fork-baseline-build-verification.md; pins/hashes corroborated by R3 source & execution; not full log recovery

HISTORICAL EVIDENCE:
NOT RECONCILED — FSA-00A absent; prior FSA-00C snapshots preserved
```

### Build Verification

```text
GRADLE:
BLOCKED — wrapper pin 9.8.0 verified, Gradle never ran (R3-03 exit 1, no JVM)

JDK:
BLOCKED — no java (127), daemon JetBrains 21 pin verified but not observed (R3-02/03)

ANDROID SDK:
BLOCKED — no SDK/tools (R3-02); compile 37 source pin only

FULLDEBUG BUILD:
BLOCKED — :AnkiDroid:assembleFullDebug exit 1, no APK

UNIT TESTS:
BLOCKED — testFullDebugUnitTest + jacocoUnitTestReport both exit 1, no XML

LINT:
BLOCKED — lintAll ktlintCheck lint-rules:test exit 1, correct spelling used

BUILD LOGIC:
BLOCKED — -p buildSrc test exit 1

APK ARTIFACT:
NOT PRODUCED — APK search empty (R3-02), no hash/identity/signature
```

### Android Device Verification

```text
APP LAUNCH:
BLOCKED — no target/APK (R3-02/08)

DECK ACCESS:
BLOCKED

ANSWER REVEAL:
BLOCKED

AGAIN / HARD / GOOD / EASY:
BLOCKED — pipeline source-verified, runtime unproven

UNDO:
BLOCKED

PROCESS RECREATION:
BLOCKED

COLLECTION ISOLATION:
BLOCKED — shared public storage risk identified, runtime path unproven (R3-07)

SYNC TEST:
UNVERIFIED — TEST ACCOUNT NOT AUTHORIZED — no parent-contract waiver; no authorized disposable account; correctly not attempted
```

Each field is an actual result with cited evidence, not a planned procedure.

### Architecture Safety

```text
NATIVE SCHEDULER:
UNCHANGED — Reviewer/VM → undoableOp → libanki/backend at current source; binary/runtime proof blocked

PC ANKI ADAPTER:
ABSENT — zero hits in exclusion scan; prod diff empty confirms excluded

ANKICONNECT SCHEDULING:
ABSENT — excluded

SECOND FSRS:
ABSENT — existing Fsrs.kt is version-display wrapper; DummyScheduler is unsupported-version throw, not alternate engine

STUDY-AGENT MIGRATION:
NOT STARTED — exact diff outside docs/fsa empty; no client code copied

RELEASE IDENTITY:
UNCHANGED — release com.ichi2.anki, debug .debug, ${applicationId} authorities; fallback keystore present, no public distribution

USER DATA SAFETY:
BLOCKED for coexistence/isolation certification; audit itself touched no user collection; mandatory caution preserved
```

### Residual Risks (mapped to closure)

Immediate blockers: missing JDK/SDK/repo access; absent APK/tests/lint/build-logic; no disposable device/Reviewer/isolation proof; missing FSA-00A; unresolved sync/contract & branch naming. RAM readiness risk. Release identity/storage remain explicit FSA-02 constraints, not reasons to change identity in this audit-only gate. See [residual risks](FSA-00C-RESIDUAL-RISKS.md).

### Gate Decision

```text
FSA-00:
BLOCKED — NOT LOCKED

BASELINE:
VERIFIED (source equivalence + toolchain pins match expected values)

APK:
NOT BUILT

ANDROID TESTS:
NOT EXECUTED — BLOCKED

REVIEWER:
SOURCE-VERIFIED, RUNTIME-UNVERIFIED

USER DATA ISOLATION:
BLOCKED

PC ANKI ADAPTER:
EXCLUDED (absent)

NEXT GATE:
BLOCKED — FSA-01 PRODUCTION MIGRATION NOT AUTHORIZED
Next after verified lock: FSA-01A — Study-Agent Migration Discovery & Component Classification

ACTION:
Execute baseline build on capable host per R3 §3-4; attach R3 evidence set; independent re-review. Do not claim PASS without execution.
```

A blocked gate is preferable to a fabricated PASS. Prior snapshots remain valid historical evidence for their cited SHAs; this decision reflects current HEAD `45b58a9` with fresh execution evidence (R3-01..08) and source audit (R3-07). No release distribution occurred.

---

### FSA-01 Handoff

The [FSA-01 handoff](FSA-01-HANDOFF.md) is **withheld** (conditional scope/exclusions only). **After legitimate FSA-00 lock**, next gate is FSA-01A — Study-Agent Migration Discovery & Component Classification. This audit does not execute it.

