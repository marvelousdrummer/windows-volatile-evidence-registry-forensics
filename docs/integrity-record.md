# Historical Registry evidence SHA-256 digests

The original lab's `Registry_Evidence_Hashes.csv` recorded these hashes for the **unmodified evidence export files**. These files remain private and are not part of this repository.

| Original file | Recorded SHA-256 |
| --- | --- |
| `Before_InstalledSoftware.csv` | `9DB891EA37F43529869AD4D19450F00207C64DE91A0A0115488DE22929FDB10D` |
| `After_InstalledSoftware.csv` | `730D124651B5B3B927B49E81955D94407C169035A54A02BFDF7D74161BCCC3FA` |
| `Software_Registry_Changes.csv` | `C94FB4094083C6A1101B195FB1F11DCF3FF369F42F13FB8F2AD662E21ADEC585` |

**Caution:** The hashes are historical lab records; they have not been independently recomputed here against the source VM files. The published `data/registry-change-sanitized.csv` omits the unique Registry path and has different bytes. Therefore the original hash will not match that sanitized copy.

To check the hashes against your private original files:

```powershell
Get-FileHash -Algorithm SHA256 -LiteralPath "C:\private\Before_InstalledSoftware.csv"
Get-FileHash -Algorithm SHA256 -LiteralPath "C:\private\After_InstalledSoftware.csv"
Get-FileHash -Algorithm SHA256 -LiteralPath "C:\private\Software_Registry_Changes.csv"
```

SHA-256 matching can verify file content identity when the originals are available, but it is not alone a chain-of-custody record.
