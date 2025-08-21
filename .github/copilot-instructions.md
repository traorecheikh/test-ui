# Copilot Instructions for tontineflow

## Project Overview
- **tontineflow** is a Flutter app that digitizes traditional "tontines" (rotating savings and credit associations), focusing on transparency and automation for community finance in Africa.
- The app is structured around core models (`Tontine`, `User`, `Contribution`) and service classes (notably `TontineService` and `StorageService`) that manage business logic and persistence.

## Architecture & Key Patterns
- **lib/models/**: Contains data models. `tontine.dart` defines the main business entity, with enums for frequency, draw order, and status.
- **lib/services/**: Business logic is encapsulated in services. `tontine_service.dart` manages tontine lifecycle, user participation, contributions, and demo data. All persistent operations go through `StorageService`.
- **lib/screens/**: UI screens are organized by feature (e.g., `home_screen.dart`, `create_tontine_screen.dart`). Navigation is handled via Flutter's `MaterialApp`.
- **lib/widgets/**: Reusable UI components (e.g., `tontine_card.dart`, `pot_visual.dart`).
- **lib/utils/**: Utility functions and constants (e.g., `constants.dart`, `formatters.dart`).
- **Theme**: App-wide white-darkmode theming is in `theme.dart` and applied in `main.dart`.

Move all business logic, state variables, and methods from the screen widgets into their respective controllers.
Use Rx variables for all state that should trigger UI updates.
Keep widgets as “dumb” as possible—let controllers handle all logic.

## Developer Workflows
- **Build/Run**: Use standard Flutter commands:
  - `flutter pub get` to fetch dependencies
  - `flutter run` to launch the app
  - `flutter test` to run tests (if present)
- **iOS Launch Images**: Customize launch assets in `ios/Runner/Assets.xcassets/LaunchImage.imageset/`.
- **Sample Data**: On first run, demo data is generated in `TontineService._generateSampleData()` if no tontines exist.
 
## UI/UX Design Principles & Best Practices
- **Clarity & Simplicity**: Prioritize minimal clutter, clear hierarchy, and generous white space. Every element must have a clear purpose.
- **Bold, Friendly Typography**: Use large, readable fonts and bolder section headers for easy scanning.
- **Playful, Distinctive Colors**: Assign unique, friendly colors to actions and sections to guide users and create delight.
- **Smooth Animations & Feedback**: Provide subtle transitions, button tap feedback, and field focus highlights for a modern feel.
- **Friendly, Human Touch**: Use personalized greetings, avatars, motivational quotes, and micro-interactions to make the app feel welcoming.
- **Consistent, Rounded Elements**: All cards, buttons, and avatars should be rounded and spaced for a "soft" and modern look.
- **Accessibility**: Ensure high contrast, large tap targets, and readable text throughout the app.
- **Micro-interactions**: Add feedback for user actions, empty states with friendly copy, and clear error/success messages.
- **iOS-inspired Layouts**: Favor a light theme, generous padding, and "fluffy" layouts for a premium, mobile-first experience.

## Project-Specific Conventions
- **Data Flow**: All tontine and contribution data is loaded and saved via `StorageService`. In-memory lists are used for app state.
- **Tontine Lifecycle**: Creation, joining, starting, and round management are all handled in `TontineService`.
- **Invite Codes**: Tontines are joined via unique invite codes (`Tontine.inviteCode`).
- **Localization**: Dates are formatted for `fr_FR` locale by default (see `main.dart`).
- **Enums**: Business logic uses enums with French labels for clarity in UI.

## Integration & Dependencies
- **Flutter SDK**: See `pubspec.yaml` for required SDK and dependencies (e.g., `intl`, `shared_preferences`, `qr_flutter`).
- **No backend**: All data is local; no remote API integration is present by default.

## Examples
- To add a new tontine, use `TontineService.createTontine(...)` and persist via `StorageService`.
- To mark a contribution as paid, call `TontineService.markContributionPaid(...)`.

## Key Files
- `lib/models/tontine.dart`, `lib/services/tontine_service.dart`, `lib/screens/`, `lib/widgets/`, `lib/utils/constants.dart`, `theme.dart`, `main.dart`

---

**For AI agents:**
- Follow the patterns in `TontineService` for business logic.
- Use enums and model constructors as defined; do not invent new fields.
- Always persist changes via `StorageService`.
- Reference this file for project-specific conventions before generating code.
