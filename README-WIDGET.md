# Home Screen Widget for Melamine El-Sherif

This document describes the home screen widget implementation for the Melamine El-Sherif e-commerce app.

## Overview

The home screen widget displays the best selling products from the app, rotating to a new product every hour. It works on both iOS and Android platforms.

## Features

- Displays product image, name, and price from the best selling products list
- Automatically rotates through products every hour
- Works even when the app is closed
- Updates when the app fetches new best selling products
- Persists data using SharedPreferences (Android) and AppGroup (iOS)

## Implementation

### Flutter Integration

The widget integration is managed by the `WidgetService` class, which handles:

- Data extraction from the HomeProvider
- Data conversion for native widgets
- Background update scheduling
- Platform-specific implementations

### iOS Widget (WidgetKit)

The iOS widget is implemented using SwiftUI and WidgetKit:

- Uses a TimelineProvider to handle data loading and refresh
- Reads data from a shared App Group container
- Updates every hour using the Timeline API
- Provides fallback content if no data is available

### Android Widget (AppWidgetProvider)

The Android widget uses the AppWidgetManager and HomeWidget integration:

- Implemented as a custom AppWidgetProvider
- Reads data from SharedPreferences
- Updates every hour using WorkManager
- Loads images asynchronously using Kotlin Coroutines

## Setup

### iOS Setup

1. Enable App Groups in your app's capabilities
2. Set the App Group ID to `group.com.leadercompany.widget`
3. Create a new Widget Extension target in Xcode
4. Add the Swift files from the `ios/ProductWidget` directory

### Android Setup

1. The widget is registered in the AndroidManifest.xml
2. Required dependencies are added to build.gradle
3. Layout files are in the `res/layout` and `res/xml` directories

## Usage

The widget is automatically updated when the app fetches new best selling products. Users can also manually update the widget by clicking the widget update button in the app.

## Developer Notes

- The `WidgetService` singleton provides a centralized way to manage widget updates
- Use `updateWidgetDataFromProvider()` to manually update widget data
- Use `schedulePeriodicUpdates()` to ensure periodic background updates
- The widget will rotate through products automatically based on the system's timeline API 