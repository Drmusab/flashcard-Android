# FSA-00C R5 — independent baseline verification and gate decision

**FSA-00: BLOCKED, NOT LOCKED. FSA-01 production migration is not authorized.** Audit date 2026-10-29 UTC; evaluated source HEAD `f441f267b9876e07c99db6fa1912f47f1170d75e`, branch `arena/11b3224c-flashcard-android`. Worktree was clean on entry; this assessment adds documentation and execution evidence only. No personal collection, device, sync, release, signing configuration, source code or upstream merge was touched. Prior reports remain historical snapshots, not proof of builds at this revision.

## Repository and historical evidence

Origin is `https://github.com/Drmusab/flashcard-Android.git`; no upstream remote is configured. GitHub identifies it as a fork of `ankidroid/Anki-Android`. Fork HEAD and remote main were `f441f267…`; upstream main observed as `c21570b0a5139fe0823568f8fa29460aa9be6066`. GitHub compare reports **10 ahead, 142 behind**, merge base `a7121c11c6e11d9c6ba34518784156fba1701e29`; upstream-only changes were not merged. Numbers are a point-in-time snapshot.

The checkout arrived shallow at one commit with the baseline object missing. `git fetch --unshallow origin` succeeded, `git rev-parse --is-shallow-repository` returned false, baseline object is a commit and `git merge-base --is-ancestor <baseline> HEAD` returned 0. No graft file was present on entry. `git diff --name-status <baseline> HEAD -- ':(exclude)docs/fsa'` is empty: all 43 changed files are FSA documents/evidence. Thus production Kotlin/Java, tests, manifests, resources, builds and dependency configuration match the baseline source. The delta from R4's `f506261…` is likewise documentation and R4 evidence only. Source equivalence is not runtime proof. See [repository evidence](evidence/00c-r5/repository-environment-source.txt) and historical [R4 audit](FSA-00C-R4-INDEPENDENT-AUDIT.md).

**FSA-00A BLOCKED:** tracked filenames, available workspace and accessible all-ref docs history searches found no original report; no attachment was supplied. This does not establish absence from private archives. Assertions cannot be reconciled or reconstructed. **FSA-00B PARTIAL:** its report exists; pins and blocked conclusion are consistent with current source and execution, but this is not recovery of missing 00A or independent replay of 00B's historical execution. Historical reconciliation overall is **NOT RECONCILED**.

Corrections are explicit rather than overwriting old evidence: FSA-00B and `workflows/README.md` use `ktLintCheck`, while `.github/workflows/lint.yml:73` uses `ktlintCheck`. FSA-00B's launcher/JAVA_HOME discussion is not proof of the actual daemon: `gradle/gradle-daemon-jvm.properties` selects JetBrains 21 and root build logic enforces JVM 21–25. Prior R4's `f506261…`, 8/142 divergence, prior branch, and full-history state were observations of that session, not current HEAD. The current session again started shallow, then unshallowed. Its report's JVM was a JRE, not a full JDK. Instrumentation subdirectory placement beneath a configured collection root is not proof of data isolation. A sync waiver or foundation-branch naming waiver cannot be granted by this audit.

## Executed build and environment evidence

Source pins: wrapper Gradle **9.8.0**, AGP **9.4.1**, Kotlin **2.4.20**, compile SDK **37**, daemon vendor **JETBRAINS** JVM **21**; build JVM accepted range 21–25. Java source compatibility is not the daemon version. Shell `java -version` was unavailable; a JRE from `jdk4py==21.0.8.2` downloaded from allowed PyPI was used solely to execute the wrapper: Temurin 21.0.8+9, no `javac`, not the pinned JetBrains daemon. Actual daemon selection could not be observed. No full JDK, SDK location, `adb`, emulator or APK found; approximately 19 GiB free, 3.8 GiB RAM, no swap. RAM is a readiness risk, not an observed OOM. SDK build-tools patch cannot be inferred without a real SDK/build diagnostic.

Each invocation below was executed with `JAVA_HOME=/tmp/fsa00c-jvm/extracted/jdk4py/java-runtime`, its `bin` on PATH and `GRADLE_USER_HOME=/tmp/fsa00c-gradle`. Logs include command, exception and exit code; parallel wrappers shared this empty Gradle cache. **Every invocation exited 1** with four failed distribution downloads and `SSLHandshakeException: Remote host terminated the handshake`, before Gradle initialized or any task ran:

| Command | Evidence | Result |
|---|---|---|
| `./gradlew --version` | [version](evidence/00c-r5/version.txt) | BLOCKED |
| `./gradlew robolectricSdkDownload` | [robolectric](evidence/00c-r5/robolectric.txt) | BLOCKED |
| `./gradlew :AnkiDroid:assembleFullDebug` | [assemble](evidence/00c-r5/assemble.txt) | BLOCKED |
| `./gradlew :AnkiDroid:testFullDebugUnitTest` | [unit](evidence/00c-r5/unit.txt) | BLOCKED |
| `./gradlew jacocoUnitTestReport` | [jacoco](evidence/00c-r5/jacoco.txt) | BLOCKED |
| `./gradlew lintAll ktlintCheck lint-rules:test` | [lint](evidence/00c-r5/lint.txt) | BLOCKED |
| `./gradlew -p buildSrc test` | [buildsrc](evidence/00c-r5/buildsrc.txt) | BLOCKED |

Thus Gradle, pinned JDK/daemon, SDK, dependency resolution, Robolectric preparation, compilation, unit tests, lint/style and build-logic tests are **BLOCKED**, not failures on code merits. No XML/HTML test or lint results, finding counts, APK, size, hash, measured application ID, version, signing fingerprint or rebuild exist. Reproducibility is unverified. `settings.gradle.kts` declares Google, Maven Central, Plugin Portal and JitPack; project repository enforcement is commented out. Actual resolved repositories, substitutions, artifact integrity and approved backend artifacts cannot be validated without resolution. The wrapper lacks a distribution checksum; dependency integrity deserves review on an authorized host. No untrusted mirror or modified pins were introduced.

## Device and architectural safety

All device results **BLOCKED**: launch, deck, question, reveal, Again/Hard/Good/Easy, undo, session end, restart, navigation, lifecycle/process recreation, disposable collection location and app coexistence. No device or APK was available, hence no runtime assertion. Sync **UNVERIFIED — TEST ACCOUNT NOT AUTHORIZED**; parent-contract permission for an optional waiver was not supplied.

The baseline comparison establishes no new scheduler or migration code. Scoped source inspection: `AnkiDroid/src/main/java/com/ichi2/anki/Reviewer.kt:1580-1587` calls `sched.answerCard` under `undoableOp`; `AbstractFlashcardViewer.kt:864-885` forwards rating; `ui/windows/reviewer/ReviewerViewModel.kt` manages viewer commands; `libanki/src/main/java/com/ichi2/anki/libanki/sched/Scheduler.kt:130-144,172` delegates answers to `col.backend.answerCard`. Native scheduler authority is **UNCHANGED at source**; behavior including duplicate rating after lifecycle restoration and undo is **not runtime verified**. Scoped searches for `PcAnkiBackend`, `PcAnkiAvailabilitySource`, `AnkiConnect`, `RatingCommit` and remote review queue names produced no matches outside FSA docs; searches are not a mathematical proof of absence under all names. Baseline comparison shows no new PC adapter, alternate FSRS or Study-Agent migration. Historical R4 source excerpts and scans give additional scope and paths ([R4 source](evidence/00c-r4/07-source-audit.txt)).

Source identity: `AnkiDroid/build.gradle.kts:101,187` sets release `com.ichi2.anki`, debug suffix `.debug`. Manifest lines 45, 633, 642 use `${applicationId}` for permission/provider authorities; intent filters include browsable links, `allowBackup=true`, and cleartext is enabled. FileProvider and public storage paths and fallback signing are discussed in [R4 identity evidence](evidence/00c-r4/08-identity-storage-device.txt); the relevant source is unchanged. Debug package distinction **does not guarantee storage isolation**: configured public storage can select shared `/storage/emulated/0/AnkiDroid`. Never mutate that path when it belongs to an official installation. Merged manifest, routing, backup/restore and actual selected collection path remain unverified. Do not distribute with public fallback signing credentials, install the fork release over official AnkiDroid, or suggest uninstalling the official app. Independent release identity and keys remain FSA-02 work. User data safety: **BLOCKED** as a coexistence claim; this audit performed no collection operations.

Note on evidence: two exploratory grep paths in the R5 repository log were incorrect and emitted `No such file or directory`; corrected actual paths are cited above. This is a diagnostic error, not evidence of missing source or a test result.

## Independent audit matrix

Every row uses source evidence S (baseline diff and source locations above), execution evidence E (R5 logs above), or historical evidence H (R4 audit); remediation and residual risk are mapped to the risk register below. PASS is explicitly scoped, not a claim of runtime verification.

| AUDIT-00C | Result | Source / execution evidence; limitation | Remediation / residual risk |
|---|---|---|---|
| 01 identity | PASS | S + GitHub compare E: fork/parent confirmed | Re-observe remote; R13 |
| 02 baseline integrity | PASS | S + ancestor and empty non-doc diff E | Freeze revision; R13 |
| 03 branch/worktree | PASS | entry clean, fixed session branch, unshallow E | Branch naming contract remains R10 |
| 04 00A/B | BLOCKED | S/H: 00B partial, 00A absent | R4 |
| 05 version integrity | BLOCKED | S pins match; E launcher JRE only, daemon unresolved | R1 |
| 06 SDK/dependencies | BLOCKED | S repos; E wrapper fetch failure, no SDK | R2 |
| 07 APK compilation | BLOCKED | E assemble exit 1 before Gradle | R2, R5 |
| 08 unit execution | BLOCKED | E unit and jacoco exit 1, no results | R5 |
| 09 lint/style | BLOCKED | E lint exit 1; no findings measured | R5 |
| 10 build logic | BLOCKED | E buildsrc exit 1 | R5 |
| 11 artifact identity/signing | BLOCKED | S identity/fallback only; E no APK | R5, R7 |
| 12 native scheduler authority | PASS (source only) | S Reviewer → scheduler → backend; E non-doc diff empty | Runtime verification R3 |
| 13 rating/undo | BLOCKED | S undoable operation; E no device execution | R3 |
| 14 data isolation | BLOCKED | S shared storage branch; E no device | R6, R12 |
| 15 PC/second scheduler | PASS (scoped source) | S unchanged from baseline; symbol scan | Review future changes; R3 |
| 16 no migration | PASS | E baseline non-doc delta empty | Maintain scope; R13 |
| 17 no upstream merge | PASS | E history and compare; no merge performed | Freeze SHA; R13 |
| 18 truthful lock | PASS | E commands failed before tasks; decision blocked | Resolve mandatory checks R1–R6/R8 |

## Authoritative verification matrix

| VER-00C | Result and evidence |
|---|---|
| 01 | PASS — current HEAD above, repository E |
| 02 | PASS — baseline ancestor, E |
| 03 | PASS — empty non-doc diff, E |
| 04 | PASS — fork/upstream GitHub compare, E |
| 05 | BLOCKED — 00A absent |
| 06 | PASS — 00B classified PARTIAL, historical evidence not reconciled |
| 07 | BLOCKED — JRE only; daemon not observed |
| 08 | BLOCKED — launcher executed; distribution failed |
| 09 | BLOCKED — no dependency resolution |
| 10 | BLOCKED — Robolectric task never ran |
| 11 | BLOCKED — assemble never ran |
| 12 | BLOCKED — unit tasks never ran |
| 13 | BLOCKED — lint/style never ran |
| 14 | BLOCKED — build logic never ran |
| 15 | BLOCKED — no APK |
| 16 | BLOCKED — no disposable collection verified |
| 17 | BLOCKED — no launch |
| 18 | BLOCKED — no deck test |
| 19 | BLOCKED — no reveal test |
| 20 | BLOCKED — no ratings tested |
| 21 | BLOCKED — no undo tested |
| 22 | BLOCKED — no lifecycle test |
| 23 | PASS (audit activity only) — no collection accessed; coexistence isolation BLOCKED |
| 24 | PASS (source risk identification) — authority/deep-link/backup risks above; runtime blocked |
| 25 | PASS (scoped source) — no new PC adapter, scan |
| 26 | PASS (scoped source) — no new AnkiConnect path, scan |
| 27 | PASS (scoped source) — no new alternate FSRS, unchanged baseline |
| 28 | PASS — no production migration, diff |
| 29 | PASS (audit activity only) — nothing built, signed or distributed; release risk open |
| 30 | PASS — exact commands, exits and logs above |

## Residual risk register and closure

| ID / severity | Evidence and consequence | Owner | Required action | Blocks lock? |
|---|---|---|---|---|
| R1 critical | JRE only, JetBrains daemon not observed; build toolchain unknown | Build maintainer | Obtain full JDK and verify pinned daemon on capable host | YES |
| R2 critical | Wrapper TLS failure, no SDK; no dependency resolution | Build infrastructure | Authorized Gradle/Google/Maven/Plugin Portal/JitPack/foojay access; standard SDK 37; record actual build tools and dependencies | YES |
| R3 critical | No APK/device; Reviewer and lifecycle behavior unknown | Android QA | Disposable device/emulator; run complete table, preserve logs | YES |
| R4 high | Original 00A absent; claims cannot be reconciled | Product owner | Supply original with provenance and reconcile | YES |
| R5 high | No APK, test/lint results, hash or signing fingerprint | Build maintainer | Re-run all seven commands at frozen SHA; retain XML/HTML and APK identity/hash/signature; rebuild for reproducibility if required | YES |
| R6 critical | Public storage may be shared with official app | QA/security | Verify actual disposable collection path before any mutation; test coexistence and restore | YES |
| R7 high | Release ID collision and publicly known fallback signing | Release owner | No public fallback-signed distribution; decide separate identity/key custody in FSA-02 | NO for debug baseline; YES for release |
| R8 high | Sync untested, no authorized account or permitted waiver | Product owner/QA | Authorize disposable account and data or establish explicit parent-contract waiver | YES until resolved |
| R9 medium | 3.8 GiB/no swap vs project heaps; no OOM observed | Build infrastructure | Use capable host; document resources | YES if it prevents required evidence |
| R10 low | Fixed session branch differs from historical foundation branch name | Product owner | Resolve whether literal naming is mandatory without changing this session branch | YES if contractual |
| R11 medium | Wrapper checksum absent; dependency resolution unobserved | Build/security | Review source/repository integrity and artifact hashes on capable host | NO alone; R2 blocks readiness |
| R12 medium | Deep links, grants and backup surfaces may route/share data | Android security | Inspect merged manifest and test routing and backup on isolated devices | YES via isolation |
| R13 low | Remote moves; checkout initially shallow | Repository maintainer | Record new SHAs and recompare for each decision | NO |

Blocker reassessment B-01: full pinned JDK remains absent (JRE available); B-02: wrapper network blocked; B-03: SDK/device absent; B-04: 00A absent; B-05: low-memory readiness risk only; B-06: naming unresolved, fixed branch retained; B-07: shallow state resolved locally by unshallow; B-08: identity/storage risks remain. No unsupported workaround was applied.

**Closure order:** obtain 00A and resolve contract questions; provision a capable authorized host with full JDK, SDK and network; run and archive build/test/artifact evidence at the exact SHA; prove collection isolation before first mutation; run Reviewer, coexistence, lifecycle and authorized sync tests; obtain independent re-review. Do not waive mandatory tests. Only after legitimate lock, FSA-01A may inventory and classify Study-Agent components, retaining native Reviewer/libanki authority and excluding PC adapters, registry, AnkiConnect scheduling, remote queue and duplicate FSRS. The existing [conditional handoff](FSA-01-HANDOFF.md) is withheld, not authorization.
