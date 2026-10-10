import '../domain/entities/finding.dart';

/// Stable `(kind, value)` encoding for persisted evidence rows. Values are
/// identifiers, never localized text.
abstract final class EvidenceCodec {
  static const String _never = 'never';

  static (String kind, String value) encode(Evidence evidence) =>
      switch (evidence) {
        CapabilityEvidence(:final capability) => (
          'capability',
          capability.name,
        ),
        SpecialAccessEvidence(:final kind) => ('specialAccess', kind.name),
        TrackerSdkEvidence(:final sdk) => ('trackerSdk', sdk.id),
        LastUsedEvidence(:final lastUsedAt) => (
          'lastUsed',
          lastUsedAt?.toUtc().toIso8601String() ?? _never,
        ),
        BlockedDomainEvidence(:final domain, :final count) => (
          'blockedDomain',
          '$domain|$count',
        ),
      };
}
