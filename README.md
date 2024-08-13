# Cabled App Frontend

Welcome to the frontend repository for the Cabled App. This mobile application is designed to provide real-time updates, rider profiles, rankings, and live event feeds for spectators. It connects to the backend system via HTTPS requests and WebSockets to ensure seamless data synchronization.

## Overview

This frontend is written in Swift and is designed to run on iOS devices. It serves multiple purposes:

- **User Interface**: Displays rider profiles, rankings, and live event updates.
- **Data Synchronization**: Connects to the backend API to fetch and update data in real-time.
- **Live Feed**: Provides a live feed for spectators to stay up-to-date with live scoring and event updates.

## Features

### User Interface

- **Rider Profiles**: Showcases each rider's profile with their bio and riding stats.
- **Overall Rankings**: Displays the overall rankings of all riders in the system.
- **Live Feed**: Provides real-time updates for spectators during events, including live scoring from judges.

### Data Synchronization

- **HTTPS Requests**: Fetches and updates data by making HTTPS requests to the backend API.
- **WebSockets**: Ensures real-time data updates through WebSocket connections.

## Installation

### Prerequisites

- iOS device with iOS 13.0+
- Xcode 12.0+
- Swift 5.0+

### Setup

1. **Clone the repository**:
    ```sh
    git clone https://github.com/MNwake/Cabled_ios.git
    cd Cabled_ios
    ```

2. **Open the project in Xcode**:
    - Open `Cabled.xcodeproj` in Xcode.

3. **Install dependencies** (if using any dependency manager like CocoaPods or Swift Package Manager):
    - For CocoaPods:
        ```sh
        pod install
        ```
    - For Swift Package Manager, dependencies will be resolved automatically when you open the project in Xcode.

4. **Build and run the project**:
    - Select your target device or simulator.
    - Press `Command + R` to build and run the project.

## Usage

- **Rider Profiles**: Navigate to the rider profiles section to view detailed information about each rider, including their bio and riding stats.
- **Overall Rankings**: Check the rankings section to see the current standings of all riders.
- **Live Feed**: During events, navigate to the live feed section to stay updated with real-time scoring and updates from the judges.

## Disclaimer

This frontend is part of an ongoing project to develop a comprehensive system for cable wakeboard parks. It is a work in progress and may not be fully functional. For the most current version of the Cabled app, please refer to the Apple App Store.
