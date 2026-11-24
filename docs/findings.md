# Investigation findings

**Lab date:** November 9, 2026  
**Target:** Controlled Windows 11 Enterprise Evaluation VM  
**Study:** Before/after live-system captures, process memory, and Windows Uninstall Registry analysis

## A. Before-and-after system state

Before shutdown, Administrator PowerShell collected local and UTC time, last boot, logged-on user, active TCP connections, processes, mapped drives, clipboard content, and session command history. Task Manager created a Notepad process memory dump. After shutdown and restart, comparable observations and another Notepad dump were collected.

- Last boot changed from **4:27:22 p.m.** to **4:54:51 p.m.** on November 9, 2026 (VM local time).
- Interactive login changed from approximately **4:28 p.m.** to **4:55 p.m.**
- Chrome process entries changed **11 → 0** because Chrome was not reopened before the second capture.
- Established TCP connection counts changed **27 → 26**. These are aggregate counts, not per-connection identities.
- Neither capture showed mapped network drives.
- Current PowerShell session-history entries were **7 → 6**. `Get-History` only reports the session and is not all user activity.

**Interpretation:** The live-state snapshots differ after restart. A changed count is not proof that a particular process or socket survived or was permanently erased.

## B. Clipboard artifact and collection effects

The pre-shutdown clipboard contained **107 characters** of synthetic test information mentioning Chrome and Facebook. The post-restart clipboard capture had **76 characters**, and the text was the collection command rather than the original test text.

**Interpretation:** The original content was absent from the post-restart capture, but copying the PowerShell command into the VM may have replaced it. This experiment **cannot attribute the clipboard difference to shutdown**. It illustrates how live evidence collection can change the observed artifact.

## C. Process memory versus system memory

Task Manager created one Notepad *process* dump per session.

| Capture | Reported size | VM-local timestamp |
| --- | ---: | --- |
| Before_Notepad_ProcessMemory.dmp | 309.97 MB | November 9, 4:47:38 p.m. |
| After_Notepad_ProcessMemory.dmp | 317.40 MB | November 9, 5:03:58 p.m. |

**Interpretation:** The files have different sizes; there was no byte-level analysis of their contents in the supplied findings. A Notepad process dump is **not** a complete physical memory image.

## D. Windows Uninstall Registry investigation

The original before and after inventory CSVs were inspected directly while preparing this portfolio. They contain **21** and **22** records, respectively. The captured `Compare-Object` output listed a single added item (`SideIndicator =>`):

| Observed field | Original recorded value |
| --- | --- |
| DisplayName | Adobe Acrobat (64-bit) |
| DisplayVersion | 26.002.22031 |
| Publisher | Adobe |
| InstallDate | 20261109 |
| Hive | HKEY_LOCAL_MACHINE |

The exports included uninstall-key locations in `HKEY_LOCAL_MACHINE`, `WOW6432Node`, and `HKEY_CURRENT_USER`. Adobe had not appeared in the before inventory and appeared in the after inventory, consistent with the controlled installation step.

**Interpretation:** A Registry before/after comparison can reveal application-presence changes. The `InstallDate` value is **not independently conclusive** about when an application was first installed, because servicing can also affect installation metadata. The full original inventories and the unique uninstall-key identifier were withheld from the public-ready project. [View the derived delta](../data/registry-change-sanitized.csv).

## E. Integrity assessment

The original lab recorded SHA-256 values for the before inventory, after inventory, and Registry change CSV. These are preserved in [integrity-record.md](integrity-record.md) as historical results. Since the original evidence CSVs are excluded, a reviewer cannot rehash those originals using this repository alone. The sanitized CSV has a different byte stream and therefore a different digest.

## Lessons and limits

1. Collect relevant perishable artifacts before a planned shutdown.
2. Preserve original acquisition outputs and document when, how, and by whom they were obtained.
3. Distinguish observations (counts, timestamps, sizes) from causal conclusions.
4. Consider collection interference, especially with clipboard content.
5. Use before/after Registry comparisons as supporting evidence, not definitive installation timelines.
6. Do not present a process dump as a full-memory capture or hashes alone as a full chain of custody.

This is an educational experiment, not a forensic-tool validation or legal case report.
