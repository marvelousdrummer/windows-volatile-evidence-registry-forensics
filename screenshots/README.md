# Selected evidence screenshots

Four focused captures from the controlled November 9, 2026 Windows 11 lab. The terminal values are preserved. `03_boot_and_logon_times.png` was cropped to remove unrelated content at the bottom.

| File | Visible evidence | Caveat |
| --- | --- | --- |
| `01_process_network_comparison.png` | Chrome 11 to 0 and established connections 27 to 26 | Aggregate counts do not establish connection persistence |
| `02_clipboard_comparison.png` | 107 to 76 characters and differing content | Copying an acquisition command may explain the change |
| `03_boot_and_logon_times.png` | Before/after boot and logon times | `forensicadmin` is a generic lab account |
| `04_notepad_dump_sizes.png` | 309.97 to 317.40 MB | Only Notepad process dumps; sizes do not identify changed data |

No suitable Registry screenshot was available. Registry findings are supported by reviewed historical before/after CSVs, reported in the [README](../README.md) and [sanitized delta](../data/registry-change-sanitized.csv).
