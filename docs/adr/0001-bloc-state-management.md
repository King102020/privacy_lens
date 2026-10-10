# ADR 0001: BLoC / Cubit for state management

## Status
Accepted

## Context
The production standards require one state-management approach, with
explicit loading, empty, error, and access-denied states. The product is a
Flutter app with several tabs that share a scan result.

## Decision
Use `flutter_bloc` Cubits. Shared app-scope Cubits hold Settings, Access,
Audit, Tracker Shield, and the data vault. Screen-local Cubits hold list
filters. There is no second state library.

## Consequences
Screens stay dumb. Concurrent scans are ignored in `AuditCubit` because the
repository is already single-flight. Tests use `bloc_test`.
