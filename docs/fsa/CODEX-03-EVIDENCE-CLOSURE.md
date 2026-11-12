# CODEX-03 — final evidence closure

**FSA-00: BLOCKED.** No application/build source changed and no successful tests were rerun. Entry HEAD was `7966e5f51fb0f96115b07520ba56b02d0e0979b4`; the verified APK source remains `7653676c30374b8270f9be57871dacae0cc41d9a`. All four APK hashes, **348** raw CODEX-01/02 evidence files and the five referenced executed-check logs matched their receipts. Retained FullDebug XML still totals 3,898 cases, zero failures/errors and 85 skips across 465 suites. [Closure receipt](evidence/codex03/closure.json).

## FSA-00A

`docs/fsa/FSA-00A_Baseline_Discovery_Report.md` is absent from both the actual recovery checkout and original archive workspace. The named attachment search also found no original, and observed remote main/recovery tips were unchanged. The owner's `<repository-root>` path did not supply the missing bytes.

Expected SHA-256: `4b9d7fef3c3166eede26b3e753d892d54f81f61959e0e606747e7d315935935b`. The owner-stated discovery date is **2026-10-25**, not independently verified from the missing original. No report was reconstructed, altered, hash-verified or historically reconciled. **Owner action: provide the original file**, then verify its exact hash and preserve it verbatim before comparing it with B/C and CODEX-01/02.

## Sync disposition

The owner explicitly selected **Option 1 — controlled disposable-account sync**, not a deferral. Direct entry was offered in the visible, isolated API 36 emulator; the owner reported a network/connection error. The subsequently supplied account was explicitly identified by the owner as **existing/production: do not use**. It was excluded; credentials were not repeated, put in tool commands or stored in evidence. Login UI and authentication logs were not captured.

Unauthenticated diagnostics found working DNS/TCP connectivity but Android certificate-path failures. Windows accepted an Avast HTTPS-inspection certificate chain. This is consistent with an antivirus/emulator trust mismatch; it is not a demonstrated sync-implementation defect. The owner authorized a temporary use of the app's existing custom-certificate setting, scoped only to disposable Debug. **It was not applied**, because no usable disposable account was available. Android system trust, Windows antivirus settings and TLS verification were unchanged. [Diagnostic findings](evidence/codex03/tls-diagnostic.json).

The Debug app was stopped to clear the login screen. A private check recorded only booleans: **no stored native account token and no custom certificate applied**. The disposable emulator was then shut down. No controlled upload/download or sync recovery test ran. **SYNC: NOT EXECUTED — disposable-account access remains required.** No waiver, prospective amendment or backdated acceptance was created.

## Final matrix

| Requirement | Result |
|---|---|
| FSA-00A provenance | **BLOCKED — original absent** |
| Source integrity | **PASS — unchanged application/build source** |
| Local build evidence | **PASS — preserved CODEX-01 execution** |
| Unit tests and lint | **PASS — preserved equivalent-source results** |
| Debug APK verification | **PASS — all four hashes unchanged** |
| Modern Android runtime | **PASS — preserved CODEX-02 execution** |
| Native Reviewer | **PASS — preserved CODEX-02 execution** |
| Process-death recovery | **PASS — preserved distinct PID/task evidence** |
| Official/Debug coexistence | **PASS — tested separate app-internal paths only** |
| Collection isolation | **PASS — preserved verified-path evidence** |
| Sync requirement disposition | **UNRESOLVED — Option 1 authorized; test not executed** |
| Gate lock | **BLOCKED** |

[Machine-readable matrix with exact prior evidence references](evidence/codex03/acceptance-matrix.json). Historical CODEX-01/02 reports remain unchanged. Source receipts, the existing draft PR and previous successful tests have not been replaced with new claims.

Closure requires the original matching FSA-00A and an actual new, empty disposable AnkiWeb account for the authorized test. Future controlled sync must verify upload/download, native review/scheduling data integrity and restart recovery, then remove any temporary app-only trust configuration. FSA-01A handoff is not prepared while the gate is blocked; production migration has not started. PC Anki Adapter, AnkiConnect scheduling, secondary FSRS, remote PC review queues and parallel rating persistence remain excluded.
