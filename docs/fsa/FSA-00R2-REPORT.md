# FSA-00R2 — GitHub Actions recovery, Android build and foundation gate closure

**Repository:** `Drmusab/flashcard-Android`
**Date:** 2026-10-31 UTC · **Stage:** FSA-00 Foundation Recovery · **Authority:** FSA-00R2 only

```
FSA-00R2 STATUS: BLOCKED
ROOT CAUSE: ACCOUNT BILLING RESTRICTION
OWNER ACTION REQUIRED: RESOLVE GITHUB BILLING LOCK
ANDROID BUILD: NOT EXECUTED
FSA-00 LOCK: NOT AUTHORIZED
```

No application source, dependency version, toolchain pin, Gradle configuration, workflow definition or
branch target was changed by this round. The only commits on this branch are documentation and evidence
(§9). Nothing was bypassed, mocked, downgraded or substituted.

---

## 1. Contract block

```
REPOSITORY:
Drmusab/flashcard-Android

CHECKED HEAD:
0d8158658c6a2d766e069a01c7a5b1b7cb9a14bc   (entry commit; docs-only delta vs origin/main)

FOUNDATION CI RUN URL:
https://github.com/Drmusab/flashcard-Android/actions/runs/41216750669

RUNNER ALLOCATED:
NO

GRADLE:
BLOCKED

JDK:
BLOCKED

ANDROID SDK:
BLOCKED

FULLDEBUG BUILD:
BLOCKED

UNIT TESTS:
BLOCKED

LINT:
BLOCKED

BUILD LOGIC:
BLOCKED

APK IDENTITY:
NOT PRODUCED

EMULATOR:
BLOCKED

REVIEWER SMOKE TESTS:
BLOCKED

COLLECTION ISOLATION:
BLOCKED

FSA-00A PROVENANCE:
BLOCKED

FSA-00 FINAL LOCK:
BLOCKED
```

`GRADLE`, `JDK`, `ANDROID SDK` are recorded as `BLOCKED`, not `FAIL`: no Gradle process, no JDK
provisioning step and no SDK installation step ever started on a runner, so no execution result exists for
them (mission §4: `BILLING_OR_RUNNER_ERROR`, not a build failure).

---

## 2. Entry conditions (§2) — what was verified and what was not

| Entry condition | Result | Evidence |
| --- | --- | --- |
| Workflow is registered | **YES** — id `402787991`, path `.github/workflows/fsa-foundation-ci.yml`, state `active`, created 14:12:48Z, updated 15:20:51Z | [01](evidence/00r2/01-github-entry-probes.txt) |
| Account billing restriction resolved | **NO** — restriction reproduced from this session | [02](evidence/00r2/02-run-annotations.txt), [06](evidence/00r2/06-run-41216750669.txt) |
| A runner is allocated | **NO** — `runner_name` empty/null for every job; no self-hosted runner exists (inventory call `403`) | [03](evidence/00r2/03-billing-and-runner-probes.txt), [04](evidence/00r2/04-run-history-audit.txt) |
| The job has actually executed steps | **NO** — `steps` array length 0 on every job of every run in the repository's history | [04](evidence/00r2/04-run-history-audit.txt) |
| Checked-out Git SHA matches intended revision | **NOT OBSERVABLE** — the `Checkout` step never ran, therefore no checkout exists to compare. The run is *bound* to `0d815865…` (`head_sha`), which is not the same thing | [06](evidence/00r2/06-run-41216750669.txt) |

### 2.1 Fresh, self-triggered run at the intended SHA

`workflow_dispatch` is not permitted to this session's integration (`HTTP 403: Resource not accessible by
integration` on `…/actions/workflows/402787991/dispatches` — [01](evidence/00r2/01-github-entry-probes.txt)).
The workflow file itself documents the branch-push path as the pre-merge exercise route, and `arena/**` is an
explicit trigger, so exactly **one** push was made at `0d815865…`. Result
([run 41216750669](https://github.com/Drmusab/flashcard-Android/actions/runs/41216750669)):

| Field | Value |
| --- | --- |
| Trigger | `push`, branch `arena/f9ac2ddf-flashcard-android` |
| `head_sha` | `0d8158658c6a2d766e069a01c7a5b1b7cb9a14bc` |
| Created → completed | 15:50:24Z → 15:50:29Z (**5 s**) |
| Conclusion | `failure` |

| Job | Runner | Steps executed | Conclusion | Annotation |
| --- | --- | --- | --- | --- |
| FullDebug build + APK identity | *none* | 0 | failure | `The job was not started because your account is locked due to a billing issue.` |
| Unit tests (FullDebug + aggregate) | *none* | 0 | failure | same |
| Lint, style and build-logic tests | *none* | 0 | failure | same |
| Evidence index | *none* | 0 | failure | same |

The same annotation is attached to run `41215932263` (`main`, `26de0813…`) — the run named in the mission
briefing — and to all 75 runs in the repository (verbatim in
[02](evidence/00r2/02-run-annotations.txt)).

### 2.2 Account-wide, not workflow-specific

A full scan of **all 75** workflow runs recorded for the repository (every workflow, 14:10Z→15:51Z) shows
**0 runs with any allocated runner, 0 runs with any executed step, and 0 runs ever concluded `success`**
([04](evidence/00r2/04-run-history-audit.txt)):

```
total_runs_reported=75
runs_listed=75
runs_with_any_runner=0
runs_with_any_steps=0
runs_with_conclusion_success=0
```

Note on method: GitHub reports *skipped* jobs with the literal string `"null"` as `runner_name`. Those were
excluded; a naive non-empty test would have produced false "allocated" counts (it did on a first pass, and the
correction is why this audit counts only real allocations and executed steps).

The restriction is therefore an account-level entitlement/lock condition, not a defect in
`fsa-foundation-ci.yml`. There is nothing in this repository to fix.

### 2.3 Trigger and settings APIs are not available to this session

`repos/…/actions/permissions`, `repos/…/actions/permissions/workflow`, `repos/…/actions/runners` and
`users/Drmusab/settings/billing/actions` all return `403 Resource not accessible by integration`
([03](evidence/00r2/03-billing-and-runner-probes.txt)). This session can read run/job state and push commits;
it cannot read or change billing, runner inventory or Actions permissions.

### 2.4 Authorized alternative Android host (§2, second paragraph)

**None exists.** The Arena sandbox is not an authorized Android development host and cannot become one:

* `java` absent, `JAVA_HOME` unset, `/usr/lib/jvm` does not exist — no JDK, so the pinned JetBrains 21 daemon
  JVM cannot even be installed;
* `ANDROID_HOME`/`ANDROID_SDK_ROOT` unset, no SDK tree, no `local.properties` — compileSdk 37 unavailable;
* egress blocked at TLS (`exit=35`, `SSL_ERROR_SYSCALL`) for `services.gradle.org`, `repo1.maven.org`,
  `dl.google.com`, `plugins.gradle.org`, `jitpack.io`; only `api.github.com` answers (`200`).

([00-sandbox-capability.txt](evidence/00r2/00-sandbox-capability.txt). Same conclusion as FSA-00C R4/§3 and
FSA-00R1, re-measured here, not inherited.) Consequently the seven §3 commands cannot be executed locally and
no substitute evidence may be manufactured for them.

---

## 3. Stages (§3) — independent verification status

Every stage is `BLOCKED` at allocation, before its step could start. The table records the exact task the
workflow would run, so the remaining contract is unambiguous when a runner appears.

| # | Stage | Command / step as defined | Status | Why |
| --- | --- | --- | --- | --- |
| 1 | JetBrains JDK 21 | `actions/setup-java@de7274f0…`, `distribution: jetbrains`, `java-version: "21"` | **BLOCKED** | step never started |
| 2 | Gradle 9.8.0 initialization | `./gradlew --version` (wrapper pin `gradle-9.8.0-bin.zip`) | **BLOCKED** | never started |
| 3 | Android SDK + dependency resolution | Compile stage / AGP provisioning | **BLOCKED** | never started |
| 4 | Robolectric preparation | `./gradlew robolectricSdkDownload` | **BLOCKED** | never started |
| 5 | FullDebug compilation | `./gradlew :AnkiDroid:assembleFullDebug` | **BLOCKED** | never started |
| 6 | FullDebug unit tests | `./gradlew :AnkiDroid:testFullDebugUnitTest` | **BLOCKED** | never started |
| 7 | Aggregate unit tests | `./gradlew jacocoUnitTestReport` | **BLOCKED** | never started |
| 8 | Android lint + ktlint | `./gradlew lintAll ktlintCheck lint-rules:test` | **BLOCKED** | never started |
| 9 | Build-logic tests | `./gradlew -p buildSrc test` | **BLOCKED** | never started |
| 10 | APK artifact + identity | `assembleFullDebug` → `apk_identity.sh` (sha256, aapt2 badging, apksigner) | **BLOCKED** | never started |

Source pins at the checked revision were re-read and are unchanged (they are pins, **not** executed
compatibility — [05](evidence/00r2/05-source-pins.txt)):

| Pin | Value |
| --- | --- |
| Gradle distribution | `9.8.0` (`-bin.zip`, `networkTimeout=10000`, `retries=3`) |
| AGP (`androidGradlePlugin`) | `9.4.1` |
| Kotlin | `2.4.20` |
| compileSdk / targetSdk / minSdk | `37` / `36` / `24` |
| CI JDK | JetBrains `21` (all three jobs) |

---

## 4. Failure classification (§4)

**First meaningful failing step:** runner allocation — zero steps ran.
**Class:** `BILLING_OR_RUNNER_ERROR`. No `JDK_TOOLCHAIN_ERROR`, `GRADLE_DISTRIBUTION_ERROR`,
`DEPENDENCY_RESOLUTION_ERROR`, `ANDROID_SDK_ERROR`, `COMPILATION_ERROR`, `UNIT_TEST_FAILURE`, `LINT_FAILURE`,
`BUILD_LOGIC_FAILURE` or `RESOURCE_ERROR` can be diagnosed, because no compiler, linker, test runner or lint
engine was ever launched. No correction was applied: there is no in-scope infrastructure defect to correct,
and changing source, versions or workflows to chase a green build is prohibited.

Per §2 the instance was not repeatedly re-run. Run inventory: owner run `41215932263` (`main`, `26de0813…`)
and this round's single run `41216750669` (`arena/f9ac2ddf…`, `0d815865…`). No re-run was requested, no extra
push was made to re-test, and no workflow was created or edited.

---

## 5. APK evidence (§5)

**NOT PRODUCED.** `AnkiDroid/build/outputs/apk/full/debug` was never materialised; `apk_identity.sh` never ran;
therefore there is **no** sha256, application ID, version, signing certificate, variant or source-commit
binding to report. No APK was published, attached to a release, or signed for distribution. The repository's
fallback release-signing credentials were not accessed.

---

## 6. Emulator verification (§6)

**BLOCKED** — no APK exists to install, and `tests_emulator.yml` is subject to the same account lock
([run 41216750684](https://github.com/Drmusab/flashcard-Android/actions/runs/41216750684): `matrix_prep`
failed with the billing annotation in 2 s; every matrix leg `skipped`, 0 runners). None of the 14 required
checks — launch, deck picker, disposable deck creation, disposable note/card creation, question display,
answer reveal, Again/Hard/Good/Easy, undo, persistence, lifecycle recreation, navigation — was executed.

Collection isolation is **BLOCKED, not merely unproven**: no collection directory was created, so no path can
be recorded, and the `SetupStorage.kt` shared-storage concern (`PUBLIC` →
`File(getExternalStorageDirectory(), "AnkiDroid")`) remains an open runtime risk. Because collection
ownership cannot be established without a disposable emulator, the abort rule applies: nothing was attempted,
and no production AnkiWeb account was used or contacted.

---

## 7. FSA-00A historical evidence (§7)

**BLOCKED.** The FSA-00A report was **not supplied in this Arena session** — no file, attachment, pasted
content or hash was provided. Per instruction, the report was **not** recreated from memory, and the
historical search was **not** repeated (it is exhausted in FSA-00C R3/R4/R5 §2). The specific blocker is
unchanged and precise:

> **Owner must supply the original FSA-00A artifact to this session (file attachment or verbatim content),
> with its provenance/hash, so it can be hash-verified, preserved verbatim, filed under `docs/fsa/`, and
> reconciled against FSA-00B/C without rewriting history.**

Nothing was reconciled, and no claim in FSA-00B/C was retro-fitted.

---

## 8. Architectural safety (§8)

All invariants hold; this round touched documentation only.

```
AnkiDroid/libanki = Sole Scheduler Authority   → unchanged, no scheduler code touched
PC Anki Adapter = Excluded                     → excluded, nothing added
AnkiConnect Scheduling = Excluded              → excluded, nothing added
Second FSRS = Prohibited                       → none introduced
Second Review Scheduler = Prohibited           → none introduced
Study-Agent Migration = Not Started            → not started
Reviewer Rewrite = Not Authorized              → not attempted
Upstream Merge = Not Authorized                → no merge, no rebase, no upstream fetch
```

No voice-command or AI feature work was performed.

---

## 9. Changes made on this branch

| Commit | Content |
| --- | --- |
| `0d81586` | `docs/fsa/FSA-00R2-ENTRY-STATE.md` + `docs/fsa/evidence/00r2/{00,01,02}` |
| *(this report)* | `docs/fsa/FSA-00R2-REPORT.md` + `docs/fsa/evidence/00r2/{03,04,05,06}` |

`git diff --stat origin/main...HEAD` shows **only** paths under `docs/fsa/`. No workflow, Gradle, manifest,
source, test or dependency file was modified — so the build contract that a runner will execute is byte-identical
to `26de0813…`.

---

## 10. Owner action required — exact and minimal

1. Sign in to GitHub as the repository owner (`Drmusab`).
2. Open **Settings → Billing and plans** (user-level if the repository is user-owned; organization-level if it
   has moved) and clear the outstanding condition that triggers the lock — update the payment method, settle
   the unpaid invoice, or remove the failed-charge hold. Public repositories consume free standard-runner
   minutes, but the lock blocks job dispatch regardless of quota.
3. Confirm the account is no longer locked: the billing page shows no lock/spend-limit banner, and the next
   triggered run allocates a runner.
4. *(Optional, only if dispatch from this session is wanted)* grant the Arena GitHub integration the
   `Actions: write` scope — currently `workflow_dispatch` returns `403`.
5. Nothing else is required from the owner. The workflow needs no edit, and no code change is pending.

**Automatic resumption:** once unlocked, any push to `arena/**` or `main`, or a `workflow_dispatch`, starts all
four jobs (FullDebug build + APK identity, unit tests, lint/build-logic, evidence index) and uploads
`fsa-build-evidence`, `fsa-unit-test-evidence`, `fsa-lint-evidence` and `fsa-consolidated-evidence`. This
report must then be **re-issued at the resulting SHA** — no result below is reusable as a pass.

---

## 11. Gate decision (§10)

**FSA-00 FINAL LOCK: BLOCKED.** Not eligible, not failed.

Mandatory acceptance criteria without evidence at this revision:

* runner allocation and step execution — absent;
* JDK 21 / Gradle 9.8.0 / Android SDK provisioning — absent;
* FullDebug compilation, unit tests, lint, ktlint, build-logic tests — absent;
* APK identity (sha256, applicationId, version, certificate) — not produced;
* emulator smoke tests and collection isolation — not executable without an APK;
* FSA-00A provenance — artifact still not supplied.

**FSA-01A (Migration Discovery) is NOT AUTHORIZED.** No production migration, reviewer rewrite, upstream merge
or study-agent work is started, and none will start automatically from this report.

*End of FSA-00R2.*
