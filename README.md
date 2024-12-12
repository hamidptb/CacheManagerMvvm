# Cache Manager MVVM

A Swift iOS application demonstrating advanced caching strategies using MVVM architecture. This project showcases a robust implementation of data caching with multiple layers (memory and disk), error handling, and clean architecture principles.

## Features

- **Multi-layer Caching**: Implements both memory and disk caching strategies
- **MVVM Architecture**: Clean separation of concerns using Model-View-ViewModel pattern
- **Generic Repository Pattern**: Flexible data handling with protocol-oriented design
- **Combine Framework**: Reactive programming for data streams and UI updates
- **Error Handling**: Comprehensive error handling and user feedback
- **Mock Data Support**: Built-in mock data for testing and preview purposes

## Architecture

### Core Components

- **CacheManager**: Handles data persistence with both memory and disk caching
- **NetworkManager**: Manages API requests with proper error handling
- **Repository Pattern**: Abstracts data sources and manages caching strategy
- **ViewModels**: Handle business logic and state management
- **Views**: SwiftUI views for data presentation

### Key Features

#### Cache Management
- Two-tier caching (memory and disk)
- Configurable expiration times
- Automatic cache cleanup
- Thread-safe operations

#### Data Repository
- Protocol-based design
- Combine integration
- Support for forced cache/network operations
- Mock data support for testing

#### Error Handling
- Typed error system
- User-friendly error messages
- Recovery suggestions
- Retry functionality

## Usage

### Basic Usage 