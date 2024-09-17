# magic-ai-fi

## Overview

This Workout Tracker App is a Flutter-based mobile application designed to help users track their workout routines. It allows users to create, view, edit, and delete workouts, as well as manage individual sets within each workout.

## Architecture

This project follows the principles of Clean Architecture, which provides several benefits:

1. **Separation of Concerns**: The app is divided into three main layers:
   - Domain: Contains business logic and entities
   - Data: Handles data management and external interfaces
   - Presentation: Manages UI and user interactions

2. **Dependency Rule**: Dependencies point inwards, with the domain layer at the center, independent of outer layers.

3. **Testability**: The separation of concerns makes it easier to write and maintain unit tests.

4. **Flexibility**: It's easier to swap out implementations (e.g., changing the database) without affecting the entire system.

## Key Architectural Components

### Domain Layer
- Entities: `Workout` and `WorkoutSet`
- Use Cases: `AddWorkout`, `DeleteWorkout`, `GetWorkouts`, `UpdateWorkout`
- Repository Interfaces: `WorkoutRepository`

### Data Layer
- Models: `WorkoutModel` and `WorkoutSetModel` for data mapping
- Data Sources: `WorkoutLocalDataSource` for local data persistence
- Repository Implementations: `WorkoutRepositoryImpl`

### Presentation Layer
- Views: `WorkoutListView` and `WorkoutView`
- ViewModels: `WorkoutListViewModel` and `WorkoutViewModel`
- Widgets: Various dialogs and UI components

## Third-Party Packages

1. **provider**: 
   - Purpose: State management
   - Reasoning: Provider offers a simple yet powerful way to manage app state. It's officially recommended by the Flutter team and integrates well with Flutter's widget tree.

2. **get_it**:
   - Purpose: Dependency injection
   - Reasoning: Get_it provides a simple and flexible way to implement dependency injection. It allows for easy registration and retrieval of dependencies, promoting loose coupling and testability.

3. **shared_preferences**:
   - Purpose: Local data storage
   - Reasoning: For small amounts of data, SharedPreferences offers a simple key-value storage solution. It's efficient for storing app settings and small datasets.

4. **dartz**:
   - Purpose: Functional programming constructs
   - Reasoning: Dartz provides tools for handling operations that can fail, like the Either type. This allows for more expressive error handling in our use cases and repositories.

5. **equatable**:
   - Purpose: Equality comparisons
   - Reasoning: Equatable simplifies the implementation of equality for our entity and model classes. This is particularly useful for efficient comparisons in lists and for state management.

## Project Structure

```
lib/
├── core/
│   ├── error/
│   └── usecases/
├── features/
│   └── workout/
│       ├── data/
│       ├── domain/
│       └── presentation/
├── utils/
├── injection_container.dart
└── main.dart
```

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the app

## Future Improvements

- Implement comprehensive test suite
- Add data synchronization with a backend server
- Enhance UI/UX with more sophisticated design elements
- Implement more advanced workout tracking features

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License.