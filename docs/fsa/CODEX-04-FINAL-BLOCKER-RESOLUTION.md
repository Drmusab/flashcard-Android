# CODEX-04 — final blocker resolution

Executed **2026-11-13, Asia/Baghdad**. **FSA-00: BLOCKED.** Controlled disposable AnkiWeb sync now **PASS**; the only remaining closure requirement is the original FSA-00A file and its verification/reconciliation. No waiver or acceptance-contract amendment was made.

## Historical evidence

`docs/fsa/FSA-00A_Baseline_Discovery_Report.md` remains absent from the recovery checkout. Task 1 stopped without reconstruction. The owner must supply the original bytes at that path, with expected SHA-256 `4b9d7fef3c3166eede26b3e753d892d54f81f61959e0e606747e7d315935935b`. The discovery date **2026-10-25** remains owner-stated, not verified from the missing report. Its provenance and comparison with FSA-00B/C and CODEX-01/02 cannot yet be completed.

Earlier reports remain unchanged. Their missing-sync conclusions describe their historical execution dates; the new runtime evidence below resolves that requirement prospectively. [CODEX-03 closure](CODEX-03-EVIDENCE-CLOSURE.md) preserves the prior provenance checks, including 348 raw CODEX-01/02 files, five executed-check logs, four APK identities, and retained FullDebug totals of 3,898 cases with zero failures/errors and 85 skips. Those successful tests were not rerun.

## Controlled sync result

The owner authorized Option 1 and identified a newly supplied account as disposable. Credentials were entered privately through native Android UI in each installation. The earlier account explicitly classified as production was excluded. No account credentials, authentication tokens, login screenshots or authentication logs were captured in tools or evidence.

The existing API 36 AVD `FSA00E_01a1cc75_API36` used two newly created Android users: source **10** and replica **11**, each with an independent Debug installation and an explicitly selected, initially empty app-private collection. The existing user **0** and its prior official/Debug test collections were preserved. [Source isolation](evidence/codex04/codex04-source-isolation.json), [replica isolation](evidence/codex04/codex04-replica-isolation.json), [empty replica](evidence/codex04/codex04-replica-empty.json).

The source created deck `FSA00_SYNC_20261113_01a1cc75` and two Basic notes/cards, then used native Reviewer ratings **Again (1)** and **Good (3)**. Before synchronization there were exactly two notes, two cards, two review records and one repetition per card. The source reported **“Collection synced. Media is being synced in the background.”** The empty replica subsequently synchronized and reported the same success. Server upload/download is established by the independent installation receiving the source identities, fields, native scheduling values and review records. No media payload was included in this small text-only test. [Source native result](evidence/codex04/codex04-ui-source-sync-initial.xml), [replica native result](evidence/codex04/codex04-ui-replica-sync-download-result.xml).

Read-only logical snapshots, taken with the relevant app stopped, were equal before/after source sync, after replica download, and after a replica cold restart. Comparison covered note IDs/GUIDs, note-type IDs, fields and tags; card IDs, note/deck relationships, ordinal, type, queue, due, interval, factor, repetitions, lapses, remaining steps, original due/deck, flags and native card data; all review IDs, card references, ratings, intervals, factors, elapsed times and types; and deck/note-type IDs and names. Synchronization bookkeeping was excluded. No duplicated or missing notes, cards or reviews appeared. **Raw SQLite file hashes were not used as proof of sync equivalence.** [Acceptance](evidence/codex04/codex04-sync-acceptance.json), [logical comparison](evidence/codex04/codex04-logical-equivalence.json), [query archive](evidence/codex04/logical-state-query.ps1).

Snapshots: [source before](evidence/codex04/codex04-state-source-pre-sync.json), [source after](evidence/codex04/codex04-state-source-post-sync.json), [replica downloaded](evidence/codex04/codex04-state-replica-downloaded.json), [replica after restart](evidence/codex04/codex04-state-replica-after-restart.json).

## Network and cleanup

Default Android trust previously rejected the certificate path on the inspected connection, while Windows trusted its Avast issuer. No alternative unintercepted network was available in this run. The owner's existing authorization was used for a temporary **app-only** custom certificate: the exact Windows-trusted public root with SHA-256 `B699A880ED464C43AF4AD3A430FE0B29820EB7C37B1FA5ABEF68014566914EAC`. The existing native custom-certificate setting accepted it in both disposable installations; the standard AnkiWeb endpoint remained selected. An unauthenticated scoped HTTPS probe also returned HTTP 200 for both public endpoints with certificate-chain and hostname validation enabled. This validates the controlled inspected path, not an independent unintercepted path. [Probe output](evidence/codex04/codex04-scoped-public-tls.txt), [probe source](evidence/codex04/ScopedTlsProbe.java).

An initial provisioning error assigned the new source folder the wrong Android-user SELinux category. Correcting only that test folder's label to match app-created directories restored access to an empty collection. No application defect or implementation change was involved. Early diagnostic attempts are not acceptance results.

After evidence capture, AVD identity and both task-created user names/IDs were checked. Only users **10/11** were removed, clearing their app data, disposable credentials and temporary certificates. Public probe files were removed and battery simulation reset. Android system trust, global antivirus settings and normal TLS verification were unchanged. Hashes of the frozen official test collection and empty WAL matched before/after, solely as an untouched-data check. No user-owned collection was accessed or overwritten. [Cleanup](evidence/codex04/codex04-sync-cleanup.json), [official before](evidence/codex04/codex04-official-before-sync-hashes.txt), [official after](evidence/codex04/codex04-official-after-sync-hashes.txt).

## Final acceptance matrix and decision

[Machine-readable matrix](evidence/codex04/acceptance-matrix.json) retains the exact prior evidence references and records the new sync result:

- **BLOCKED:** FSA-00A original provenance, date verification and historical reconciliation.
- **PASS, preserved:** local build, unit/lint/build-logic checks, APK identities, modern Android runtime, native Reviewer/Undo, process-death recovery, configured official/Debug coexistence, collection isolation and local backup/restore.
- **PASS, new execution:** controlled upload/download, native review/scheduling integrity, cold-restart persistence, and removal of disposable credentials/temporary trust.
- **PASS:** application/build source equivalent to verified APK source `7653676c30374b8270f9be57871dacae0cc41d9a`; installed x86_64 APK SHA-256 `4f373c2d3e1699e04fc0db5425f016260e44a4cb356aed9a8c65745d4f763102`. No rebuild, implementation change, repeated successful test suite, upstream merge or production migration occurred.

**FSA-00: BLOCKED**, because a mandatory historical-evidence requirement remains unsatisfied. Supply the original FSA-00A, verify its exact hash and stated date, preserve it verbatim, and reconcile material historical findings with B/C and CODEX-01/02. Successful controlled sync evidence can then be reused without repetition. FSA-01A handoff remains held until legitimate lock.

PC Anki Adapter, AnkiConnect scheduling, secondary FSRS, parallel rating persistence and remote PC review queues remain excluded. [Closure/provenance receipt](evidence/codex04/closure.json).
