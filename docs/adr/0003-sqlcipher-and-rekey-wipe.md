# ADR 0003: SQLCipher vault and wipe-by-rekey

## Status
Accepted

## Context
Audit rows, usage, and blocked DNS events are sensitive. Deleting a database
file can leave pages on flash. Users also asked for a "wipe data vault"
action.

## Decision
Encrypt the Drift database with SQLCipher. The 256-bit key is created once
and stored in Android Keystore through `flutter_secure_storage`. Wipe does
not delete the file. It deletes every row, runs `PRAGMA rekey` with a new
key, then `VACUUM`, and saves the new key. Native caches are cleared in the
same action.

If the file cannot be decrypted at startup (for example after an interrupted
wipe), it is replaced with an empty database so the app stays usable.

## Consequences
Backup and device transfer are disabled. Schema snapshots live under
`drift_schemas/` so migration tests can run when the schema changes.
