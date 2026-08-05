# Security policy

## Supported versions

Security fixes are applied to the latest revision of `main`. Release-specific support guarantees
will be documented when the project begins publishing versioned releases.

## Reporting a vulnerability

Do not open a public issue for a suspected vulnerability. Use GitHub's private vulnerability
reporting feature for this repository and include the affected component, reproduction steps,
impact, and any suggested remediation.

Maintainers will acknowledge a complete report within seven days, coordinate validation and a
fix privately, and credit the reporter when requested. Never include live credentials, Roblox
session cookies, user data, or third-party secrets in a report.

## Baseline expectations

- The backend must run as an unprivileged container user.
- Secrets must be supplied at runtime and must never be committed.
- Plugin HTTP access must be explicit, narrowly scoped, and documented before it is introduced.
- Dependencies and GitHub Actions are reviewed and updated through automated pull requests.
