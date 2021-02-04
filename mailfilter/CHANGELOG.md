## What’s changed

- Stop using sock log-overlay for logging. An upcoming change in the supervisor
  will cause problems, and socklog is really not needed for this add-on.

## 🚀 Enhancements

- Remove socklog and log to stdout instead @erik73 (#17)
- Fix Freshclam config file @erik73 (#18)

## ⬆️ Dependency updates

- Bump frenck/action-yamllint from v1.0.2 to v1.1 @dependabot (#15)
- Upgrade base image to 1.0.1 @erik73 (#16)
