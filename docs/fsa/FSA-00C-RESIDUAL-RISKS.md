# FSA-00C — Residual risks and blocker-resolution plan

**As of:** 2026-10-25 UTC, source `f8212252540fe104663e935d4c582e9ad499ec89`.
Owners below are required roles, not claims of assignment/acceptance. Evidence IDs resolve in the [entry report](FSA-00C-ENTRY-AND-EVIDENCE.md).

| Risk ID | Severity | Evidence | Consequence / residual risk | Owner | Required action | Blocks FSA-00 lock? |
| --- | --- | --- | --- | --- | --- | --- |
| R-00C-01 | Critical to verification | E02 `java -version` 127; E03 wrapper exits 1 | No actual launcher/daemon version or Gradle evaluation | Build/platform maintainer | Execute on authorized host with pinned JetBrains 21; capture launcher and daemon output; do not downgrade pins | **YES** |
| R-00C-02 | Critical to verification | E02 absent SDK/cache; E06 seven TLS failures | SDK 37, build-tools, native backend and Robolectric dependencies cannot resolve; compatibility unknown | Build infrastructure owner | Provide standard SDK plus authorized access to Gradle/Google/Maven/plugin/JitPack/foojay endpoints and vendor redirects; let Gradle identify exact build-tools; record dependency graph | **YES** |
| R-00C-03 | Critical to verification | E02 no adb/emulator/KVM; device matrix unexecuted | Launch, all ratings, undo, lifecycle, navigation and persistence unproven | Android QA/platform owner | Fresh emulator/disposable device; execute complete device matrix and instrumentation after isolation; preserve real evidence | **YES** |
| R-00C-04 | High | E01/E04/E05/E09; no FSA-00A attachment/report found | Original discovery assertions and parent waiver/naming contract cannot be fully reconciled | Product owner / original FSA-00A author | Supply original artifact with provenance (author/revision/date/hash), not a recreated substitute; independent comparison and contradiction record | **YES** |
| R-00C-05 | High | E03 all seven blocked; no APK/XML/lint output; zero exact-HEAD CI runs | Compiler/test/lint defects may exist; APK package/signing/hash and reproducibility unverified | Build maintainer + independent reviewer | Rerun all required commands at frozen source; inspect XML/HTML, lint, artifact metadata/signature/hash; rebuild before any reproducibility claim | **YES** |
| R-00C-06 | Critical to user data | E08 InitialActivity/SetupStorage; E09 CollectionHelper; broad file-grant source | Debug and official apps can share public collection storage; test runner path is nested under configured root | Android QA + storage/security owner | Verify actual collection/media/backup paths before mutation; use fully disposable environment; record paired-install isolation; never touch production `/AnkiDroid` | **YES** |
| R-00C-07 | High for distribution | App ID/signing source E08; fallback-key hash E07 | Release identity collides with official app; public fallback key cannot establish trusted updates | FSA-02 product/security/release owner | Keep release installs/distribution prohibited; define independent ID, key custody and provider/permission identity in FSA-02; do not uninstall official app | **NO** for a safely verified debug-only FSA-00; **YES for independent release distribution** |
| R-00C-08 | High pending contract | No authorized account; FSA-00A/parent waiver evidence absent | Sync state unverified; no lawful optional waiver established | Product owner + QA | Supply parent waiver authority and written waiver, or authorize isolated account/data and execute safe sync; never waive mandatory device/data safety | **YES**, until requirement/waiver is legitimately resolved |
| R-00C-09 | Medium | E02 3.8 GiB RAM/no swap; source daemon 3 GiB + test forks 2 GiB | Potential OOM/timeouts; no observed OOM or compiler failure | Build infrastructure owner | Use adequate-memory host; document any supported concurrency/JVM host setting; no off-record settings | **YES** to readiness here; capability must be demonstrated on rerun |
| R-00C-10 | Low technical / contract uncertainty | E01/E04 fixed Arena branch; historical B-06 demanded foundation name | Historical branch-name acceptance remains unresolved; isolated session itself is safe | Product owner / repository maintainer | Accept fixed session branch as equivalent isolation if allowed by parent contract; no branch switch/create/reset in this session | **YES** pending contract acceptance if inherited naming requirement is mandatory; cannot silently waive it |
| R-00C-11 | Medium | E07/E08: no wrapper distribution checksum, no tracked dependency verification/lockfile, repository enforcement commented | Source hashes do not authenticate downloaded artifacts or prove deterministic resolution | Build/security owner | Record standard repository provenance, resolved versions/artifact hashes on capable host; review hardening separately without changing frozen audit baseline | **NO** by itself (inherited policy); actual dependency/artifact verification remains blocked by R-02/R-05 |
| R-00C-12 | High for data routing / Medium for telemetry | E08/E09 manifest, filepaths, ACRA/analytics source | Shared handlers, broad grants and backup restore can cross intended boundaries; upstream telemetry attribution persists | Android security + QA; FSA-02 identity owner | Verify merged manifest and runtime routing/restore/permissions with disposable data; plan telemetry/backup identity decisions in FSA-02; never expose credentials | **YES** for runtime isolation via R-06; branding/telemetry policy alone is future-gate work |
| R-00C-13 | Low | E01/E05 shallow history; baseline object fetched and exact local diff; GitHub compare successful | Full local ancestry unavailable; remote snapshot may advance | Repository maintainer | Retain frozen SHAs/API evidence; use full-history capable-host checkout for stronger local ancestry reproduction, without merging upstream | **NO**; permitted source comparison established baseline/divergence |

## Historical blocker reassessment

| FSA-00B ID | Current disposition |
| --- | --- |
| B-01 no JDK | **Still BLOCKED**, fresh evidence R-01; prior failed JDK download is historical, not represented as a new attempt |
| B-02 restricted network | **Still BLOCKED**, seven new endpoint failures R-02; no dependency incompatibility established |
| B-03 no SDK/emulator | **Still BLOCKED**, R-02/R-03; no authorized capable remote target supplied |
| B-04 missing FSA-00A | **Still BLOCKED**, repository/workspace/PR/release search unsuccessful, R-04 |
| B-05 RAM | **Still readiness risk**, not a demonstrated failure, R-09 |
| B-06 foundation branch | **Naming contract unresolved**; fixed branch preserved, R-10; no unauthorized branch creation |
| B-07 shallow checkout | **Mitigated for this audit** via fetched reference tree + GitHub compare; checkout still shallow, R-13 |
| B-08 identity/storage | **Open**: storage safety mandatory now (R-06); release identity/key policy deferred to FSA-02 (R-07/R-12) |

## Ordered closure plan

1. **Owner prerequisites:** obtain original FSA-00A and parent Gate contract; reconcile claims, branch equivalence and sync policy. Preserve originals with provenance, append corrections rather than rewriting history.
2. **Capable build host:** allocate supported JDK/SDK, authorized repository connectivity, enough memory/disk and disposable Android target. Record exact source SHA and host configuration. Do not synchronize upstream as part of baseline verification.
3. **Build/test evidence:** run the complete build report command set; classify actual compiler/test failures only if observed. Collect test results, lint, APK hash/identity/signature and equivalent-condition rebuild evidence. Fix real defects only in a separately authorized targeted change, then rerun affected checks.
4. **Data safety first:** prove disposable storage/account separation before any mutation. Run full Reviewer, navigation, lifecycle, restart/undo and coexistence checks. Resolve sync authorization/waiver from contract, not convenience.
5. **Independent re-review:** rerun all affected verification rows with linked evidence. FSA-00 can lock only after every mandatory row passes and any truly optional waiver has proper authority. No inherited FAIL/BLOCKED row may be relabeled without new evidence.
6. **Then and only then:** activate FSA-01A discovery/classification. Independent release identity stays a separate FSA-02 requirement; never distribute a fallback-signed release.
