# Learning Dashboard

A production-ready **Learning Dashboard** iOS Application engineered with **Swift 5.10 / Swift 6**, **SwiftUI**, **Clean Architecture + Repository Pattern**, and **SwiftData** for offline local database persistence.

---

## Technical Assignment Q&A

### 1. Architecture Choice
**Why did you choose your architecture?**
I selected **Clean Architecture combined with MVVM (Model-View-ViewModel) and the Repository Pattern** using Swift's `@Observable` framework.
- **Separation of Concerns**: 
  - **Presentation Layer**: Pure SwiftUI Views separated from business logic via `@Observable` ViewModels (`LoginViewModel`, `CourseDashboardViewModel`, `CourseDetailViewModel`).
  - **Domain Layer**: Clean value types (`Course`, `Lesson`) and pure business logic calculation engines (`CourseProgressCalculator`).
  - **Data Layer**: Protocol-oriented repository (`CourseRepositoryProtocol`) abstracting remote REST/JSON services (`CourseAPIServiceProtocol`) and local persistent stores (`SwiftDataContainer`).
- **Testability & Loose Coupling**: Every service interface is protocol-driven, allowing 100% isolated unit testing without network or database dependencies using mock injection (`DependencyContainer`).
- **Maintainability**: Clear unidirection flow makes debugging, refactoring, and feature extensions predictable and scalable.

---

### 2. Offline Support Strategy
**How are you storing and loading offline data?**
- **Single Source of Truth Strategy**: The app uses **SwiftData** (`SDCourse` and `SDLesson` models with a 1-to-many cascading relationship) as the local persistent cache.
- **Repository Orchestration**:
  1. When online, `CourseRepository` fetches fresh data from `CourseAPIService`, replaces local SwiftData records within `ModelContext`, and updates the UI state.
  2. If network connectivity fails or device goes offline (monitored via `NWPathMonitor`), the repository transparently falls back to fetching cached models from SwiftData and converting them to domain entities.
  3. When marking lessons complete offline, status updates and dynamic progress recalculations are saved immediately to SwiftData, ensuring complete data persistence across app restarts.
- **Simulator Toggle**: An **Offline Mode Simulator Switch** is built into the dashboard header to demonstrate real-time offline cache loading during technical review.

---

### 3. Security in Production
**Where would you store authentication tokens in a production application?**
- **iOS Security Keychain (`KeychainManager`)**: Authentication access tokens (JWTs) and refresh tokens must **never** be stored in `UserDefaults` or raw plist files because they are unencrypted. In production, tokens are stored in the iOS **Keychain** using `SecItemAdd` with `kSecAttrAccessibleAfterFirstUnlock`.
- **Biometric Security & Secure Enclave**: High-security endpoints utilize `SecAccessControl` with Touch ID / Face ID requirements.
- **Token Lifecycle & Network Security**:
  - Transport Layer Security (TLS 1.3) with **SSL/TLS Certificate Pinning** using `URLSessionDelegate` to prevent Man-in-the-Middle (MitM) attacks.
  - Automatic silent token refresh via `URLSession` interceptors upon receiving HTTP `401 Unauthorized` responses.

---

### 4. System Scalability (1 Million Users + Hundreds of Courses)
**If this application had 1 million users + hundreds of courses, mention 3–5 things you would improve:**

1. **Paginated API & Cursor-Based Lazy Loading**: Replace bulk fetch endpoints with cursor-based API pagination (e.g., `page=1&limit=20`) and implement `LazyVStack` pagination with `onAppear` infinite scrolling.
2. **Database Indexing & CoreData / SQLite Queries**: Add indexing on `course_id`, `user_id`, and `instructor`, and utilize partial background fetch contexts (`ModelContext(concurrency: .background)`) to eliminate UI thread blocking.
3. **Background Sync Engine & Retry Queue**: Implement Apple `BGTaskScheduler` and persistent write queues to handle offline lesson completion syncs when connectivity is restored.
4. **CDN & Adaptive Image Caching**: Serve course thumbnails and video assets via Cloudflare/AWS CloudFront CDN with multi-layer disk and memory caching (`URLCache` + `Kingfisher`).
5. **Modularization (Swift Package Manager)**: Split monolithic codebase into decoupled SPM feature modules (`CoreData`, `AuthFeature`, `DashboardFeature`, `DesignSystem`).

---

### 5. Cross-Platform Implementation (Android)
**How would you implement the same application on Android?**
- **Language & UI**: **Kotlin** + **Jetpack Compose** for modern declarative UI.
- **Architecture**: **MVVM + Clean Architecture** with **Jetpack ViewModel**, `StateFlow` / `SharedFlow` for reactive UI state, and **Kotlin Coroutines** for async concurrency.
- **Dependency Injection**: **Hilt** (or Koin) for compile-time dependency injection.
- **Database & Offline Cache**: **Room Persistence Library** (`@Entity`, `@Dao`, `@Database`) for local SQLite caching.
- **Networking**: **Retrofit** or **Ktor Client** with **Moshi/Kotlinx Serialization** for JSON parsing and **OkHttp Interceptors** for token authentication.
- **Background Sync**: **WorkManager** (`PeriodicWorkRequest`) for guaranteed background offline data sync.

---

## Unit Test Verification
Run automated tests in Xcode:
```bash
xcodebuild -project MeetMind.xcodeproj -scheme MeetMind -destination 'platform=iOS Simulator,name=iPhone 17' -derivedDataPath ./DerivedData test
```
- `CourseProgressCalculatorTests`: Business logic verification for progress % (0%, 50%, 100%, fallback).
- `LoginViewModelTests`: Form validation, regex email rules, loading & auth state.
- `CourseDashboardViewModelTests`: Reactive state transitions (`.loading`, `.success`, `.empty`, `.error`).
- `CourseDetailViewModelTests`: Lesson status toggle & real-time progress re-calculation.
