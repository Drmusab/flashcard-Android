# CODEX-01 — local Android foundation and working APK

Executed 2026-11-12 on the owner's Windows host. **FSA-00D: PASS for the local build and specified native smoke scope. FSA-00: NOT LOCKED. FSA-01 remains held.**

## A. Local environment

The actual Git checkout is `.recovery/checkout`, branch `codex/fsa00-recovery`, clean on entry at `7653676c30374b8270f9be57871dacae0cc41d9a`. Origin is `https://github.com/Drmusab/flashcard-Android.git`; the checkout is shallow. The original archive and historical FSA documents remain preserved. No upstream merge, push or CI dispatch occurred.

Modules: AnkiDroid, anki-common, api, baselineprofile, common, common:android, compat, libanki, lint-rules, note-editor, vbpd and widgets; buildSrc supplies build logic.

Detected and executed: complete JetBrains JDK/javac **21.0.11**, wrapper **Gradle 9.8.0**, SDK platform **37.0**, build-tools **36.0.0** (selected by AGP; 37.0.0 also installed), platform-tools **37.0.1 / ADB 1.0.41**, emulator **37.2.13.0**, and usable **WHPX 10.0.26200**. Repository pins remain AGP **9.4.1**, Kotlin **2.4.20**, Anki backend **0.1.72-anki26.09.3**. Gradle's embedded Kotlin 2.4.10 is not the project's Kotlin pin.

Android Studio was absent at the checked system/user installation locations; the CLI build needs no Studio installation. The host has an i5-12400F and 15.8 GiB RAM; approximately 4.1 GiB was available before emulator boot. Official Google downloads succeeded in this round; dependency resolution succeeded during CODEX-00. This build reused cached dependencies and does not establish a clean-machine reproducibility result.

Only task-created SDK/JDK/tools were relocated to `D:\AnkiStudioRecovery-01a1cc75`, with every copied file's SHA-256 verified before removing the originals. The outer `.recovery/activate.ps1` selects these tools, the existing task-local Gradle cache, and the AVD on L:. It uses Windows trusted certificate authorities without disabling TLS verification. No system feature, driver or Android Studio installation was performed. Final free space: C: approximately 1.5 GiB, D: 3.7 GiB, L: 14.9 GiB.

## B. Build result

Fresh executions from the clean revision above:

- `gradlew.bat --version --console=plain`: **exit 0**; pinned Gradle and JetBrains JVM confirmed.
- `gradlew.bat :AnkiDroid:assembleFullDebug -PbuildTime=1794508349860 --console=plain`: **exit 0**, 1m 10s; 212 tasks, 7 executed / 205 up-to-date. Four ABI APKs produced.

The existing buildTime property fixes build metadata; no project pin or application behavior changed. Generated BuildConfig records the exact source revision and timestamp. [Build source receipt](evidence/codex01/codex01-build-source.json), [build log](evidence/codex01/codex01-assemble.log), [version log](evidence/codex01/codex01-gradle-version.log).

## C. Test result

The required commands were executed successfully during this local recovery and are reused explicitly, rather than rerunning unchanged aggregate scopes. The only tracked difference between their code revision `1ca8fcc1c631c4000ae63ed53ee949a6cce78b33` and this APK's revision is `docs/fsa/CODEX-00-RECOVERY.md`.

- `robolectricSdkDownload`: exit 0; all 13 configured runtimes prepared.
- `:AnkiDroid:testFullDebugUnitTest`: 3,898 cases, 0 failures/errors, 85 skips.
- `jacocoUnitTestReport`: exit 0, normal forced-fresh producers; PlayDebug 3,898 cases, 0 failures/errors, 85 skips, plus library scopes. HTML/XML retained.
- `lintAll ktlintCheck lint-rules:test`: exit 0; 549 actionable tasks. Lint-rule tests: 118 cases, 0 failures/errors, 1 skip.
- Final `-p buildSrc test ktlintCheck --rerun-tasks --no-watch-fs`: exit 0; 29 cases, 0 failures/errors, 1 existing Windows skip.

Earlier failures, regression fixes and cancelled/diagnostic runs remain documented in [CODEX-00](CODEX-00-RECOVERY.md); they are not relabelled as passing. [Reused-check receipt](evidence/codex01/codex01-reused-checks.json) identifies exact logs, hashes and source equivalence. Original XML/HTML and logs remain under the checkout's build directories and the outer `.recovery/evidence` directory. No test or lint rule was disabled in CODEX-01.

## D. APK evidence

Artifacts: `AnkiDroid/build/outputs/apk/full/debug/`. All four passed `aapt2 dump badging` and `apksigner verify --verbose --print-certs`:

- Application ID: **com.ichi2.anki.debug**.
- Version: **2.26.0alpha7-debug / 22600107**; compile SDK 37, target 36, minimum 24.
- Signing: **Android debug certificate**, SHA-256 `1f0c7bcce20fe9e01d54f74ec7e5fe1ee74aab1d22de99805ab3a52e2078e87d`.
- Source: **7653676c30374b8270f9be57871dacae0cc41d9a**, built using Gradle 9.8.0 / JetBrains JDK 21.0.11.
- `AnkiDroid-full-arm64-v8a-debug.apk`: SHA-256 **3FFF7837AF9FF0EBD691171D2107D4125EFF19941F23E44592688AC5D11B6422**.
- Emulator-tested `AnkiDroid-full-x86_64-debug.apk`: SHA-256 **4F373C2D3E1699E04FC0DB5425F016260E44A4CB356AED9A8C65745D4F763102**.

[Complete four-ABI receipt](evidence/codex01/codex01-apk-receipt.json) includes sizes and hashes. No release/fallback signing identity was used. This report's later documentation commit does not change the APK's recorded source revision.

## E. Android verification

Official image: **API 28 default x86_64 revision 4**. Fresh AVD **FSA00D_01a1cc75_API28**, explicit ADB serial **emulator-5580**. No existing Anki installation or account was present. The first start on D: failed before boot because userdata requires 7,372.8 MiB free. A fresh task-only AVD on local NTFS L: booted successfully using the existing WHPX hypervisor. Its writable image is `L:\AnkiStudioRecovery-01a1cc75\avd\FSA00D_01a1cc75_API28.avd\userdata-qemu.img`; no shared SD-card image was attached.

Before the acceptance launch, the selected `deckPath` was verified and its directory was empty: **/data/user/0/com.ichi2.anki.debug/files/fsa00d-native-01a1cc75**. Isolation rests on that app-internal path and the fresh AVD filesystem, not on the debug ID. [Isolation receipt](evidence/codex01/codex01-isolation-final.json).

Executed native acceptance matrix, all **PASS**:

- Launch and Deck Picker; create **FSA00D_Native**; create four Basic notes/cards through the native editor.
- Display **Native_Q1**, reveal **Native_A1**, and use **Again, Hard, Good, Easy** through native Reviewer controls.
- **Undo** restores Native_Q1 and counts from 3 new / 1 learning to 4 new / 0 learning; repeat the rating through native Reviewer.
- Revealed answer survives portrait/landscape/portrait changes and Home/background/resume.
- Navigate Reviewer → Deck Picker → Card Browser → back; browser shows all four cards.
- Stop the process and cold-launch: deck/cards and the four-review summary persist, with 0 new / 3 learning. After stopping the app again, database assertions confirm four notes, four cards, exactly one revlog entry for each native rating 1–4, and one repetition per card.

[UI assertions](evidence/codex01/codex01-native-assertions.jsonl), [persistence assertions](evidence/codex01/codex01-native-persistence.json), [runtime receipt](evidence/codex01/codex01-runtime-receipt.json), [answer screenshot](evidence/codex01/codex01-screen-native-answer.png), [cold-launch screenshot](evidence/codex01/codex01-screen-native-cold-deckpicker.png). Selected UI XML is alongside these receipts. No fatal exception was found in captured logcat. The emulator was shut down; its disposable data and a local collection snapshot remain preserved.

Diagnostic correction: an initial external SQLite connection disturbed the first disposable run's WAL; its persistence observations were discarded. Acceptance was repeated in the new empty directory above, with no external database access while the app ran. The stock SQLite `integrity_check` also lacks libanki's `unicase` collation; no integrity-check pass is claimed. Final count/rating queries ran only after proving the app process stopped.

Scope limitation: the API 28 image contains WebView **66.0.3359.158** and displays an outdated-WebView warning. Basic cards and the native smoke matrix passed; modern WebView features, every note type, physical-device behavior and exact Reviewer restoration after process death were not certified. No AnkiWeb sync was attempted. Native libanki remained the sole writer of reviews/scheduling/undo.

## F. Residual blockers

- **Original FSA-00A:** owner must provide the separate original with provenance/hash; then preserve and reconcile it against B/C. It was not supplied in CODEX-01 and has not been reconstructed.
- **Parent FSA-00 runtime criteria:** authorized disposable AnkiWeb sync or a resolved parent-contract disposition, paired official/debug coexistence and provider/deep-link routing, and independent acceptance remain outside this smoke result. Supply the authorized test account/contract decision and execute the remaining parent checks before final lock.
- **CI:** the last recorded Actions evidence reports an account billing lock and zero executed steps. This round supplies local execution; it does not claim the account was unlocked. If parent acceptance requires CI evidence, the owner must resolve that condition and obtain an executing run at the reviewed revision.
- **Current-WebView coverage:** use an updated disposable image/provider before certifying modern WebView functionality; the old-image warning remains documented.

## G. Gate verdict

**FSA-00D: PASS**, bounded to the pinned local build, retained equivalent-source checks, verified debug APKs and the executed disposable native smoke matrix. **Overall FSA-00: BLOCKED / NOT LOCKED** by the remaining parent evidence requirements. No Study-Agent production feature, scheduler/FSRS change, PC adapter, AnkiConnect scheduling, remote queue or parallel rating store was introduced. FSA-01 was not started.

Raw local command journal, failed attempts, downloads, full logcat, test reports and collection snapshot remain in `.recovery/evidence`; their names, sizes, hashes and retained paths are recorded in the [local evidence manifest](evidence/codex01/local-evidence-manifest.json). Packaged text logs normalize trailing whitespace; the hashed originals are retained unchanged. Historical reports remain unchanged.
