import 'package:flutter/material.dart';

class CalculatorView extends StatefulWidget {
  const CalculatorView({super.key});

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  final _textController = TextEditingController();
  List<String> lstSymbols = [
    "C",
    "*",
    "/",
    "<-",
    "1",
    "2",
    "3",
    "+",
    "4",
    "5",
    "6",
    "-",
    "7",
    "8",
    "9",
    "*",
    "%",
    "0",
    ".",
    "=",
  ];

  final _key = GlobalKey<FormState>();
  String displayText = ""; // To hold the current input/output value
  String previousText = ""; // For saving the previous input for operations
  String operation = ""; // To store the current operation (like +, -, *, /)

  void _handleButtonPress(String value) {
    setState(() {
      if (value == "C") {
        displayText = ""; // Clear the input
      } else if (value == "<-") {
        if (displayText.isNotEmpty) {
          displayText =
              displayText.substring(0, displayText.length - 1); // Backspace
        }
      } else if (value == "=") {
        _evaluateExpression(); // Evaluate the final expression
      } else if (value == "+" ||
          value == "-" ||
          value == "*" ||
          value == "/" ||
          value == "%") {
        if (displayText.isNotEmpty) {
          previousText = displayText; // Save the current number
          displayText = ""; // Reset displayText for next number
          operation = value; // Set the operation
        }
      } else {
        displayText += value; // Add the number or symbol to the display
      }
      _textController.text = displayText; // Update the text field
    });
  }

  void _evaluateExpression() {
    if (previousText.isNotEmpty &&
        displayText.isNotEmpty &&
        operation.isNotEmpty) {
      double num1 = double.tryParse(previousText) ?? 0.0;
      double num2 = double.tryParse(displayText) ?? 0.0;
      double result;

      // Perform calculation based on the operation
      switch (operation) {
        case "+":
          result = num1 + num2;
          break;
        case "-":
          result = num1 - num2;
          break;
        case "*":
          result = num1 * num2;
          break;
        case "/":
          result = num2 != 0 ? num1 / num2 : 0.0; // Avoid division by zero
          break;
        case "%":
          result = num1 % num2;
          break;
        default:
          result = 0.0;
          break;
      }

      displayText = result.toString(); // Display the result
      operation = ""; // Clear the operation
      previousText = ""; // Reset the previous number
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _key,
          child: Column(
            children: [
              TextFormField(
                textDirection: TextDirection.rtl,
                controller: _textController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
                readOnly: true, // Make the text field read-only
                textAlign: TextAlign.right, // Align text to the right
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: lstSymbols.length,
                  itemBuilder: (context, index) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      onPressed: () => _handleButtonPress(lstSymbols[index]),
                      child: Text(
                        lstSymbols[index],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
