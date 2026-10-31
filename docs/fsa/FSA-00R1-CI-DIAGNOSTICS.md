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

## 2. GitHub Actions diagnosis (A-02) — the central finding of this round

### 2.1 What is observable

| # | Question | Observed answer | Evidence |
| --- | --- | --- | --- |
| 1 | Are workflows recognised by GitHub? | **Yes.** 18 workflows registered, every one `state: active`, including `tests_unit.yml`, `tests_emulator.yml`, `lint.yml` | [02](evidence/00r1/02-github-actions-api.txt) |
| 2 | Has any workflow ever run? | **No.** `GET /actions/runs` → `total_count: 0`; `check-runs` on `main` → `0`; `actions/cache/usage` → `0` entries, `0` bytes | [02](evidence/00r1/02-github-actions-api.txt) |
| 3 | Do triggers match this fork's branches? | **Yes.** `tests_unit.yml`, `tests_emulator.yml`, `lint.yml` trigger on `push` (all branches), `pull_request`, `merge_group`, `workflow_dispatch`, `schedule`; the only fork guard restricts *scheduled* runs to the upstream repository, which is correct and does not block push/PR/manual runs | [06](evidence/00r1/06-ci-static-validation.txt) |
| 4 | Wanted events — did they happen? | **Yes.** `PushEvent` 2026-10-28T11:07Z and 2026-10-28T18:42Z; merge of PR #6 into `main` 2026-10-31T12:54Z; FSA-00R1 branch creation/push 2026-10-31T14:01Z. All should have produced `push` runs. **None did.** | [02](evidence/00r1/02-github-actions-api.txt) |
| 5 | Are jobs restricted to the upstream repository? | **No.** The only repository comparisons are (a) `schedule && github.repository == 'ankidroid/Anki-Android'` guards and (b) `fail_ci_if_error: ${{ github.repository == 'ankidroid/Anki-Android' }}` on the codecov upload. Neither prevents a fork run. | [06](evidence/00r1/06-ci-static-validation.txt) |
| 6 | Do inherited workflows depend on upstream-only secrets? | Nine upstream secrets are referenced repository-wide (`KEYSTORE*`, `GOOGLE_PUBLISH_CREDENTIALS`, `CROWDIN_APIv2_PAT`, `SSH_PRIVATE_KEY`, `RELEASES_PUBLISH_TOKEN`, `MACHINE_ACCOUNT_PAT`, `AMAZON_PUBLISH_CREDENTIALS`, `CODACY_TOKEN`, `CODECOV_TOKEN`) — **but none of them gates the build/test jobs**. The three build/test workflows reference only `CODECOV_TOKEN` (upload step, non-fatal in a fork) plus the automatic `GITHUB_TOKEN`. Missing secrets are **not** the cause. | [06](evidence/00r1/06-ci-static-validation.txt) |
| 7 | Is `workflow_dispatch` usable? | The trigger is declared in all three build/test workflows, **but dispatch cannot be issued from here**: `POST /actions/workflows/{id}/dispatches` → `403 Resource not accessible by integration` for both `tests_unit.yml` and `lint.yml` | [02](evidence/00r1/02-github-actions-api.txt) |
| 8 | Are Actions settings readable/changed? | **No.** `GET /actions/permissions`, `/actions/permissions/workflow`, `/actions/permissions/selected-actions`, `/actions/runners` → `403`; `PUT /actions/permissions` (`enabled=true`) → `403`; `PUT /actions/workflows/{id}/enable` → `403`. The integration token carries **no** `x-oauth-scopes` and no Actions permission. Nothing was changed. | [02](evidence/00r1/02-github-actions-api.txt) |
| 9 | Are hosted runners / minutes available? | **Not determinable from here.** No run has ever been scheduled, so no runner allocation or minutes consumption has been recorded (0 caches, 0 artifacts). | [02](evidence/00r1/02-github-actions-api.txt) |

### 2.2 What the evidence does and does not prove

**Proved:** GitHub Actions is not executing on `Drmusab/flashcard-Android`. The workflows are present, valid,
active and correctly triggered, the triggering events occurred, and yet zero runs have ever been created —
including after a fresh push performed *during this round*.

**Not proved:** *why*. Three explanations remain, and all three are owner-side account/repository settings that
this integration cannot read or write:

1. **Fork Actions not enabled.** GitHub registers the workflows of a newly forked repository but does not run them
   until the fork owner approves them ("Workflows aren't being run on this forked repository" → *I understand my
   workflows, go ahead and enable them*). This is the default state for a fork created 2026-10-23 and is the
   single most probable cause.
2. **Repository Actions policy disabled** (Settings → Actions → General → *Disable actions*, or an
   allow-list that excludes the pinned third-party actions such as `nick-fields/retry`,
   `gradle/actions/setup-gradle`, `reactivecircus/android-emulator-runner`).
3. **Account-level Actions block** (billing/spending-limit state, or an organisation policy if the repository is
   later moved into an organisation).

> **Live control experiment, same round.** While this report was being written, the round's own commit
> `2a44a16a61` was pushed to `arena/a6008955-flashcard-android` (2026-10-31). A commit push creates a `push` event on
> a branch the inherited workflows and the new workflow all listen to. Immediately afterwards
> `GET /actions/runs` still returned `total_count: 0`. The absence of runs is therefore reproducible on demand, at
> the exact revision this report describes, and is not an artefact of a stale query or an old default branch.

We explicitly do **not** claim the owner changed anything, and we explicitly do **not** claim that
"no runs" proves Actions is disabled — it proves Actions is not running, and the cause must be read off the
web UI by someone who can see the owner's settings.

### 2.3 Exact owner actions (nothing here can be done by Arena)

| # | Where | Action |
| --- | --- | --- |
| O-1 | <https://github.com/Drmusab/flashcard-Android/actions> | If the banner *"Workflows aren't being run on this forked repository"* is present, click **I understand my workflows, go ahead and enable them**. Screenshot the resulting state. |
| O-2 | Settings → Actions → General | Set **Actions permissions** to *Allow all actions and reusable workflows* (or an allow-list containing the SHA-pinned actions already used by the inherited workflows). Confirm **Disable actions** is not selected. |
| O-3 | Settings → Billing / Actions usage | Confirm hosted-runner minutes are not blocked (public repositories use free standard runners; a payment or spending-limit failure still blocks job scheduling). |
| O-4 | Arena → GitHub connection | If Actions should be dispatchable from this session, reconnect the GitHub app with **Actions: read and write** (plus `workflow` scope on a classic token). Today every Actions write is `403`, so the session cannot even start a run. No credential should ever be pasted into chat. |
| O-5 | After O-1…O-4 | Run the baseline workflow: Actions → **🧪 FSA Foundation CI** → *Run workflow* on branch `arena/a6008955-flashcard-android`. CLI equivalent for a token with `workflow` scope: `gh workflow run fsa-foundation-ci.yml --ref arena/a6008955-flashcard-android`. |

Once Actions executes, the evidence FSA-00 is missing is produced automatically by the workflow added in this
round (§3) plus the inherited `tests_unit.yml`, `lint.yml` and `tests_emulator.yml` — no further code change is
required.

---

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
| Are the workflows missing? | No — 18 registered, all active, all valid YAML, correct triggers, no upstream-only blocking guard. |
| Is GitHub Actions disabled? | Unproven, but Actions is **not executing**. The three candidate causes are all owner-side settings this integration cannot read (`403`) or change (`403`). |
| Is a code defect blocking CI? | No evidence of one. Nothing in the workflows explains zero runs; the triggering events happened. |
| What was fixed in this round? | Only the genuine infrastructure gaps: no FullDebug/APK evidence path and no per-command provenance. No source, dependency, wrapper, lint or Reviewer change. |
| What is still needed? | Owner actions O-1…O-5 (§2.3), then one dispatch produces FSA-00's build/test/lint/APK evidence. Emulator evidence then follows from `tests_emulator.yml`. |
