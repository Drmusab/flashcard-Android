# FSA-00C — Disposable Android and Reviewer verification

**Revision:** `f8212252540fe104663e935d4c582e9ad499ec89`.
**Date:** 2026-10-25 UTC. **Result: BLOCKED. No device session occurred.**
Evidence IDs are defined in [entry report](FSA-00C-ENTRY-AND-EVIDENCE.md).

## Actual observations

E02: `adb devices -l` exits **127** (`adb: command not found`); emulator/SDK tools and `/dev/kvm` are absent. E03: FullDebug build exits **1** before JVM startup. E02/E07: no APK. Thus there is no suitable Android target or installable artifact for this audit. No installation, collection opening, import, note creation, rating, backup/restore or synchronization was performed. No user-owned collection was accessed.

| Required device check | Actual result | Evidence / missing observation |
| --- | --- | --- |
| Disposable environment/collection/path | BLOCKED | E02/E03; no target, selected path or dataset exists |
| App launch | BLOCKED | No install or Android launch log |
| Deck access | BLOCKED | No test deck opened |
| Question/front display | BLOCKED | No rendering observed |
| Answer reveal/back display | BLOCKED | No rendering observed |
| Again | BLOCKED | No native rating executed |
| Hard | BLOCKED | No native rating executed |
| Good | BLOCKED | No native rating executed |
| Easy | BLOCKED | No native rating executed |
| Undo | BLOCKED | No before/after collection or review state |
| Session end/data integrity | BLOCKED | No session occurred |
| Restart/persisted collection | BLOCKED | No persistence observation |
| Process recreation/lifecycle | BLOCKED | No lifecycle test; source state-saving is not a runtime PASS |
| Navigation | BLOCKED | No browser/editor/settings/statistics traversal |
| Official/debug coexistence | BLOCKED | Source IDs differ; no paired installation or storage observations |
| Collection isolation/user-data safety on Android | BLOCKED | No runtime path/account/backup verification; no personal data touched during this audit |
| Sync | **UNVERIFIED — TEST ACCOUNT NOT AUTHORIZED** | No disposable credentials/account authorization supplied; no sync attempted |

No screenshots, logcat files or device test XML were produced. `connectedFullDebugAndroidTest` was **not run**, rather than presented as a passing or attempted instrumentation suite. Every mandatory runtime requirement stays blocked.

## Safe rerun protocol — pending, NOT evidence of completion

1. **Target:** use a fresh emulator or dedicated disposable device/profile with no personal accounts, collections, restored app data or production `/storage/emulated/0/AnkiDroid`. Record emulator image/API, device serial, Android build and app version. Do not clear/uninstall any personal app to create this condition.
2. **Artifact:** require the FullDebug APK verified in the build report, including hash/package/signature; use its real path. Never sideload the fork release as a substitute. Disable production sync and avoid inherited credentials.
3. **Storage before mutations:** document actual selected collection/media/backup directories for each installation/profile. Inspect startup selections and preferences; compare resolved paths. Do this before creating a note, importing a package, rating or syncing. FullDebug may choose shared PUBLIC storage automatically. If testing official/debug coexistence, both installs must use disposable data and demonstrably different paths. Abort on any personal/shared production path.
4. **Dataset:** once isolation is proven, create a small local test deck with deterministic fronts/backs and enough cards to exercise all four ratings separately. Record dataset recipe, card IDs and expected states. Do not use a personal deck or a remote PC queue. Avoid custom scheduling JavaScript for the basic native smoke test; record FSRS/deck settings.
5. **Reviewer:** capture front/back, each rating, review history/queue transitions and Undo's restored state. Verify a single committed answer per deliberate input; include rapid/repeated input observations and rotation/background/foreground/process recreation checks. Merely seeing button taps is insufficient evidence of native scheduling correctness.
6. **Persistence/navigation:** finish session, restart app and verify known collection state; navigate browser/editor/settings/stats. Validate backup destinations and integrity using only disposable data. Document any crash, data loss or mismatch rather than assuming upstream behavior is sound.
7. **Automation:** after isolation, run `./gradlew :AnkiDroid:connectedFullDebugAndroidTest` with the default debug test build type (ensure `TEST_RELEASE_BUILD` is not true). Save actual runner/XML results. The runner's `androidTest` subdirectory is relative to the configured root; it is not a sandbox by itself.
8. **Evidence:** preserve command exits, exact APK hash, actual package/authority/permission metadata, storage-path evidence, timestamped screenshots/logcat and collection state comparisons. Scrub secrets and personal content. Record teardown of disposable assets only.

## Sync authorization and waiver

No disposable AnkiWeb account was authorized. A suitable account still requires proof of isolated local/remote data and permission to sync; never use production synchronization as a smoke test.

No parent Gate contract expressly allowing an optional sync waiver is available. Therefore **no waiver is granted**, and an unexecuted sync cannot become PASS. Obtain the parent contract and explicit written waiver if permitted, or execute an authorized isolated sync later. Mandatory build, Reviewer and data-isolation tests cannot be waived under this audit.
