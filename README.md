# Recipe Finder App

https://github.com/user-attachments/assets/978efa4b-3e17-4da8-b061-f92994237723

## Overview
**Recipe Finder** is an iOS application that allows users to search for recipes by entering a recipe name or food ingredient in the search bar. The app provides users with an easy way to filter search results based on dietary preferences like Low Sugar, Dairy-Free, and Vegan. The app also supports seamless pagination and a detailed view for each recipe.

This project is built using the **MVVM (Model-View-ViewModel)** architecture pattern for better code organization and maintainability. It also leverages popular libraries like **Kingfisher** for image caching and **Alamofire** for network requests.

## Features
- **Search Functionality:** Users can search for recipes by typing a recipe name or ingredient in the search bar.
- **Recipe Listing:** Each search result displays:
  - Recipe’s image (fetched and cached using Kingfisher)
  - Recipe’s title
  - Recipe source
- **Health Filters:** Users can filter recipes based on:
  - Low Sugar
  - Dairy-Free
  - Vegan
- **"ALL" Tab:** Selecting the "ALL" tab removes all filters, displaying all search results.
- **Horizontal Scrolling for Filters:** The filters section is horizontally scrollable, ensuring full visibility of all filter tabs.
- **Pagination Support:** As the user scrolls down the list, more results are automatically loaded when available using Alamofire for network requests.
- **Initial State:** No search results are shown initially until the user enters a query in the search bar.

## Recipe Details View
When a recipe is selected, the app navigates to a detailed view showing:
- Recipe’s image (fetched and cached using Kingfisher)
- Recipe’s title
- Calories & Total Weight
- Total Time
- A back button to return to the main screen

## How to Run the Project
1. Clone the repository to your local machine.
2. Open the project in Xcode.
3. Build and run the project on a simulator or a physical device.

## Design Considerations
- The app is structured using the MVVM architecture pattern, which separates the UI, business logic, and data binding.
- The filters section supports horizontal scrolling to accommodate all dietary filter options.
- The app is designed to handle pagination smoothly, loading additional content as needed when the user reaches the bottom of the list.

