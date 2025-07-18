# Dependencies Documentation

## Core Dependencies Status

### ✅ Successfully Added
- **flutter_riverpod**: State management
- **Firebase suite**: Core backend services (Auth, Firestore, Storage, Analytics, Crashlytics, Messaging, Functions)
- **hive & hive_flutter**: Local storage
- **go_router**: Navigation
- **fl_chart**: Charts and analytics visualization
- **flutter_form_builder & form_builder_validators**: Form handling
- **dynamic_color**: Material 3 theming
- **currency_picker & money2**: Multi-currency support
- **dio**: HTTP client
- **flutter_tts**: Text-to-speech (working alternative)
- **image_picker & cached_network_image**: Image handling
- **permission_handler**: Device permissions
- **timezone**: Date/time utilities

### ⏸️ Deferred Dependencies
- **speech_to_text**: Skipped due to known cross-platform bugs
  - **Alternative**: Will implement voice input using platform-specific solutions or wait for bug fixes
  - **Impact**: Voice transaction entry feature will be implemented later
  - **Workaround**: Users can use text input and TTS for accessibility

### 🔄 Code Generation Tools
- **build_runner**: Code generation runner
- **freezed**: Immutable data classes
- **json_serializable**: JSON serialization
- **hive_generator**: Hive type adapters

## Notes
- All critical dependencies for core financial management features are in place
- Voice input can be added later when speech_to_text issues are resolved
- Project is ready for core development without voice features