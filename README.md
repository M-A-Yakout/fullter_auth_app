# Flutter Authentication App

## Overview
This is a comprehensive Flutter application featuring user authentication, SQLite database integration, and a structured home screen with expandable menu options.

## Features
- Secure user registration with input validation
- Login system with password hashing
- SQLite database for user data storage
- Intuitive home screen with menu options
- Responsive and visually appealing UI

## Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio or VS Code with Flutter extensions

## Setup and Installation
1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Connect a device or start an emulator
4. Run `flutter run` to launch the application

## Dependencies
- `sqflite`: SQLite database management
- `crypto`: Password hashing
- `email_validator`: Email validation
- `flutter_secure_storage`: Secure credential storage

## Security Considerations
- Passwords are hashed using SHA-256 before storage
- Input validation on registration and login forms
- Secure database interactions

## TODO
- Implement full profile management
- Add password reset functionality
- Enhance error handling
- Add more robust authentication mechanisms

## Contributing
1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License
MIT License 