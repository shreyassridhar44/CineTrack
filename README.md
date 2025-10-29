# CineTrack 🎬 - Flutter Internship Project

## Project Overview

CineTrack is a multi-platform movie watchlist application developed as a project for the Flutter Developer internship program at AeroAspire. The app allows users to discover popular movies, view detailed information, and manage a personal watchlist using Firebase. Built from a single codebase, it runs on both Android and the Web and serves as a practical demonstration of building a modern, scalable Flutter application.

## ✨ Core Features

-   **Firebase Authentication:** Full user auth flow including Sign Up, Login, Sign Out, Password Reset, and secure Account Deletion.
-   **Movie Discovery:** Fetches and displays popular movies from The Movie Database (TMDB) API in a clean, grid-based UI.
-   **Detailed Views:** Tap on any movie to see a detailed screen with its overview, rating, release date, and poster.
-   **Personal Watchlist:** Save movies to a persistent, real-time watchlist powered by Cloud Firestore. The watchlist is unique to each user.
-   **Profile Management:** A dedicated settings screen where users can manage their account.
-   **Theme Customization:** Seamlessly switch between Light, Dark, and System Default themes, with the user's preference saved across sessions.
-   **Web & Mobile:** Deployed as both a native Android APK and a live website via Firebase Hosting.

## ✏️ Core Concepts Demonstrated

This project was systematically built to ensure every topic from the internship curriculum was implemented in a practical, real-world scenario.

#### 1. **Project Setup, Architecture, and Navigation**
* **Scalable Folder Structure:** The project is organized into a clean architecture with distinct layers for `app`, `core`, `data`, and `presentation` to ensure separation of concerns.
* **Declarative Routing (`auto_route`):** Implemented a type-safe and declarative navigation system to manage the flow between screens like Splash, Login, Home, and Movie Details. This decouples navigation logic from the UI.
* **Dependency Injection (`get_it` & `injectable`):** Utilized a service locator pattern to provide dependencies (e.g., `AuthService`, `MovieApiService`) throughout the widget tree, making the codebase modular and easily testable.

#### 2. **State Management (`signals`)**
* **Reactive UI:** Implemented `signals` for granular and efficient state management. UI components automatically rebuild in response to state changes (e.g., movie list loading, user authentication status), creating a responsive user experience.
* **Centralized Logic:** Business logic is encapsulated within controllers (e.g., `HomeController`, `AuthController`), which manage the state signals and interact with data services.

#### 3. **Networking & Data Handling (`dio`, `json_serializable`)**
* **API Integration:** Used the `dio` package to handle all network requests to The Movie Database (TMDB) API for fetching movie data.
* **Data Modeling & Serialization:** Created robust data models (e.g., `Movie`) using `freezed` and `json_serializable` to automatically handle the parsing of JSON responses into type-safe Dart objects.

#### 4. **Backend & Persistence (Firebase)**
* **Firebase Authentication:** Implemented a complete user authentication system (Sign Up, Login, Password Reset, Account Deletion) for secure user management.
* **Cloud Firestore:** Used Firestore as a real-time NoSQL database to store user-specific data, such as their personal movie watchlist. The app listens to real-time streams, so the UI updates instantly when database content changes.
* **Firebase Cloud Functions (Proxy):** Deployed a TypeScript-based Cloud Function to act as a secure proxy server. This resolves CORS issues for the web deployment and securely hides the TMDB API key on the backend instead of exposing it in the client-side code.

#### 5. **Application Polishing & Tooling**
* **Animations (`lottie`):** Integrated Lottie animations to enhance the user experience, replacing standard loading indicators with a more engaging visual on the splash screen.
* **Logging (`logger`):** Implemented structured logging throughout the application to track key events, API calls, and errors, which is crucial for debugging and maintenance.
* **Code Generation (`build_runner`):** Leveraged `build_runner` extensively to automate the generation of boilerplate code for routing, dependency injection, and data models, reducing manual effort and potential for errors.

## 🛠️ Technology Stack

This project was built using a modern, scalable architecture to demonstrate best practices in Flutter development.

-   **Frontend:** Flutter
-   **Backend & Database:** Firebase (Authentication, Cloud Firestore, Cloud Functions, Hosting)
-   **Architecture:** Clean Architecture principles
-   **State Management:** `signals` for reactive UI updates
-   **Navigation:** `auto_route` for a type-safe, declarative routing solution
-   **Dependency Injection:** `get_it` & `injectable` for decoupling services
-   **Networking:** `dio` for efficient API requests
-   **Animations:** `lottie` for beautiful, lightweight animations
-   **Code Generation:** `freezed` for models & `json_serializable` for data parsing

## 🚀 Local Development Setup

To run this project locally, follow these steps.

### Prerequisites
-   Flutter SDK installed
-   A code editor like VS Code or Android Studio
-   A Firebase account

### Installation
1.  **Clone the repository:**
    ```sh
    git clone https://github.com/shreyassridhar44/CineTrack.git
    ```
2.  **Navigate into the project directory:**
    ```sh
    cd cinetrack
    ```
3.  **Set up Firebase:** Create a new project on the [Firebase Console](https://console.firebase.google.com/) and follow the `flutterfire configure` steps to add your project's configuration file (`firebase_options.dart`).
4.  **Create a `.env` file:** In the root of the project, create a file named `.env` and add your TMDB API key:
    ```
    TMDB_API_KEY=your_key_here
    ```
5.  **Install dependencies and run the app:**
    ```sh
    flutter pub get
    flutter run
    ```
