# Food Ninja (Flutter)

Simple mobile app prototype for user onboarding flow:

- Splash screen
- Login screen with remember-me support
- Register screen with remote API call

## What Was Improved

This repository has been updated with UI/UX and code-quality improvements:

- Refreshed splash/login/register visual layout (gradient background, card-based form, better spacing)
- Added form validation for name, email, mobile, and password
- Fixed login action bug (button previously did nothing)
- Fixed register password visibility logic
- Improved register API success handling (`success` and `succes`)
- Added safer async flow (`try/catch/finally`) for registration request
- Added proper `dispose()` for controllers to prevent memory leaks
- Updated widget test to match current app behavior

## Project Structure

```text
lib/
  splashscreen.dart   # App entry + splash screen
  loginpage.dart      # Login form + remember me
  registerpage.dart   # Registration form + API integration
  user.dart           # Basic user model (legacy)
test/
  widget_test.dart    # Basic UI smoke test
```

## Requirements

- Flutter SDK (compatible with legacy non-null-safety project)
- Dart SDK matching `pubspec.yaml` constraint (`>=2.2.2 <3.0.0`)

## Run Locally

1. Open terminal in `food_ninja`
2. Install dependencies:

```bash
flutter pub get
```

3. Run app:

```bash
flutter run
```

4. Run test:

```bash
flutter test
```

## API Endpoint

Register flow posts to:

`https://slumberjer.com/foodninjav2/php/register_user.php`

If endpoint is unavailable, app will show a network error message.

## Notes

- Current login is still demo-mode (client-side validation + optional remember me)
- For production, add real authentication endpoint and token/session handling
- Migrate to null safety when upgrading Flutter/Dart version
