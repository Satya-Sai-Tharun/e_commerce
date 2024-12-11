# E_Commerce Flutter Application

This Flutter project is an e-commerce application that provides features like user login, product search, product details, and cart management. The application fetches user and product data from APIs to simulate a dynamic shopping experience.

## Features
- User Login Page.
- Product Listing with Search functionality.
- Product Detail Page displaying details, reviews, and a rating system.
- Cart management for adding products.
- Profile Page fetching user data from an API.

## Prerequisites

Before running this application, ensure that you have the following installed:

- Flutter SDK (version 3.0.0 or later)
- Dart SDK
- An IDE such as Android Studio or Visual Studio Code
- A device or emulator for testing

## Installation and Setup

1. **Clone the repository:**
   ```bash
   https://github.com/Satya-Sai-Tharun/e_commerce.git
   ```

2. **Install dependencies:**
   Ensure that all required packages are installed by running:
   ```bash
   flutter pub get
   ```

3. **Run the application:**
   Start the app on your device/emulator by running:
   ```bash
   flutter run
   ```

   Ensure you have a connected device or an emulator running.

## Login Instructions
To log in to the application, use the following credentials:
- **`username`**= mor_2314
- **`password`**= 83r5^_
The login request can be made using the following POST method with FakeStoreAPI:
```bash
fetch('https://fakestoreapi.com/auth/login', {
    method: 'POST',
    body: JSON.stringify({
        username: "mor_2314",
        password: "83r5^_"
    })
})
```            

## Project Structure

- **`main.dart`**: Entry point of the application.
- **Pages**:
  - `login_page.dart`: Handles user login.
  - `product_detail_page.dart`: Displays detailed information about a product.
  - `search_page.dart`: Provides a search interface for products.
  - `profile_page.dart`: Displays user profile information.
- **APIs**:
  - Product data is fetched from `https://fakestoreapi.com/products`.
  - User data is fetched from `https://fakestoreapi.com/users/1`.

## How to Use

1. Launch the application.
2. Log in through the `LoginPage`.
3. Browse the product list on the `SearchPage`.
4. Click on any product to view its details on the `ProductDetailPage`.
5. Add products to your cart.
6. Navigate to the `ProfilePage` to view user details fetched from the API.

## Dependencies

This application uses the following packages:

- **`http`**: To make HTTP requests.
- **`flutter/material.dart`**: For building the user interface.

## Future Enhancements

- Integrate user authentication.
- Improve cart functionality to handle checkout.
- Add payment gateway integration.
- Optimize for multi-platform deployment.
