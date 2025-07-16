# 🛠️ Tech Requirements & Dependencies

## Platforms
- Mobile: Android and iOS
- Web: Progressive Web App support
- Desktop: Future expansion (Phase 6)

## Frontend
- Flutter SDK (stable channel, managed with FVM)
- State Management: Riverpod
- Local Storage: 
  - Mobile: Isar
  - Web: IndexedDB (via Hive or localstorage)
- UI Components: Material 3 design system
- Charts: fl_chart (web-compatible)
- Forms: flutter_form_builder
- Navigation: go_router
- Localization: flutter_localizations and intl
- Testing: flutter_test, mockito, riverpod_test

## Backend (Supabase)
- PostgreSQL database
- Row-level security policies
- Supabase Auth with multiple providers
- Supabase Edge Functions for complex operations
- Supabase Storage for file storage
- Realtime subscriptions for sync

## API Integrations
- OpenAI API (GPT-4 or equivalent for NLP)
- Web Speech API for voice commands on web
- Google Speech-to-Text API for voice commands on mobile
- Banking API partnerships (region-specific)
- Firebase Cloud Messaging for notifications (mobile only)
- Web Push API for web notifications

## Web-Specific Requirements
- Progressive Web App (PWA) configuration
- Service worker for offline functionality
- Web-compatible storage solutions
- Responsive layouts for various screen sizes
- Web-specific authentication flows

## Additional Dependencies
- flutter_hooks & hooks_riverpod for stateful logic reuse
- freezed for immutable models and code generation
- json_serializable for JSON parsing
- uuid for unique identifiers
- intl for date/currency formatting
- secure_storage:
  - Mobile: flutter_secure_storage
  - Web: localstorage with encryption
- rxdart for advanced stream operations
- dio for HTTP requests outside of Supabase
- cached_network_image for efficient image loading
- shimmer for loading state UI

## Development Tools
- Codemagic or GitHub Actions for CI/CD
- Flutter Version Management (FVM)
- dart_code_metrics for code quality
- GitFlow workflow
- Figma for UI/UX design
- Postman for API testing 
- Browser testing suite for web platform 
