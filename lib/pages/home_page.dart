import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class SimpleCalculator extends StatefulWidget {
  const SimpleCalculator({Key? key}) : super(key: key);

  @override
  State<SimpleCalculator> createState() => _SimpleCalculatorState();
}

class _SimpleCalculatorState extends State<SimpleCalculator> {
  String equation = "0";
  String result = "0";
  double equationFontSize = 38.0;
  double resultFontSize = 48.0;

  bool isOperator(String x) {
    return x == '+' || x == '-' || x == '×' || x == '÷';
  }

  void buttonPressed(String buttonText) {
    setState(() {
      // CLEAR
      if (buttonText == "AC") {
        equation = "0";
        result = "0";
        equationFontSize = 38.0;
        resultFontSize = 48.0;
        return;
      }

      // BACKSPACE
      if (buttonText == "⌫") {
        equationFontSize = 48.0;
        resultFontSize = 38.0;

        if (equation.length > 1) {
          equation = equation.substring(0, equation.length - 1);
        } else {
          equation = "0";
        }
        return;
      }

      // EQUAL
      if (buttonText == "=") {
        equationFontSize = 38.0;
        resultFontSize = 48.0;

        String expression = equation.replaceAll('×', '*').replaceAll('÷', '/');

        try {
          Parser parser = Parser();
          Expression exp = parser.parse(expression);
          ContextModel cm = ContextModel();

          double eval = exp.evaluate(EvaluationType.REAL, cm);

          result = eval % 1 == 0 ? eval.toInt().toString() : eval.toString();
        } catch (e) {
          result = "Error";
        }
        return;
      }

      // PREVENT MULTIPLE OPERATORS
      if (isOperator(buttonText) && isOperator(equation[equation.length - 1])) {
        return;
      }

      // NORMAL INPUT
      equationFontSize = 48.0;
      resultFontSize = 38.0;

      if (equation == "0") {
        equation = buttonText;
      } else {
        equation += buttonText;
      }
    });
  }

  Widget buildButton(String text, double height, Color color) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.1 * height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.white),
          ),
        ),
        onPressed: () => buttonPressed(text),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculator"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(20),
            child: Text(
              equation,
              style: TextStyle(fontSize: equationFontSize),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(20),
            child: Text(
              result,
              style: TextStyle(fontSize: resultFontSize),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width * .75,
                child: Table(
                  children: [
                    TableRow(
                      children: [
                        buildButton("AC", 1, Colors.redAccent),
                        buildButton("⌫", 1, Colors.blue),
                        buildButton("÷", 1, Colors.blue),
                      ],
                    ),
                    TableRow(
                      children: [
                        buildButton("7", 1, Colors.black54),
                        buildButton("8", 1, Colors.black54),
                        buildButton("9", 1, Colors.black54),
                      ],
                    ),
                    TableRow(
                      children: [
                        buildButton("4", 1, Colors.black54),
                        buildButton("5", 1, Colors.black54),
                        buildButton("6", 1, Colors.black54),
                      ],
                    ),
                    TableRow(
                      children: [
                        buildButton("1", 1, Colors.black54),
                        buildButton("2", 1, Colors.black54),
                        buildButton("3", 1, Colors.black54),
                      ],
                    ),
                    TableRow(
                      children: [
                        buildButton(".", 1, Colors.black54),
                        buildButton("0", 1, Colors.black54),
                        buildButton("00", 1, Colors.black54),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * .25,
                child: Table(
                  children: [
                    TableRow(children: [buildButton("×", 1, Colors.blue)]),
                    TableRow(children: [buildButton("-", 1, Colors.blue)]),
                    TableRow(children: [buildButton("+", 1, Colors.blue)]),
                    TableRow(children: [buildButton("=", 2, Colors.redAccent)]),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
