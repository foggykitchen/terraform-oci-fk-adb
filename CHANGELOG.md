# Changelog

## v2.0.0 — 2026-11-12

- BREAKING: require OCI provider >= 9.12.1, < 10.0.0 and OpenTofu >= 1.11.0.
- Preserve previous local module/example work in separate commits.
- Update embedded examples and dependency pins; add plan-only mocked test coverage.
- Preserve output names and shapes; mark adb_database sensitive because it includes wallet content and password. Consumers that re-export this object must also mark their outputs sensitive.
- Fix missing password arguments in clone and cross-region training examples. Resource addresses are unchanged.
- Explicitly retain SINGLE wallet generation after removal of the provider default.
