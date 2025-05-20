# News App - SwiftUI with MVVM Architecture

## Overview
A modern iOS news application built with SwiftUI that fetches and displays real-time news articles from various sources using the NewsAPI. The app follows MVVM architecture and incorporates reactive programming principles.

## Features
- Browse news by categories (Business, Technology, Sports, etc.)
- View news sources for each category
- Read full articles in-app with WebView
- Search functionality for both sources and articles
- Infinite scrolling pagination
- Comprehensive error handling
- Clean, responsive UI

## Technical Specifications
- **Architecture**: MVVM
- **State Management**: Combine + @Published
- **Networking**: RxSwift + URLSession
- **Dependencies**:
  - RxSwift/RxCocoa
  - SDWebImageSwiftUI
  - SwiftUIWebView
- **Minimum iOS Version**: 15.0
- **API**: NewsAPI.org

## Installation
1. Clone the repository
2. Get API key from NewsAPI.org
3. Add API key in Constants.swift
4. Build and run in Xcode 13+

## Screens
- Categories Screen
- Sources Screen
- Articles Screen
- Article WebView

## Testing
Includes:
- Unit tests for ViewModels
- UI tests for main workflows
- Mock API testing

## Learning Points
This project demonstrates:
- Clean SwiftUI implementation
- MVVM best practices
- Combine + RxSwift integration
- Pagination implementation
- Professional error handling

## Requirements
- Xcode 13+
- iOS 15+
- NewsAPI key (free tier available)

## Contributing
Pull requests are welcome. For major changes, please open an issue first.
