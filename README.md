# electron-check-biometric-auth-changed

A native node module that allows you to query and handle native macOS biometric authentication changes.

This module will have no effect unless there's an app bundle to own it: without one the API will simply appear not to run as a corollary of the way macOS handles native UI APIs.

**Nota Bene:** This module does not nor is it intended to perform process privilege escalation, e.g. allow you to authenticate as an admin user.

## API

### `checkBiometricAuthChanged`
Returns `Boolean` - whether or not the biometric authentication settings have changed since the last check. This includes changes to enrolled fingerprints, Face ID data, or other biometric authentication settings.
