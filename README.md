# Dynamic Form Builder - Flutter Web App

This Flutter web app allows users to input JSON data, dynamically validates and formats it, and renders corresponding form widgets based on the input. It supports various widget types like dropdowns, checkboxes, radios, text fields, and more. The app is built using **Clean Architecture** and **Riverpod** for state management to ensure modularity, maintainability, and testability.

---

## 1. Architecture and State Management

### 1.1 Clean Architecture: Simplifying Code for the Long Run

The app follows **Clean Architecture** principles to organize the codebase into modular layers, making it easier to maintain and extend. Here's how it's structured:

- **Presentation Layer**: This layer is responsible for rendering UI and reacting to user input. It communicates with the business logic layer through **Riverpod** state management. The presentation layer stays focused on what is shown on the screen, without worrying about how the data is processed or fetched.
  
- **Domain Layer**: The Domain Layer abstracts away network calls and external dependencies. It defines the business logic and rules for handling data. This layer doesn't care about where the data comes from or how it's fetched—it only cares about what data is needed, why it’s needed, and how to manipulate it. It helps to keep the module independent and easier to test.
  
- **Data Layer**: The Data Layer is responsible for fetching and storing data. It interacts with external sources like APIs or databases. It also handles JSON parsing and returns the required data to the Domain Layer.

### 1.2 Riverpod for State Management

We use **Riverpod** for managing the app's state. Riverpod provides a clean way to separate the UI from the business logic, ensuring more maintainable and testable code. It allows us to manage the state of the app using **StateNotifier** and **StateNotifierProvider**. This enables seamless state updates, such as validating and formatting JSON data, and exposes this state to the UI.

#### 1.3.1 Why Riverpod?

- **Predictability**: Riverpod helps keep the app state predictable and manageable. It decouples the UI from the logic and keeps everything in sync.
  
- **Testability**: Riverpod makes it easy to test the state and business logic in isolation, without worrying about UI details.

- **Flexibility**: With Riverpod, you can manage complex state transitions and easily modify the app's state logic.

---

## 2. Using the App

### 2.1 Input JSON Format: What You Can Provide

You can input JSON data in two formats:

- **Array of JSON Objects**:

    ```json
    [
      { "field_name": "f1", "widget": "dropdown", "valid_values": ["A", "B"] },
      { "field_name": "f2", "widget": "checkbox", "label": "Example" },
      { "field_name": "f3", "widget": "radio", "valid_values": ["Yes", "No"] }
    ]
    ```

- **Single JSON Object**:

    ```json
    { "field_name": "f4", "widget": "textfield", "visible": "f1=='A'" }
    ```

### 2.2 Steps to Use the App

#### Running the App:

1. Clone the repository.
2. Open the project in your favorite editor (e.g., **VSCode** or **Android Studio**).
3. Run the project using `flutter run`.

#### Entering JSON Data:

1. Use the provided multi-line text field to enter your JSON data.
2. The app will automatically validate and format the JSON as you type.

#### Widget Behavior:

- The app will dynamically display widgets like dropdowns, checkboxes, or text fields based on the input JSON.
- You can use the `"visible"` field to conditionally show or hide certain widgets based on dynamic expressions like `f1=='A'`.

#### Error Handling:

- If there’s an issue with the JSON format (missing fields, incorrect data types), the app will show a helpful error message below the input field.

---

## 3. Quick Guide and Test Scenarios

### 3.1 How to Use

1. **JSON Input Field**: Type your JSON data into the multi-line text field.
2. **Error Display**: If something goes wrong with the JSON format, an error message will appear below the input field.
3. **Visibility Logic**: Some fields are only shown based on the conditions you set in the JSON (e.g., `f1=='A'`).
4. **Widgets Interactivity**: Each widget type (dropdown, text field, checkbox) is interactive. You can select options, toggle checkboxes, and input text.

### 3.2 Test Scenarios: What to Test

Here are some scenarios to ensure everything works as expected:

#### Valid JSON Input:

- Try inputting a correct JSON array (like the example above). The app should render the widgets without errors.

#### Invalid JSON (Missing Fields):

- Input a JSON object that misses required fields like `field_name` or `widget`. The app should display an error message such as:
  
    ```text
    "Missing required json Object field_name or widget"
    ```

#### Invalid JSON (Incorrect Data Types):

- Input a widget with the wrong data type (e.g., using a non-list for `valid_values` in a dropdown). The app should display an error indicating what's wrong with the JSON.

#### Visibility Based on Conditions:

- Test fields with conditions like `f1=='A'` to see if widgets are displayed correctly based on the visibility condition.

#### Edge Case (Empty JSON):

- Try submitting an empty JSON string (`{}`). The app should display an error saying it’s not a valid JSON format.

#### Performance with Large JSON:

- Test the app’s performance with a large JSON object with many fields. The app should remain responsive and handle the input without significant delay or crashes.

---

## 4. Testing for Functionality, Performance, and Edge Cases

### Functionality Testing

- Verify that each widget type (dropdown, checkbox, radio button, etc.) behaves as expected.
- Check that validation is accurate and that fields are displayed correctly based on the JSON input.

### Performance Testing

- Try entering a large JSON object with many fields and verify that the app remains responsive and performs well even with heavy data loads.

### Edge Case Testing

- Ensure the app handles unexpected inputs, such as empty JSON or incorrectly typed values, gracefully and shows the appropriate error messages.

---

## 5. Conclusion

This app leverages **Clean Architecture** and **Riverpod** to create a modular, scalable, and testable solution for dynamically rendering form fields based on user-provided JSON input. The use of Riverpod simplifies state management and ensures that the UI stays separated from the business logic, making the app easy to maintain as it grows. By following the guidelines and testing scenarios above, you can ensure the app works correctly under various conditions and handles edge cases gracefully.
