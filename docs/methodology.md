# Methodology, provenance, and selection

This independently written portfolio project is based on a completed **November 9, 2026** Windows 11 virtual machine lab in CYB/451 Computer Forensics Lab.

## Sources reviewed but not redistributed

- Four-page student report, *Changes in Forensic Evidence After Windows Shutdown and Software Installation*.
- `Final_Lab_Findings.txt`, `Clipboard_Analysis_Notes.txt`, `Volatile_Comparison_Summary.txt`.
- `Before_SystemTime.txt` and `After_SystemTime.txt`.
- `Memory_Dump_Comparison.txt`.
- `Before_InstalledSoftware.csv` (21 rows), `After_InstalledSoftware.csv` (22 rows).
- `Software_Registry_Changes.csv` (one newly listed Adobe record).
- `Registry_Evidence_Hashes.csv` (three original SHA-256 records).
- Nine screenshots found from the lab period, of which four were selected.

The original university report, copyrighted course instructions, software inventories, memory dumps, raw clipboard text, account lists, and unfiltered network details are **not published**.

## Historical investigation (documented in source)

1. Create controlled browser and Notepad test activity in the Windows 11 VM.
2. Capture system times, logged-on sessions, connections, processes, mapped drives, clipboard text, and PowerShell session history.
3. Produce a Notepad process dump using Task Manager.
4. Shut down, restart, and repeat the collections.
5. Compare selected counts and text; preserve acquisition limitations.
6. Export software inventory from Registry Uninstall locations before and after installing Adobe Acrobat.
7. Compare entries and save SHA-256 hashes of the original Registry CSV evidence.

## Screenshot review

- **Selected:** process/network comparison; clipboard comparison; boot and login timestamps; Notepad memory-dump sizes.
- **Rejected:** a captured PowerShell hash-export error, unrelated UI, an incomplete capture of commands, and redundant/low-value screenshots.
- **Image modification:** only the boot/login screenshot was cropped to eliminate an unrelated application below the terminal. Recorded forensic output was not changed.
- **Privacy:** the terminal account name `forensicadmin` belongs to the test VM. Host Windows personal user paths, live credentials, and third-party account data are excluded.
- **Registry:** no suitable Registry screenshot was available. The published Registry finding comes from the original CSVs, not an invented screen capture.

## Reusable code status

The Python comparator and PowerShell scripts were **prepared after the lab** for portfolio use. They are not copies of the exact command sequence run during the experiment. The Python comparator is tested with synthetic unit tests and checked against the original CSV exports; the PowerShell examples have **not** been run in the historical Windows VM in their present form.

This project documents learning and evidence assessment. It does not claim a court-ready forensic chain of custody.
