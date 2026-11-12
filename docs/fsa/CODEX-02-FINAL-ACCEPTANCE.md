# CODEX-02 — final foundation acceptance

Executed 2026-11-12. **FSA-00E / FSA-00 lock: BLOCKED.** The remaining technical checks passed within the isolated configuration below; the original FSA-00A and authorized sync disposition are still missing. FSA-01A has not started.

## Preserved source and execution

Entry HEAD was `a1aa6c7932e65982220de10ae10c53a2e8b0fa7e` on `codex/fsa00-recovery`, not the APK's source revision. All four CODEX-01 APK hashes still match their receipts. Their exact source remains **7653676c30374b8270f9be57871dacae0cc41d9a**; subsequent tracked changes are documentation/evidence only. No rebuild or redundant test execution was performed. The existing FullDebug build, 3,898-case FullDebug unit scope, coverage, lint and build-logic results remain valid at equivalent application/build source. [Source receipt](evidence/codex02/codex02-source-integrity.json), [prior execution](CODEX-01-LOCAL-FOUNDATION.md).

## New acceptance evidence

Fresh AVD **FSA00E_01a1cc75_API36**, serial **emulator-5582**, ran Android **API 36** with WebView **133.0.6943.137**. No outdated-WebView warning appeared. The official API 36 AOSP image was installed on L:, reusing the existing emulator; no build caches or arbitrary user files were cleaned. C: and D: remained low on space. Initial CLI/root-resolution, duplicate-dependency and UI timing attempts are retained locally and are not acceptance results. [Runtime](evidence/codex02/codex02-runtime-summary.json), [disk](evidence/codex02/codex02-disk-final.json).

The unchanged Debug APK was paired with the publisher's [official AnkiDroid 2.25.3 release](https://github.com/ankidroid/Anki-Android/releases/tag/v2.25.3). Its published SHA-256 and signature verified; package `com.ichi2.anki` and certificate differ from `com.ichi2.anki.debug`. [Official APK receipt](evidence/codex02/codex02-official-apk-receipt.json).

Before either first launch, both selected collection directories were verified empty:

- Official, UID **10150**: `/data/user/0/com.ichi2.anki/files/fsa00e-official-01a1cc75`.
- Debug, UID **10151**: `/data/user/0/com.ichi2.anki.debug/files/fsa00e-debug-01a1cc75`.

These are separate app-internal paths inside the fresh L: userdata image; a different package ID alone was not accepted as isolation. One official sentinel card and four distinct Debug cards were created natively. The official collection's file hashes stayed unchanged throughout Debug creation, review, Undo and lifecycle testing. [Isolation](evidence/codex02/codex02-isolation.json), [unchanged official files](evidence/codex02/codex02-official-after-debug.json).

Debug question/answer rendering, Again/Hard/Good/Easy and Undo passed. Native history after process death and local restore contained exactly one entry for each rating 1–4, four cards with one repetition each, three learning cards and one review card. No scheduler/FSRS code or parallel rating store was added. Database inspection occurred only after stopping the app. [Scheduler receipt](evidence/codex02/codex02-native-scheduler.json), [accepted UI assertions](evidence/codex02/codex02-accepted-assertions.jsonl).

Lifecycle cases were tested separately:

- **Ordinary background/resume and rotation:** PID **2954** retained; revealed answer remained visible. [Receipt](evidence/codex02/codex02-lifecycle-background.json).
- **Activity destruction/recreation:** native Developer Options control; `onDestroy` at 22:47:40 and `onCreate` with four saved-state keys at 22:47:45, same PID **2954**, same task and pending card/counts. The control was restored to off. A settings-write-only attempt and a premature Recents click were excluded. [Receipt and log lines](evidence/codex02/codex02-lifecycle-activity.json).
- **Genuine process death:** Home → `am kill --user 0` → PID **2954 proven absent** → retained task restored through Recents in PID **5341**. The pending card and 0 new / 3 learning counts returned without resubmitting a rating. It returned to the **question** side; answer-side preservation across process death is not claimed. No force-stop was used for this test. [Receipt](evidence/codex02/codex02-lifecycle-process-death.json).
- **Ordinary cold launch after local restore:** tested separately, not used as process-death proof. [Restore receipt](evidence/codex02/codex02-backup-restore.json).

Both actual binary manifests have distinct provider authorities and API permissions, with zero authority collisions. Unprivileged UID 2000 was denied access to both API/FileProviders without grants. Both apps register shared `anki://` and APKG/COLPKG handlers: the implicit deep link displayed Android's chooser with two **AnkiDroid** labels. Package-scoped links opened only the corresponding collection: four Debug cards versus the single official sentinel. This is **configured private-path coexistence**, not certification of shared public `/AnkiDroid` defaults or unambiguous generic routing. [Identity surfaces](evidence/codex02/codex02-identity-surfaces.json), [routing](evidence/codex02/codex02-coexistence-routing.json).

Backup is allowed by both manifests without explicit extraction rules. A Debug-only backup/restore using **com.android.localtransport/.LocalTransport**, entirely on the emulator's local disk, restored a deliberately modified marker and preserved all native card/review rows. The stopped official collection's hashes were unchanged. No cloud account was involved. [Backup/restore proof](evidence/codex02/codex02-backup-restore.json).

WebView accessibility text was intermittent after Activity recreation; actual card rendering was also verified in screenshots. No application fix was justified by these observation races. The emulator was shut down with its disposable data preserved. No production installation or collection was accessed.

## Final acceptance matrix

| Requirement | Result | Evidence |
|---|---|---|
| FSA-00A provenance | **BLOCKED** | [Original not supplied](evidence/codex02/codex02-fsa00a-provenance.json) |
| Source integrity | **PASS** | [APK source and unchanged hashes](evidence/codex02/codex02-source-integrity.json) |
| Local build evidence | **PASS** | [Preserved executed build](evidence/codex01/codex01-assemble.log) |
| Unit tests and lint | **PASS** | [Equivalent-source execution](evidence/codex01/codex01-reused-checks.json) |
| Debug APK verification | **PASS** | [Four preserved APK hashes](evidence/codex02/codex02-source-integrity.json) |
| Modern Android runtime | **PASS** | [API 36 / WebView 133](evidence/codex02/codex02-runtime-summary.json) |
| Native Reviewer | **PASS** | [Native review history](evidence/codex02/codex02-native-scheduler.json) |
| Process-death recovery | **PASS** | [Absent old PID, new PID, retained task](evidence/codex02/codex02-lifecycle-process-death.json) |
| Official/Debug coexistence | **PASS — configured private paths** | [Scoped routing](evidence/codex02/codex02-coexistence-routing.json), [local restore](evidence/codex02/codex02-backup-restore.json) |
| Collection isolation | **PASS** | [Paths verified before first write](evidence/codex02/codex02-isolation.json) |
| Sync requirement disposition | **UNRESOLVED** | [Authorization / parent authority missing](evidence/codex02/codex02-sync-disposition.json) |
| Gate lock | **BLOCKED** | Two owner requirements below |

## Exact remaining owner requirements

1. Supply the original **FSA-00A_Baseline_Discovery_Report.md**, expected SHA-256 **4b9d7fef3c3166eede26b3e753d892d54f81f61959e0e606747e7d315935935b**. It was not supplied or located in the named-file searches. No original hash, historical date or reconciliation can be asserted yet. Preserve it verbatim after hash verification; do not reconstruct it.
2. **SYNC: NOT EXECUTED — AUTHORIZATION REQUIRED.** Authorize a disposable test account and controlled sync, or provide the explicit parent-contract deferral authority and its written authorized disposition. FSA-00B mentions an explicit UNVERIFIED waiver, but FSA-00C requires parent authority; the missing original means that authority has not been established. This agent grants no waiver. [B](FSA-00B-fork-baseline-build-verification.md), [C device contract](FSA-00C-DEVICE-VERIFICATION.md), [R-08](FSA-00C-RESIDUAL-RISKS.md).

GitHub main was observed at `4bfadceba7d91abec270c4b45e95e26dbc294d15`; it was not overwritten or merged. The recovery branch contains the earlier local recovery changes. A draft PR is prepared for review; no automatic merge is authorized. Billing was not reinvestigated or changed, and no CI pass is claimed in place of the successful local execution.

This change adds only this report and selected evidence. Raw logs, unsuccessful diagnostic attempts, helper scripts, test collections, APKs and local backup data remain outside the committed evidence set. [Local evidence manifest](evidence/codex02/local-evidence-manifest.json); packaged text copies may normalize trailing whitespace. Historical FSA documents remain unchanged. FSA-01A inventory and all production migration remain held until legitimate gate closure.
