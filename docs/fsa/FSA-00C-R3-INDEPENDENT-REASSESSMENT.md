# FSA-00C — Independent Baseline Reassessment R3 and Gate Decision

> **FSA-00: BLOCKED — NOT LOCKED.**
> Source equivalence and scoped source architecture audit are supported.
> Required build, test, APK, Android Reviewer and collection-isolation evidence is missing.
> FSA-00A reconciliation is blocked. **FSA-01 production migration is NOT AUTHORIZED.**

**Observation date:** 2026-10-29 UTC. **Authority:** FSA-00C audit only, no feature migration.
This is a new independent assessment at the current repository HEAD, not a claim that prior FSA-00C audits were executed at this HEAD. Prior reports and their evidence are preserved as historical snapshots. No application, build, dependency, manifest, identity, signing or scheduler change is made here. Owner roles below are suggested responsibilities, not confirmed assignments.

## 1. Repository and provenance

| Field | Result |
| --- | --- |
| Target | `Drmusab/flashcard-Android`, GitHub `fork:true`, parent/source `ankidroid/Anki-Android`, default branch `main` |
| Audited HEAD | `45b58a96dd161efb65339f4f8f1c6ef5d1138da1` |
| Branch | `arena/1a304a7c-flashcard-android` (Arena fixed session branch) |
| Worktree | Clean on entry; this reassessment adds this report and R3 evidence under `docs/fsa/evidence/00c-r3/`; no pre-existing uncommitted changes discarded. See `git status` in evidence R3-01. |
| Origin | `https://github.com/Drmusab/flashcard-Android.git`; no configured `upstream` remote |
| Reference baseline | `a7121c11c6e11d9c6ba34518784156fba1701e29` – `feat(card-templates): reposition card types` (David Allison, 2026-10-23) |
| Upstream snapshot | `210b543e8ff832073e31672494fdaa1e8a2d6549` (ankidroid/Anki-Android `main` at observation 2026-10-29) |
| Fork divergence | GitHub compare: **6 ahead / 141 behind** that upstream SHA, merge base `a7121c11c6e11d9c6ba34518784156fba1701e29`. These are snapshot counts, not a complete upstream file inventory. Upstream has advanced since R2 (`fe65770…` → `210b543…`): 141 commits ahead upstream now vs 88 at R2. |
| History | Full history available locally (24,687 commits counted from HEAD) – sandbox fetched --unshallow succeeded. Shallow flag absent. Grafted marker not present in current log (prior runs were shallow/grafted; this run has full history). However branch `arena/...` history is still merge-based; no local ancestry fabrication. |
| Baseline comparison | `git diff --name-status a7121c11..HEAD` lists **25 added files, all under `docs/fsa/`**: FSA-00B (1), seven prior FSA-00C/handoff docs (7), sixteen evidence transcripts across 00c and 00c-r2 (16), plus 1 historical R2 report. Excluding `docs/fsa/` the diff is **empty** – production Kotlin/Java, tests, build configuration, manifests, resources and dependencies are **identical** to baseline. |
| Commit evolution | Fork-only commits since baseline: 6 commits comprising FSA-00B report, two FSA-00C audit merge commits and the R2 reassessment merge. No upstream sync performed. |

At observation, remote `main` and audited HEAD match (`45b58a9` on both `origin/main` and local `main`). The 6 fork-only commits are documentation/evidence only. GitHub reports zero workflow runs for exact HEAD (check-runs empty). A documentation merge is not build evidence.

### Evidence index — R3 (current)

All paths relative to this document. Timestamps, exact commands, outputs and exit codes retained. `grep` exit 1 means no match, not a failing application test.

| ID | Evidence | Contents |
| --- | --- | --- |
| R3-01 | [01-repository.txt](evidence/00c-r3/01-repository.txt) | HEAD, branch, log, remote, status, baseline tree diff, ls docs |
| R3-02 | [02-environment.txt](evidence/00c-r3/02-environment.txt) | OS, java -version 127, SDK/daemon inventory, RAM/disk/CPU, APK search empty |
| R3-03 | [03-gradle-attempts.txt](evidence/00c-r3/03-gradle-attempts.txt) | `java -version` and 7 wrapper invocations (robolectricSdkDownload, assembleFullDebug, testFullDebugUnitTest, jacocoUnitTestReport, lintAll ktlintCheck lint-rules:test, buildSrc test) – all exit 1 with no JVM |
| R3-04 | [04-network.txt](evidence/00c-r3/04-network.txt) | 10 endpoint probes – Gradle/Google/Maven/Plugin/JitPack/Foojay TLS 35 / HTTP 000; GitHub/npm/pypi 200 |
| R3-05 | [05-github-and-baseline.txt](evidence/00c-r3/05-github-and-baseline.txt) | GitHub repo metadata, ls-remote origin/upstream, compare baseline→HEAD and HEAD→upstream, upstream commit list, fork commit list, PR list, FSA-00A search |
| R3-06 | [06-integrity-and-scans.txt](evidence/00c-r3/06-integrity-and-scans.txt) | SHA-256 anchors, prod diff empty, repository declarations, buildSrc test files, lint baseline absence, fallback keystore hash, identity scan, excluded-symbol scan |
| R3-07 | [07-source-audit.txt](evidence/00c-r3/07-source-audit.txt) | Reviewer/VM answerCardInner excerpts, undo, collection storage, Fsrs wrapper, DummyScheduler, version pins, CI commands |
| R3-08 | [08-device-and-isolation.txt](evidence/00c-r3/08-device-and-isolation.txt) | adb/emulator absent, APK absent, deep links, sync/backup surfaces |

Historical evidence (preserved, not current-head execution):

| ID | Artifact | Scope |
| --- | --- | --- |
| E01-E10 | [00c/01-10](../../FSA-00B-fork-baseline-build-verification.md) + [R2-01..06](evidence/00c-r2/) | Prior FSA-00C audits at `a7121c1`/`f821225`/`99d339e` – source pins and blocked conclusions corroborated |

## 2. Prerequisite and documentation reconciliation

- **FSA-00A: BLOCKED.** Original discovery report not found by repository/workspace filename and content searches (`find`/`grep` for FSA/00A/discovery), PR/release inspection (3 PRs are all FSA-00B/C docs), or any attachment supplied in this session. No `docs/fsa/*00A*` exists. This is not a claim that no private archive exists elsewhere. Its findings cannot be attributed, compared or recreated without the original and provenance. Classification: **BLOCKED**, not PASS.

- **FSA-00B: PARTIAL.** Report present at `docs/fsa/FSA-00B-fork-baseline-build-verification.md` (463 lines + 29k). Source pins, 9 SHA-256 anchors, baseline identity and blocked build conclusion independently corroborated by current source and fresh R3 attempts. Original observation was at `a7121c11…`; current HEAD is 25 files ahead in docs. This is not independent recovery of every original execution log – those are preserved as historical evidence.

- **Historical evidence: NOT RECONCILED in full** because FSA-00A absent. Prior FSA-00C at `f821225…` (2 ahead /17 behind) and R2 at `99d339e…` (4 ahead /88 behind) are separate historical snapshots with valid snapshot counts for their cited upstream SHAs; their blocked results are consistent with present result. Their `lint` spelling correction and daemon JVM range qualification remain valid.

Explicit qualifications (preserving originals):

1. FSA-00B §5.1 and CI `.github/workflows/lint.yml:73` specify `ktlintCheck`; §5.2 and `workflows/README.md:16` use `ktLintCheck`. Correct spelling `ktlintCheck` was attempted in R3; neither spelling reached task resolution historically.
2. FSA-00B blanket “any ≥17 launcher works” not established as unlimited guarantee. Source enforces daemon JVM 21–25 in `build.gradle.kts:205-240` and selects JetBrains 21 independently of `JAVA_HOME` via `gradle-daemon-jvm.properties` + foojay resolver 1.0.0. Actual daemon never started.
3. Instrumentation collection path is `androidTest` subdirectory of configured root, not inherently isolated. No personal root should be used.
4. Suggested sync waiver requires explicit parent-contract authority; none available – sync remains UNVERIFIED, no waiver granted.
5. Catalog pins AGP 9.4.1 despite stale adjacent comment referencing 9.0.1 (`libs.versions.toml:24-26`); actual catalog value is source pin. SDK/build-tools compatibility unverified.
6. `feature/fsa-foundation` branch naming requirement still unresolved contractually; fixed Arena branch provides equivalent isolation but was not created/switched in this session per branch lock.
7. Memory suggestion of off-record settings not acceptable; any host memory setting must be recorded.

Contributor and architecture context: `CONTRIBUTING.md`, `AI_POLICY.md`, `docs/development/gradle-daemon-jvm.md`, actual unit/lint/emulator workflows inspected. No upstream contribution, workflow dispatch or PR operation performed.

## 3. Toolchain and actual build verification

| Item | Source / observation | Result |
| --- | --- | --- |
| Gradle | `gradle/wrapper/gradle-wrapper.properties` pins **9.8.0** (`gradle-9.8.0-bin.zip`, retries 3, validateDistributionUrl true, no distributionSha256Sum) | **BLOCKED** – wrapper shell launched but no JVM; distribution not downloaded (TLS failure proven in R3-04) |
| JDK / daemon JVM | `gradle/gradle-daemon-jvm.properties`: `toolchainVendor=JETBRAINS`, `toolchainVersion=21`, 8 foojay URLs (Linux x86_64 = id 0d1a1acdc708062093673f65aa9aba4b). Root guard 21–25 in `build.gradle.kts:203-240`; daemon message explains `JAVA_HOME` does not override. CI uses `actions/setup-java` jetbrains 21, jitpack pins 21.0.10-jbr. | **BLOCKED** – clean env has no java/javac (`which java` empty, `java -version` 127). Daemon vendor/version/resolution never observed. |
| AGP / Kotlin | Catalog `androidGradlePlugin = 9.4.1`, `kotlin = 2.4.20` | Source pins verified; dependency resolution/compatibility **unverified** (no Gradle execution) |
| Android SDK | Catalog `compileSdk = 37`, `compileSdkMinor = 0`, `targetSdk = 36`, `minSdk = 24`, `apiMinSdk = 16`; `buildSrc/ankidroid.android.app.gradle.kts:18-19` applies compile 37/0. No `buildToolsVersion` pinned in tracked scripts. | **BLOCKED** – no SDK manager/platform/build-tools installed (`ANDROID_HOME` unset, no local.properties, no adb/sdkmanager). AGP-selected build-tools patch unknown until capable-host Gradle output. |
| Dependencies / Robolectric | `settings.gradle.kts` declares google(), mavenCentral(), maven(jitpack.io); `buildSrc/build.gradle.kts` adds gradlePluginPortal(). Backend `0.1.72-anki26.09.3`, testing artifact same, Robolectric 4.17 + downloader plugin `robolectricSdkDownload`. | **BLOCKED** – no graph download; 7 endpoint TLS failures prove network boundary, not incompatibility |
| APK / metadata | `AnkiDroid/build/outputs` absent; `find . -name *.apk` empty | **NOT PRODUCED** – path/size/hash/package/version/variant/certificate unavailable; no reproducibility claim |

Host inventory (R3-02): Debian 12 x86_64, 2 CPUs, 3.8 GiB RAM (no swap), ~19 GiB free disk (21G root, 7% used), no Android tools, no `/dev/kvm`. Memory is readiness risk (daemon -Xmx3072M + test forks 2 GiB each) not observed OOM. No unauthorized mirror, substitution or downgrade used. Network probes confirm sandbox allowlist restricts Gradle/Google/Maven/Plugin/JitPack/Foojay but allows github/api/pypi/npm – consistent with FSA-00B.

### Commands and results (R3-03)

Each command executed independently, without changing project configuration. Timeout 30s; all fail before Gradle JVM startup.

```
$ java -version
bash: java: command not found
exit 127

$ ./gradlew --version
ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.
exit 1

$ ./gradlew robolectricSdkDownload
ERROR: JAVA_HOME ... (same)
exit 1

$ ./gradlew :AnkiDroid:assembleFullDebug
ERROR: JAVA_HOME ... (same)
exit 1

$ ./gradlew :AnkiDroid:testFullDebugUnitTest
exit 1

$ ./gradlew jacocoUnitTestReport
exit 1  (aggregate CI path – tests_unit.yml:181)

$ ./gradlew lintAll ktlintCheck lint-rules:test
exit 1  (ci lint.yml:73 correct spelling; README.md old spelling noted)

$ ./gradlew -p buildSrc test
exit 1
```

**No Gradle task executed.** No SDK diagnostic, dependency graph, compiler diagnostic, test XML/HTML, lint output or build-logic result. Counts of passed/failed tests unavailable, not inferred from source files. Exact-HEAD Actions query returned zero runs (R3-05). No remote green substituted.

Canonical tasks (source/CI corroborated, R3-07):

- `full`+`debug` defines `AnkiDroid/build.gradle.kts:184-265` with `.debug` suffix, versionNameSuffix `-debug`, universal ABI output.
- Unit: `tests_unit.yml:177,181` runs `robolectricSdkDownload` then `jacocoUnitTestReport` (aggregate); explicit `testFullDebugUnitTest` also valid.
- Lint: `lint.yml:53,73` runs buildSrc tests + `lintAll ktlintCheck lint-rules:test`; `lintAll` pins AnkiDroid to lintFullDebug (`build.gradle.kts:184-200`), AndroidLint convention `abortOnError=true`, warnings as errors, `lint-release.xml`.
- No `lint-baseline*.xml` found; `lint-release.xml` is severity configuration, not clean result. `.editorconfig` is formatting policy.
- Build-logic tests: 8 Kotlin tests in `buildSrc/src/test` + fixtures; input files `../AnkiDroid/build.gradle.kts` + version catalog.

## 4. Device, Reviewer and data-safety verification

**All BLOCKED or UNVERIFIED – no device execution performed, by design to protect user data.**

| Field | Current result | Evidence |
| --- | --- | --- |
| Disposable environment | **BLOCKED** – no emulator/device/adb/KVM | R3-02, R3-08: `adb: not found`, no sdk, `/dev/kvm` absent |
| App launch | **BLOCKED** – no APK to install | R3-08 APK search empty |
| Deck access | **BLOCKED** | |
| Question/Answer reveal | **BLOCKED** | |
| Again/Hard/Good/Easy (native path) | **BLOCKED** – native pipeline inspected in source only, runtime unproven | R3-07 excerpts; R3-02 no target |
| Undo | **BLOCKED** – source path inspected, behavior unproven | R3-07 |
| Session end/restart persistence | **BLOCKED** | |
| Process recreation / lifecycle | **BLOCKED** | |
| Navigation | **BLOCKED** | |
| Coexistence vs official | **BLOCKED** – source IDs verified, installation not tested | R3-06 |
| Collection isolation | **BLOCKED** – shared-storage risk exposed in source; runtime path unproven | R3-07 CollectionHelper, InitialActivity |
| Sync | **UNVERIFIED – TEST ACCOUNT NOT AUTHORIZED** – no parent waiver; no authorized disposable account provided; correctly not attempted | R3-08 |

**Procedure that must be executed on capable host before lock:**

Fresh emulator or disposable device profile, FullDebug universal APK (`com.ichi2.anki.debug`), app-private or fully disposable collection path (never point first-run at production `/AnkiDroid` or personal backup), no production AnkiWeb account. Capture logcat/screenshot for launch → create deck/note → review → each rating → undo → end session → restart → navigation → coexistence spot-check. Only with explicitly authorized throwaway AnkiWeb account may disposable sync be tested with isolated data; never waive mandatory checks.

Instrumentation aggregate `:AnkiDroid:connectedFullDebugAndroidTest` (or CI `TEST_RELEASE_BUILD=true :connectedPlayReleaseAndroidTest` via `run_emulator_tests.py`) mirrors CI emulator coverage for debug type.

## 5. Architecture safety (source-level)

| Field | Result and qualification |
| --- | --- |
| NATIVE SCHEDULER | **UNCHANGED** in source; `Reviewer.kt:1580-1600` and `ReviewerViewModel.kt:527-541` both delegate to `sched.answerCard` inside `undoableOp`; runtime rating/undo still BLOCKED |
| PC ANKI ADAPTER | **ABSENT** – zero hits case-insensitive scan for PcAnki/AnkiConnect/BackendRegistry in tracked Kotlin/Java (R3-06) |
| ANKICONNECT SCHEDULING | **ABSENT** – excluded |
| SECOND FSRS / DUAL SCHEDULER | **ABSENT** as separate engine; `AnkiDroid/scheduling/Fsrs.kt` is version-display wrapper over `BackendBuildConfig.FSRS_VERSION`; `libanki/sched/DummyScheduler.kt` throws for old v1/v2, not functioning engine |
| STUDY-AGENT MIGRATION | **NOT STARTED** – no Study-Agent symbols found; exact prod diff empty proves no client code copied |
| RELEASE IDENTITY | **UNCHANGED** – release `com.ichi2.anki` (line 101), debug `+ .debug` (187), `customSuffix` property retained; authorities templated `${applicationId}` |
| USER DATA SAFETY | **BLOCKED** for Android coexistence/isolation certification; no user collection touched by this audit (R3-08). Shared-storage risk remains: `SetupStorage.legacyAnkiDroidDirectory` uses primary shared external storage root + `AnkiDroid` (`/storage/emulated/0/AnkiDroid` on typical emulated storage); `InitialActivity` chooses PUBLIC for legacy permission sets; `FileProvider` filepaths includes broad `external-path .` plus cache/export; `allowBackup true` without explicit backup rules. |

Detailed mapping in companion audit doc and source excerpts R3-07.

## 6. Independent audit matrix (18)

| Audit ID / subject | Result | Source evidence | Execution evidence | Defect / limitation | Remediation | Residual risk |
| --- | --- | --- | --- | --- | --- | --- |
| AUDIT-00C-01 Fork/upstream identity | **PASS** | Origin & GitHub parent/source metadata | R3-01/05 identity, heads, ls-remote upstream | Remote snapshot advances | Preserve exact SHAs; reobserve | R-13 |
| AUDIT-00C-02 Baseline integrity | **PASS** | Reference & HEAD trees; 9 matching SHA-256 hashes | R3-05/06 local diff excludes only docs/fsa (25 files), exit 0; hashes match R2 & FSA-00B | Local ancestry previously shallow, now full (24687) | Retain API + local diff evidence | R-13 |
| AUDIT-00C-03 Worktree/branch safety | **PASS** | Fixed Arena branch, unchanged tracked baseline | R3-01 status/staged clean, worktree list | Foundation-branch naming contract unresolved | Keep fixed branch; obtain owner acceptance | R-10 |
| AUDIT-00C-04 FSA-00A/B reconciliation | **BLOCKED** | B present; A absent | R3-05 PR/release/search, 00c-R2 hashes | No original A; B partially corroborated | Obtain original with provenance | R-04 |
| AUDIT-00C-05 Version integrity | **PASS (pins only)** | Wrapper/catalog/daemon criteria/root bounds/buildSrc | R3-06 hashes; R3-07 numbered pins | Daemon JVM/Gradle resolution blocked | Execute pinned toolchain on capable host | R-01/R-02 |
| AUDIT-00C-06 SDK/dependency readiness | **BLOCKED** | SDK 37, repo/backend definitions | R3-02 inventory, R3-04 TLS 35 ×6 + GitHub 200 | No SDK; build-tools unresolved; deps unavailable | Standard SDK + authorized network | R-02/R-09/R-11 |
| AUDIT-00C-07 APK compilation | **BLOCKED** | FullDebug config exists | R3-03 assemble exit 1 before JVM | No compiler verdict | Execute frozen FullDebug build | R-01/R-02/R-05 |
| AUDIT-00C-08 Unit-test integrity | **BLOCKED** | FullDebug & aggregate tasks | R3-03 both scopes exit 1; no XML | No measured outcomes | Run both scopes, collect XML/HTML | R-05 |
| AUDIT-00C-09 Lint/style | **BLOCKED** | lintAll/config/editor/lint.yml | R3-03 correct ktlintCheck exit 1 | Errors/warnings unmeasured | Run unchanged rules, retain reports | R-05 |
| AUDIT-00C-10 Build-logic tests | **BLOCKED** | buildSrc test config & lint CI | R3-03 buildSrc exit 1 | Test sources exist ≠ execution | Run buildSrc tests with SDK where needed | R-05 |
| AUDIT-00C-11 APK identity/signing/hash | **BLOCKED** | Source debug ID/signing expectations | R3-02 APK search empty; no tools | No binary/package/cert evidence | Inspect built APK with apkanalyzer/aapt2/apksigner & hash | R-05/R-07 |
| AUDIT-00C-12 Native scheduler authority | **PASS (source)** | Reviewer/VM → undoableOp → libanki/backend (R3-07) | R3-05/06 unchanged tree; exclusion scan | Backend binary/runtime unproven | Preserve authority; complete artifact/device evidence | R-03/R-05 |
| AUDIT-00C-13 Rating/undo behavior | **BLOCKED** | Native pipeline inspected | R3-02 no target; no Android execution | Behavioral proof requires device | Execute device matrix with disposable collection | R-03/R-05/R-06 |
| AUDIT-00C-14 Data/storage isolation | **BLOCKED** | AppId/provider & storage sources | R3-02/08 no runtime path; shared-storage risk exposed | Runtime path unproven | Verify actual path before mutation; paired-install test | R-06/R-12 |
| AUDIT-00C-15 No PC Adapter/second scheduler | **PASS (source)** | No adapter symbols; Fsrs wrapper/DummyScheduler clarified | R3-06 scans + tree diff | Binary not reverse-audited | Maintain exclusion; future gates enforce | R-05 |
| AUDIT-00C-16 No Study-Agent migration in FSA-00 | **PASS** | Exact diff empty outside docs/fsa | R3-05 diff | – | Keep migration for FSA-01A, subject to isolation | – |
| AUDIT-00C-17 No unauthorized upstream merge | **PASS** | HEAD frozen; no merge commit from upstream | R3-01/05 log, diff vs upstream shows 6 ahead only | – | Do not merge upstream during verification | R-11 |
| AUDIT-00C-18 Truthful verification & lock decision | **PASS** | This report cites only executed evidence | R3-01..08 transcripts retained | – | No PASS without execution; gate remains BLOCKED | – |

Source inspection alone does not satisfy mandatory runtime/build audits – those remain BLOCKED as shown.

## 7. Verification matrix (30)

| ID | Check | Result |
| --- | --- | --- |
| VER-00C-01 Current HEAD recorded | **PASS** – `45b58a9…` in R3-01 | 
| VER-00C-02 Baseline reachable & equivalence | **PASS** – full-history checkout, `a7121c1…` reachable, diff outside docs/fsa empty | 
| VER-00C-03 No unexplained prod modifications | **PASS** – R3-05/06 | 
| VER-00C-04 Fork/upstream relation | **PASS** – R3-05 origin/upstream ls-remote + GitHub compares | 
| VER-00C-05 FSA-00A reconciliation | **BLOCKED** – original unavailable (R3-05) | 
| VER-00C-06 FSA-00B evidence | **PARTIAL** – pins/hashes/branch corroborated; not full log recovery | 
| VER-00C-07 JDK & daemon JVM | **BLOCKED** – `java -version` 127 (R3-02/03) | 
| VER-00C-08 Gradle wrapper executes | **BLOCKED** – wrapper shell exits 1 before Gradle (R3-03) | 
| VER-00C-09 Dependencies resolve | **BLOCKED** – TLS 35 failures (R3-04) | 
| VER-00C-10 Robolectric preparation | **BLOCKED** – same exit 1 (R3-03) | 
| VER-00C-11 FullDebug APK builds | **BLOCKED** – exit 1, no APK (R3-03/02) | 
| VER-00C-12 Unit tests pass | **BLOCKED** – both scopes exit 1, no XML (R3-03) | 
| VER-00C-13 Lint/style pass | **BLOCKED** – exit 1, no reports (R3-03) | 
| VER-00C-14 Build-logic tests pass | **BLOCKED** – exit 1 (R3-03) | 
| VER-00C-15 APK hash/identity | **BLOCKED** – NOT PRODUCED (R3-02) | 
| VER-00C-16 Disposable collection verified | **BLOCKED** – no device/APK (R3-08) | 
| VER-00C-17 App launches | **BLOCKED** | 
| VER-00C-18 Deck access | **BLOCKED** | 
| VER-00C-19 Q/A reveal | **BLOCKED** | 
| VER-00C-20 Native ratings | **BLOCKED** – source pipeline PASS but runtime BLOCKED | 
| VER-00C-21 Undo | **BLOCKED** | 
| VER-00C-22 Lifecycle survival | **BLOCKED** | 
| VER-00C-23 Official data untouched | **PASS (audit)** – no collection operation; isolation runtime still BLOCKED | 
| VER-00C-24 Provider/deep-link risks | **PASS (source)** – authorities templated, handlers identified (R3-06/07/08) | 
| VER-00C-25 No PC Adapter | **PASS (source)** | 
| VER-00C-26 No AnkiConnect scheduling | **PASS (source)** | 
| VER-00C-27 No alternate FSRS | **PASS (source)** – wrapper/dummy clarified | 
| VER-00C-28 No unauthorized migration | **PASS** – exact diff | 
| VER-00C-29 No release-signing violation | **PASS (audit)** – no APK built/distributed; fallback key risk documented | 
| VER-00C-30 Exact evidence attached | **PASS** – R3-01..08 transcripts | 

Mandatory build/device rows remain BLOCKED; optional sync is UNVERIFIED.

## 8. Residual risks and ordered closure

All risks are **BLOCKED** for gate lock except as noted. See companion residual-risks register for owners/actions.

| Risk | Severity | Blocks? |
| --- | --- | --- |
| R-01 No JDK/daemon | Critical | **YES** |
| R-02 No SDK/repo access | Critical | **YES** |
| R-03 No device/Reviewer proof | Critical | **YES** |
| R-04 Missing FSA-00A provenance | High | **YES** |
| R-05 No APK/tests/lint artifact | High | **YES** |
| R-06 Shared-storage isolation (public `AnkiDroid` can be selected, runner path nested) | Critical for data | **YES** |
| R-07 Release ID collision / fallback public key | High for distribution | **NO for debug-only FSA-00; YES for release** |
| R-08 Sync authorization/waiver | High | **YES** until resolved |
| R-09 RAM (3.8 GiB + 3 GiB daemon + 2 GiB forks) | Medium | **YES to readiness** |
| R-10 Foundation-branch naming contract | Low-technical | **YES if mandatory** |
| R-11 No distribution checksum/lockfile (inherited) | Medium | **NO alone**; actual verification still blocked |
| R-12 Deep-link/file-grant/backup routing | Medium | **YES via R-06** |
| R-13 History (now resolved) – was shallow, now full | Low | **NO** |

Closure order: 1) Owner prerequisites (FSA-00A original + parent contract for branch/sync), 2) Capable build host (JetBrains 21, SDK 37, authorized network, adequate memory, disposable Android target), 3) Re-execute 7 wrapper commands and collect XML/lint/APK hash/identity/signature + rebuild comparison, 4) Prove disposable storage/account separation before any mutation, then execute full Reviewer/lifecycle/coexistence matrix, 5) Independent re-review – only then may FSA-00 lock and FSA-01A activate. Never distribute fallback-signed release; never operate on personal collection.

## 9. Gate decision

```
FSA-00:
  BLOCKED

SOURCE AUDIT:
  PASS (equivalence + source architecture)

TOOLCHAIN PINS:
  VERIFIED (Gradle 9.8.0 / AGP 9.4.1 / Kotlin 2.4.20 / compileSdk 37 / JetBrains 21 / backend 0.1.72-anki26.09.3 / Robolectric 4.17)

ANDROID BUILD:
  BLOCKED (no JVM, no SDK, no dependency access)

DEVICE TESTS:
  BLOCKED (no target/APK)

REVIEWER:
  SOURCE-VERIFIED, RUNTIME-UNVERIFIED

USER DATA ISOLATION:
  BLOCKED (shared-storage risk identified, runtime unproven)

PC ANKI ADAPTER:
  EXCLUDED (absent in source, no forbidden symbols)

NEXT GATE:
  FSA-01 PRODUCTION MIGRATION NOT AUTHORIZED
  Next gate after verified lock: FSA-01A — Study-Agent Migration Discovery & Component Classification (classification only, no copy)

NEXT ACTION:
  Execute baseline build on capable host per §§3-4; attach evidence; re-review. Do not merge upstream 141 commits. Do not claim PASS without execution.
```

A blocked gate is preferable to a fabricated PASS. This reassessment preserves prior evidence as historical and adds current execution evidence. FSA-00 cannot inherit unverified claims as proven.

---

*This R3 reassessment supersedes prior gate snapshots for decision purposes; prior snapshots remain valid historical evidence for their cited SHAs. All conclusions supported by source, logs or executed tests cited above.*
