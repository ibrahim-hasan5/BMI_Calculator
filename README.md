# Flutter BMI Calculator

A precise, user-friendly BMI calculator built with Flutter.

## Features
- **Flexible Units**: Toggle between Metric (kg, m, cm) and Imperial (lb, ft+in) units.
- **Auto-Carry Logic**: If you enter "5 ft 15 in", the app automatically adjusts to "6 ft 3 in".
- **Real-time Feedback**: Result card changes color based on health category.
- **Error Handling**: Prevents crashes on empty strings or invalid decimal inputs.

## Technical Details<img width="377" height="624" alt="Screenshot (372)" src="https://github.com/user-attachments/assets/97ac1ab8-26b2-4a57-9c04-f6cec2b08ed7" />



- **Formula**: $BMI = weight(kg) / height(m)^2$
- **Conversions**:
  - 1 lb = 0.45359237 kg
  - 1 inch = 0.0254 meters
- **Color Mapping**:
  - < 18.5 (Underweight): Blue
  - 18.5 - 24.9 (Normal): Green
  - 25.0 - 29.9 (Overweight): Orange
  - ≥ 30.0 (Obese): Red

## How to Run
1. Clone this repository.
2. Ensure you have Flutter installed (`flutter doctor`).
3. Run `flutter pub get` in the terminal.
4. Run `flutter run` on your connected device or emulator.
