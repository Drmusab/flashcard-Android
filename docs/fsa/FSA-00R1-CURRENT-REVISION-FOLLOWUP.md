# FSA-00R1 — current revision follow-up and independent review

**Observed:** 2026-10-31 UTC. **Checkout on entry:** `2aaa16ac2dee5609c6c3de67e54c72ceab5dbabc`, branch `arena/ca9e6052-flashcard-android`, clean worktree. This follow-up preserves the earlier R1 reports and their historical revision-specific evidence; it does not turn their failures into passes. The local commands below ran at this HEAD with uncommitted CI-helper/workflow changes in the worktree; no application source or build configuration was changed. Git SHA alone does not identify those uncommitted helper changes.

## Repository and source baseline

`git status --short` was empty; `git rev-parse HEAD` and `git branch --show-current` gave the values above. `origin` fetch and push both point to `https://github.com/Drmusab/flashcard-Android.git`. `git log -5 --oneline` returned only `2aaa16a Merge pull request #7 from Drmusab/arena/a6008955-flashcard-android`: this checkout is shallow, so that output does not establish earlier history. `ca446d8712e3a9b01050c536c26e3869220f0415` is not present locally. GitHub's compare API reports six commits ahead of that revision, touching only FSA docs/evidence and CI infrastructure. Comparison against recorded reference `a7121c11c6e11d9c6ba34518784156fba1701e29` reports 18 commits ahead, 80 changed files, all in FSA docs/evidence or explicitly identified CI files; no production source change appears in that comparison. See [comparison](evidence/00r1-followup/source-comparison.txt). This is not a fresh execution of the native scheduler.

## GitHub Actions diagnosis

GitHub lists the foundation, unit, emulator and lint workflows as `active` on default branch `main`. Real `push` runs exist for the current checkout revision:

| Workflow | Run | Observed result |
| --- | --- | --- |
| FSA Foundation | [41214420301](https://github.com/Drmusab/flashcard-Android/actions/runs/41214420301) | failed, four jobs, no steps, no runner |
| Unit | [41214420414](https://github.com/Drmusab/flashcard-Android/actions/runs/41214420414) | matrix preparation failed without steps; test job skipped |
| Emulator | [41214420340](https://github.com/Drmusab/flashcard-Android/actions/runs/41214420340) | matrix preparation failed without steps; emulator job skipped |
| Lint | [41214420287](https://github.com/Drmusab/flashcard-Android/actions/runs/41214420287) | both jobs failed without steps |

GitHub's check annotations for representative jobs in all four runs state: **“The job was not started because your account is locked due to a billing issue.”** This is positive evidence that runs were admitted, not that Android builds started or that Actions is disabled. The foundation run has zero artifacts. The available evidence does not establish a precise payment cause or remaining minutes, nor does it prove that every future runner or action will be available once the lock is removed. See [API observations](evidence/00r1-followup/github-observations.txt). Downloading run logs redirected to a host not accessible from this sandbox; the check annotations are independently available through the GitHub API.

The three inherited workflows declare `workflow_dispatch`, PR and push triggers; their push branch exclusions do not match this Arena branch, and scheduled unit/emulator runs are upstream-only. The foundation workflow declares `workflow_dispatch`, push on `main` and `arena/**`, and PRs targeting `main`. The default-branch workflow is registered, but an attempted `gh workflow run fsa-foundation-ci.yml --ref main` returned **403 Resource not accessible by integration**, so dispatch through this session is not available. Actions permissions, selected-action restrictions, default workflow permissions and self-hosted runner settings also returned 403; billing usage endpoint returned 404. The owner must inspect these settings if needed; no settings were modified. `CODECOV_TOKEN` is referenced in inherited test workflows; Codecov failures are configured non-fatal on forks. `GITHUB_TOKEN` is automatic. The billing annotation, not a secret or a trigger filter, is the observed first blocker.

The existing dedicated workflow was already present on entry and is justified in the earlier CI report: inherited workflows do not establish FullDebug APK identity and per-command provenance together. It reuses SHA-pinned checkout, JetBrains setup-java, Gradle setup/cache and retry actions from inherited CI; Android SDK availability comes from the hosted runner/Gradle rather than a separate setup step. The unit job prepares Robolectric; lint uses the repository's warmup and lint commands, and reports/artifacts are configured. The emulator workflow uses SDK manager, KVM and the pinned emulator-runner action, with XML/log/video artifact paths. Its release-oriented instrumentation is not equivalent to the complete FullDebug Reviewer smoke matrix. A configured artifact path is not evidence that a report exists.

## Build and tests — actual results

Source pins remain wrapper Gradle **9.8.0**, daemon criteria **JetBrains JVM 21**, AGP **9.4.1**, Kotlin **2.4.20**, compile SDK **37.0**, target **36**, min **24** (`gradle/wrapper/gradle-wrapper.properties`, `gradle/gradle-daemon-jvm.properties`, `gradle/libs.versions.toml`). Project repositories include Google Maven, Maven Central, Gradle Plugin Portal, JitPack and the Foojay toolchain resolver. Their resolution on GitHub runners is **unverified**: no runner started. No pins, TLS settings or repositories were changed.

This sandbox has no `java` on PATH, no `JAVA_HOME`, no `adb`, emulator or `/dev/kvm`. Actual current attempts, with timestamps, duration, OS and paths, are in [commands.tsv](evidence/00r1-followup/commands.tsv) and the adjacent logs:

| Command | Exit | Result |
| --- | --- | --- |
| `./gradlew --version` | 1, 0 s | wrapper reports no Java; no Gradle version executed |
| `./gradlew :AnkiDroid:assembleFullDebug` | 1, 0 s | same error before distribution resolution or task execution |

The harness recorded `UNKNOWN` because its pattern did not classify the missing-Java message; independent classification is **ENVIRONMENT_ERROR** (no launcher JVM). No compile or app failure can be inferred. No test reports exist for these two invocations. Robolectric, `:AnkiDroid:testFullDebugUnitTest`, `jacocoUnitTestReport`, `lintAll ktlintCheck lint-rules:test`, `-p buildSrc test` and instrumentation were **not attempted in this follow-up**: all require the missing JVM/runner. Earlier actual failed attempts and their logs remain in [historical build evidence](FSA-00R1-BUILD-EVIDENCE.md) and [test results](FSA-00R1-TEST-RESULTS.md); they are not passes. No APK was built, so no APK path, size, SHA-256, actual application ID/version, signing fingerprint or actual variant can be verified.

## Infrastructure corrections and checks

* Removed Robolectric preparation from the FullDebug **build** job only; it remains in the unit job. A test-only download failure should not prevent the baseline build attempt. The version step remains a prerequisite to build; an unavailable wrapper/JVM still blocks it.
* APK identity capture now exits nonzero for missing APK, tools, required badging, failed signature verification, missing fingerprints or a signer with a non-debug DN. It records a caller-supplied `FullDebug` label, not a purported automatically verified variant. A debug DN is not proof of key provenance: independently compare the actual SHA-256 certificate fingerprint with the intended disposable debug key and verify metadata/variant. It is not a production-signing check by itself.
* Command retries retain distinct log paths; a successful initial `gradle-version` invocation records its own observed version. Reports remain in their workflow artifact paths, not per-command TSV columns. Raw command output is retained, not automatically sanitized: before sharing artifacts, a responsible reviewer must inspect logs and reports for sensitive values. Do not supply credentials or collections to this workflow. The presence of `contents: read` is not a guarantee of sanitized outputs.
* [Synthetic helper tests](evidence/00r1-followup/helper-tests.txt) and shell syntax checks passed locally. Mock APK and mock tools test missing inputs, failed tools, non-debug DN, retry preservation and exit propagation; they are **not** APK, Android, Gradle or GitHub runner evidence. The new helper test is configured in the build job but has not run on CI. The CI changes in this worktree have not been pushed or exercised by GitHub.

## Emulator, collection safety and independent assessment

No device was started, no application installed, no collection opened or written, no sync or signing performed. App launch, Deck Picker, disposable deck/card, front/reveal, Again/Hard/Good/Easy, Undo, persistence, lifecycle recreation and navigation are all **NOT EXECUTED**. No runtime proof exists that official data remains untouched under test.

Before any future write, the runner owner must provision an independently disposable emulator and storage, including any SD card; ensure no production data/accounts or restored unsafe AVD snapshot are present; prove and record the actual resolved collection path and emptiness **before the app opens it**, using a test-only preflight/configuration or other verifiable method; abort if that cannot be established. A `.debug` application ID alone does not isolate shared public storage. The prior suggestion to use plain `adb shell id -u` to assert package ownership is insufficient: it reports the shell identity, not the app's UID. Verify package UID/path access with an appropriate package/app-context method and do not infer ownership of shared storage from UID. Reuse the inherited emulator infrastructure only after resolving snapshot/data isolation; inspect test runner behavior and reports, and add or conduct explicit native-Reviewer smoke coverage for every required behavior. No CI YAML currently proves that preflight or that behavioral matrix.

Independent source comparison supports unchanged app/Reviewer code from the recorded baseline; the prior native Reviewer → libanki backend investigation is source evidence, not runtime validation or a proof that a second scheduler is impossible. No PC adapter, AnkiConnect scheduling integration, extra FSRS or Reviewer rewrite was introduced in this follow-up. No upstream merge, public release signing, user-data access or FSA-01 work occurred. Successful source diff and synthetic helper checks do not satisfy Android execution criteria. The helper changes and artifacts need independent review after a real run, including sensitive-data inspection and APK identity verification.

## Acceptance and owner actions

| Criterion | Current status |
| --- | --- |
| Recognized workflow and actual run URL | **Observed**, but runs failed before runner startup |
| Executed JDK/Gradle versions | **BLOCKED** |
| FullDebug build, unit tests, lint, build-logic tests | **BLOCKED** |
| APK identity and SHA-256 | **BLOCKED**, no APK |
| Emulator instrumentation and Reviewer smoke | **BLOCKED**, no execution |
| Disposable collection path verified | **BLOCKED**, no runtime proof |
| Original FSA-00A and reconciliation | **BLOCKED**, original not supplied; prior search preserved |
| Security | No unsafe signing or user collection access occurred here; future-run isolation and artifact sanitization remain unverified |

1. **Owner:** resolve the GitHub account billing lock in GitHub Settings → Billing and licensing, using GitHub support if the cause is unclear. In repository Settings → Actions → General, inspect workflow enablement and allowed-action policies if necessary. These settings were inaccessible to this integration; no change is claimed.
2. **Owner / CI engineer:** make the reviewed CI changes available on this session's branch, then dispatch `fsa-foundation-ci.yml` on the exact intended revision, or rerun a suitable run; confirm runner allocation, JDK/Gradle output, exact checked-out SHA, task outcomes, XML/HTML reports, artifact contents and APK identity. A rerun of an old SHA does not test these uncommitted fixes. Resolve any newly observed toolchain, dependency, source or resource failure on its actual merits. Configure Actions permission for the integration if Arena is to dispatch/read settings.
3. **Owner / Android verifier:** establish and record disposable collection isolation before first write; execute the existing emulator instrumentation and explicit FullDebug native Reviewer smoke checks. Inspect reports and retain only sanitized evidence. If any check is unavailable, keep it blocked.
4. **Owner:** supply the original FSA-00A file and its original SHA-256/provenance if available. Preserve the file, verify the hash and reconcile it with FSA-00B/C; do not reconstruct it from memory.

**Decision:** FSA-00 **BLOCKED**; FSA-00 lock **NOT GRANTED**; FSA-01 production migration **NOT AUTHORIZED**. Stop at FSA-00R1.
