# Rick and Morty Episode Viewer

A SwiftUI-based iOS app that lets you explore episodes and characters from the Rick and Morty TV show. Built using modern iOS development practices and the [Rick and Morty API](https://rickandmortyapi.com/).

![Xcode Version](https://img.shields.io/badge/Xcode-15.0+-blue.svg)
![iOS Version](https://img.shields.io/badge/iOS-17.0+-green.svg)
![Swift Version](https://img.shields.io/badge/Swift-5.9-orange.svg)

## Features

- 📺 Browse all episodes from the show
- 👥 View detailed character information
- 🔄 Pull-to-refresh for latest data
- 💾 Offline storage using SwiftData
- 📤 Export character details to CSV
- 📱 Share functionality for exported data
- 🎨 Modern iOS design with dynamic type support

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/RickAndMorty.git
```

2. Open the project in Xcode:
```bash
cd RickAndMorty
open RickAndMorty.xcodeproj
```

3. Build and run the project (⌘R)

## Architecture

The app follows modern iOS development practices and patterns:

### Data Layer
- SwiftData for persistent storage
- Async/await for network operations
- Actor-based services for thread safety

### UI Layer
- SwiftUI for the user interface
- MVVM-inspired architecture
- Comprehensive loading and error states

### Key Components

```swift
// Models
struct Character: Codable, Identifiable
@Model final class Episode

// Views
struct EpisodeListView: View
struct CharacterDetailView: View

// Services
actor CharacterService
actor EpisodeService
```

## Features in Detail

### Episode List
- Displays all episodes sorted by season and episode number
- Shows air date and episode code
- Pull-to-refresh to update content
- Last refresh timestamp

### Character Details
- Character image with status indicator
- Basic information (status, species, gender)
- Origin and current location
- Episode appearance count
- Export and share functionality

### Data Export
- Export character details to CSV
- Share exported files
- Compatible with various document readers

## Testing

The project includes comprehensive unit tests covering:

- Model functionality
- Data transformation
- Export operations
- Edge cases

Run tests using:
- Xcode's Test Navigator (⌘6)
- Command line: `xcodebuild test`

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

- [Rick and Morty API](https://rickandmortyapi.com/) for providing the data
- SwiftUI and SwiftData for making modern iOS development a joy
- The Rick and Morty show creators for the amazing content

## Screenshots

[Place screenshots here]

## Contact

Your Name - [@appforce1](https://x.com/appforce1)

Project Link: [https://github.com/AppForce1/RickAndMorty](https://github.com/AppForce1/RickAndMorty) 