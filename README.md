# LocalGenAI: Offline AI Assistant

LocalGenAI is your offline AI companion that empowers users to interact with multiple language models directly on their mobile devices. This app prioritizes privacy, performance, and accessibility, making advanced AI tools available without an internet connection.

---

## Features
- 🌐 **Offline Functionality**: Chat with AI models anytime, anywhere without relying on the internet.
- 🔄 **Downloadable AI Models**: Choose and switch between various models tailored to your needs.
- 🔒 **Privacy-First Design**: All data stays on your device – no cloud involvement.
- ⚡ **Optimized for Mobile**: Lightweight, fast, and efficient on both Android and iOS.
- 🎨 **Customizable Experience**: Tailor your AI assistant to match your preferences.

---

## Tech Stack
- **Frontend**: Flutter
- **Backend (Model Handling)**: PyTorch / TensorFlow Lite (optimized models)
- **State Management**: GetX (Flutter)
- **Model Conversion & Optimization**: ONNX, TFLite, Core ML
- **Storage**: SQLite for metadata, local storage for models

---

## Getting Started

### Prerequisites
Before you begin, ensure you have the following installed:
- Flutter SDK
- Android Studio or Xcode (for emulators and physical device testing)
- Python (for model optimization and preprocessing tasks)

### Installation

1. Clone the repository:
   ```bash
   https://github.com/KumaloWilson/Local_genai
   cd Local_genai
    ```

Install dependencies:  
flutter pub get
Run the app:  
flutter run
<hr></hr>
Model Integration
Steps to Add New Models
Prepare your model: Ensure your model (e.g., GPT-2 or LLaMA 2) is in PyTorch format.
Convert the model: Use tools like ONNX or TensorFlow Lite to optimize the model for mobile use.
Add the model: Place the optimized model in the assets/models directory.
Update metadata: Modify models.json to include the new model's details.# Local_genai
# Local_genai
# Local_genai
