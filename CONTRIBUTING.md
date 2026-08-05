# Contributing

Thank you for helping build Roblox AI. The project accepts focused issues and pull requests that
keep the plugin and backend boundaries explicit.

## Development workflow

1. Read [the development guide](docs/development.md) and install the pinned toolchains.
2. Create a branch from `main` and keep each change scoped to one concern.
3. Add or update tests for behavior changes.
4. Run every local quality check documented in the development guide.
5. Open a pull request that explains the problem, the design, and the verification performed.

Commits should use imperative, descriptive subjects. Do not commit generated build artifacts,
local environments, credentials, or installed Wally packages.

## Architecture changes

Changes that add a service, protocol, persistence mechanism, or cross-boundary dependency must
update `docs/architecture.md`. Significant and difficult-to-reverse decisions should be proposed
in an issue before implementation.

## Reporting defects

Include reproducible steps, expected behavior, actual behavior, Roblox Studio or Python versions,
and relevant logs with secrets removed. Report vulnerabilities according to `SECURITY.md`, not in
a public issue.
