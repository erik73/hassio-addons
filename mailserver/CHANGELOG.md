## What’s changed

- This release provides a fix for the socklog-overlay logging that is used by this add-on. In the new supervisor that is now in beta, /dev/log is symlinked to a folder. This version will make logging work for old and new supervisor versions.

## 🚀 Enhancements

- Logfix @erik73 (#35)
- Add symbolic link for dev/log if it is missing @erik73 (#38)
- Fix typos in documentation @erik73 (#39)

## ⬆️ Dependency updates

- Bump actionshub/markdownlint from 2.0.0 to 2.0.2 @dependabot (#37)
- Bump actions/cache from v2.1.3 to v2.1.4 @dependabot (#36)
