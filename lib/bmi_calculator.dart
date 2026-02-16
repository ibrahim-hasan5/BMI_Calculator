import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const BMICalculatorScreen(),
    );
  }
}

enum WeightUnit { kg, lb }

enum HeightUnit { m, cm, ftIn }

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({super.key});

  @override
  State<BMICalculatorScreen> createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  // Units State
  WeightUnit _weightUnit = WeightUnit.kg;
  HeightUnit _heightUnit = HeightUnit.cm;

  // Controllers
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _feetController = TextEditingController();
  final TextEditingController _inchesController = TextEditingController();

  // Result State
  double? _bmi;
  String _category = "";
  Color _resultColor = Colors.transparent;

  void _calculateBMI() {
    double? weightKg;
    double? heightM;

    // 1. Convert Weight to KG
    double weightInput = double.tryParse(_weightController.text) ?? 0;
    if (_weightUnit == WeightUnit.kg) {
      weightKg = weightInput;
    } else {
      weightKg = weightInput * 0.45359237;
    }

    // 2. Convert Height to Meters
    if (_heightUnit == HeightUnit.ftIn) {
      double ft = double.tryParse(_feetController.text) ?? 0;
      double inches = double.tryParse(_inchesController.text) ?? 0;

      // Carry inches to feet if >= 12 (UX requirement)
      if (inches >= 12) {
        ft += (inches / 12).floor();
        inches = inches % 12;
        _feetController.text = ft.toStringAsFixed(0);
        _inchesController.text = inches.toString();
      }

      heightM = (ft * 12 + inches) * 0.0254;
    } else {
      double heightInput = double.tryParse(_heightController.text) ?? 0;
      heightM = (_heightUnit == HeightUnit.m) ? heightInput : heightInput / 100;
    }

    // 3. Validate and Calculate
    if (weightKg > 0 && heightM > 0) {
      setState(() {
        _bmi = weightKg! / (heightM! * heightM);
        _updateCategory(_bmi!);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid positive numbers")),
      );
    }
  }

  void _updateCategory(double bmi) {
    if (bmi < 18.5) {
      _category = "Underweight";
      _resultColor = Colors.blue;
    } else if (bmi < 25.0) {
      _category = "Normal";
      _resultColor = Colors.green;
    } else if (bmi < 30.0) {
      _category = "Overweight";
      _resultColor = Colors.orange;
    } else {
      _category = "Obese";
      _resultColor = Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BMI Calculator"), centerTitle: true, backgroundColor: Colors.blue,),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Weight Section
            const Text("Weight", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SegmentedButton<WeightUnit>(
              segments: const [
                ButtonSegment(value: WeightUnit.kg, label: Text("kg")),
                ButtonSegment(value: WeightUnit.lb, label: Text("lb")),
              ],
              selected: {_weightUnit},
              onSelectionChanged: (set) =>
                  setState(() => _weightUnit = set.first),
            ),
            TextField(
              controller: _weightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              decoration: InputDecoration(
                labelText: "Enter Weight in ${_weightUnit.name}",
              ),
            ),
            const SizedBox(height: 30),

            // Height Section
            const Text("Height", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SegmentedButton<HeightUnit>(
              segments: const [
                ButtonSegment(value: HeightUnit.m, label: Text("m")),
                ButtonSegment(value: HeightUnit.cm, label: Text("cm")),
                ButtonSegment(value: HeightUnit.ftIn, label: Text("ft + in")),
              ],
              selected: {_heightUnit},
              onSelectionChanged: (set) =>
                  setState(() => _heightUnit = set.first),
            ),
            _buildHeightInput(),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _calculateBMI,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Calculate BMI"),
            ),
            const SizedBox(height: 30),

            if (_bmi != null) _buildResultCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeightInput() {
    if (_heightUnit == HeightUnit.ftIn) {
      return Row(
        children: [
          Expanded(
            child: TextField(
              controller: _feetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Feet"),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _inchesController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(labelText: "Inches"),
            ),
          ),
        ],
      );
    } else {
      return TextField(
        controller: _heightController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: "Enter Height in ${_heightUnit.name}",
        ),
      );
    }
  }

  Widget _buildResultCard() {
    return Card(
      color: _resultColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: _resultColor, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("Your BMI", style: Theme.of(context).textTheme.titleMedium),
            Text(
              _bmi!.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: _resultColor,
              ),
            ),
            Chip(
              label: Text(
                _category,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: _resultColor,
            ),
          ],
        ),
      ),
    );
  }
}
