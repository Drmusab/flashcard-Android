# FSA-00R1 — Residual blockers, acceptance matrix and gate decision

**Evaluated revision:** `ca446d8712e3a9b01050c536c26e3869220f0415` · **Date:** 2026-10-31 UTC
**Gate decision: FSA-00 stays BLOCKED. FSA-01 production migration is NOT AUTHORIZED.**

---

## 1. Acceptance matrix

| Requirement | Required evidence | Status at this revision | What exists instead |
| --- | --- | --- | --- |
| GitHub Actions | recognised workflow **and a run URL** | **RUNS RECOGNISED, EXECUTION BLOCKED** — run URLs now exist (e.g. [run 41208932554](https://github.com/Drmusab/flashcard-Android/actions/runs/41208932554)), workflows are active and triggered, but **every job is refused at runner allocation**: *"The job was not started because your account is locked due to a billing issue."* (`runner_name: ""`, `steps: 0`) — [11](evidence/00r1/11-run-evidence.txt), [02](evidence/00r1/02-github-actions-api.txt) |
| JDK / Gradle | executed version output | **BLOCKED** | wrapper launcher executes under Temurin 25 JRE, dies on distribution fetch (`ENVIRONMENT_ERROR`); JetBrains 21 never provisioned — [04](evidence/00r1/04-jvm-and-wrapper.txt) |
| Build | successful `:AnkiDroid:assembleFullDebug` | **BLOCKED** | attempted, exit 1 before any task ran — [BUILD §2](FSA-00R1-BUILD-EVIDENCE.md) |
| Tests | executed unit-test results | **BLOCKED** | attempted, exit 1, no XML/HTML — [TEST §1](FSA-00R1-TEST-RESULTS.md) |
| Lint | executed lint results | **BLOCKED** | attempted (correct task spelling), exit 1, no reports — [TEST §1](FSA-00R1-TEST-RESULTS.md) |
| Build logic | successful `-p buildSrc test` | **BLOCKED** | attempted, exit 1, 8 test classes inventoried but none executed — [TEST §2](FSA-00R1-TEST-RESULTS.md) |
| APK | artifact identity + SHA-256 | **BLOCKED** | no APK; identity expectations recorded from source only — [BUILD §3](FSA-00R1-BUILD-EVIDENCE.md) |
| Emulator | executed Android-test evidence | **BLOCKED** | no APK, no runner, no KVM; route chosen (`tests_emulator.yml`), not executed — [EMULATOR](FSA-00R1-EMULATOR-EVIDENCE.md) |
| Collection safety | verified disposable storage | **BLOCKED** | shared-public-root risk re-confirmed at `SetupStorage.kt:127-138`; runtime path unproven — [EMULATOR §1](FSA-00R1-EMULATOR-EVIDENCE.md) |
| Reviewer | runtime smoke tests | **BLOCKED** | native scheduler path source-verified; 14 behaviours unexecuted — [EMULATOR §2](FSA-00R1-EMULATOR-EVIDENCE.md) |
| FSA-00A | original evidence + reconciliation | **BLOCKED** | absent from every ref/PR/release/artifact; **not** reconstructed — [09](evidence/00r1/09-fsa-00a-search.txt) |
| Security | no unsafe signing, no user-data access | **PASS (this round)** | no release/signing path used, no collection touched, new workflow audited `contents: read` + no keystore/publish — [07](evidence/00r1/07-ci-workflow-safety.txt) |
| Source baseline | no production change vs baseline | **PASS** | non-`docs` diff vs `a7121c11` empty; 0 matches for all 16 forbidden symbols — [01](evidence/00r1/01-repository-state.txt), [08](evidence/00r1/08-identity-invariants.txt) |

Only two rows pass, and both of them are *absence* claims (nothing unsafe was done, nothing was changed). Every
row that requires execution is blocked.

---

## 2. Blockers, owners and exact actions

| ID | Blocker | Owner | Exact action | Evidence it produces |
| --- | --- | --- | --- | --- |
| **R1-B1** | **Owner account locked for billing → no GitHub-hosted runner is ever allocated** (workflows run, jobs stop at allocation) | **Repository owner (Drmusab)** | (1) **Clear the billing lock** at <https://github.com/settings/billing> (settle the failed payment / update the payment method / adjust the spending limit) until the account shows no lock. (2) Verify Settings → Actions → General still allows the pinned actions. (3) Re-run a failed run or push again — a healthy job shows a non-empty `runner_name` and real steps. (4) Optionally reconnect the GitHub app in Arena with **Actions: read/write** so this session can dispatch and read logs. (5) Run **🧪 FSA Foundation CI** on `arena/a6008955-flashcard-android` (`gh workflow run fsa-foundation-ci.yml --ref arena/a6008955-flashcard-android`). | FullDebug build, unit tests, lint, build-logic tests, APK identity, run URLs with executed steps |
| **R1-B2** | No capable build runner reachable from Arena itself (sandbox has no compiler, SDK or Maven access; run logs are outside its egress) | **None — inherent to the environment**; resolved by R1-B1 | No action beyond O-1; do not add mirrors or TLS workarounds | — |
| **R1-B3** | No APK → no install → no emulator, no Reviewer smoke tests | **Owner** (after R1-B1) | Dispatch `tests_emulator.yml -f iterations=1` for install/boot/instrumentation evidence; add a dedicated disposable-collection test **or** perform a documented manual session if D-02's 14 behaviours are to be certified | Instrumentation results, logcat; Reviewer behaviour only if step 2 is done |
| **R1-B4** | Disposable collection path unproven at runtime | **Owner / device runner** | Apply the 5-step procedure in [EMULATOR §1](FSA-00R1-EMULATOR-EVIDENCE.md) on the emulator, recording the resolved absolute path and the package uid before the first write | Proof that the path is disposable |
| **R1-B5** | FSA-00A original report missing | **Owner** | Supply the original file (and its SHA-256 if available) so provenance can be recorded and reconciled against FSA-00B/C. Not reconstructed here, and not a reason to repeat another source-only audit | FSA-00A provenance entry |
| **R1-B6** | Sync verification (out of R1 scope) | **Owner** | Provide an authorized disposable AnkiWeb test account before any sync test is attempted | Sync evidence, or an explicit waiver |

`R1-B1` is the single unblocking action for the entire Android execution chain. The workflows are already admitted
and already triggering; GitHub refuses only the runner. Once the billing lock is cleared, one run of the new
workflow plus one run of `tests_emulator.yml` produces everything FSA-00 is missing except R1-B5 (FSA-00A) and the
runtime proof required by R1-B4.

---

## 3. What changed in the repository this round

| Change | Type | Why it is safe |
| --- | --- | --- |
| `.github/workflows/fsa-foundation-ci.yml` (new) | CI only | `contents: read`; pinned actions only (all six verified against the GitHub API); no release, publish, keystore, signing or emulator step; justification in [CI §4](FSA-00R1-CI-DIAGNOSTICS.md#4-why-a-dedicated-baseline-workflow-was-necessary-c-01c-02-justification) |
| `.github/fsa/run_evidence_command.sh` (new) | CI helper | records provenance, propagates exit codes, self-tested including a negative control ([10](evidence/00r1/10-harness-selftest.txt)) |
| `.github/fsa/apk_identity.sh` (new) | CI helper | reports `NOT_PRODUCED` instead of inventing an artifact |
| `docs/fsa/FSA-00R1-*.md` (5 reports) | Documentation | this round's report set |
| `docs/fsa/evidence/00r1/**` (new) | Evidence | verbatim command output and logs from this revision |
| `docs/fsa/FSA-00-FINAL-LOCK.md` | Documentation | new evidence appended; historical text preserved; decision unchanged |

No production code, test source, manifest, Gradle file, dependency pin, workflow trigger of an inherited workflow,
or Reviewer/scheduling code was modified. Non-`docs` diff against the reference baseline remains empty except for
the three new `.github` files above.

---

## 4. Mandatory invariants — re-checked this round

| Invariant | Result | Basis |
| --- | --- | --- |
| NO PC ANKI ADAPTER | **HELD** | 0 matches for `pcanki`, `pc-anki`, `PcAnkiBackend`, `PcAnkiAvailabilitySource`, `BackendRegistry` — [08](evidence/00r1/08-identity-invariants.txt) |
| NO ANKICONNECT SCHEDULING | **HELD** | 0 matches for `ankiconnect`, `anki-connect`, `AnkiConnect` |
| NO SECOND FSRS | **HELD** | 0 matches for `SecondFsrs`, `DualScheduler`; single native backend path |
| NO SECOND CARD SCHEDULER | **HELD** | reviewer → `undoableOp` → libanki `Scheduler` → `backend.answerCard` |
| NO REVIEWER LOGIC REWRITE | **HELD** | `Reviewer.kt` and the whole app source are byte-identical to baseline |
| NO USER COLLECTION ACCESS | **HELD** | no install, no device, no collection; runtime risk documented, nothing executed |
| NO UNAUTHORIZED UPSTREAM MERGE | **HELD** | upstream left 165 commits ahead and unmerged |
| NO PUBLIC RELEASE SIGNING | **HELD** | only `assembleFullDebug` (debug key) is even configured; zero keystore/publish references in the new workflow |
| NO FABRICATED TEST RESULTS | **HELD** | every attempted command's real exit code recorded; nothing upgraded to pass |
| NO AUTOMATIC FSA-01 MIGRATION | **HELD** | no Study-Agent code added (0 matches for `study-agent`, `studyagent`, `StudyVoiceTurn`, `SpeechOrchestrator`, `RatingCommit`) |

---

## 5. Gate decision

```text
FSA-00:                              BLOCKED
FSA-01 PRODUCTION MIGRATION:         NOT AUTHORIZED
FSA-00 LOCK:                         NOT GRANTED

REMAINING BLOCKERS:
  R1-B1  Owner account billing lock: no runner allocated       owner: Drmusab   -> clear the billing lock (O-1)
  R1-B2  No capable runner reachable from Arena            none             -> resolved by R1-B1
  R1-B3  No APK / no emulator / no Reviewer runtime proof  owner            -> dispatch FSA CI + tests_emulator
  R1-B4  Disposable collection path unproven at runtime    owner/runner     -> 5-step isolation procedure
  R1-B5  FSA-00A original report missing                   owner            -> supply file + hash
  R1-B6  Sync verification (out of R1 scope)               owner            -> disposable test account or waiver
```

**Why not LOCK:** the lock criteria require executed build, test, lint, APK and emulator evidence plus a
reconciled FSA-00A. This round produced a diagnosis, a justification, an evidence pipeline and a verified
security posture — but zero executed Android tasks. Documentation is not a substitute for execution, and this
round explicitly refuses that substitution.

**Why this round is still progress:** the blocker is now precisely localised. It is not "the build is broken", it is
"the runner never starts". One owner action (R1-B1) plus one workflow dispatch converts this report from BLOCKED
to a full evidence set without further code change.
