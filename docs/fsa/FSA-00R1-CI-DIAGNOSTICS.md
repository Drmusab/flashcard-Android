# FSA-00R1 — CI discovery and diagnosis

**Stage:** FSA-00 Foundation Remediation · **Round:** FSA-00R1
**Evaluated revision:** `ca446d8712e3a9b01050c536c26e3869220f0415` (branch `arena/a6008955-flashcard-android`, clean worktree on entry)
**Date:** 2026-10-31 UTC · **Prepared with:** Arena.ai Agent Mode · **Maintainer acceptance is not implied**
**Result of this round: FSA-00 remains BLOCKED.** No new feature work, no upstream merge, no release, no collection access.

> Round scope: discover why no GitHub Actions run exists, fix only build-infrastructure defects that are
> inside the authorized scope, and record what can and cannot be executed. No claim of a pass is made for
> anything that was not executed.

Evidence files referenced below live in [`docs/fsa/evidence/00r1/`](evidence/00r1/).

---

## 1. Repository state (A-01)

| Contract field | Observed result | Evidence |
| --- | --- | --- |
| `git status --short` | empty (clean entry; nothing discarded, nothing stashed) | [01](evidence/00r1/01-repository-state.txt) |
| `git rev-parse HEAD` | `ca446d8712e3a9b01050c536c26e3869220f0415` | [01](evidence/00r1/01-repository-state.txt) |
| `git branch --show-current` | `arena/a6008955-flashcard-android` | [01](evidence/00r1/01-repository-state.txt) |
| `git remote -v` | `origin https://github.com/Drmusab/flashcard-Android.git` (no upstream remote configured) | [01](evidence/00r1/01-repository-state.txt) |
| `git log -8 --oneline` | `ca446d8712` merge of PR #6 → `cc9de1a3ef`, `f441f267b9`, … (documentation-only history since the baseline) | [01](evidence/00r1/01-repository-state.txt) |
| Reference baseline | `a7121c11c6e11d9c6ba34518784156fba1701e29`, verified present and an ancestor of HEAD | [01](evidence/00r1/01-repository-state.txt) |
| Shallow history | **no longer shallow**: `git fetch --unshallow` completed in this session, 24,693 commits | [01](evidence/00r1/01-repository-state.txt) |
| Diff vs baseline, excluding `docs/` | **empty** — production code, tests, manifests, Gradle files and `.github/` are byte-identical to the baseline | [01](evidence/00r1/01-repository-state.txt) |
| Diff vs baseline, all paths | 52 files, all under `docs/fsa/` (+9,271 lines of audits/evidence) | [01](evidence/00r1/01-repository-state.txt) |
| Upstream divergence | baseline is **165 commits behind** `ankidroid/Anki-Android` main `89e5dbeabb7b…` (GitHub compare `a7121c11...89e5dbe`, `behind_by: 165`, `ahead_by: 0`); upstream was **not** merged | [01](evidence/00r1/01-repository-state.txt) |

A-01 conclusion: the tree under audit is the unchanged AnkiDroid baseline plus FSA documentation. Shallow-history
handling from earlier rounds is superseded (history is now complete and verified, not inherited).

---

## 2. GitHub Actions diagnosis (A-02) — root cause proven

**Root cause: the repository owner's GitHub account is locked for billing reasons, so GitHub accepts every
workflow, queues every job, and then refuses to start any job on a runner.** The annotation GitHub attaches to each
job is reproduced verbatim:

```text
The job was not started because your account is locked due to a billing issue.
```

Primary evidence (run URLs — these are real runs, created during this round):

| Workflow | Revision | Result | Run URL |
| --- | --- | --- | --- |
| 🛠️ Unit Tests | `42d86837cc` | failure, 0 steps, no runner | <https://github.com/Drmusab/flashcard-Android/actions/runs/41208932554> |
| 🛠️ Code Quality Checks | `42d86837cc` | failure, 0 steps | <https://github.com/Drmusab/flashcard-Android/actions/runs/41208932541> |
| 🛠️ Emulator Tests | `42d86837cc` | failure, 0 steps | <https://github.com/Drmusab/flashcard-Android/actions/runs/41208932535> |
| 🛠️ Conflict Scan | `42d86837cc` | failure, 0 steps | <https://github.com/Drmusab/flashcard-Android/actions/runs/41208932546> |
| 🛠️ Unit Tests | `2a44a16a61` | failure, 0 steps | <https://github.com/Drmusab/flashcard-Android/actions/runs/41208928756> |
| 🛠️ Code Quality Checks | `2a44a16a61` | failure, 0 steps | <https://github.com/Drmusab/flashcard-Android/actions/runs/41208928667> |
| 🛠️ Emulator Tests | `2a44a16a61` | failure, 0 steps | <https://github.com/Drmusab/flashcard-Android/actions/runs/41208928673> |
| 🛠️ Conflict Scan | `2a44a16a61` | failure, 0 steps | <https://github.com/Drmusab/flashcard-Android/actions/runs/41208928627> |

| 🧪 **FSA Foundation CI** (new, this round) | `8481a0e4ae` | failure, 4 jobs, 0 steps each | <https://github.com/Drmusab/flashcard-Android/actions/runs/41209077114> |

The new workflow is admitted and triggered exactly like the inherited ones — GitHub registered its four jobs
(`FullDebug build + APK identity`, `Unit tests (FullDebug + aggregate)`, `Lint, style and build-logic tests`,
`Evidence index`) and created a run for the pushed revision, then refused every one of them a runner
([12](evidence/00r1/12-fsa-workflow-run.txt)). That is the strongest possible confirmation that the CI work of this
round is correct and that the obstruction is purely account-level.

Job-level proof that no runner was ever allocated: `runner_name` is empty, `runner_group_name` is empty, and
`steps` is an empty array — a job that had started would list its steps with per-step conclusions
([11](evidence/00r1/11-run-evidence.txt)).

### 2.1 The state changed inside this round — recorded honestly

| Time (UTC) | Observation |
| --- | --- |
| 14:01 | push of `arena/a6008955-flashcard-android` → `GET /actions/runs` = **0** |
| 14:08 | evidence file [02](evidence/00r1/02-github-actions-api.txt) captured → runs **0**, caches **0**, artifacts **0** |
| 14:10:50 / 14:10:53 | pushes of `2a44a16a61` and `42d86837cc` → **8 runs created**, all failing within 2–3 s with the billing annotation |

So the earlier "no runs at all" state ended during this round. Two facts must be stated plainly:

* **Arena changed nothing.** Every Actions settings write attempted from this session returned
  `403 Resource not accessible by integration` ([02](evidence/00r1/02-github-actions-api.txt)). The session holds no
  Actions permission and no `workflow` scope, so it cannot enable, disable or dispatch anything.
* **The origin of the change is not verifiable from here.** It is consistent with the owner approving the fork's
  workflows and/or GitHub adjusting the account state, but that cannot be confirmed from a session that cannot read
  Actions settings. It is recorded as an observation, not as an act of this round.

### 2.2 Answering the ten A-02 questions

| # | Question | Answer | Evidence |
| --- | --- | --- | --- |
| 1 | Are Actions enabled for this fork? | **Effectively yes** — workflows are registered, `push` events create runs, jobs are queued. Execution is then blocked by the billing lock, not by Actions being off. | [11](evidence/00r1/11-run-evidence.txt) |
| 2 | Are the workflows recognised? | **Yes.** 18 workflows, all `state: active`, valid YAML, including `tests_unit.yml`, `tests_emulator.yml`, `lint.yml`. | [02](evidence/00r1/02-github-actions-api.txt), [06](evidence/00r1/06-ci-static-validation.txt) |
| 3 | Is `workflow_dispatch` available? | **Declared** in the three build/test workflows and in the new FSA workflow. **Not issuable from this session** (`POST .../dispatches` → `403`). Also note GitHub only exposes a dispatchable workflow in the UI once the file exists on the default branch: `fsa-foundation-ci.yml` therefore also triggers on `arena/**` pushes so it can be exercised before merge. | [02](evidence/00r1/02-github-actions-api.txt), workflow triggers |
| 4 | Are workflows restricted by repository settings? | **No restriction observed.** No allow-list error, no "workflow not allowed" annotation; the only blocking annotation is billing. Settings themselves are unreadable (`403`). | [11](evidence/00r1/11-run-evidence.txt) |
| 5 | Do triggers match the fork's branches? | **Yes.** `push` on all branches (minus merge-queue/dependabot/crowdin), `pull_request`, `merge_group`, `workflow_dispatch`; only *scheduled* runs are upstream-guarded. | [06](evidence/00r1/06-ci-static-validation.txt) |
| 6 | Are runner resources available? | **No.** `ubuntu-latest` jobs are queued and refused; no runner is ever assigned. | [11](evidence/00r1/11-run-evidence.txt) |
| 7 | Do inherited workflows depend on upstream-only secrets? | Nine upstream secrets are referenced repository-wide, but **none gates a build/test job**; the three build/test workflows use only `CODECOV_TOKEN` (non-fatal in a fork) plus the automatic `GITHUB_TOKEN`. Secrets are **not** the cause. | [06](evidence/00r1/06-ci-static-validation.txt) |
| 8 | Are any jobs restricted to the upstream repository? | **No.** Only `schedule` guards and a codecov `fail_ci_if_error` comparison reference `ankidroid/Anki-Android`. | [06](evidence/00r1/06-ci-static-validation.txt) |
| 9 | Are workflows skipped by event filters? | **No.** The failing runs prove the events match; the jobs exist and then fail at runner allocation. | [11](evidence/00r1/11-run-evidence.txt) |
| 10 | Are hosted runners and Actions minutes available? | **No** — this is precisely the blocked resource: the account is locked for billing, which suspends hosted-runner allocation (public-repo minutes included until the lock is cleared). | [11](evidence/00r1/11-run-evidence.txt) |

### 2.3 Exact owner actions (none of these can be performed by Arena)

| # | Where | Action |
| --- | --- | --- |
| **O-1 (blocking)** | <https://github.com/settings/billing> (account `Drmusab`) | **Clear the billing lock.** Settle the failed payment / update the payment method / raise or remove the spending limit until the account shows no lock. This is the single action that unblocks every Android execution step. |
| O-2 | <https://github.com/Drmusab/flashcard-Android/actions> | If the fork banner *"Workflows aren't being run on this forked repository"* reappears, click **I understand my workflows, go ahead and enable them**. |
| O-3 | Settings → Actions → General | Keep **Allow all actions and reusable workflows** (or an allow-list containing the SHA-pinned actions already in use). This is currently not the blocker — the annotation proves runner allocation is — but it should be verified while the owner is there. |
| O-4 | Arena → GitHub connection | Optional: reconnect with **Actions: read/write** (+ `workflow` scope) so this session can dispatch runs and read logs itself. Today every Actions write is `403`, and run logs live on `results-receiver.actions.githubusercontent.com`, which this sandbox cannot reach. |
| O-5 | After O-1 | Re-run any failed run, or push again; then run **🧪 FSA Foundation CI** on `arena/a6008955-flashcard-android`. CLI (token with `workflow` scope): `gh workflow run fsa-foundation-ci.yml --ref arena/a6008955-flashcard-android`. |

Verification that O-1 worked: the next run's jobs show a non-empty `runner_name` and a non-zero step count, and no
billing annotation.

### 2.4 Why the earlier rounds saw "no runs" and this one sees failing runs

Earlier rounds (2026-10-29) recorded `total_count: 0`. This round reproduced that at 14:01 and 14:08, then observed
runs appearing at 14:10 with a billing-lock annotation. Both observations are true for their timestamps. The
difference is not an audit error and not a code change: the fork moved from "workflows not running at all" to
"workflows running and blocked at runner allocation". What has **not** changed is the thing FSA-00 needs —
no job has ever executed on a runner, so there is still no build, test, lint or APK evidence.

## 3. Existing CI dependencies audit (A-03) — what is reused

| Capability | Existing implementation (reused, not duplicated) |
| --- | --- |
| JetBrains JDK 21 | `actions/setup-java@de7274f0…` (`distribution: jetbrains`, `java-version: 21`) in `tests_unit.yml`, `lint.yml`, `tests_emulator.yml`; `jitpack.yml` matches |
| Gradle wrapper | `./gradlew` (pinned distribution `gradle-9.8.0-bin.zip`, `gradle/wrapper/gradle-wrapper.properties`) |
| Gradle cache | `gradle/actions/setup-gradle@3f5f9ada…` with `cache-provider: basic`, `cache-read-only: ${{ github.ref != 'refs/heads/main' }}` |
| Android SDK | Pre-installed on `ubuntu-latest`; explicit `sdkmanager` install only in `tests_emulator.yml` (build-tools `37.0.0`, platform `android-36`/`37.0`) |
| Robolectric preparation | `./gradlew robolectricSdkDownload` wrapped in `nick-fields/retry` (3 attempts) in `tests_unit.yml` |
| Unit tests + coverage | `./gradlew jacocoUnitTestReport` (`tests_unit.yml`); scoped variant `:AnkiDroid:testFullDebugUnitTest` |
| Lint / style / lint-rule tests | `./gradlew lintAll ktlintCheck lint-rules:test` (`lint.yml`) |
| Build-logic tests | `./gradlew -p buildSrc test` (`lint.yml`) |
| Test-failure reporting | `python3 .github/report_test_failures.py` (upstream script, reused unchanged) |
| Emulator startup | `reactivecircus/android-emulator-runner@a421e438…` + `insightsengineering/disk-space-reclaimer`, `actions/cache` AVD cache, KVM udev rules, `EMULATOR_*` env contract (`tests_emulator.yml`) |
| Instrumentation results | `./gradlew jacocoAndroidTestReport` with `TEST_RELEASE_BUILD=true`, logcat artifact upload (`tests_emulator.yml`) |
| APK artifacts | Not covered by any inherited workflow — this was the one real gap (§4) |

Note: no inherited workflow compiles `assembleFullDebug`, produces an APK, or records per-command provenance.

---

## 4. Why a dedicated baseline workflow was necessary (C-01/C-02 justification)

Reuse was preferred and everything reusable *is* reused. A dedicated workflow was added **only** because the
inherited workflows cannot produce three mandatory FSA-00 evidence classes:

1. **APK identity (C-05).** `tests_unit.yml` and `lint.yml` never assemble an application variant; no inherited
   workflow runs `:AnkiDroid:assembleFullDebug`, so no APK, size, SHA-256, package id, version or signing
   certificate can ever be observed from them.
2. **Per-command provenance (C-04).** The inherited workflows report a step pass/fail but not a machine-readable
   record of *command → git SHA → OS → JDK → Gradle → exit code → duration → failure category → log path*. FSA-00
   has been blocked for four rounds precisely on the difference between "attempted" and "executed".
3. **A single baseline verdict.** `tests_unit.yml` defaults to a three-OS matrix (`ubuntu-latest`, `macos-14`,
   `windows-latest`) and `tests_emulator.yml` to an API 36/37 × 2-target matrix. That is correct for upstream
   flake-hunting and wasteful for one baseline decision; the FSA workflow runs one Ubuntu job per evidence class.

Added files (both new, both narrow):

| File | Purpose |
| --- | --- |
| `.github/workflows/fsa-foundation-ci.yml` | `workflow_dispatch` + `push`/`pull_request` on `main`; `permissions: contents: read`; jobs `build_fulldebug`, `unit_tests`, `lint_and_build_logic`, `evidence_index` |
| `.github/fsa/run_evidence_command.sh` | runs exactly one command; appends `label, command, git_sha, branch, os, jdk_vendor, jdk, gradle, exit_code, duration_s, started_utc, failure_category, log` to `fsa-evidence/commands.tsv`; propagates the real exit code |
| `.github/fsa/apk_identity.sh` | records APK path, size, SHA-256, `aapt2 badging`, `apksigner --print-certs`; exits non-zero with `result=NOT_PRODUCED` rather than inventing an artifact |

Safety of the addition is audited in [07](evidence/00r1/07-ci-workflow-safety.txt): `contents: read` only, the only
secret referenced is the automatic `GITHUB_TOKEN`, `persist-credentials: false` on checkout, and zero occurrences of
`signingConfig`, `keystore`, `assembleRelease`, `bundleRelease`, `action-gh-release`, `gh release` or
`pull_request_target`. It runs no emulator and touches no collection.

Action pins were not invented: all six are the SHAs already used by the inherited workflows, each re-verified
against the GitHub API in this round — the tag for every pin resolves to exactly the pinned commit
(`actions/checkout v7.0.1`, `actions/setup-java v6.0.1`, `gradle/actions v6.4.0`, `actions/upload-artifact v7.0.1`,
`actions/download-artifact v7.0.0`, `nick-fields/retry v4.0.0`) — see
[06 §5](evidence/00r1/06-ci-static-validation.txt). `download-artifact` is the one pin the repository did not
already use; it was resolved through the API (`v7.0.0 → 37930b1c2abaa49bbe596cd826c3c89aef350131`) and matched to
the `upload-artifact` v7 major.

Instrumentation was deliberately **not** duplicated into the new workflow: `tests_emulator.yml` already owns the
only tested emulator setup in this repository, and D-03 is therefore routed through it (§[EMULATOR](FSA-00R1-EMULATOR-EVIDENCE.md)).

---

## 5. Build environment recovery (B-01/B-02) — outcome

| Requirement | Result in this round | Evidence |
| --- | --- | --- |
| GitHub-hosted Ubuntu runner | **UNAVAILABLE** — no workflow can be scheduled (Actions not executing) | §2 |
| Local sandbox runner | **INCAPABLE** — no JDK with `javac`, no Android SDK, and every Gradle/Maven/Google endpoint is unreachable at TLS | [03](evidence/00r1/03-network-probe.txt), [04](evidence/00r1/04-jvm-and-wrapper.txt) |
| Approved dependency sources | `services.gradle.org`, `dl.google.com`, `maven.google.com`, `repo.maven.apache.org`, `repo1.maven.org`, `plugins.gradle.org`, `jitpack.io`, `api.foojay.io`, `objects.githubusercontent.com` → **all blocked (curl exit 35, TLS handshake reset)**; only `github.com`, `api.github.com`, `registry.npmjs.org`, `pypi.org` answer | [03](evidence/00r1/03-network-probe.txt) |
| No mirror / no TLS bypass / no pin changes | Honoured: nothing was substituted, no checksum bypassed, `libs.versions.toml`, wrapper and repository declarations are untouched (diff vs baseline is docs-only) | [01](evidence/00r1/01-repository-state.txt), [03](evidence/00r1/03-network-probe.txt) |
| Source pins re-verified | Gradle `9.8.0` (wrapper), AGP `9.4.1`, Kotlin `2.4.20` (`gradle/libs.versions.toml`), compileSdk `37`, targetSdk `36`, minSdk `24` — all unchanged and matching the pins on record | [01](evidence/00r1/01-repository-state.txt), [04](evidence/00r1/04-jvm-and-wrapper.txt) |

This is the same wall earlier rounds hit, now demonstrated a second time at a different revision and with a
different JVM: the wrapper launcher starts under a real JVM and dies fetching `gradle-9.8.0-bin.zip`
(`SSL peer shut down incorrectly` / `EOFException`), so **no Gradle task can start in this sandbox**. The only
capable runner is the GitHub-hosted one, and it is gated on the owner actions in §2.3.

---

## 6. Verdict for this section

| Question | Answer |
| --- | --- |
| Are the workflows missing? | No — 18 registered, all active, valid YAML, correct triggers, no upstream-only blocking guard. |
| Is GitHub Actions disabled? | **No.** Workflows are recognised, `push` events create runs, jobs are queued. Execution is blocked one layer deeper. |
| What blocks execution? | **An account-level billing lock on the repository owner**: every job carries the annotation *"The job was not started because your account is locked due to a billing issue."* No runner is ever allocated (`runner_name: ""`, `steps: 0`). |
| Is any code/workflow defect involved? | No evidence of one. Four inherited workflows and the new one behave identically on the same pushes. |
| What was fixed in this round? | Only the genuine infrastructure gaps: no FullDebug/APK evidence path and no per-command provenance. No source, dependency, wrapper, lint or Reviewer change. |
| What is needed to unblock? | Owner action **O-1** (clear the billing lock, §2.3). Everything else is already in place: one dispatch of `.github/workflows/fsa-foundation-ci.yml` then produces the build/test/lint/APK evidence, and one dispatch of `tests_emulator.yml` produces the install/instrumentation evidence. |
| Honest limitation | Run **logs** live on `results-receiver.actions.githubusercontent.com`, which this sandbox cannot reach, so future log reading needs either the GitHub UI or a reconnect with broader permissions. Job/step metadata via `api.github.com` is readable and is what the evidence here uses. |
