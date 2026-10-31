# FSA-00C — Independent baseline audit and final gate decision

> **FSA-00R1 (2026-10-31, evaluated HEAD `ca446d8`): FSA-00 remains BLOCKED, NOT LOCKED — the execution blocker is
> now localised to GitHub Actions availability on the fork, not to the build.** New evidence: 18 workflows are
> registered and active with correct triggers, the triggering push/merge events occurred, and **zero workflow runs
> have ever been created**; every Actions settings/dispatch call returns `403` to the session's integration, so the
> fix is an owner-side click. In parallel, all seven Gradle commands were attempted again at this revision through a
> new evidence harness and all seven fail with `ENVIRONMENT_ERROR` at the wrapper's distribution download. A pinned,
> least-privilege baseline workflow (`fsa-foundation-ci.yml`) plus an evidence harness were added so that one owner
> action produces the missing build/test/lint/APK evidence without further code change. FSA-00A remains absent and
> is not reconstructed. See [FSA-00R1 residual blockers](FSA-00R1-RESIDUAL-BLOCKERS.md) and
> [CI diagnostics](FSA-00R1-CI-DIAGNOSTICS.md). FSA-01 remains NOT AUTHORIZED. All text below is preserved as
> historical evidence.

> **Latest reassessment (R5, evaluated HEAD `f441f267`): FSA-00 remains BLOCKED, NOT LOCKED.** The earlier R4 snapshot below is preserved as historical evidence. See [R5 independent audit](FSA-00C-R5-INDEPENDENT-AUDIT.md) for the current branch, divergence, executed commands, matrix, and blocker-resolution plan. FSA-01 production migration remains unauthorized.

> **FSA-00: BLOCKED — NOT LOCKED.**
> Source equivalence and scoped source architecture checks pass.
> Mandatory build, test, artifact, device and data-isolation evidence does not exist.
> FSA-00A reconciliation is blocked. FSA-01 production migration is **NOT AUTHORIZED**.
> **Current snapshot:** `f506261` on 2026-10-29 (R4). Prior snapshots `45b58a9…` (R3), `99d339e…` (R2) and `f821225…` are preserved as historical evidence.
> See the [R4 independent audit](FSA-00C-R4-INDEPENDENT-AUDIT.md) for current evidence. The tables below were produced at R3; every field was re-verified at R4 with the same or a sharper result, and the R4-specific differences are called out inline and in the final contract block.

**Audit date:** 2026-10-29 UTC. **Authority:** FSA-00C only, no feature migration.
**Prepared with:** Arena.ai Agent Mode; maintainer acceptance is not implied.

## 1. Repository

| Contract field | Observed result |
| --- | --- |
| Target repository | `Drmusab/flashcard-Android` |
| HEAD | `f506261b8968418a2d98f7bfa796ea61e98e1578` |
| Branch | `arena/2424aa82-flashcard-android` |
| Worktree status | Clean on entry; R4 adds documentation/evidence only. No prod/build changes, no existing work discarded. See R4-01. |
| Baseline commit | `a7121c11c6e11d9c6ba34518784156fba1701e29` (verified present locally and upstream) |
| Upstream HEAD (observed) | `c21570b0a5139fe0823568f8fa29460aa9be6066` (ankidroid/Anki-Android main, 2026-10-29T22:05:40Z) |
| Fork divergence | **8 ahead / 142 behind** that upstream SHA; merge base = reference baseline. Snapshot counts move as upstream advances (was 6/141 at R3, 4/88 at R2). |
| Source comparison | 34 added files at R4 entry, all under `docs/fsa/`. Outside docs/fsa diff empty – production, tests, build, manifests, deps identical to baseline; all 9 FSA-00B §5.4 hashes match (R4-06). |
| History | This checkout arrived **shallow (1 commit)**; `git fetch --unshallow` succeeded → full history (24,689 commits), no shallow file, no grafted commit. Must be re-established per session, never inherited. |

[R4-01..08](FSA-00C-R4-INDEPENDENT-AUDIT.md#evidence-index--r4) record exact commands, outputs and exit codes for this snapshot. No upstream merge, branch switch, commit, push, PR action or workflow dispatch performed. Source and signing policies frozen.

Historical: At R2 (`99d339e…`) HEAD and remote main matched; 4 ahead /88 behind, 18 added docs. At `f821225…` 2 ahead /17 behind, 1 added doc. Those counts were valid for cited upstream SHAs, not current upstream.

## 2. Prerequisite evidence

```text
FSA-00A:             BLOCKED — absent from every ref, all 4 PRs, releases and attachments (R4-05); not recreated
FSA-00B:             PARTIAL — pins, 9 hashes, blocked conclusion corroborated at the current revision; not full log recovery
HISTORICAL EVIDENCE: NOT RECONCILED — original FSA-00A missing
```

Detailed searches, limitations and corrections in [R3 §2](FSA-00C-R3-INDEPENDENT-REASSESSMENT.md#2-prerequisite-and-documentation-reconciliation) and companion entry report. Original FSA-00B preserved unchanged; its merge and automated PR review are not build evidence. Historical corrections retained: ktlintCheck spelling, daemon JVM range 21–25, instrumentation path caveat, sync waiver authority, branch naming contract.

## 3. Build verification

| Field | Result | Actual evidence |
| --- | --- | --- |
| GRADLE | **BLOCKED** | R4-03: wrapper **launches under a real JVM 21** and dies downloading `gradle-9.8.0-bin.zip` (`SSLHandshakeException`, 4/4 attempts). Distribution never fetched, so no Gradle task ran. Pin 9.8.0 verified in wrapper |
| JDK | **PARTIAL / BLOCKED** | R4-03: `java -version` = Temurin 21.0.8+9 (JRE only — **no `javac`**, no `jmods`), obtained from an allowed host (`pypi.org`/`jdk4py`). Pinned JETBRAINS 21 daemon never provisioned or observed; 21–25 bounds satisfied by the substitute but it cannot build |
| ANDROID SDK | **BLOCKED** | R4-02/04: no SDK/tools/`local.properties`; `dl.google.com` and `maven.google.com` return `000`; SDK 37 source pin only, build-tools patch unknown until a real SDK diagnostic |
| FULLDEBUG BUILD | **BLOCKED** | R4-03: `:AnkiDroid:assembleFullDebug` exit 1 at distribution fetch; no compiler execution, no `AnkiDroid/build` |
| UNIT TESTS | **BLOCKED** | R4-03: `testFullDebugUnitTest` and `jacocoUnitTestReport` each exit 1; no XML/HTML |
| LINT | **BLOCKED** | R4-03: correct `lintAll ktlintCheck lint-rules:test` exit 1; no findings measured, no rule disabled |
| BUILD LOGIC | **BLOCKED** | R4-03: `./gradlew -p buildSrc test` exit 1 (8 test classes exist, none executed) |
| APK ARTIFACT | **NOT PRODUCED** | R4-02/03/08: APK search empty; no size/hash/package/signature from binary |

Robolectric preparation also exit 1. All 7 wrapper invocations fail at the **same** step — the Gradle distribution download — so **no Gradle task ran**. This is a material sharpening of R3: the prior round could not distinguish a launcher/JVM defect from a network defect because there was no JVM at all. With a real JVM present, the failure is unambiguously artifact acquisition (`services.gradle.org`, `repo1.maven.org`, `dl.google.com`, `plugins.gradle.org`, `jitpack.io`, `api.foojay.io` all return `000`; even `objects.githubusercontent.com` is blocked, so GitHub release binaries are not an alternative either — R4-04). AGP 9.4.1 / Kotlin 2.4.20 remain verified source pins, not executed compatibility. No mirror, repackaged JDK/SDK, checksum bypass or dependency substitution was attempted. Exact commands and capable-host rerun contract in [R4 §3](FSA-00C-R4-INDEPENDENT-AUDIT.md#3-toolchain-and-build-verification-executed) and [build verification](FSA-00C-BUILD-VERIFICATION.md).

## 4. Android device verification

| Field | Actual result / evidence |
| --- | --- |
| APP LAUNCH | **BLOCKED** – no APK/target, R3-02/08 |
| DECK ACCESS | **BLOCKED** |
| ANSWER REVEAL | **BLOCKED** |
| AGAIN / HARD / GOOD / EASY | **BLOCKED** – native pipeline source-verified, runtime unproven |
| UNDO | **BLOCKED** |
| PROCESS RECREATION | **BLOCKED** – lifecycle unexecuted |
| COLLECTION ISOLATION | **BLOCKED** – shared-storage risk exposed and re-pinned at R4 to `SetupStorage.kt:127-148` (`PUBLIC` → `File(getExternalStorageDirectory(), "AnkiDroid")`); runtime path unknown |
| SYNC TEST | **UNVERIFIED – TEST ACCOUNT NOT AUTHORIZED** – no parent-contract waiver; no authorized disposable account; correctly not attempted |

Session end, restart/persistence, navigation, coexistence also BLOCKED. No install, collection access or production sync performed. Safe procedure and disposable-environment requirements in [R3 §4](FSA-00C-R3-INDEPENDENT-REASSESSMENT.md#4-device-reviewer-and-data-safety-verification) and [device report](FSA-00C-DEVICE-VERIFICATION.md).

## 5. Architecture safety

| Field | Result and qualification |
| --- | --- |
| NATIVE SCHEDULER | **UNCHANGED** in source; `Reviewer.kt:1580-1592` / `AbstractFlashcardViewer.kt:885-890` / `ReviewerViewModel.kt:527-541` all via `undoableOp` → libanki `Scheduler.kt:172` → `backend.answerCard` (R4-07); runtime still blocked |
| PC ANKI ADAPTER | **ABSENT** in source; exclusion scan zero hits for all 10 forbidden symbols (R4-07) |
| ANKICONNECT SCHEDULING | **ABSENT** – excluded |
| SECOND FSRS | **ABSENT** as separate engine; scheduling is delegated to the native backend, and `DummyScheduler` is only used when `schedVer() == 1` (unsupported legacy), `Collection.kt:231-236` (R4-07) |
| STUDY-AGENT MIGRATION | **NOT STARTED** – prod diff empty |
| RELEASE IDENTITY | **UNCHANGED** – release `com.ichi2.anki`, debug `.debug`, templated authorities/permissions; fallback keystore present but no distribution |
| USER DATA SAFETY | **BLOCKED** for coexistence/isolation certification. No user collection touched. Risk: distinct package ID ≠ isolated storage. |

[Architecture audit](FSA-00C-ARCHITECTURE-AUDIT.md) traces legacy and ViewModel reviewers, native commit/undo, lifecycle limits, manifests/providers/deep-links, test storage, fallback signing and all 14 invariants. Source audit alone not substituted for runtime.

## 6. Independent audit matrix

**PASS = stated scope only.** Rows were established at R3 and re-verified at R4; the current evidence IDs are the R4 index in the [R4 audit](FSA-00C-R4-INDEPENDENT-AUDIT.md#6-independent-audit-matrix), which carries the same 18 verdicts plus the sharper JDK/dependency findings. Risks/owners/closure in [risk register](FSA-00C-RESIDUAL-RISKS.md).

| Audit ID / subject | Result | Source evidence | Execution evidence | Defect / limitation | Remediation | Residual risk |
| --- | --- | --- | --- | --- | --- | --- |
| AUDIT-00C-01 Fork/upstream identity | **PASS** | Origin & GitHub parent/source | R3-01/05 identity/heads/compare | Remote advances | Preserve SHAs; reobserve | R-13 |
| AUDIT-00C-02 Baseline integrity | **PASS** | Reference & HEAD trees; 9 hashes | R4-01/06 diff outside docs/fsa empty; hashes 9/9 | Checkout recurs shallow per session | Re-run `--unshallow`; retain API + diff | R-13 |
| AUDIT-00C-03 Worktree/branch safety | **PASS** | Fixed Arena branch, unchanged baseline | R3-01 status/worktree | Branch-name contract unresolved | Keep branch; obtain acceptance | R-10 |
| AUDIT-00C-04 FSA-00A/B reconciliation | **BLOCKED** | B present; A absent | R3-05 searches | No original A | Obtain original w/ provenance | R-04 |
| AUDIT-00C-05 Version integrity | **PASS (pins)** | Wrapper/catalog/daemon/root bounds/buildSrc | R4-06 hashes; R4-03 JVM 21 inside the 21–25 guard | Daemon vendor/patch and AGP compatibility unexecuted | Execute pinned toolchain | R-01/R-02 |
| AUDIT-00C-06 SDK/dependency readiness | **BLOCKED** | SDK 37, repos/backend defs | R4-02 inventory; R4-04 12 endpoints `000` | No SDK; deps unobtainable by any allowed route | Standard SDK + authorized net | R-02/R-09/R-11 |
| AUDIT-00C-07 APK compilation | **BLOCKED** | FullDebug config exists | R4-03 exit 1 at distribution fetch | No compiler verdict | Frozen FullDebug build | R-01/R-02/R-05 |
| AUDIT-00C-08 Unit-test integrity | **BLOCKED** | FullDebug & aggregate tasks | R4-03 both exit 1; no XML | No outcomes | Run both scopes, collect XML | R-05 |
| AUDIT-00C-09 Lint/style | **BLOCKED** | lintAll/config/editor + lint.yml | R4-03 exit 1 (correct spelling) | Unmeasured | Run unchanged rules | R-05 |
| AUDIT-00C-10 Build-logic tests | **BLOCKED** | 8 buildSrc test classes | R4-03 exit 1 | Sources ≠ execution | Run on capable host | R-05 |
| AUDIT-00C-11 APK identity/signing/hash | **BLOCKED** | Source ID/signing expectations | R4-02/08 no APK, no apksigner/aapt2 | No binary evidence | Inspect APK with tools & hash | R-05/R-07 |
| AUDIT-00C-12 Native scheduler authority | **PASS (source)** | Viewer→undoableOp→libanki/backend | R3-05 unchanged + R3-06 scan | Backend binary/runtime unproven | Preserve; complete device | R-03/R-05 |
| AUDIT-00C-13 Rating/undo behavior | **BLOCKED** | Native pipeline inspected | R3-02 no target | Behavioral proof requires device | Disposable device matrix | R-03/R-05/R-06 |
| AUDIT-00C-14 Data/storage isolation | **BLOCKED** | AppId/provider & storage sources | R4-08 shared-risk re-pinned to `SetupStorage.kt:127-148` | Runtime unproven | Verify path; paired-install test | R-06/R-12 |
| AUDIT-00C-15 No PC Adapter/second scheduler | **PASS (source)** | No adapter symbols; Fsrs/Dummy clarified | R3-06 scan + tree diff | Binary not reverse-audited | Maintain exclusion | R-05 |
| AUDIT-00C-16 No Study-Agent migration in FSA-00 | **PASS** | Exact diff outside docs/fsa empty | R3-05/06 | – | Enforce for FSA-01A | – |
| AUDIT-00C-17 No unauthorized upstream merge | **PASS** | HEAD frozen; 8 ahead from docs only | R4-01/05 logs; 142 upstream commits not merged | – | Do not sync upstream | R-11 |
| AUDIT-00C-18 Truthful verification & lock decision | **PASS** | Only executed evidence cited | R4-01..08 retained | – | Gate remains BLOCKED | – |

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
| VER-00C-07 JDK & daemon JVM | **PARTIAL** – real Temurin 21.0.8 **JRE** ran the launcher (no `javac`, not the pinned vendor); pinned JETBRAINS 21 daemon never observed (R4-03) |
| VER-00C-08 Gradle wrapper executes | **BLOCKED** – launcher runs, distribution fetch fails TLS (R4-03) |
| VER-00C-09 Dependencies resolve | **BLOCKED** – 12 acquisition endpoints `000` (R4-04) |
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
| VER-00C-30 Exact evidence attached | **PASS** – R4-01..08 |

Mandatory device rows remain BLOCKED; sync waiver not granted.

## 8. Residual risks

| Risk | Severity | Blocks? |
| --- | --- | --- |
| R-01 No full pinned JDK/daemon (JRE-only substitute proven insufficient) | Critical | **YES** |
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
| R-13 History full only after per-session `--unshallow` | Low | NO |

Ordered closure: owner prerequisites → capable host (**full** JETBRAINS JDK 21, SDK 37 via standard SDK manager, authorized network to Gradle/Google/Maven/Plugin/foojay, ≥8 GiB RAM, disposable Android target) → re-execute the 7 commands and collect XML/lint/APK hash/signature, then rebuild before any reproducibility claim → prove disposable storage before the first mutation, then the full Reviewer/lifecycle/coexistence matrix → independent re-review. Never distribute a fallback-signed release. Nothing in the R4 round closed a risk. See [risk register](FSA-00C-RESIDUAL-RISKS.md).

## 9. Final contract

### Repository

```text
FSA-00C — INDEPENDENT BASELINE AUDIT (R4)

TARGET REPOSITORY:
Drmusab/flashcard-Android

HEAD:
f506261b8968418a2d98f7bfa796ea61e98e1578

BRANCH:
arena/2424aa82-flashcard-android

WORKTREE STATUS:
Clean on entry; R4 documentation/evidence only. No prod/build changes.

BASELINE COMMIT:
a7121c11c6e11d9c6ba34518784156fba1701e29

UPSTREAM HEAD:
c21570b0a5139fe0823568f8fa29460aa9be6066 (ankidroid/Anki-Android main 2026-10-29T22:05:40Z)

FORK DIVERGENCE:
8 ahead (docs only) / 142 behind upstream — merge base a7121c11…
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
BLOCKED — wrapper launches under JVM 21 then fails fetching gradle-9.8.0-bin.zip
(SSLHandshakeException, 4/4 attempts); no Gradle task ran (R4-03)

JDK:
PARTIAL — Temurin 21.0.8 JRE ran the launcher, but it has no javac/jmods and is not
the pinned JETBRAINS vendor; pinned daemon JVM 21 never provisioned or observed (R4-03)

ANDROID SDK:
BLOCKED — no SDK/tools (R4-02); dl.google.com and maven.google.com return 000 (R4-04);
compileSdk 37 source pin only, build-tools patch unknown until a real SDK diagnostic

FULLDEBUG BUILD:
BLOCKED — :AnkiDroid:assembleFullDebug exit 1 at distribution fetch, no APK, no build dir

UNIT TESTS:
BLOCKED — testFullDebugUnitTest + jacocoUnitTestReport both exit 1, no XML

LINT:
BLOCKED — lintAll ktlintCheck lint-rules:test exit 1, correct spelling used

BUILD LOGIC:
BLOCKED — -p buildSrc test exit 1 (8 test classes exist, none executed)

APK ARTIFACT:
NOT PRODUCED — APK search empty (R4-02/03/08), no hash/identity/signature
```

### Android Device Verification

```text
APP LAUNCH:
BLOCKED — no APK, no adb, no emulator, no /dev/kvm (R4-02/08)

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
BLOCKED — PUBLIC storage branch resolves to shared /AnkiDroid (SetupStorage.kt:127-148);
runtime path unproven; no user-owned collection read or written (R4-08)

SYNC TEST:
UNVERIFIED — TEST ACCOUNT NOT AUTHORIZED — no parent-contract waiver; no authorized disposable account; correctly not attempted
```

Each field is an actual result with cited evidence, not a planned procedure.

### Architecture Safety

```text
NATIVE SCHEDULER:
UNCHANGED — Reviewer/VM → undoableOp → libanki Scheduler → backend.answerCard at current source
(Reviewer.kt:1580-1592, ReviewerViewModel.kt:527-541, Scheduler.kt:172); binary/runtime proof blocked

PC ANKI ADAPTER:
ABSENT — zero hits in exclusion scan; prod diff empty confirms excluded

ANKICONNECT SCHEDULING:
ABSENT — excluded

SECOND FSRS:
ABSENT — existing Fsrs.kt is version-display wrapper; DummyScheduler is unsupported-version throw, not alternate engine

STUDY-AGENT MIGRATION:
NOT STARTED — exact diff outside docs/fsa empty; no client code copied

RELEASE IDENTITY:
UNCHANGED — release com.ichi2.anki, debug .debug, ${applicationId} authorities; committed fallback
keystore (public passwords) untouched and nothing built, signed, installed or distributed

USER DATA SAFETY:
BLOCKED for coexistence/isolation certification; audit itself touched no user collection; mandatory caution preserved
```

### Residual Risks (mapped to closure)

Immediate blockers: missing JDK/SDK/repo access; absent APK/tests/lint/build-logic; no disposable device/Reviewer/isolation proof; missing FSA-00A; unresolved sync/contract & branch naming. RAM readiness risk. Release identity/storage remain explicit FSA-02 constraints, not reasons to change identity in this audit-only gate. See [residual risks](FSA-00C-RESIDUAL-RISKS.md).

### Gate Decision

```text
FSA-00:
BLOCKED — NOT LOCKED  (Gate contract Case B)

BASELINE:
VERIFIED (source equivalence, 9/9 hashes, toolchain pins match expected values)

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
Execute baseline build on capable host per R4 §3 and the R4 closure plan (full pinned JDK 21,
SDK 37, authorized egress, disposable target); attach R4-equivalent evidence; independent
re-review. Do not merge upstream. Do not claim PASS without execution.
```

A blocked gate is preferable to a fabricated PASS. Prior snapshots remain valid historical evidence for their cited SHAs; this decision reflects current HEAD `f506261` with fresh execution evidence (R4-01..08) and a re-verified source audit. The R4 round changed no verdict: it narrowed the JDK blocker from "no JVM" to "no full pinned JDK", and moved the build blocker's proven boundary from the launcher to artifact acquisition. No release distribution, upstream merge or user-data operation occurred.

---

### FSA-01 Handoff

The [FSA-01 handoff](FSA-01-HANDOFF.md) is **withheld** (conditional scope/exclusions only). **After legitimate FSA-00 lock**, next gate is FSA-01A — Study-Agent Migration Discovery & Component Classification. This audit does not execute it.


---

## FSA-00R1 addendum — CI recovery round (2026-10-31, revision `ca446d8`)

Appended by FSA-00R1. Everything above is preserved unchanged as historical evidence for its cited SHAs. This
addendum adds new execution evidence and re-affirms the existing decision; it does not upgrade any earlier result.

### What was re-verified at `ca446d8712e3a9b01050c536c26e3869220f0415`

| Item | Result | Evidence |
| --- | --- | --- |
| Baseline integrity | non-`docs` diff vs `a7121c11` **empty**; 12 commits ahead of baseline, all documentation | [01](evidence/00r1/01-repository-state.txt) |
| Upstream | 165 commits ahead, **not merged** | [01](evidence/00r1/01-repository-state.txt) |
| GitHub Actions | 18 workflows registered and `active`, triggers correct, events occurred, **0 runs ever**, 0 caches, 0 artifacts; dispatch/settings `403` | [02](evidence/00r1/02-github-actions-api.txt) |
| Gradle wrapper | launcher executes, distribution fetch fails (`EOFException` / `SSL peer shut down incorrectly`) | [04](evidence/00r1/04-jvm-and-wrapper.txt) |
| Seven Gradle commands | all attempted, all exit 1, all `ENVIRONMENT_ERROR`, no build directory, no reports | [05-logs](evidence/00r1/05-logs/commands.tsv) |
| Dependency hosts | every Gradle/Google/Maven/JitPack/foojay host blocked at TLS in this sandbox | [03](evidence/00r1/03-network-probe.txt) |
| Invariants (16 forbidden symbols) | 0 matches; native scheduler path unchanged | [08](evidence/00r1/08-identity-invariants.txt) |
| FSA-00A | still absent from every ref, PR, release and artifact; not reconstructed | [09](evidence/00r1/09-fsa-00a-search.txt) |

### What was added (infrastructure only — no product code)

* `.github/workflows/fsa-foundation-ci.yml` — manual + `main` workflow producing FullDebug compile, unit tests,
  lint/ktlint/lint-rule tests, build-logic tests, APK identity, per-command provenance and artifacts, under
  `permissions: contents: read` with SHA-pinned actions only.
* `.github/fsa/run_evidence_command.sh`, `.github/fsa/apk_identity.sh` — evidence harness (self-tested, including a
  negative control) so that "attempted" can never again be confused with "executed".
* `docs/fsa/FSA-00R1-*.md` + `docs/fsa/evidence/00r1/**` — this round's report and evidence set.

### Decision (unchanged)

```text
FSA-00:                     BLOCKED  (11 of 13 acceptance rows blocked; 2 pass as absence claims only)
FSA-00 LOCK:                NOT GRANTED
FSA-01 PRODUCTION MIGRATION: NOT AUTHORIZED
UNBLOCKING OWNER ACTION:    R1-B1 — enable GitHub Actions for fork Drmusab/flashcard-Android
                            (Actions tab fork banner + Settings → Actions → General),
                            then run "🧪 FSA Foundation CI" on arena/a6008955-flashcard-android
SECOND OWNER ACTION:        R1-B5 — supply the original FSA-00A report (with hash) for provenance
```

A blocked gate remains preferable to a fabricated PASS. This round produced no APK, executed no test and ran no
emulator; it localised the blocker and removed the remaining excuse for a repeat source-only audit.
