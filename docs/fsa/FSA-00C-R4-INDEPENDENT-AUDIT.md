# FSA-00C — Independent Baseline Audit R4 and Gate Decision

> **FSA-00: BLOCKED — NOT LOCKED.**
> Source equivalence, toolchain pins and the scoped source architecture audit are supported by fresh execution.
> The Android build, tests, lint, APK, device Reviewer and collection-isolation evidence required for a lock still does not exist, and this environment cannot produce it.
> FSA-00A reconciliation remains BLOCKED. **FSA-01 / FSA-01A production migration is NOT AUTHORIZED.**

**Observation date:** 2026-10-29 UTC.
**Audited revision:** `f506261b8968418a2d98f7bfa796ea61e98e1578`.
**Branch:** `arena/2424aa82-flashcard-android` (fixed Arena session branch).
**Authority:** FSA-00C audit and verification only. No feature migration, no scheduler change, no dependency or identity change, no upstream merge.
**Prepared with:** Arena.ai Agent Mode. No upstream contribution, workflow dispatch, release or remote branch operation performed.

This is a new independent assessment at the current HEAD. It does not claim that prior FSA-00C reports were executed at this revision; R1/R2/R3 remain valid historical snapshots for their cited SHAs and are preserved unchanged.

## 1. Repository, baseline and provenance

| Field | Observed value | Evidence |
| --- | --- | --- |
| Target | `Drmusab/flashcard-Android`, GitHub `fork:true`, parent & source `ankidroid/Anki-Android`, default branch `main` | R4-05 |
| Audited HEAD | `f506261b8968418a2d98f7bfa796ea61e98e1578` — *Merge pull request #4 from Drmusab/arena/1a304a7c-flashcard-android* | R4-01 |
| Branch | `arena/2424aa82-flashcard-android`; local `main` and `origin/main` both at the same commit | R4-01 |
| Worktree | Clean on entry (`git status --short` empty). This audit adds only `docs/fsa/` files; nothing pre-existing was discarded, reset or force-pushed | R4-01 |
| Reference baseline | `a7121c11c6e11d9c6ba34518784156fba1701e29` — *feat(card-templates): reposition card types* (2026-10-23 UTC); object verified present locally and in upstream | R4-01, R4-05 |
| History | **Full history**: 24,689 commits, `.git/shallow` absent after `git fetch --unshallow`; no grafted ancestry. The session checkout *started shallow* (1 commit) — see §2 correction 9 | R4-01 |
| Upstream HEAD at observation | `c21570b0a5139fe0823568f8fa29460aa9be6066` (2026-10-29T22:05:40Z) | R4-05 |
| Fork divergence | **8 ahead / 142 behind** upstream, status `diverged`; merge base `a7121c11…`. The 8 fork-only commits are documentation/evidence merges only | R4-05, R4-01 |
| Source delta vs baseline | **34 added files, all under `docs/fsa/`**; `git diff --stat a7121c11..HEAD ':(exclude)docs/fsa'` is **empty** | R4-01, R4-06 |
| CI evidence for this HEAD | `check-runs` = 0, `actions/runs` total = 0. No green build exists remotely to inherit | R4-05 |

`git diff --name-only a7121c11..HEAD -- '*.kt' '*.java' '*.kts' '*.xml' '*.toml' '*.gradle'` returns **nothing** (R4-06). Production Kotlin/Java, tests, build scripts, dependency catalog, manifests, resources and the native backend wiring are byte-identical to the reference baseline. All nine FSA-00B §5.4 SHA-256 anchors were independently recomputed and match (R4-06).

### Evidence index — R4

All artifacts are in [`evidence/00c-r4/`](evidence/00c-r4/), generated in this session with UTC timestamps, the exact command text and exit codes. A `grep` exit of 1 means "no match", not a failing application test.

| ID | Artifact | Contents |
| --- | --- | --- |
| R4-01 | [01-repository.txt](evidence/00c-r4/01-repository.txt) | `status`, `HEAD`, branch list, remotes, log, commit count, shallow check, baseline `cat-file`, full baseline diff, tree hashes |
| R4-02 | [02-environment.txt](evidence/00c-r4/02-environment.txt) | OS/kernel, 2 vCPU, 3.8 GiB RAM, no swap, 19 GiB free, absent `/dev/kvm`, absent tool inventory, no `local.properties`/APK |
| R4-03 | [03-jvm-and-gradle.txt](evidence/00c-r4/03-jvm-and-gradle.txt) | JVM provisioning from an allowed host, `java -version`, absent `javac`, and **7 wrapper invocations with exit codes** |
| R4-04 | [04-network.txt](evidence/00c-r4/04-network.txt) | 17-endpoint acquisition matrix |
| R4-05 | [05-github-and-upstream.txt](evidence/00c-r4/05-github-and-upstream.txt) | GitHub metadata, upstream head, baseline presence, both compares, merge base, PR list, releases, check-runs, FSA-00A search |
| R4-06 | [06-integrity.txt](evidence/00c-r4/06-integrity.txt) | 9 SHA-256 anchors, non-docs diff, code/build/manifest diff |
| R4-07 | [07-source-audit.txt](evidence/00c-r4/07-source-audit.txt) | Reviewer & ViewModel answer paths, undo boundary, libanki `Scheduler`, scheduler-class inventory, forbidden-symbol scan |
| R4-08 | [08-identity-storage-device.txt](evidence/00c-r4/08-identity-storage-device.txt) | Application ID/version, signing & fallback keystore, authorities/permissions, backup/cleartext, storage resolution, FileProvider paths, device/sync status |

Historical evidence retained: `evidence/00c/` (E01–E10), `evidence/00c-r2/` (R2-01..06), `evidence/00c-r3/` (R3-01..08).

## 2. Prerequisite and documentation reconciliation

| Requirement | Classification | Basis and limitation |
| --- | --- | --- |
| FSA-00A original discovery report | **BLOCKED** | Absent from every ref: `git log --all --diff-filter=A --name-only -- 'docs/fsa/*'` contains no 00A/discovery file (grep exit 1); no matching tracked filename; all four PRs are FSA-00B/C documentation; `gh release list` empty; no attachment supplied in this session. Only *references to its absence* exist. Its claims therefore cannot be compared or recreated without fabrication. This is a statement about accessible evidence, not about private archives. |
| FSA-00B baseline report | **PARTIAL** | Present at `docs/fsa/FSA-00B-fork-baseline-build-verification.md`. Its nine source hashes, version pins and BLOCKED conclusion are independently corroborated at the current rather than its original revision. This is not recovery of its original execution logs, which remain historical. |
| Historical evidence overall | **NOT RECONCILED** | Blocked by the missing FSA-00A artifact. Prior R1/R2/R3 snapshots are internally consistent with this run's result. |

### Explicit corrections and qualifications

Prior documents are preserved unchanged; corrections are recorded here rather than silently rewritten.

1. **Lint task spelling.** The correct task is `ktlintCheck` (`.github/workflows/lint.yml:73`). FSA-00B §5.2 and `workflows/README.md:16` spell it `ktLintCheck`. This audit attempted only the correct spelling; neither spelling ever reached task resolution.
2. **JVM range is not unlimited.** FSA-00B's "any ≥17 launcher works" is not a guarantee. Root `build.gradle.kts:203-240` throws unless the daemon JVM is **21–25**, and states explicitly that `JAVA_HOME` does not override `gradle/gradle-daemon-jvm.properties` (JETBRAINS 21). The JVM used here is 21, inside the documented range.
3. **Revision and branch identity.** FSA-00B's `a7121c11…` and the earlier Arena branch names describe those runs, not this one. Current HEAD is the R3 documentation merge `f506261…`, and the fork is now 142 commits behind upstream. A documentation merge is not build evidence.
4. **Instrumentation path is not isolation.** `CollectionHelper.kt:186-195` appends `androidTest` beneath the *configured* collection root when `isInstrumentationTest`; if that root is shared public storage, tests still run inside it (R4-08).
5. **Sync waiver.** The "written optional waiver" is a suggestion, not an authorization. No parent-Gate contract permitting a waiver was supplied, so sync is UNVERIFIED and no waiver is granted.
6. **Branch naming.** FSA-00B's `feature/fsa-foundation` requirement remains contractually unresolved. The fixed Arena session branch provides equivalent isolation; no branch was created, renamed or switched, per the session branch lock.
7. **Stale catalog comment.** `gradle/libs.versions.toml:24` mentions 9.0.1 while the actual pin is `androidGradlePlugin = "9.4.1"` (line 26). The catalog value is the source pin; the comment is stale.
8. **Artifact paths in FSA-00B are expectations, not outputs.** No APK exists in the repository (R4-02, R4-08).
9. **R3's "no JVM can be provisioned" is imprecise and is corrected here.** R3 stated that no JVM could be obtained without bypassing network policy. In fact a real JDK 21 JRE *is* obtainable from `pypi.org`, which is an allowed host. It was provisioned in this run (Temurin 21.0.8+9) and used to execute the wrapper, which moved the proven failure boundary from "no JVM" to "dependency acquisition" (R4-03). It is **not** the pinned JETBRAINS vendor and it contains **no `javac`**, so it cannot substitute for the pinned toolchain.
10. **Memory claims.** This host has 3.8 GiB with no swap against a 3 GiB daemon heap plus per-fork test heaps in the source configuration. That is a readiness risk, not an observed OOM; nothing reached the Java compile stage, so no memory conclusion is drawn.

## 3. Toolchain and build verification (executed)

The decisive new step in this round: give the wrapper a real JVM and observe exactly where it stops.

**JVM provisioning (R4-03).** `python3 -m pip download jdk4py==21.0.8.2` succeeded from `pypi.org` (an allowed host); the wheel was extracted to `/tmp/jdk21/jdk4py/java-runtime`. `java -version` reports `OpenJDK Runtime Environment Temurin-21.0.8+9`, exit 0. `javac` is **absent** (exit 127) and there are no `jmods` — the distribution is a **JRE, not a JDK**.

**Wrapper behaviour with that JVM present (R4-03).** All seven required invocations were run with `GRADLE_USER_HOME` outside the repository so the worktree stayed clean:

| # | Exact command | Exit | Actual observed result |
| --- | --- | --- | --- |
| 1 | `./gradlew --version` | **1** | `Downloading https://services.gradle.org/distributions/gradle-9.8.0-bin.zip` → `Attempt 1/4…4/4 failed. Reason: Remote host terminated the handshake` → `javax.net.ssl.SSLHandshakeException` |
| 2 | `./gradlew robolectricSdkDownload` | **1** | same distribution-download failure |
| 3 | `./gradlew :AnkiDroid:assembleFullDebug` | **1** | same distribution-download failure |
| 4 | `./gradlew :AnkiDroid:testFullDebugUnitTest` | **1** | same distribution-download failure |
| 5 | `./gradlew jacocoUnitTestReport` | **1** | same distribution-download failure |
| 6 | `./gradlew lintAll ktlintCheck lint-rules:test` | **1** | same distribution-download failure (correct spelling) |
| 7 | `./gradlew -p buildSrc test` | **1** | same distribution-download failure |

Afterwards `find . -name '*.apk'` is empty, `lint-results*` is empty, `AnkiDroid/build` does not exist and `git status --short` shows only the new evidence directory (R4-03).

**Interpretation.** The Gradle wrapper launcher itself works under JVM 21. The blocker is strictly **artifact acquisition**: the pinned distribution cannot be fetched because egress to `services.gradle.org` is terminated at the TLS handshake. This is an environmental boundary, **not a compiler, version or project defect**, and it is not evidence of AGP/Kotlin incompatibility.

**Acquisition matrix (R4-04).** 17 endpoints probed with `curl`:

| Host | Result |
| --- | --- |
| `services.gradle.org`, `downloads.gradle.org` | `000` — TLS handshake terminated |
| `plugins.gradle.org`, `repo1.maven.org`, `repo.maven.apache.org`, `jitpack.io` | `000` |
| `dl.google.com` (SDK index and Google Maven POM), `maven.google.com` | `000` |
| `api.foojay.io` (pinned daemon-JVM redirector) | `000` |
| `raw.githubusercontent.com`, `objects.githubusercontent.com` | `000` — GitHub release **binary assets are unreachable** |
| `github.com` `200`, `api.github.com` `200`, `codeload.github.com` `301`, `registry.npmjs.org` `200`, `pypi.org` `200` | reachable |

Consequently there is **no legitimate route** in this sandbox to Gradle 9.8.0, AGP 9.4.1, Kotlin 2.4.20, AndroidX, Robolectric 4.17, `io.github.david-allison:anki-android-backend:0.1.72-anki26.09.3`, or Android SDK platform 37. No mirror, repackaged SDK/JDK, checksum bypass, dependency substitution or `local_backend` override was attempted; all are prohibited by the audit contract and by dependency-integrity policy.

### Verified source pins (source evidence, not executed compatibility)

| Item | Pin | Where |
| --- | --- | --- |
| Gradle | **9.8.0** (`gradle-9.8.0-bin.zip`, retries 3, `validateDistributionUrl=true`, **no `distributionSha256Sum`**) | `gradle/wrapper/gradle-wrapper.properties:3-7` |
| AGP | **9.4.1** | `gradle/libs.versions.toml:26`, applied via `buildSrc` |
| Kotlin | **2.4.20** | `gradle/libs.versions.toml:105` |
| Daemon JVM | **JETBRAINS 21** + 8 foojay toolchain URLs (Linux x86_64 id `0d1a1acdc708062093673f65aa9aba4b`); foojay resolver 1.0.0 | `gradle/gradle-daemon-jvm.properties`, `settings.gradle.kts` |
| Build JVM bounds | **21–25**, enforced with `GradleException`; `ANKIDROID_JVM` mismatch guard | `build.gradle.kts:203-240` |
| Android SDK | `compileSdk 37` / `compileSdkMinor 0`, `targetSdk 36`, `minSdk 24`, `apiMinSdk 16`; **no explicit `buildToolsVersion`** | `gradle/libs.versions.toml:2-14`, `buildSrc/ankidroid.android.app.gradle.kts:18-19` |
| Backend | `ankiBackend = 0.1.72-anki26.09.3` | `gradle/libs.versions.toml:76` |
| Robolectric / ktlint | 4.17 / engine 1.8.0, plugin 14.2.0 | `gradle/libs.versions.toml:16,108,123` |
| App version | `2.26.0alpha7`, code `22600107` | `AnkiDroid/build.gradle.kts:133-135` |

The AGP-selected build-tools patch level is **unknown** until a build emits its SDK diagnostic; it is not inferred here.

### Canonical task configuration (source-corroborated, unexecuted)

- Debug variant: `versionNameSuffix = "-debug"`, `applicationIdSuffix = ".debug"`, universal debug APK always produced (`AnkiDroid/build.gradle.kts:183-190`).
- CI unit tests: `robolectricSdkDownload` then aggregate `jacocoUnitTestReport`, plus `testFullDebugUnitTest -PemptyApplication` (`.github/workflows/tests_unit.yml:177,181,191`).
- CI lint: `./gradlew -p buildSrc test --daemon`, then `compileFullDebugJavaWithJavac compileLint lint-rules:compileTestJava`, then `lintAll ktlintCheck lint-rules:test` (`lint.yml:53,68,73`).
- `lintAll` is registered at `build.gradle.kts:186` and depends on AnkiDroid `lintFullDebug` (`:184-200`). AndroidLint uses `abortOnError=true`, warnings-as-errors, `lint-release.xml`. No `lint-baseline*.xml` exists, so no baseline suppresses findings.

### Artifact evidence

| Required field | Observation |
| --- | --- |
| APK path / size / SHA-256 | **NOT PRODUCED** (R4-02, R4-03, R4-08) |
| Application ID / version / variant from a binary | Unavailable; source declares `com.ichi2.anki` (release), `.debug` (debug), `2.26.0alpha7`, code `22600107` |
| Signing certificate fingerprint | Unavailable — no APK, no `apksigner` |
| Merged manifest / resolved dependency graph | Unavailable |
| Repeat-build comparison | **BLOCKED** — no first artifact |

No reproducibility, determinism or supply-chain claim is made. The 9 matching SHA-256 anchors prove **source** integrity only.

## 4. Device, Reviewer and data-safety verification

**Outcome: BLOCKED across the whole device matrix.** There is no APK, no `adb`, no emulator, no `/dev/kvm` and therefore no Android target at all (R4-02, R4-08). No installation, launch, rating, undo, import, navigation, lifecycle event or sync was executed. Nothing was simulated or inferred as a pass.

| Test | Result | Reason |
| --- | --- | --- |
| App launch | **BLOCKED** | no APK, no target |
| Deck access | **BLOCKED** | no target |
| Question display | **BLOCKED** | no target |
| Answer reveal | **BLOCKED** | no target |
| Again / Hard / Good / Easy | **BLOCKED** | native path is source-verified (R4-07), runtime unproven |
| Undo | **BLOCKED** | no target |
| Session end / persistence | **BLOCKED** | no target |
| App restart | **BLOCKED** | no target |
| Navigation | **BLOCKED** | no target |
| Process recreation | **BLOCKED** | no target |
| Coexistence with official AnkiDroid | **BLOCKED** | no target |
| Sync | **UNVERIFIED — TEST ACCOUNT NOT AUTHORIZED** | no disposable account supplied; no waiver authority in the parent contract |

### Reviewer mutation-boundary audit (source level)

Confirmed at the current revision (R4-07):

- `Reviewer.kt:1580-1592` — `override suspend fun answerCardInner(rating: Rating)` calls `undoableOp(this) { sched.answerCard(state, rating) }`, exactly as the Gate contract describes. No Study-Agent `RatingCommit` adapter, no remote mutation, no duplicate scheduling command, no direct database write and no second FSRS are introduced.
- `ReviewerViewModel.kt:527-541` — `answerCardInternal` likewise computes the answer through `withCol { sched.answerCard(...) }` then commits inside `undoableOp(handler = this) { sched.answerCard(answer) }`, so both reviewer surfaces share one native, undoable authority.
- `libanki/.../sched/Scheduler.kt:172` — `fun answerCard(input: CardAnswer): OpChanges = col.backend.answerCard(input)`, i.e. the Rust/libanki backend performs scheduling. The Kotlin `Scheduler` is a thin wrapper.
- Scheduler inventory: only `Scheduler` (open class, libanki), `DummyScheduler` (assigned when `schedVer() == 1`, i.e. an unsupported-legacy-version placeholder, `Collection.kt:231-236`) and the unrelated dialog `SchedulerUpgradeDialog`. There is **no** fork-owned or alternate scheduling engine.
- Undo is the native collection undo (`Collection.undo()` → `backend.undo()`), reached through the same `undoableOp` boundary.

These are source facts. They do **not** establish runtime rating/undo behaviour, which stays BLOCKED.

### Data isolation: distinct package ≠ distinct storage

The FullDebug package is `com.ichi2.anki.debug` (suffix at `AnkiDroid/build.gradle.kts:187`), while release/official is `com.ichi2.anki`; authorities and the custom permission are templated on `${applicationId}`. **However** (R4-08):

- `SetupStorage.kt:127-148` — `getDefaultAnkiDroidDirectory` returns `legacyAnkiDroidDirectory()` for `AnkiDroidFolder.PUBLIC`, which is `File(Environment.getExternalStorageDirectory(), "AnkiDroid")` — on typical devices `/storage/emulated/0/AnkiDroid`, i.e. **potentially the same directory a production install uses**.
- `CollectionHelper.kt:186-195` — the instrumentation runner only nests an `androidTest` subdirectory under whatever root is configured; it does not isolate from a shared public root.
- `res/xml/filepaths.xml` exposes `<external-path path="." name="photos" />`, so FileProvider grants reach broad external storage.
- `android:allowBackup="true"` with no `fullBackupContent`/`dataExtractionRules` in the tracked manifest; `android:usesCleartextTraffic="true"`; BROWSABLE `http`/`https` deep links and `apkg/colpkg` SEND/VIEW handlers can compete with an official install for the same intent.

Therefore: **no claim of data isolation is made**, and any future device test must prove the actual collection path is disposable *before* the first mutation. No user-owned collection was read or written by this audit.

### Release and sync safety

- Release application ID `com.ichi2.anki` collides with official AnkiDroid. Installing a fork release over an official installation would fail signature verification; uninstalling the official app to work around that risks user data, and is not suggested anywhere in this audit.
- `AnkiDroid/build.gradle.kts:167-180` falls back to the committed `tools/fallback-release-keystore.jks` (SHA-256 `d1d3fb7d…ac80ea`) with publicly visible passwords when `KEYSTOREPATH` is unset. A release APK signed with that key can never be a trustworthy update channel. **No release APK was built, signed, installed or distributed.** Independent distribution identity remains an FSA-02 decision.
- No AnkiWeb synchronization of any kind was performed.

## 5. Architecture safety

| Field | Result | Basis |
| --- | --- | --- |
| NATIVE SCHEDULER | **UNCHANGED** (source) | Reviewer/ViewModel → `undoableOp` → libanki `Scheduler` → `backend.answerCard` (R4-07); binary/runtime proof BLOCKED |
| PC ANKI ADAPTER | **ABSENT** | 0 matches for `pcanki`, `pc-anki`, `PcAnkiBackend` across `.kt/.kts/.java/.xml/.toml/.gradle` (R4-07) |
| ANKICONNECT SCHEDULING | **ABSENT** | 0 matches for `anki-connect`, `ankiconnect` |
| SECOND FSRS | **ABSENT** | single native scheduler; `DummyScheduler` is an unsupported-v1 placeholder; no fork-owned FSRS engine |
| STUDY-AGENT MIGRATION | **NOT STARTED** | production diff vs baseline empty; 0 matches for `study-agent`, `studyagent`, `StudyVoiceTurn`, `SpeechOrchestrator`, `RatingCommit` |
| RELEASE IDENTITY | **UNCHANGED** | `com.ichi2.anki` / `.debug`; fallback keystore untouched; nothing distributed |
| USER DATA SAFETY | **BLOCKED for certification** | no collection touched; shared-public-storage risk demonstrated from source; runtime isolation unproven |

## 6. Independent audit matrix

**PASS is limited to the stated scope.** Source-only audits are explicitly marked; they never stand in for a runtime/build result.

| Audit | Result | Source evidence | Execution evidence | Defect / limitation | Remediation | Residual risk |
| --- | --- | --- | --- | --- | --- | --- |
| AUDIT-00C-01 Fork & upstream identity | **PASS** | GitHub parent/source metadata; origin URL | R4-01 remotes/branches; R4-05 API metadata, upstream head, baseline presence | Remote snapshot keeps advancing | Preserve exact SHAs; re-observe before each claim | R-13 |
| AUDIT-00C-02 Baseline commit integrity | **PASS** | Reference & HEAD trees; 9 anchors | R4-01 `cat-file`/diff; R4-06 hashes 9/9 | Session checkout began shallow | Full history now fetched; retain API + diff evidence | R-13 |
| AUDIT-00C-03 Worktree & branch safety | **PASS** | Fixed session branch | R4-01 clean status, single local branch pair | Foundation-branch naming contract unresolved | Owner acceptance of equivalent isolation; do not rename | R-10 |
| AUDIT-00C-04 FSA-00A/B reconciliation | **BLOCKED** | B present, A absent | R4-05 searches across refs/PRs/releases | Original A unavailable → no provenance comparison | Supply original artifact with provenance | R-04 |
| AUDIT-00C-05 Gradle/JDK/AGP/Kotlin integrity | **PASS (pins only)** | Wrapper, catalog, daemon criteria, 21–25 guard, buildSrc | R4-06 hashes; R4-03 JVM 21 inside range | Distributed version, daemon vendor and AGP compatibility never executed | Execute pinned toolchain on capable host | R-01/R-02 |
| AUDIT-00C-06 SDK & dependency readiness | **BLOCKED** | SDK 37, repositories, backend pin | R4-02 no SDK; R4-04 12 endpoints `000` | Nothing resolvable; build-tools patch unknown | Standard SDK manager + authorized egress | R-02/R-09/R-11 |
| AUDIT-00C-07 Actual APK compilation | **BLOCKED** | FullDebug config present | R4-03 `assembleFullDebug` exit 1 at distribution fetch | No compiler verdict exists | Frozen FullDebug build on capable host | R-01/R-02/R-05 |
| AUDIT-00C-08 Unit-test execution integrity | **BLOCKED** | `testFullDebugUnitTest`, `jacocoUnitTestReport` | R4-03 both exit 1; no XML/HTML | Zero measured outcomes | Run both scopes; attach JUnit XML | R-05 |
| AUDIT-00C-09 Android lint & Kotlin style | **BLOCKED** | `lintAll`, `lint-release.xml`, `.editorconfig`, `lint.yml` | R4-03 `lintAll ktlintCheck lint-rules:test` exit 1 | Errors/warnings unmeasured | Run unchanged rules; retain reports | R-05 |
| AUDIT-00C-10 Build-logic test execution | **BLOCKED** | 8 `buildSrc/src/test` classes | R4-03 `-p buildSrc test` exit 1 | Sources present ≠ tests executed | Execute on capable host | R-05 |
| AUDIT-00C-11 APK identity, signing, hash | **BLOCKED** | Source ID/signing expectations | R4-02/08 no APK, no `aapt2`/`apksigner` | No binary-level package/cert/hash evidence | Inspect built APK, record hashes/certs | R-05/R-07 |
| AUDIT-00C-12 Native scheduler authority | **PASS (source)** | Reviewer, VM, libanki `Scheduler`, `Collection` undo | R4-07 excerpts; R4-06 unchanged tree | Backend binary and runtime unproven | Preserve authority; complete device proof | R-03/R-05 |
| AUDIT-00C-13 Reviewer rating/undo behaviour | **BLOCKED** | Pipeline inspected | R4-02/08 no target/APK | Behavioural proof needs a device | Disposable-device matrix | R-03/R-05/R-06 |
| AUDIT-00C-14 Data & storage isolation | **BLOCKED** | `SetupStorage`/`CollectionHelper`, `filepaths.xml`, IDs, permissions | R4-08 no runtime path; public-storage branch demonstrated | Package separation ≠ storage separation | Prove actual path first; paired-install test | R-06/R-12 |
| AUDIT-00C-15 No PC Adapter / second scheduler | **PASS (source)** | Forbidden-symbol scan = 0; single scheduler inventory | R4-07; R4-06 tree identity | Binary not reverse-audited | Keep exclusion; enforce in later gates | R-05 |
| AUDIT-00C-16 No Study-Agent migration in FSA-00 | **PASS** | Diff outside `docs/fsa` empty | R4-01/R4-06 | — | Defer all copying to FSA-01A under lock | — |
| AUDIT-00C-17 No unauthorized upstream merge | **PASS** | HEAD frozen; 8 ahead are docs merges only | R4-01 log; R4-05 compare (142 behind, not merged) | — | Do not merge upstream during verification | R-11 |
| AUDIT-00C-18 Truthful verification & lock decision | **PASS** | Every claim cites R4-01..08 or source lines | Transcripts retained verbatim | — | Gate stays BLOCKED | — |

## 7. Verification matrix

| ID | Check | Result |
| --- | --- | --- |
| VER-00C-01 | Current HEAD recorded | **PASS** — `f506261…` (R4-01) |
| VER-00C-02 | Baseline reachable / source equivalent | **PASS** — `a7121c11…` present locally & upstream; full history 24,689; non-docs diff empty |
| VER-00C-03 | No unexplained production modifications | **PASS** — R4-01/R4-06 |
| VER-00C-04 | Fork/upstream relation verified | **PASS** — 8 ahead / 142 behind, merge base = baseline (R4-05) |
| VER-00C-05 | FSA-00A reconciled | **BLOCKED** — artifact absent from all refs (R4-05) |
| VER-00C-06 | FSA-00B evidence classified | **PARTIAL** — pins/hashes/BLOCKED conclusion corroborated |
| VER-00C-07 | JDK & daemon JVM verified | **PARTIAL** — a real Temurin 21.0.8 JRE ran the launcher (JRE only, no `javac`); pinned JETBRAINS 21 daemon never provisioned or observed |
| VER-00C-08 | Gradle wrapper executes | **BLOCKED** — launcher runs, distribution fetch fails TLS (R4-03) |
| VER-00C-09 | Dependencies resolve | **BLOCKED** — 12 acquisition endpoints `000` (R4-04) |
| VER-00C-10 | Robolectric SDK preparation executes | **BLOCKED** — exit 1 at distribution fetch |
| VER-00C-11 | FullDebug APK builds | **BLOCKED** — no APK |
| VER-00C-12 | Unit tests execute and pass | **BLOCKED** — both scopes exit 1, no XML |
| VER-00C-13 | Lint/style execute and pass | **BLOCKED** — exit 1, no reports |
| VER-00C-14 | Build-logic tests execute and pass | **BLOCKED** — exit 1 |
| VER-00C-15 | APK hash & package identity confirmed | **BLOCKED** — NOT PRODUCED |
| VER-00C-16 | Disposable collection verified | **BLOCKED** — no device/APK |
| VER-00C-17 | App launches | **BLOCKED** |
| VER-00C-18 | Deck access works | **BLOCKED** |
| VER-00C-19 | Question/answer reveal works | **BLOCKED** |
| VER-00C-20 | Native ratings work | **BLOCKED** — source PASS (R4-07), runtime unproven |
| VER-00C-21 | Undo works | **BLOCKED** |
| VER-00C-22 | Reviewer state survives lifecycle | **BLOCKED** |
| VER-00C-23 | Official AnkiDroid data untouched | **PASS (audit scope)** — no collection operation of any kind; runtime isolation still BLOCKED |
| VER-00C-24 | Provider/deep-link identity risks identified | **PASS (source)** — templated authorities/permission, handlers and broad file grants enumerated (R4-08) |
| VER-00C-25 | No PC Anki Adapter | **PASS (source)** — 0 matches |
| VER-00C-26 | No AnkiConnect scheduling path | **PASS (source)** — 0 matches |
| VER-00C-27 | No alternate FSRS scheduler | **PASS (source)** — single native scheduler |
| VER-00C-28 | No unauthorized feature migration | **PASS** — non-docs diff empty |
| VER-00C-29 | No release-signing safety violation | **PASS (audit)** — no release built/distributed; fallback-key risk documented |
| VER-00C-30 | Report includes exact commands and results | **PASS** — R4-01..08 |

## 8. Residual risks and blocker reassessment

| ID | Severity | Evidence | Consequence | Owner | Required action | Blocks lock? |
| --- | --- | --- | --- | --- | --- | --- |
| R-01 | Critical | R4-03: JRE present, no `javac`; pinned JETBRAINS 21 never provisioned; distribution never fetched | No compilation or daemon verification possible here | Build maintainer | Full pinned JDK 21 on capable host; record `java -version` + `./gradlew --version` + daemon vendor/patch | **YES** |
| R-02 | Critical | R4-04: 12 endpoints `000`; R4-02 no SDK | Gradle/AGP/Kotlin/AndroidX/backend/SDK 37 unattainable | Build infra owner | Authorized egress to Gradle/Google/Maven/Plugin/foojay + standard SDK manager | **YES** |
| R-03 | Critical | R4-02/08: no adb, no `/dev/kvm`, no APK | No launch, deck, rating, undo, lifecycle, coexistence proof | Android QA | Emulator with KVM or disposable device; run full matrix | **YES** |
| R-04 | High | R4-05: FSA-00A absent from all refs | Discovery claims unreconcilable | Product owner | Supply original with author/revision/date/hash | **YES** |
| R-05 | High | R4-03: 7× exit 1; no XML/lint/APK; 0 CI runs at HEAD | Compiler/test/lint defects may exist undetected | Build maintainer + reviewer | Re-run all 7 commands at frozen SHA; attach XML/HTML, hashes, certificate | **YES** |
| R-06 | Critical for user data | R4-08: `PUBLIC` → shared `/AnkiDroid`; `androidTest` nested under configured root; broad `external-path "."` | Debug build may share a real collection directory with the official app | Android QA + security | Prove path is disposable before any mutation; paired-install test | **YES** |
| R-07 | High for distribution | R4-08: release ID collision; committed fallback keystore with public passwords | Fork release cannot be a trusted update channel; uninstall-to-install risks data | FSA-02 release owner | Keep release distribution prohibited; define independent ID and key custody | **NO** for debug-only FSA-00; **YES** for any release |
| R-08 | High | R4-08: no account, no waiver authority | Sync behaviour unverified | Product owner + QA | Authorize disposable account or provide parent-contract waiver | **YES** until resolved |
| R-09 | Medium | R4-02: 3.8 GiB, no swap, vs 3 GiB daemon heap + per-fork heaps | OOM/timeout risk (not observed: nothing reached Java compile) | Build infra owner | ≥8 GiB host, more with emulator; document any JVM host setting | **YES** to readiness |
| R-10 | Low (contract) | Fixed Arena branch vs historical `feature/fsa-foundation` | Naming requirement unmet literally | Product owner | Accept equivalent isolation explicitly; do not rename branch | **YES** if naming is contractual |
| R-11 | Medium | Wrapper has no `distributionSha256Sum`; `repositoriesMode` commented; no tracked dependency verification | Artifact authenticity unproven (inherited policy) | Build/security owner | Record resolved artifact hashes on capable host; review hardening separately | **NO** alone |
| R-12 | Medium | R4-08: `allowBackup=true` without rules, cleartext traffic, BROWSABLE deep links, `apkg` handlers, broad file grants | Routing/restore can cross app boundaries | Android security + FSA-02 | Verify merged manifest and routing with disposable data | **YES** via R-06 |
| R-13 | Low | R4-01/05: full history now fetched; remote advances | Snapshot drift | Repo maintainer | Re-observe SHAs per claim | **NO** |

### FSA-00B blocker reassessment

| Blocker | Disposition at `f506261…` |
| --- | --- |
| B-01 No JDK | **Partially superseded, still blocking** — a JRE was obtained from an allowed host and executed the wrapper (R4-03), but it lacks `javac` and is not the pinned vendor; no build JVM resolution was observed |
| B-02 Restricted dependency network | **Confirmed with sharper evidence** — Gradle distribution fetch fails inside the JVM (`SSLHandshakeException`), and 12 acquisition endpoints return `000` (R4-03/R4-04) |
| B-03 No SDK or emulator | **Unchanged** — no SDK, no adb, no `/dev/kvm` (R4-02/R4-08) |
| B-04 FSA-00A absent | **Unchanged** — absent from every ref, PR, release and attachment (R4-05) |
| B-05 Insufficient RAM | **Readiness risk only** — 3.8 GiB vs 3 GiB daemon + per-fork heaps; no OOM observed because compilation was never reached |
| B-06 Foundation branch absent | **Contract unresolved** — fixed session branch retained; no branch created, renamed or reset |
| B-07 Shallow checkout | **Resolved in this run** — `git fetch --unshallow` succeeded; 24,689 commits; previous runs were shallow |
| B-08 Release identity/storage risks | **Open** — storage risk now demonstrated from source (R4-08); release identity deferred to FSA-02 |

## 9. Gate decision

This is **Case B — Source Verified, Android Build Missing** of the Gate contract. It is not Case C: no compiler, test or lint defect was observed, because none of those stages executed. It is not Case D: nothing here is a legitimately optional requirement that the parent contract permits waiving, and device/data-safety checks may not be waived unilaterally.

```text
FSA-00:
  BLOCKED — NOT LOCKED

BASELINE:
  VERIFIED (source equivalence + 9/9 hashes + pins)

SOURCE AUDIT:
  PASS (equivalence, native authority, exclusions, identity)

TOOLCHAIN PINS:
  VERIFIED (Gradle 9.8.0 / AGP 9.4.1 / Kotlin 2.4.20 / compileSdk 37 / daemon JETBRAINS 21 / JVM bounds 21–25
            / backend 0.1.72-anki26.09.3 / Robolectric 4.17)

ANDROID BUILD:
  UNVERIFIED / BLOCKED (Gradle distribution + all dependency repositories unreachable; no full JDK)

DEVICE TESTS:
  UNVERIFIED / BLOCKED (no APK, no adb, no emulator, no KVM)

REVIEWER:
  SOURCE-VERIFIED, RUNTIME-UNVERIFIED

USER DATA ISOLATION:
  BLOCKED (shared-public-storage branch demonstrated; runtime path unproven; no user data touched)

PC ANKI ADAPTER:
  EXCLUDED (absent)

NEXT GATE:
  FSA-01 PRODUCTION MIGRATION NOT AUTHORIZED
  After a legitimate lock: FSA-01A — Study-Agent Migration Discovery & Component Classification

NEXT ACTION:
  Execute the baseline build on a capable host per the closure plan; attach R4-equivalent evidence; re-review.
  Do not merge upstream 142 commits. Do not claim PASS without execution.
```

### Ordered closure plan

1. **Owner prerequisites.** Supply the original FSA-00A with provenance; decide the branch-naming and sync-waiver questions explicitly in the parent contract.
2. **Capable host.** Pinned JETBRAINS JDK 21 (full JDK, not a JRE), Android SDK platform 37 installed through the standard SDK manager, authorized egress to Gradle/Google/Plugin Portal/Maven Central/foojay, ≥8 GiB RAM (more for an emulator), a disposable Android target with KVM.
3. **Build evidence.** Re-run the seven commands at a frozen SHA with `--version` first; capture test XML/HTML, lint reports, buildSrc results, dependency graph, SDK diagnostic with the actual build-tools patch, then the APK's size, SHA-256, `applicationId`, version and signing certificate.
4. **Data safety first.** Before any rating or note creation, prove the selected collection path is disposable and not a production `/storage/emulated/0/AnkiDroid`; then run the full Reviewer, undo, lifecycle, restart and coexistence matrix; sync only with an explicitly authorized throwaway account.
5. **Independent re-review.** Only when every mandatory row passes may FSA-00 lock. No BLOCKED row may be relabelled without new execution.

A blocked gate is preferable to a fabricated PASS. Every claim above is traceable to R4-01..08 or a cited source line; nothing was executed remotely, distributed, or taken on trust from a previous report.
