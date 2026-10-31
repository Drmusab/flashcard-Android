# FSA-00R2 — Entry conditions: GitHub Actions runner availability

**Evaluated:** 2026-10-31 UTC · **Target workflow:** `.github/workflows/fsa-foundation-ci.yml`
**Baseline revision under test:** `26de08130112e7fbc244839ca80f518742588696` (`main`)
**Result: entry conditions verified; runner allocation still refused. The billing lock persisted on a fresh
run at 15:50:24Z, so FSA-00R2 resolved to BLOCKED — see [the FSA-00R2 report](FSA-00R2-REPORT.md).** No source,
dependency, toolchain or workflow definition was changed to produce this document.

---

## 1. Workflow registration — VERIFIED

`gh api repos/Drmusab/flashcard-Android/actions/workflows/402787991`
([evidence 01](evidence/00r2/01-github-entry-probes.txt)):

| Field | Value |
| --- | --- |
| id | `402787991` |
| name | `🧪 FSA Foundation CI` |
| path | `.github/workflows/fsa-foundation-ci.yml` |
| state | `active` |
| created | 2026-10-31T14:12:48Z |
| updated | 2026-10-31T15:20:51Z |

`gh workflow list --all` reports it plus the 18 inherited workflows, all `active`. The workflow file is
registered and dispatchable in principle; it is not disabled.

## 2. Billing restriction — STILL PRESENT AT 15:40Z, STATUS NOT ASSUMED

Run `41215932263` (push, `main`, HEAD `26de0813…`) completed `failure` in **5 seconds**:

| Job | Conclusion | Runner allocated | Steps executed |
| --- | --- | --- | --- |
| FullDebug build + APK identity | failure | *none* (`runner_name` empty) | 0 |
| Unit tests (FullDebug + aggregate) | failure | *none* | 0 |
| Lint, style and build-logic tests | failure | *none* | 0 |
| Evidence index | failure | *none* | 0 |

Every job carries the same check-run annotation
([evidence 02](evidence/00r2/02-run-annotations.txt)):

> `The job was not started because your account is locked due to a billing issue.`

The four other workflows dispatched at 15:40:00Z (`Unit Tests`, `Emulator Tests`, `Code Quality Checks`,
`CodeQL Advanced`) show the identical signature — failure in 2–5 s, empty `runner_name`, zero steps — so the
restriction was account-wide, not workflow-specific. **No step of the Foundation workflow has ever executed.**

## 3. Trigger-path constraint

| Path | Result |
| --- | --- |
| `workflow_dispatch` (`gh workflow run`) | **HTTP 403** — `Resource not accessible by integration` (integration token lacks `actions:write`) |
| push to `arena/**` | permitted and used (the workflow file documents this as the pre-merge exercise path) |
| pull_request to `main` | permitted, but a PR is not required for baseline evidence |

Runners therefore cannot be tested by dispatch from this session; a branch push is the only available
trigger and is what the workflow was written to support.

## 4. Local/authorized-host alternative — NOT AVAILABLE

The Arena sandbox cannot run any Gradle task
([capability probe](evidence/00r2/00-sandbox-capability.txt)):

* `java` absent, `JAVA_HOME` unset, no `/usr/lib/jvm` — no JDK at all, so the pinned JetBrains 21 daemon JVM cannot be provisioned;
* `ANDROID_HOME` / `ANDROID_SDK_ROOT` unset, no SDK tree, no `local.properties` — compileSdk 37 unavailable;
* egress: `services.gradle.org`, `repo1.maven.org`, `dl.google.com`, `plugins.gradle.org`, `jitpack.io` all
  fail at TLS (`exit=35`, `SSL_ERROR_SYSCALL`); only `api.github.com` responds (`200`).

Because the Gradle distribution, AGP 9.4.1 and the Android SDK cannot be fetched, no local build, unit test,
lint, build-logic test or APK identity is producible here. No mirror, repackaged JDK/SDK, version downgrade or
checksum bypass was attempted. The same conclusion was recorded in FSA-00C R4/§3 and FSA-00R1; it is
re-confirmed here rather than inherited.

**Consequence:** GitHub-hosted runners are the only authorized Android build host for this stage. If they stay
locked, every build/test/APK criterion stays `BLOCKED` and no substitute evidence may be substituted.

## 5. Outcome (resolved)

The allocation test ran at 15:50:24Z on `0d815865…` and reproduced the lock exactly: 4/4 jobs failed in 5 s with
`The job was not started because your account is locked due to a billing issue.`, 0 runners, 0 steps
([06](evidence/00r2/06-run-41216750669.txt)). Full scan of all 75 repository runs: 0 allocations, 0 steps,
0 successes ([04](evidence/00r2/04-run-history-audit.txt)). Verdict: [FSA-00R2 report](FSA-00R2-REPORT.md).

## 6. What this document does not claim

No build, test, lint, build-logic, APK, emulator or collection-isolation result is claimed here. Those fields
remain `BLOCKED` until a runner allocates and executes steps at a recorded SHA.
