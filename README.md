# Countries List iOS Application

## Overview
This iOS application was developed as part of a coding assessment challenge. It allows users to search for countries, view their details, and manage a list of up to 5 favorite countries. The application uses the REST Countries API to fetch country information and implements location-based features.

## Architecture
The application is built using the **MVVM (Model-View-ViewModel)** architecture pattern with a **Coordinator** pattern for navigation management. This combination provides several benefits:

### MVVM Pattern
- **Separation of Concerns**: Clear separation between UI (View), data (Model), and business logic (ViewModel)
- **Testability**: ViewModels are independent of the UI, making them easier to test
- **Data Binding**: Using Combine framework for reactive data flow between View and ViewModel
- **Reusability**: Components can be reused across different parts of the application

### Coordinator Pattern
- **Centralized Navigation**: Moves navigation logic out of ViewControllers
- **Decoupled Screens**: Each screen doesn't need to know about other screens
- **Flow Control**: Easier to manage complex navigation flows
- **Improved Testability**: Navigation logic can be tested independently

## Project Structure

```
CountriesListTask/
├── Application/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   └── AppCoordinator.swift
├── Data/
│   ├── Models/
│   │   ├── Country.swift
│   │   └── ...
│   ├── Repositories/
│   │   ├── CountryRepository.swift
│   │   └── ...
│   └── Services/
│       ├── NetworkService.swift
│       ├── LocationService.swift
│       └── CachingManager.swift
├── Presentation/
│   ├── Common/
│   │   ├── Extensions/
│   │   └── Utilities/
│   ├── CountriesList/
│   │   ├── View/
│   │   │   ├── CountriesListViewController.swift
│   │   │   └── CountryCell.swift
│   │   ├── ViewModel/
│   │   │   └── CountriesListViewModel.swift
│   │   └── Coordinator/
│   │       └── CountriesListCoordinator.swift
│   ├── CountryDetail/
│   │   ├── View/
│   │   │   └── CountryDetailView.swift (SwiftUI)
│   │   ├── ViewModel/
│   │   │   └── CountryDetailViewModel.swift
│   │   └── Coordinator/
│   │       └── CountryDetailCoordinator.swift
│   └── Search/
│       ├── View/
│       │   └── CountrySearchViewController.swift
│       ├── ViewModel/
│       │   └── CountrySearchViewModel.swift
│       └── Coordinator/
│           └── SearchCoordinator.swift
└── Tests/
    ├── CountriesListViewModelTests.swift
    ├── CountryDetailViewModelTests.swift
    └── ...
```

## Core Features Implementation

### 1. API Integration
- The application uses the REST Countries API (`https://restcountries.com/v2/all`) for fetching country data
- Network requests are handled by a dedicated `NetworkService` that uses modern Swift concurrency patterns
- JSON responses are decoded into Swift models using `Codable`

### 2. Country Management
- Users can search for countries and view detailed information
- The main view displays a list of up to 5 selected countries
- The first country is automatically added based on the user's GPS location
- When location permission is denied, my home country is added as the default
- Users can remove countries from the main view

### 3. Offline Support
- Country data is persisted locally using a custom Caching Manager
- The app works seamlessly in offline mode by loading cached data
- This approach provides lightweight, efficient data persistence without the overhead of CoreData

### 4. UI Implementation
- The UI is implemented programmatically (no Storyboards or XIB files)
- The main screen uses UIKit with a UITableView for the country list
- The detail screen is implemented in SwiftUI for modern UI construction
- Clean and intuitive user interface with smooth transitions

## Coordinator Pattern Implementation
The coordinator pattern is implemented to handle navigation between different parts of the application:

1. **AppCoordinator**: The main coordinator that manages the application flow
2. **CountriesListCoordinator**: Handles navigation within the countries list flow
3. **CountryDetailCoordinator**: Manages the detail view presentation
4. **SearchCoordinator**: Controls the search flow

Each coordinator is responsible for:
- Creating and configuring view controllers
- Managing navigation between screens
- Handling communication between different parts of the application

## MVVM Implementation
Each screen follows the MVVM pattern:

1. **Model**: Plain Swift structs that represent the data
2. **View**: UIViewController or SwiftUI View that displays the UI
3. **ViewModel**: Contains the business logic and provides data to the view

Communication between the View and ViewModel is implemented using:
- Combine framework for reactive updates
- Callback closures for events
- Protocols for defining the ViewModel interface

Example for the CountryDetailViewModel:
```swift
protocol CountryDetailViewModelProtocol {
    var displayModel: PresentedDataViewModel { get set }
    var actionsSubject: PassthroughSubject<CountryDetailViewModel.CountryDetailActions, Never> { get set }
    func viewDidLoad()
    func bindActions()
}

class CountryDetailViewModel: CountryDetailViewModelProtocol, ObservableObject {
    @Published var displayModel: PresentedDataViewModel
    var actionsSubject = PassthroughSubject<CountryDetailActions, Never>()
    var callback: CountryDetailViewModelCallback
    
    // Implementation details...
}
```

## Testing
The application includes unit tests for the ViewModels and Coordinators:

- **ViewModel Tests**: Test the business logic independently from the UI
- **Coordinator Tests**: Verify that navigation flows work as expected
- **Repository Tests**: Ensure data handling works correctly

## Setup Instructions

### Requirements
- Xcode 13.0+
- Swift 5.5+
- iOS 14.0+

### Installation
1. Clone the repository
2. Open the project in Xcode
3. Build and run the application

## Future Improvements
- Implement more comprehensive UI tests
- Add CI/CD pipeline for automated testing and deployment
- Enhance the UI with more animations and visual feedback
- Add more data points from the Countries API
- Implement favorite countries using iCloud for cross-device synchronization
