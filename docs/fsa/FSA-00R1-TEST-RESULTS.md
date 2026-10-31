# FSA-00R1 — Test results

**Evaluated revision:** `ca446d8712e3a9b01050c536c26e3869220f0415` · **Date:** 2026-10-31 UTC
**Result: no test was executed. No test is reported as passed, failed or skipped.**

The distinction that matters for this document is the one FSA-00 has been blocked on for four rounds:

| Class | Meaning | This round |
| --- | --- | --- |
| **PLANNED** | command identified, scope understood, harness ready | 8 scopes identified |
| **ATTEMPTED** | process actually started | 7 processes started (all Gradle-wrapper invocations) |
| **EXECUTED** | the test engine actually ran and produced results | **0** |

Evidence: [`05-logs/commands.tsv`](evidence/00r1/05-logs/commands.tsv) and the seven verbatim logs in
[`05-logs/`](evidence/00r1/05-logs/).

---

## 1. Result matrix

| Scope | Command | Class | Exit | Reports produced | Evidence |
| --- | --- | --- | --- | --- | --- |
| Unit tests, `fullDebug` variant | `./gradlew :AnkiDroid:testFullDebugUnitTest` | **ATTEMPTED, NOT EXECUTED** | 1 | none (no XML, no HTML) | [log](evidence/00r1/05-logs/test-full-debug-unit.log) |
| Unit tests, aggregate + coverage | `./gradlew jacocoUnitTestReport` | **ATTEMPTED, NOT EXECUTED** | 1 | none | [log](evidence/00r1/05-logs/jacoco-unit-test-report.log) |
| Build-logic tests (`buildSrc`) | `./gradlew -p buildSrc test` | **ATTEMPTED, NOT EXECUTED** | 1 | none | [log](evidence/00r1/05-logs/buildsrc-test.log) |
| Android lint | `./gradlew lintAll` | **ATTEMPTED, NOT EXECUTED** | 1 | none (`lint-results*` absent) | [log](evidence/00r1/05-logs/lint-all-ktlint-lint-rules-test.log) |
| ktlint formatting | `./gradlew ktlintCheck` | **ATTEMPTED, NOT EXECUTED** (same invocation) | 1 | none | same log |
| Lint-rule tests | `./gradlew lint-rules:test` | **ATTEMPTED, NOT EXECUTED** (same invocation) | 1 | none | same log |
| Robolectric SDK preparation | `./gradlew robolectricSdkDownload` | **ATTEMPTED, NOT EXECUTED** | 1 | none | [log](evidence/00r1/05-logs/robolectric-sdk-download.log) |
| Instrumentation (`jacocoAndroidTestReport` equivalent, `tests_emulator.yml`) | not attempted — no runner, no emulator, no APK | **PLANNED ONLY** | — | none | [EMULATOR report](FSA-00R1-EMULATOR-EVIDENCE.md) |

All seven attempts fail at the identical step — fetching `gradle-9.8.0-bin.zip` — before any build script is
evaluated. Failure class for every row: `ENVIRONMENT_ERROR` (dependency/distribution acquisition). Nothing about
the test sources, their correctness or their flakiness is learned by these runs.

### Why no partial execution was possible

* Gradle never started, so no task graph existed to substitute a narrower scope.
* Robolectric's own preparation task (`robolectricSdkDownload`) is itself a Gradle task and fails identically.
* JUnit XML / HTML / JaCoCo outputs require the test engines; none ran, so no report can be salvaged or
  "reconstructed".
* Fabricating results was not an option and is explicitly prohibited (mandatory invariant *NO FABRICATED TEST
  RESULTS*).

---

## 2. What exists to be run (source inventory, not a result)

Inventory is recorded so the first real CI run can be checked for completeness rather than trusted blindly.

| Scope | Inventory | Basis |
| --- | --- | --- |
| Build-logic tests | **8 test classes** in `buildSrc/src/test/kotlin/com/ichi2/anki/gradle/` (e.g. `JacocoPluginTest.kt`) | [06 §6](evidence/00r1/06-ci-static-validation.txt) |
| Lint-rule tests | `lint-rules/src/test/java/...` present | [06 §6](evidence/00r1/06-ci-static-validation.txt) |
| Task existence | `robolectricSdkDownload` (`robolectric-downloader.gradle.kts:47`), `jacocoUnitTestReport` (`JacocoCoverage.kt:58`), `lintAll` (`build.gradle.kts:186`), `ktlintCheck` (registered by `org.jlleitschuh.gradle.ktlint`, applied at `build.gradle.kts:78`) | [06 §6](evidence/00r1/06-ci-static-validation.txt) |
| Other unit-test scopes the aggregate covers | `jacocoUnitTestReport` aggregates unit tests across modules; upstream README documents it as the unit-test entry point | `.github/workflows/README.md` |

Note on spelling: `ktlintCheck` is correct as written in `lint.yml` (the earlier "ktLintCheck" note in FSA-00C is
already recorded as a historical correction). Verified against the applied plugin rather than against prose.

---

## 3. Expected evidence once CI can run

`.github/workflows/fsa-foundation-ci.yml` (added this round) produces, per command:

* `fsa-evidence/commands.tsv` — one row per command with exit code and failure category, plus a Markdown table in
  the run summary;
* `fsa-evidence/<label>.log` — verbatim output;
* JUnit XML (`**/build/test-results/`), JaCoCo reports (`**/build/reports/jacoco/`), HTML test reports
  (`**/build/reports/tests/`), lint reports (`**/build/reports/lint-results*`), and `buildSrc`/`lint-rules` test
  results — uploaded as `fsa-unit-test-evidence` and `fsa-lint-evidence`.

Acceptance for FSA-00 will require, from that run: `:AnkiDroid:testFullDebugUnitTest` **SUCCESS** with a non-zero
executed-test count, `jacocoUnitTestReport` **SUCCESS**, `lintAll ktlintCheck lint-rules:test` **SUCCESS** *without
disabling any rule*, and `./gradlew -p buildSrc test` **SUCCESS** with ≥8 test classes executed. None of these is
claimed now.

---

## 4. Verdict

| Field | Result |
| --- | --- |
| Unit tests executed | **NO** |
| Lint executed | **NO** |
| Build-logic tests executed | **NO** |
| Test/lint reports captured | **NO** |
| Instrumentation executed | **NO** |
| Any test claimed as PASS | **None** — deliberately |

FSA-00 test/lint evidence remains **BLOCKED**, blocked upstream of the tests by CI execution availability
([CI diagnostics §2.3](FSA-00R1-CI-DIAGNOSTICS.md#23-exact-owner-actions-nothing-here-can-be-done-by-arena)).

---

**Current-revision follow-up (2026-10-31):** See [FSA-00R1 current-revision follow-up](FSA-00R1-CURRENT-REVISION-FOLLOWUP.md). This report above remains historical evidence for its stated revision; the follow-up records later GitHub runs and current blockers.
