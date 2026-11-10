# Changelog

All notable changes to `rafi_login_template` will be documented in this file.

## 1.1.0

- **Genuine Full-Screen Responsive Layout**: Replaced the presentation phone mockup stage with a production-ready edge-to-edge layout that natively respects `SafeArea` and system navigation insets.
- **Keyboard-Aware Scrolling & Layout**: Integrated responsive `SingleChildScrollView` with clamping physics and bottom view-inset listeners, preventing `RenderFlex` overflows when virtual software keyboards open.
- **Responsive Form Positioning**: Refactored `RafiLoginForm` from fixed coordinate positioning into a modern, adaptive `Column` layout constrained to 400px on wider screens.
- **Adaptive Character Positioning & Keyboard Behavior**: Back characters (`Cookie`, `Sun`, `Bean`) center dynamically with starfield sparkles in the header stage, while front corner characters (`Wobble`, `Pebble`) automatically fade out smoothly when the keyboard opens so they never occlude form fields or the action button.
- **Backward Compatibility for `showPhoneFrame`**: Retained `showPhoneFrame` as a deprecated parameter defaulting to `false`, allowing existing v1.0.0 consumers to upgrade seamlessly without compilation errors.
- **Removal of Obsolete Mockup Widgets**: Cleaned up internal, non-public mockup staging widgets (`DesignStage`, `PhoneFrame`, and `StatusBar`).
- **Expanded Responsive & Keyboard Tests**: Added comprehensive test cases for small mobile screens (360x640), virtual keyboard inset simulations, and high system text scaling (1.5x).

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
