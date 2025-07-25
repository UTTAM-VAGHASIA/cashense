# Implementation Plan

- [x] 1. Create MVVM directory structure and setup barrel exports





  - Create the new MVVM directory structure (models/, views/, viewmodels/, services/, utils/, constants/)
  - Set up barrel export files (index.dart) for each major directory
  - Create subdirectories for shared and feature-specific code
  - _Requirements: 1.1, 3.1, 3.2, 3.3_

- [x] 2. Migrate core utilities and constants to flattened structure





  - Move files from core/constants/ to constants/ directory
  - Move files from core/utils/ to utils/ directory
  - Move files from core/exceptions/ to utils/exceptions.dart
  - Update all import statements for moved utility files
  - _Requirements: 1.4, 4.1, 4.2_

- [x] 3. Migrate shared services to services directory





  - Move files from shared/services/ to services/ directory
  - Update import statements for service files across the codebase
  - Ensure service functionality remains unchanged
  - _Requirements: 1.4, 3.4, 4.1, 4.2_

- [x] 4. Create and migrate settings feature models





  - Move lib/features/settings/domain/entities/app_settings.dart to models/features/settings/app_settings_model.dart
  - Enhance the model with any additional validation or business logic if needed
  - Create barrel export file for settings models
  - Update imports for the settings model across the codebase
  - _Requirements: 2.1, 2.2, 4.1, 4.2, 5.5_

- [x] 5. Create settings ViewModel by consolidating provider and repository logic





  - Create viewmodels/features/settings/settings_viewmodel.dart
  - Migrate logic from lib/features/settings/presentation/providers/settings_provider.dart
  - Integrate repository implementation logic directly into the ViewModel (from settings_repository_impl.dart)
  - Remove repository abstraction layer and make direct service calls
  - Update ViewModel to use the new settings model location
  - _Requirements: 2.2, 2.3, 4.1, 4.2, 5.5_

- [x] 6. Migrate settings views to new structure





  - Move lib/features/settings/presentation/pages/settings_page.dart to views/features/settings/pages/settings_page.dart
  - Update imports in settings page to use new ViewModel and model locations
  - Create barrel export files for settings views
  - Ensure settings page functionality remains unchanged
  - _Requirements: 2.4, 4.1, 4.2, 5.3_

- [x] 7. Migrate shared widgets to views structure





  - Move files from shared/widgets/ to views/shared/ directory
  - Update import statements for shared widgets across the codebase
  - Create barrel export file for shared views
  - _Requirements: 2.4, 3.2, 4.1, 4.2_

- [x] 8. Update app-level imports and configuration





  - Update lib/main.dart imports to use new service and ViewModel locations
  - Update lib/app/app.dart imports for any shared components
  - Update app router imports if it references moved components
  - Ensure app initialization and configuration work with new structure
  - _Requirements: 4.1, 4.2, 4.3, 5.4_

- [x] 9. Create provider exports and update dependency injection





  - Create viewmodels/providers.dart barrel file that exports all ViewModels
  - Update main.dart and other files that reference providers to use new locations
  - Ensure Riverpod dependency injection works with new ViewModel structure
  - Test that state management continues to work correctly
  - _Requirements: 2.3, 4.3, 5.5_

- [x] 10. Remove old Clean Architecture directories and files





  - Delete lib/features/settings/data/ directory and its contents
  - Delete lib/features/settings/domain/ directory and its contents
  - Delete lib/features/settings/presentation/ directory and its contents
  - Delete empty lib/features/settings/ directory
  - Delete lib/core/ directory and its contents
  - Delete lib/shared/ directory and its contents
  - _Requirements: 1.1, 1.2, 1.3_

- [x] 11. Update and verify all import statements





  - Run Flutter analyzer to identify any remaining import errors
  - Fix any remaining import statements that reference old file locations
  - Ensure all barrel exports are working correctly
  - Verify that no unused imports remain
  - _Requirements: 4.1, 4.2, 4.3_

- [x] 12. Clean up empty directories and test application functionality




  - Remove empty feature directories that will be created later as needed (models/features/*, views/features/*, viewmodels/features/* except settings)
  - Keep only the directory structure that is currently being used
  - Run the application and verify settings page loads correctly
  - Test all settings functionality (theme changes, toggles, reset)
  - Verify app initialization and navigation work correctly
  - Fix any runtime errors or functionality issues
  - Run existing tests and update test imports if needed
  - _Requirements: 1.1, 5.1, 5.2, 5.3, 5.4, 5.5_