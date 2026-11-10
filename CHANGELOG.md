# Changelog

All notable changes to `rafi_login_template` will be documented in this file.

## 1.0.0

- Initial release of **Rafi Login Template** as a professional, reusable Flutter UI package.
- Features five interactive vector characters (**Cookie**, **Bean**, **Sun**, **Wobble**, **Pebble**) rendered with `CustomPainter`.
- Physics-based spring animations and interactive eye gaze tracking responding to real user typing and focus targets.
- Real user credentials handling with `LoginCredentials` (protects passwords from leaking in logs).
- Pluggable typed authentication callback API returning `AuthResult`.
- Configurable identifier types: `email`, `username`, `emailOrUsername`, and `name`.
- Optional 3-field layout (`showNameField`).
- Configurable branding widget support (`logo`).
- Support for both presentation phone mockup mode (`showPhoneFrame: true`) and direct embedded mode (`showPhoneFrame: false`).
- Bundled **Outfit** font family configured for zero-setup package integration.
- Included standalone example application with host-managed navigation and mock authentication flows.
