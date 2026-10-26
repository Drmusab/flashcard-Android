# FSA-00C — Entry, provenance and evidence reconciliation

**Audit date:** 2026-10-25 UTC. **Authority:** audit only; no migration.
**Prepared with:** Arena.ai Agent Mode. No upstream contribution or remote workflow was submitted.
**Decision:** [FSA-00 remains BLOCKED](FSA-00-FINAL-LOCK.md).

## Frozen repository

| Field | Observed value |
| --- | --- |
| Target | `Drmusab/flashcard-Android` |
| Audited HEAD / fork main at observation | `f8212252540fe104663e935d4c582e9ad499ec89` |
| Session branch | `arena/8214a12a-flashcard-android` |
| Reference baseline | `a7121c11c6e11d9c6ba34518784156fba1701e29` |
| Origin | `https://github.com/Drmusab/flashcard-Android.git` |
| Upstream relationship | GitHub reports fork=true, parent/source=`ankidroid/Anki-Android`, default branch=`main` |
| Configured upstream remote | None; upstream queried by URL/API only |
| Observed upstream main | `fe6577031a7c2a875981f963c36aea5c5fe529bf` |
| Divergence, fork relative to that upstream SHA | **2 ahead / 17 behind**, merge base `a7121c11c6e11d9c6ba34518784156fba1701e29` |
| Entry worktree | Clean in first interactive inspection; no existing changes discarded |
| Report-generation worktree | New FSA-00C documentation/evidence only; recorded status starts after evidence directory creation |
| History | Shallow at entry and exit; no replace refs or `.git/info/grafts` file |

The baseline object was absent initially. Executed `git fetch --no-tags --depth=1 origin a7121c11c6e11d9c6ba34518784156fba1701e29` fetched that object into `FETCH_HEAD` without switching branches or merging. Local tree comparison now proves equivalence outside the historical report. This does **not** unshallow ancestry: the common ancestor and ahead/behind counts are GitHub compare evidence, not a local `merge-base` result.

`git diff --name-status a7121c11… HEAD` contains exactly:

```text
A docs/fsa/FSA-00B-fork-baseline-build-verification.md
```

463 added documentation lines; **zero** changes to production Kotlin/Java, tests, build scripts, dependencies, manifests, resources or native scheduler. The diff excluding that one document exits 0. All nine FSA-00B §5.4 SHA-256 anchors were independently recalculated and match. This verifies source integrity, not downloaded dependencies or an APK.

### Upstream changes not merged

The fork-only commits are report commit `2ad3dc8ce960e426007190c903c2df4f4eb4a742` and merge `f821225…`. The 17 upstream-only commits include deck access/type refactors, custom-study dialog changes, tests, lint, translations, policy/workflow documentation and the alpha8 version bump. Their SHAs/messages are retained in E05. GitHub's comparison file list may be capped at 300 files; it is not asserted to be a complete upstream changed-file inventory. No upstream commit was imported into the working tree. Remote snapshots may advance after the recorded observation.

## Evidence index

All paths below are relative to this directory. Text transcripts record UTC observation time, exact command, output and exit code. A grep exit 1 means no match, not a failing application test. Pipelines are inspection commands; build attempts are individual direct wrapper invocations. File hashes are provenance aids, not independent signatures.

| ID | Artifact | Purpose |
| --- | --- | --- |
| E01 | [01-repository.txt](evidence/00c/01-repository.txt) | Git state and initial report search |
| E02 | [02-environment.txt](evidence/00c/02-environment.txt) | Host, memory/disk, absent tools, artifact search |
| E03 | [03-gradle-attempts.txt](evidence/00c/03-gradle-attempts.txt) | All seven required wrapper attempts and exit codes |
| E04 | [04-github.txt](evidence/00c/04-github.txt) | Repository identity, remote heads, baseline compare, prerequisite search |
| E05 | [05-baseline-and-upstream.txt](evidence/00c/05-baseline-and-upstream.txt) | Baseline fetch/tree diff, divergence, PR evidence, corrected CI query |
| E06 | [06-network.txt](evidence/00c/06-network.txt) | Exact endpoint probes; TLS failures, not dependency resolution |
| E07 | [07-integrity-and-scans.txt](evidence/00c/07-integrity-and-scans.txt) | Hashes, exclusions, CI commands, repository scan |
| E08 | [08-source-excerpts.txt](evidence/00c/08-source-excerpts.txt) | Numbered source excerpts at audited HEAD |
| E09 | [09-follow-up-source.txt](evidence/00c/09-follow-up-source.txt) | FSRS wrapper, test-storage caveat, documentation corrections |
| E10 | [10-final-validation.txt](evidence/00c/10-final-validation.txt) | Final documentation/scope checks |

The installed `gh` rejected `gh run list --commit` (E04); the subsequent REST query via `gh api` succeeded (E05) and returned **zero workflow runs for the exact audited HEAD**. The PR's automated review comment is not Android build evidence. Issues are disabled; the issue search error is retained. No credentials/environment dumps or download authorization URLs were collected.

## Prerequisite reconciliation

| Requirement | Classification | Evidence and limitation |
| --- | --- | --- |
| FSA-00A original discovery report | **BLOCKED** | No report in tracked current/baseline filenames or current content outside FSA-00B; workspace filename search yielded none. No attachment was supplied. Fork PR listing has only PR #1 (FSA-00B); its body/comments provide no original report. Release list empty; issue search unavailable because issues disabled. This is an accessible-evidence search, not a claim about private external archives. |
| FSA-00B | **PARTIAL** | Located at `docs/fsa/FSA-00B-fork-baseline-build-verification.md`. Source pins, hashes, baseline-only scope and blocked execution conclusion independently corroborated. Historical command narrative is not independently recoverable as full external raw logs; fresh E03 attempts are separate evidence. |
| Historical evidence overall | **NOT RECONCILED** | Missing FSA-00A prevents complete cross-report reconciliation. Do not recreate findings and attribute them to FSA-00A. |

### Explicit corrections/qualifications (historical documents preserved)

1. **Revision and branch:** FSA-00B's `a7121c11…` and prior Arena branch describe its run, not this run. Current HEAD is the documentation merge `f821225…`; remote main is no longer exactly baseline. A merge of documentation proves no build success.
2. **Lint spelling:** FSA-00B §5.1 correctly specifies `ktlintCheck`, but §5.2 attempted `ktLintCheck`. `.github/workflows/README.md:16` also has the old capitalization; authoritative `lint.yml:73` uses `ktlintCheck`. E03 uses the correct spelling. Neither attempt reached task resolution.
3. **JVM claim:** FSA-00B's “any ≥17 launcher works” is not a verified unlimited compatibility range. Root `build.gradle.kts:203–240` enforces **daemon JVM 21–25** and states `JAVA_HOME` does not override daemon criteria. JetBrains 21 is the pinned default. Java 17 bytecode targets are not the runtime requirement. Launcher and daemon compatibility remain unexecuted here; use the pinned JDK and record both.
4. **No upstream remote ≠ no possible merge:** Git can fetch/merge by URL. The no-merge conclusion rests on unchanged HEAD/tree and the command record, not missing remote configuration.
5. **Test runner ≠ full isolation:** FSA-00B calls the instrumentation runner a disposable-path pattern. It actually appends `androidTest` to the configured collection directory (`CollectionHelper.kt:186–195`), which may be shared public storage. It is not permission to run tests on a personal device.
6. **Sync waiver:** FSA-00B's suggested waiver is not authorization. No parent contract permitting a waiver was supplied; sync remains UNVERIFIED and no waiver is granted.
7. **Branch remedy:** FSA-00B proposes creating `feature/fsa-foundation`. This session must remain on its fixed Arena branch. No creation/switch is performed. Obtain owner acceptance of equivalent branch isolation if historical naming remains a contract requirement; never reset main to make the old statement true.
8. **Memory:** FSA-00B's suggestion of “off-record” memory settings is not acceptable evidence practice. Any supported host settings must be recorded. Memory pressure is a risk, not an observed OOM.
9. **Artifact paths:** FSA-00B's APK paths are expectations, not existing outputs. E02/E07 found no APK; metadata/signature/hash remain absent.

Contributor and architecture references inspected: `CONTRIBUTING.md`, `AI_POLICY.md`, `.github/workflows/README.md`, actual lint/unit/emulator workflows, `docs/development/gradle-daemon-jvm.md`, and storage/reviewer source. Existing contributor-policy requirements must be respected for any later upstream submission; none was made here.

## Checkpoint coverage

| Checkpoints | Deliverable |
| --- | --- |
| 00C-00–03 | This entry/reconciliation report and E01/E04/E05 |
| 00C-04–12 | [Build verification](FSA-00C-BUILD-VERIFICATION.md) |
| 00C-13–14, 18 | [Device verification](FSA-00C-DEVICE-VERIFICATION.md) |
| 00C-15–17 | [Architecture audit](FSA-00C-ARCHITECTURE-AUDIT.md) |
| All audit/verification IDs and decision | [Final lock report](FSA-00-FINAL-LOCK.md) |
| B-01–B-08 reassessment and owners | [Residual risks](FSA-00C-RESIDUAL-RISKS.md) |
| Conditional next gate only | [Withheld handoff](FSA-01-HANDOFF.md) |
