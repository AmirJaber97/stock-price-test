# Stock Price App

Simple Flutter app displaying stock prices for a set of stocks using the Alpha Vantage API.

## Architecture and Design Choices

### MVVM (Model-View-ViewModel)

This app follows the MVVM architectural pattern:

- **Model**: The `Stock` class, which holds the data structure for stock information.
- **View**: The `StockListView` widget, responsible for displaying the UI.
- **ViewModel**: The `StockListViewModel` class, which manages the business logic and state of the view.

### Provider for State Management

We use the Provider package for dependency injection and state management:

- `Provider<StockService>`: Provides a single instance of `StockService` throughout the app.
- `ChangeNotifierProxyProvider<StockService, StockListViewModel>`: Creates and updates the `StockListViewModel`.

### ChangeNotifierProxyProvider

We use `ChangeNotifierProxyProvider` for the following reasons:

1. allows us to create a ViewModel (`StockListViewModel`) that depends on a service (`StockService`).
2. ensures that if the `StockService` is ever updated or recreated, the `StockListViewModel` will be updated with the new instance.
3. follows the Dependency Inversion principle.

## Current Limitations and Potential Improvements

### Error Handling

Currently, basic error handling is implemented in the ViewModel and errors are displayed using a SnackBar for simplicity.

### Caching

The app currently doesn't implement caching

### Logging

Logging is not implemented in the current version

### Environment Variables

For simplicity, the `.env` file is committed to the repository and the API key is exposed.


