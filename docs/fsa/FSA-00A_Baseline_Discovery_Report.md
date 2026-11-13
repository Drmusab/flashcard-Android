# FSA-00A — Baseline Discovery & Architecture Contract

**Project:** Anki Studio Agent (AnkiDroid fork)  
**Discovery date:** 2026-10-25  
**Target:** `https://github.com/Drmusab/flashcard-Android`, branch `main`  
**Upstream:** `https://github.com/ankidroid/Anki-Android`  
**Reference only:** `https://github.com/Drmusab/Study-Agent-Client`  
**Scope:** Source-level remote discovery only. No repository mutation or product feature implementation.

## 1. Decision

| Criterion | Status |
|---|---|
| Remote fork identity and branch | VERIFIED |
| Fork's remote HEAD | VERIFIED: `a7121c11c6e11d9c6ba34518784156fba1701e29` |
| Upstream's remote HEAD when checked | `fe6577031a7c2a875981f963c36aea5c5fe529bf` |
| Divergence at check time | Upstream 17 commits ahead of fork base; do not merge automatically |
| Kotlin/Gradle/Android version configuration | SOURCE-VERIFIED |
| Reviewer and scheduler integration sites | SOURCE-VERIFIED, no runtime proof |
| Application identity baseline | SOURCE-VERIFIED; full coexistence audit deferred to FSA-02 |
| Local `git status`/worktree of fork | UNVERIFIED: no checkout available |
| Gradle configuration | NOT RUN |
| APK compilation / unit tests / lint | NOT RUN |
| Emulator / real device | NOT RUN |
| FSA-00A discovery | COMPLETED at source inspection level |
| **FSA-00 baseline lock** | **BLOCKED pending reproducible Gradle + Android evidence** |

Do not confuse a successfully inspected repository with a successfully built Android app.

## 2. Repository and toolchain

Sources:
- [Fork repository](https://github.com/Drmusab/flashcard-Android)
- [Wrapper](https://github.com/Drmusab/flashcard-Android/blob/main/gradle/wrapper/gradle-wrapper.properties)
- [Version catalog](https://github.com/Drmusab/flashcard-Android/blob/main/gradle/libs.versions.toml)
- [Root build](https://github.com/Drmusab/flashcard-Android/blob/main/build.gradle.kts)
- [App build](https://github.com/Drmusab/flashcard-Android/blob/main/AnkiDroid/build.gradle.kts)
- [Daemon JDK pin](https://github.com/Drmusab/flashcard-Android/blob/main/gradle/gradle-daemon-jvm.properties)

| Component | Source-configured value |
|---|---|
| Gradle distribution | 9.8.0 |
| Android Gradle Plugin | 9.4.1 |
| Kotlin | 2.4.20 |
| Gradle daemon JDK | JetBrains JDK 21 pin; root allows JVM 21–25 |
| compileSdk | 37 |
| minSdk | 24 |
| targetSdk | 36 |
| primary app module | `:AnkiDroid` |
| other major modules | `:libanki`, `:api`, `:note-editor`, `:anki-common`, `:common`, `:common:android`, `:compat`, `:vbpd`, `:widgets`, `:lint-rules`, `:baselineprofile` |
| product flavors | `play`, `amazon`, `full` |
| standard applicationId | `com.ichi2.anki` |
| debug suffix | `.debug` |
| instrumentation ID | `com.ichi2.anki.tests` (source-configured; exact resulting variants still require verification) |

**Important:** The build system is not interchangeable with the older Study-Agent-Client (`:app`, Kotlin/AGP/SDK differing). The fork must own its own Gradle setup. `JAVA_HOME` alone does not override the pinned Gradle daemon toolchain.

## 3. Native reviewer integration map

Source:
- [Reviewer.kt](https://github.com/Drmusab/flashcard-Android/blob/main/AnkiDroid/src/main/java/com/ichi2/anki/Reviewer.kt)
- [AnswerButtons.kt](https://github.com/Drmusab/flashcard-Android/blob/main/AnkiDroid/src/main/java/com/ichi2/anki/reviewer/AnswerButtons.kt)
- [ReviewerBinding.kt](https://github.com/Drmusab/flashcard-Android/blob/main/AnkiDroid/src/main/java/com/ichi2/anki/reviewer/ReviewerBinding.kt)

Observed source-level entry points:
1. `Reviewer.displayCardQuestion()` / `Reviewer.displayCardAnswer()` relate to question/answer display, but are **not yet approved event hooks** for a new service. Existing delayed mutation/race logic must be preserved.
2. `Reviewer.executeCommand(which: ViewerCommand, fromGesture: Gesture?)` dispatches supported reviewer operations, delegating remaining commands to superclass.
3. `AnswerButtons.toViewerCommand()` maps Again/Hard/Good/Easy to native `ViewerCommand` values.
4. `Reviewer.answerCardInner(rating)` uses `sched.answerCard(state, rating)` within `undoableOp` and handles additional reviewer side effects. A voice feature must not bypass that path by calling the scheduler directly.
5. Reviewer `currentCard` and `queueState` change asynchronously; voice interactions require *card/turn generation guards*, not only a boolean “reviewing”.

**Contract for FSA-06 onward:** voice actions enter the existing validated reviewer command workflow with phase checking, voice self-trigger suppression, idempotent user-intent handling and stale-turn rejection. No second review scheduler, queue, card mutation ledger or PC Anki adapter.

## 4. Audio and features inventory

Fork has [TtsVoices.kt](https://github.com/Drmusab/flashcard-Android/blob/main/AnkiDroid/src/main/java/com/ichi2/anki/TtsVoices.kt), Android `TextToSpeech` service integration and the platform's audio recording functionality. Do not import a second TTS playback lifecycle without examining these hooks.

Study-Agent-Client **reference candidates** (existence confirmed in its repository tree; not yet audited for portability):

| Candidate | Intended treatment |
|---|---|
| `core/voice/stt/AndroidSpeechRecognitionBackend.kt`, `DefaultSpeechRecognitionOrchestrator.kt` | REVIEW + ADAPT to the fork's lifecycle and microphone permissions |
| `core/voice/stt/VoiceCommandGrammar.kt`, `VoiceCommandInterpreter.kt` | REVIEW + ADAPT; grammar needs new native reviewer command policy |
| `core/voice/StudyVoiceTurnGate.kt` | REVIEW + REDESIGN; bind to native Anki card/answer lifecycle |
| `core/voice/tts/DefaultSpeechOrchestrator.kt`, `SpeechQueue.kt`, `VoiceHandoffController.kt` | REVIEW + ADAPT around existing fork TTS; avoid competing playback/recognizer ownership |
| `core/audio/AudioRouteManager.kt`, `StudyAudioRouteCoordinator.kt` | REVIEW + ADAPT for headset/speaker routes |
| `service/StudySessionForegroundService.kt` | REDESIGN against Android foreground service policy; do not copy directly |
| `core/study/StudySessionMachine.kt` | DO NOT PORT AS SECOND AUTHORITY; extract only reusable ideas/tests |
| `core/anki/*Backend*`, PC adapter/availability layers, BackendRegistry/Resolver | DO NOT PORT |
| Separate Anki review mutation/reconciliation pipeline | DO NOT PORT as a second scheduler or reviewer authority |
| PC Agent transport / WebSocket protocol for Anki traffic | REMOVE FROM TARGET ARCHITECTURE |
| AI evaluation and cloud provider interfaces | LATER GATE; review privacy, network and consent separately |
| Medical-specific pronunciation/vocabulary | OPTIONAL user-configurable lexicon, not a global app default |

No code was moved.

## 5. Application identity, storage and security baseline

Source: [app Gradle](https://github.com/Drmusab/flashcard-Android/blob/main/AnkiDroid/build.gradle.kts) and [AndroidManifest.xml](https://github.com/Drmusab/flashcard-Android/blob/main/AnkiDroid/src/main/AndroidManifest.xml).

- Release app ID currently matches official `com.ichi2.anki`. **Do not install a custom release as a replacement for official AnkiDroid without an explicit migration/signing plan.**
- Debug adds `.debug`; coexistence still needs a complete provider-authority, permission, deep-link, storage and sync audit.
- `RECORD_AUDIO`, `MODIFY_AUDIO_SETTINGS`, `FOREGROUND_SERVICE`, and related permissions are present, but future background microphone operation is **not thereby validated**.
- Manifest currently sets `android:usesCleartextTraffic="true"`; any new remote AI provider must enforce deliberate security and privacy rules rather than inheriting permissive defaults.
- Use a *disposable* Anki collection for early review/sync testing. Back up valuable collections before field tests.
- Preserve original FSRS, AnkiWeb sync, media/collection semantics, and undo behavior.
- Independent fork distribution requires GPL/AGPL license compliance and modified-source disclosures. Upstream's `AI_POLICY.md` applies to proposed upstream contributions; do not assume AI-assisted changes are eligible to submit upstream.

## 6. CI and verification discovery

Source: [Workflows quality guide](https://github.com/Drmusab/flashcard-Android/blob/main/.github/workflows/README.md), [Unit workflow](https://github.com/Drmusab/flashcard-Android/blob/main/.github/workflows/tests_unit.yml), [Emulator workflow](https://github.com/Drmusab/flashcard-Android/blob/main/.github/workflows/tests_emulator.yml).

Repository-tested task names to attempt once the environment is ready:

```powershell
# Run in the local root of flashcard-Android, on Windows
.\gradlew.bat --version
.\gradlew.bat :AnkiDroid:assembleFullDebug
.\gradlew.bat :AnkiDroid:testFullDebugUnitTest
.\gradlew.bat lintAll ktLintCheck lint-rules:test
.\gradlew.bat -p buildSrc test
# Check the actual installed/emulator test variants before invoking:
.\gradlew.bat :AnkiDroid:tasks --all
```

Official repository CI uses `./gradlew jacocoUnitTestReport` for broader JVM coverage and `TEST_RELEASE_BUILD=true ./gradlew jacocoAndroidTestReport` for emulator checks; these are more expensive and need a configured environment. For a first smoke test, build FullDebug and launch on a disposable emulator/phone before running the full matrix. Android SDK Platform 37 and SDK components required by the build must be installed via Android Studio/SDK Manager; do not assume an exact build-tools version without inspecting resolved tool requirements.

**Evidence template:** command, source HEAD, JDK/Gradle/SDK, exit code, report path, build artifact checksum, device model/API, result, failure log.

### Why not executed in this session?

The tool runtime has `git` and Java 21 but no Android SDK, no `gradle` or `adb`, no local clone of `flashcard-Android`, and `git ls-remote` to GitHub failed DNS resolution. Source inspection succeeded via the connected GitHub repository service. The fork has no Actions runs in the inspected API result. No Gradle task, Kotlin compile, APK build, instrumentation test or real-device check executed. None can be marked PASS or FAIL.

## 7. Upstream divergence

At discovery, fork `main` = `a7121c11…`; upstream `main` = `fe657703…`. GitHub compare reports upstream **17 commits ahead** of fork base at this instant. Do not merge upstream into the baseline before collecting a reproducible build on the currently pinned fork state. A future maintenance Gate will own upstream merges and regression verification.

## 8. Risk register

| ID | Risk | Priority | Mitigation |
|---|---|---|---|
| FSA-R-001 | Cannot compile Android here | BLOCKER | Execute FSA-00B on Windows/CI with SDK and Gradle |
| FSA-R-002 | No local worktree inspection | BLOCKER FOR BUILD | Clone fork and capture `git status`, HEAD, remotes |
| FSA-R-003 | Duplicate scheduler/reviewer authority | CRITICAL | Native Reviewer command dispatch only; no direct independent scheduler |
| FSA-R-004 | Production app identity collision | HIGH | FSA-02 independent package, signing, providers, storage, intents audit |
| FSA-R-005 | Duplicate TTS/STT lifecycle | HIGH | Map upstream audio before migrating old orchestration |
| FSA-R-006 | Voice-triggered double review or old-card rating | CRITICAL | Turn identity, phase validation, native commit path, stress/device tests |
| FSA-R-007 | Foreground/microphone policies | HIGH | Explicit Android permission/service-type analysis before screen-off support |
| FSA-R-008 | Anki collection corruption or sync conflict | CRITICAL | Disposable collections and backup/restore tests |
| FSA-R-009 | Upstream drift (17 commits at discovery) | MEDIUM | Pinned baseline, regular audited merge windows |
| FSA-R-010 | Fork distribution, copyrights and upstream AI policy | HIGH | License inventory, attribution, policy separation |
| FSA-R-011 | PC Adapter architecture leaks into fork | HIGH | Explicit exclusion and code review rule |
| FSA-R-012 | Historical Study-Agent tests claimed as fork tests | HIGH | New fork builds and test evidence required |

## 9. FSA-00B — proposed implementation/validation checkpoint (NOT EXECUTED)

1. Create a working clone of the user's fork. Record current `main`, `upstream`, `git status` and commit hash. Work on a dedicated `feature/fsa-foundation` branch; keep `main` clean and upstream-tracking.
2. Check actual JDK and pinned daemon JVM (JetBrains JDK 21) and Gradle wrapper 9.8.0. Install/configure Android SDK 37 and required build tools.
3. Run `:AnkiDroid:assembleFullDebug`, `:AnkiDroid:testFullDebugUnitTest`, relevant lint/build logic tests. Record outputs; do not hide pre-existing failures.
4. Run the signed debug APK on disposable Android environment. Exercise launch, deck creation/import, question display, reveal, rating, undo, and sync on test data. Capture results, not credentials.
5. Review package/coexistence behavior without modifying release application identity (FSA-02 owns that decision).
6. Produce full `FSA-00B` evidence report with PASS/FAIL/BLOCKED. Do not proceed automatically to feature migration.

## 10. Final disposition

```text
FSA-00A SOURCE DISCOVERY: COMPLETED
FSA-00A REMOTE REPOSITORY / MODULE ANALYSIS: VERIFIED
FSA-00A LOCAL GIT WORKTREE: UNVERIFIED
FSA-00A GRADLE / ANDROID BUILD: BLOCKED (ENVIRONMENT)
FSA-00 FOUNDATION LOCK: NOT AUTHORIZED
FSA-00B NEXT TASK: BUILD AND BASELINE TESTING ON ANDROID-CAPABLE MACHINE / CI
PC ANKI ADAPTER: EXCLUDED
PRODUCTION CODE CHANGES: NONE
GITHUB REPOSITORY MUTATIONS: NONE
```
