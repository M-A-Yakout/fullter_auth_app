# Social Hub - Live Chat Application

A modern social media application built with Flutter that enables users to connect, share posts, and interact with each other in real-time.

## Features

### Authentication
- User registration with email and password
- Secure login system
- Password hashing for security

### Profile Management
- Customizable user profiles
- Profile picture support
- Bio and personal information editing
- Username and email management

### Social Features
- Create and share posts
- Like posts
- Comment on posts
- Real-time post updates
- View post engagement metrics

### Search & Discovery
- Search for users
- Search for posts
- Discover new content
- Browse user profiles

### Modern UI Features
- Material Design 3 implementation
- Dark and light theme support
- Responsive layout
- Pull-to-refresh functionality
- Modern navigation with bottom bar
- Beautiful animations and transitions
- Online status indicators
- Modern card-based design

## Technical Details

### Architecture
- Feature-based folder structure
- Clean separation of concerns
- Provider pattern for state management
- DAO pattern for data access
- Async/await for handling asynchronous operations

### Database
- SQLite database using sqflite
- Windows support with sqflite_common_ffi
- Structured data models for:
  - Users
  - Posts
  - Comments
  - Likes

### Dependencies
```yaml
dependencies:
  flutter: sdk: flutter
  sqflite: ^2.3.0
  sqflite_common_ffi: ^2.3.0
  path: ^1.8.3
  provider: ^6.1.1
  image_picker: ^1.0.7
  intl: ^0.19.0
  uuid: ^4.3.3
  crypto: ^3.0.3
```

## Getting Started

### Prerequisites
- Flutter SDK (^3.7.0)
- Dart SDK
- Any IDE with Flutter support (VS Code, Android Studio, etc.)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/M-A-Yakout/fullter_auth_app.git
```

2. Navigate to the project directory:
```bash
cd live_chat
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the application:
```bash
flutter run
```

### Database Setup
The application automatically initializes the SQLite database on first run. No additional setup is required.

## Project Structure

```
lib/
├── core/
│   └── database/          # Database helper and configurations
├── features/
│   ├── auth/             # Authentication related code
│   │   ├── data/
│   │   ├── models/
│   │   └── screens/
│   ├── home/             # Home screen and related widgets
│   ├── posts/            # Post creation and display
│   ├── profile/          # User profile management
│   └── search/           # Search functionality
└── shared/
    ├── utils/            # Shared utilities
    └── widgets/          # Reusable widgets

```

## Key Features Implementation

### Posts
- Create new posts with text content
- View posts in a modern card layout
- Like and comment on posts
- Real-time post updates

### Comments
- Add comments to posts
- View comment threads
- Time-based comment sorting
- User attribution for comments

### Profile
- View user profiles
- Edit profile information
- View user's posts
- Update profile picture

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Material Design team for the design guidelines
- All contributors who participate in this project
