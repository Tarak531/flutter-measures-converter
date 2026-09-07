import 'package:flutter/material.dart';

void main() {
  runApp(const MeasuresConverterApp());
}

/// Root widget for the Measures Converter application.
class MeasuresConverterApp extends StatelessWidget {
  const MeasuresConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Measures Converter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ConverterPage(),
    );
  }
}

/// Screen that allows users to convert between metric and imperial units.
class ConverterPage extends StatefulWidget {
  const ConverterPage({super.key});

  @override
  State<ConverterPage> createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  final TextEditingController _valueController = TextEditingController();

  final List<String> _units = <String>[
    'meters',
    'kilometers',
    'miles',
    'feet',
    'kilograms',
    'pounds',
  ];

  String _fromUnit = 'meters';
  String _toUnit = 'feet';
  String _result = '';

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  /// Validates user input and performs the selected conversion.
  void _convert() {
    final double? value = double.tryParse(_valueController.text.trim());

    if (value == null) {
      setState(() {
        _result = 'Please enter a valid number.';
      });
      return;
    }

    double? convertedValue;

    if (_isLengthUnit(_fromUnit) && _isLengthUnit(_toUnit)) {
      final double meters = _convertLengthToMeters(value, _fromUnit);
      convertedValue = _convertMetersToLength(meters, _toUnit);
    } else if (_isWeightUnit(_fromUnit) && _isWeightUnit(_toUnit)) {
      final double kilograms = _convertWeightToKilograms(value, _fromUnit);
      convertedValue = _convertKilogramsToWeight(kilograms, _toUnit);
    }

    if (convertedValue == null) {
      setState(() {
        _result = 'Cannot convert $_fromUnit to $_toUnit because they are different measurement types.';
      });
      return;
    }

    setState(() {
      _result = '${value.toStringAsFixed(1)} $_fromUnit are '
          '${convertedValue!.toStringAsFixed(3)} $_toUnit';
    });
  }

  bool _isLengthUnit(String unit) {
    return const <String>['meters', 'kilometers', 'miles', 'feet']
        .contains(unit);
  }

  bool _isWeightUnit(String unit) {
    return const <String>['kilograms', 'pounds'].contains(unit);
  }

  double _convertLengthToMeters(double value, String unit) {
    switch (unit) {
      case 'kilometers':
        return value * 1000;
      case 'miles':
        return value * 1609.344;
      case 'feet':
        return value * 0.3048;
      case 'meters':
      default:
        return value;
    }
  }

  double _convertMetersToLength(double meters, String unit) {
    switch (unit) {
      case 'kilometers':
        return meters / 1000;
      case 'miles':
        return meters / 1609.344;
      case 'feet':
        return meters / 0.3048;
      case 'meters':
      default:
        return meters;
    }
  }

  double _convertWeightToKilograms(double value, String unit) {
    switch (unit) {
      case 'pounds':
        return value * 0.45359237;
      case 'kilograms':
      default:
        return value;
    }
  }

  double _convertKilogramsToWeight(double kilograms, String unit) {
    switch (unit) {
      case 'pounds':
        return kilograms / 0.45359237;
      case 'kilograms':
      default:
        return kilograms;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Measures Converter'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Value',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            TextField(
              controller: _valueController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                hintText: 'Enter value',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'From',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            DropdownButton<String>(
              value: _fromUnit,
              isExpanded: true,
              items: _units.map((String unit) {
                return DropdownMenuItem<String>(
                  value: unit,
                  child: Text(unit),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    _fromUnit = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'To',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            DropdownButton<String>(
              value: _toUnit,
              isExpanded: true,
              items: _units.map((String unit) {
                return DropdownMenuItem<String>(
                  value: unit,
                  child: Text(unit),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    _toUnit = value;
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _convert,
                child: const Text('Convert'),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _result,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
