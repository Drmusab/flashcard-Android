# FSA-00C — Entry, provenance and evidence reconciliation

> **Current snapshot:** `f506261b8968418a2d98f7bfa796ea61e98e1578` on 2026-10-29 — see [R4 independent audit](FSA-00C-R4-INDEPENDENT-AUDIT.md) for the authoritative current decision and evidence. Prior audits at `45b58a9…` (R3), `99d339e…` (R2) and `f821225…` are preserved below as historical.

**Audit date:** 2026-10-29 UTC (R4). **Authority:** audit only; no migration.
**Prepared with:** Arena.ai Agent Mode. No upstream contribution or remote workflow dispatch.
**Decision:** [FSA-00 remains BLOCKED](FSA-00-FINAL-LOCK.md).

## Frozen repository (current)

| Field | Observed value |
| --- | --- |
| Target | `Drmusab/flashcard-Android` |
| Audited HEAD | `f506261b8968418a2d98f7bfa796ea61e98e1578` (merge of PR #4, the R3 documentation merge) |
| Session branch | `arena/2424aa82-flashcard-android` (fixed Arena session) |
| Reference baseline | `a7121c11c6e11d9c6ba34518784156fba1701e29` |
| Origin | `https://github.com/Drmusab/flashcard-Android.git` |
| Upstream relationship | GitHub reports `fork:true`, parent/source `ankidroid/Anki-Android`, default branch `main` |
| Configured upstream remote | None; upstream queried by URL/API only |
| Observed upstream main | `c21570b0a5139fe0823568f8fa29460aa9be6066` (2026-10-29T22:05:40Z) |
| Divergence vs that upstream SHA | **8 ahead / 142 behind**, merge base `a7121c11…` (GitHub compare) |
| Entry worktree | Clean; R4 adds docs/fsa evidence only |
| Report-generation worktree | New R4 documentation/evidence only; no prod/build changes discarded |
| History | **Started shallow (1 commit) in this checkout**; `git fetch --unshallow` succeeded → full history (24,689 commits), no shallow file, no grafted commit. R3's full-history state did not carry into this session. |

R4 entry evidence is index [R4-01..08](FSA-00C-R4-INDEPENDENT-AUDIT.md#evidence-index--r4); R4 also corrected R3's claim that no JVM could be provisioned at all (a JRE *is* obtainable from an allowed host, and it was used to isolate the failure to artifact acquisition).

`git diff --name-status a7121c11..HEAD` contains exactly:

```text
A docs/fsa/FSA-00-FINAL-LOCK.md
A docs/fsa/FSA-00B-fork-baseline-build-verification.md
A docs/fsa/FSA-00C-ARCHITECTURE-AUDIT.md
A docs/fsa/FSA-00C-BUILD-VERIFICATION.md
A docs/fsa/FSA-00C-DEVICE-VERIFICATION.md
A docs/fsa/FSA-00C-ENTRY-AND-EVIDENCE.md
A docs/fsa/FSA-00C-R2-INDEPENDENT-REASSESSMENT.md
A docs/fsa/FSA-00C-R3-INDEPENDENT-REASSESSMENT.md
A docs/fsa/FSA-00C-RESIDUAL-RISKS.md
A docs/fsa/FSA-01-HANDOFF.md
A docs/fsa/evidence/00c-r2/01-wrapper-exact-commands.txt
A docs/fsa/evidence/00c-r2/02-wrapper-with-jvm.txt
A docs/fsa/evidence/00c-r2/03-repository-and-upstream.txt
A docs/fsa/evidence/00c-r2/04-environment-and-network.txt
A docs/fsa/evidence/00c-r2/05-source-audit.txt
A docs/fsa/evidence/00c-r2/06-integrity-and-reconciliation.txt
A docs/fsa/evidence/00c/01-repository.txt
A docs/fsa/evidence/00c/02-environment.txt
A docs/fsa/evidence/00c/03-gradle-attempts.txt
A docs/fsa/evidence/00c/04-github.txt
A docs/fsa/evidence/00c/05-baseline-and-upstream.txt
A docs/fsa/evidence/00c/06-network.txt
A docs/fsa/evidence/00c/07-integrity-and-scans.txt
A docs/fsa/evidence/00c/08-source-excerpts.txt
A docs/fsa/evidence/00c/09-follow-up-source.txt
A docs/fsa/evidence/00c/10-final-validation.txt
```

25 added documentation lines; **zero** changes to production Kotlin/Java, tests, build scripts, dependencies, manifests, resources or native scheduler outside docs/fsa. The diff excluding docs/fsa exits 0. All nine FSA-00B §5.4 SHA-256 anchors independently recalculated and match (R3-06). This verifies source integrity, not dependencies or APK.

> **R4 update at `f506261…`:** the same diff now spans **34 added files, still all under `docs/fsa/`** (the 25 above plus the R3 report and its 8 evidence files). `git diff --stat a7121c11..HEAD ':(exclude)docs/fsa'` remains empty and the same 9 anchors still match (R4-01/R4-06). The conclusion is unchanged; only the count grew.

### Upstream changes not merged

The fork-only commits are the 3 documentation commits + 3 merges (6 ahead). The 141 upstream-only commits since baseline include deck/refactors, custom-study dialogs, tests, lint, translations, policy/workflow docs and alpha8 bump. Their SHAs are retained in R3-05. No upstream commit was imported into working tree. Remote snapshots may advance after observation.

> **R4 update:** at `f506261…` the fork is **8 ahead / 142 behind** upstream `c21570b0…`, still with merge base `a7121c11…`; the two additional fork commits are the R3 documentation commit and its merge (R4-05). No upstream commit was merged.

### Historical snapshot (preserved)

Prior FSA-00C at `f821225…` (2026-10-25):

| Field | Value |
| --- | --- |
| HEAD | `f8212252540fe104663e935d4c582e9ad499ec89` |
| Branch | `arena/8214a12a-flashcard-android` |
| Divergence | 2 ahead / 17 behind `fe65770…` |
| Added file | `FSA-00B-fork-baseline-build-verification.md` (1 doc, 463 lines) |
| Worktree | Clean at start; remained clean until report added |
| History | Shallow at entry and exit |

Prior R2 at `99d339e…` (2026-10-28):

| Field | Value |
| --- | --- |
| HEAD | `99d339e48c93d7b9c63113cb702574981e5cff30` |
| Branch | `arena/657ed7e0-flashcard-android` |
| Divergence | 4 ahead / 88 behind `4561666d…` |
| Added files | 18 under docs/fsa (FSA-00B +7 prior docs +10 evidence) |
| History | Shallow at entry and exit |

Both were valid for their cited SHAs; their blocked results are consistent with present.

## Evidence index

Current R4 evidence is the authoritative set: [R4-01..08](FSA-00C-R4-INDEPENDENT-AUDIT.md#evidence-index--r4) in `evidence/00c-r4/` (repository state, host environment, JVM provisioning + 7 wrapper executions, 17-endpoint acquisition matrix, GitHub/upstream compares, 9-anchor integrity, source audit, identity/storage/device). The R3 set below remains as historical evidence for `45b58a9…`.

Historical R3 evidence (relative to this directory, UTC timestamps, exact commands, exits):

| ID | Artifact | Purpose |
| --- | --- | --- |
| R3-01 | [01-repository.txt](evidence/00c-r3/01-repository.txt) | Git state, baseline diff |
| R3-02 | [02-environment.txt](evidence/00c-r3/02-environment.txt) | Host, memory/disk, absent tools, APK search |
| R3-03 | [03-gradle-attempts.txt](evidence/00c-r3/03-gradle-attempts.txt) | 7 wrapper attempts, exit codes |
| R3-04 | [04-network.txt](evidence/00c-r3/04-network.txt) | Endpoint probes (TLS failures, not dep resolution) |
| R3-05 | [05-github-and-baseline.txt](evidence/00c-r3/05-github-and-baseline.txt) | Baseline fetch/tree diff, divergence, PR, prerequisite search |
| R3-06 | [06-integrity-and-scans.txt](evidence/00c-r3/06-integrity-and-scans.txt) | Hashes, exclusions, CI commands, repo scan |
| R3-07 | [07-source-audit.txt](evidence/00c-r3/07-source-audit.txt) | Numbered Reviewer/scheduler/identity/storage/CI excerpts; exclusion scans |
| R3-08 | [08-device-and-isolation.txt](evidence/00c-r3/08-device-and-isolation.txt) | Device/isolation scan, deep links, sync/backup surfaces |

Historical (preserved):

| ID | Artifact |
| --- | --- |
| E01-E10 | `evidence/00c/01-10` – original FSA-00B/C audit |
| R2-01..06 | `evidence/00c-r2/01-06` – R2 reassessment |

The installed `gh` CLI succeeded for all API queries; commit SHA `a7121c11…` is verified present in upstream (`ankidroid/Anki-Android`). GitHub compare supplies ahead/behind and merge base; local diff proves prod equivalence. No credentials/dump URLs collected.

## Prerequisite reconciliation

| Requirement | Classification | Evidence and limitation |
| --- | --- | --- |
| FSA-00A original discovery report | **BLOCKED** | No report in tracked current/baseline filenames or current content outside FSA-00B; workspace filename search (R3-05) yielded none; workspace PR list (3 PRs) provides no original report; releases empty; issues disabled; no attachment supplied. Accessible-evidence search only, not claim about private archives. |
| FSA-00B | **PARTIAL** | Located at `docs/fsa/FSA-00B-fork-baseline-build-verification.md`. Source pins, hashes, baseline-only scope and blocked execution conclusion independently corroborated by R3-03/05/06. Not full original log recovery. |
| Historical evidence overall | **NOT RECONCILED** | Missing FSA-00A prevents complete cross-report reconciliation. Do not recreate findings and attribute them to FSA-00A. |

### Explicit corrections/qualifications (historical documents preserved, still valid)

1. **Revision/branch:** FSA-00B's `a7121c11…` and prior Arena branches describe those runs, not this run. Current HEAD is documentation merge `f506261…` on `arena/2424aa82-flashcard-android`; the fork is 142 behind upstream. Merge of docs proves no build success.
2. **Lint spelling:** FSA-00B §5.1 correctly specifies `ktlintCheck`, §5.2 attempted `ktLintCheck`; `workflows/README.md:16` also old capitalization; authoritative `lint.yml:73` uses `ktlintCheck`. R3-03 uses correct spelling; neither reached task resolution historically or now.
3. **JVM claim:** FSA-00B “any ≥17 launcher works” not verified unlimited range. Root `build.gradle.kts:203-240` enforces **daemon JVM 21–25** and states `JAVA_HOME` does not override daemon criteria. JetBrains 21 is pinned default. Launcher vs daemon compatibility remains unexecuted; use pinned JDK and record both.
4. **No upstream remote ≠ no possible merge:** Git can fetch/merge by URL; no-merge conclusion rests on unchanged HEAD/tree and command record (R3-01/05), not missing remote.
5. **Test runner ≠ full isolation:** Instrumentation runner appends `androidTest` to configured collection directory (`CollectionHelper.kt:186-195`), which may be shared public storage. Not permission to run tests on personal device.
6. **Sync waiver:** Suggested waiver not authorization. No parent contract permitting waiver supplied; sync remains UNVERIFIED, no waiver granted.
7. **Branch remedy:** `feature/fsa-foundation` not created/switched per fixed Arena branch lock. Obtain owner acceptance of equivalent isolation if naming remains contract requirement; never reset main.
8. **Memory:** Off-record memory settings not acceptable evidence. Any host settings must be recorded. Pressure is risk, not observed OOM.
9. **Artifact paths:** APK paths in FSA-00B are expectations, not existing outputs. R4-02/R4-08 found no APK; metadata/signature/hash remain absent.
10. **R3's JVM claim corrected by R4:** R3 concluded no JVM could be provisioned from allowed hosts. That is inaccurate — `pypi.org` is reachable and `jdk4py` supplied a working **Temurin 21.0.8 JRE**, which executed the wrapper launcher (exit 0 for `java -version`). It is a JRE (no `javac`, no `jmods`), not the pinned JETBRAINS vendor, so it cannot substitute for the build toolchain. The useful consequence: the proven blocker moved from "no JVM at all" to "Gradle distribution and all dependency artifacts are unfetchable" (R4-03/R4-04).
11. **Shallow checkout recurred:** although R3 recorded full history, this session's checkout arrived shallow (1 commit). `git fetch --unshallow` succeeded, so baseline comparison is again valid — but the state must be re-established per session, not inherited.

Contributor and architecture references: `CONTRIBUTING.md`, `AI_POLICY.md`, `workflows/README.md`, actual lint/unit/emulator workflows, `docs/development/gradle-daemon-jvm.md`, storage/reviewer source. No PR/workflow submitted.

## Checkpoint coverage

| Checkpoints | Deliverable |
| --- | --- |
| 00C-00–03 | This entry report + R3-01/05 + historical E01/E04/E05/R2-03 |
| 00C-04–12 | [Build verification](FSA-00C-BUILD-VERIFICATION.md) + R3-02/03/04/06/07 |
| 00C-13–14, 18 | [Device verification](FSA-00C-DEVICE-VERIFICATION.md) + R3-08 |
| 00C-15–17 | [Architecture audit](FSA-00C-ARCHITECTURE-AUDIT.md) + R3-06/07 |
| All audit/verification IDs and decision | [Final lock](FSA-00-FINAL-LOCK.md) + [R3 reassessment](FSA-00C-R3-INDEPENDENT-REASSESSMENT.md) |
| B-01–B-08 reassessment and owners | [Residual risks](FSA-00C-RESIDUAL-RISKS.md) |
| Conditional next gate only | [Withheld handoff](FSA-01-HANDOFF.md) |

