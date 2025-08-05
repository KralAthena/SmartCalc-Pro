import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math' as math;
import 'theme_manager.dart';
import 'unit_converter_widget.dart';

class AdvancedCalculatorWidget extends StatefulWidget {
  const AdvancedCalculatorWidget({super.key});

  @override
  State<AdvancedCalculatorWidget> createState() => _AdvancedCalculatorWidgetState();
}

class _AdvancedCalculatorWidgetState extends State<AdvancedCalculatorWidget>
    with TickerProviderStateMixin {
  String _display = '0';
  String _expression = '';
  String _history = '';
  bool _isScientific = false;
  bool _isHistoryVisible = false;
  bool _isDarkMode = true; // Tema değiştirme için
  final List<String> _calculationHistory = [];
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    _bounceController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _onButtonPressed(String value) {
    HapticFeedback.lightImpact();
    _animationController.forward().then((_) => _animationController.reverse());

    setState(() {
      if (value == 'C') {
        _display = '0';
        _expression = '';
        _history = '';
      } else if (value == '⌫') {
        if (_display.length > 1) {
          _display = _display.substring(0, _display.length - 1);
          _expression = _expression.substring(0, _expression.length - 1);
        } else {
          _display = '0';
          _expression = '';
        }
      } else if (value == '=') {
        _calculateResult();
      } else if (value == '±') {
        if (_display != '0') {
          if (_display.startsWith('-')) {
            _display = _display.substring(1);
            _expression = _expression.substring(1);
          } else {
            _display = '-$_display';
            _expression = '-$_expression';
          }
        }
      } else if (value == '.') {
        if (!_display.contains('.')) {
          _display += value;
          _expression += value;
        }
      } else if (['+', '-', '×', '÷', '^', '√', 'sin', 'cos', 'tan', 'log', 'ln', 'π', 'e'].contains(value)) {
        _handleOperator(value);
      } else {
        // Sayı girişi
        if (_display == '0') {
          _display = value;
          _expression += value;
        } else {
          _display += value;
          _expression += value;
        }
      }
    });
  }

  void _handleOperator(String operator) {
    if (operator == '√') {
      _calculateSquareRoot();
    } else if (operator == '^') {
      _expression += '^';
      _display = '0';
    } else if (['sin', 'cos', 'tan', 'log', 'ln'].contains(operator)) {
      _calculateTrigonometric(operator);
    } else if (operator == 'π') {
      _display = math.pi.toString();
      _expression = math.pi.toString();
    } else if (operator == 'e') {
      _display = math.e.toString();
      _expression = math.e.toString();
    } else {
      // Operatör eklendiğinde display'i sıfırlama, sadece expression'a ekle
      _expression += operator;
      _history = _expression; // Geçmişi güncelle
      _display = '0'; // Yeni sayı için display'i sıfırla
    }
  }

  void _calculateSquareRoot() {
    try {
      double number = double.parse(_display);
      if (number >= 0) {
        double result = math.sqrt(number);
        _addToHistory('√($number)', result.toStringAsFixed(6));
        _display = result.toStringAsFixed(6);
        _expression = result.toStringAsFixed(6);
      } else {
        _display = 'Error';
      }
    } catch (e) {
      _display = 'Error';
    }
  }

  void _calculateTrigonometric(String function) {
    try {
      double number = double.parse(_display);
      double result = 0;
      String displayFunction = '';

      switch (function) {
        case 'sin':
          result = math.sin(number * math.pi / 180);
          displayFunction = 'sin($number°)';
          break;
        case 'cos':
          result = math.cos(number * math.pi / 180);
          displayFunction = 'cos($number°)';
          break;
        case 'tan':
          result = math.tan(number * math.pi / 180);
          displayFunction = 'tan($number°)';
          break;
        case 'log':
          result = math.log(number) / math.ln10;
          displayFunction = 'log($number)';
          break;
        case 'ln':
          result = math.log(number);
          displayFunction = 'ln($number)';
          break;
      }

      _addToHistory(displayFunction, result.toStringAsFixed(6));
      _display = result.toStringAsFixed(6);
      _expression = result.toStringAsFixed(6);
    } catch (e) {
      _display = 'Error';
    }
  }

  void _calculateResult() {
    try {
      String expression = _expression
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('^', '^');

      double result = _evaluateExpression(expression);

      if (result.isInfinite || result.isNaN) {
        _display = 'Error';
      } else {
        String resultStr = result.toString();
        if (resultStr.endsWith('.0')) {
          resultStr = resultStr.substring(0, resultStr.length - 2);
        }
        _addToHistory(_expression, resultStr);
        _display = resultStr;
        _expression = resultStr;
      }
    } catch (e) {
      _display = 'Error';
    }
  }

  double _evaluateExpression(String expression) {
    expression = expression.replaceAll('×', '*');
    expression = expression.replaceAll('÷', '/');
    expression = expression.replaceAll('^', '^');

    GrammarParser parser = GrammarParser();
    ContextModel contextModel = ContextModel();

    try {
      Expression exp = parser.parse(expression);
      double eval = exp.evaluate(EvaluationType.REAL, contextModel);
      return eval;
    } catch (e) {
      throw Exception("Geçersiz ifade");
    }
  }

  void _addToHistory(String calculation, String result) {
    setState(() {
      _calculationHistory.insert(0, '$calculation = $result');
      if (_calculationHistory.length > 50) {
        _calculationHistory.removeLast();
      }
    });
  }

  Widget _buildButton(String text, {String? buttonType, double? width, double? height}) {
    BoxDecoration decoration;
    TextStyle textStyle;

    switch (buttonType) {
      case 'operator':
        decoration = _isDarkMode ? ThemeManager.operatorButtonDecoration : ThemeManager.lightOperatorButtonDecoration;
        textStyle = _isDarkMode ? ThemeManager.buttonTextStyle : ThemeManager.lightButtonTextStyle;
        break;
      case 'function':
        decoration = _isDarkMode ? ThemeManager.functionButtonDecoration : ThemeManager.lightFunctionButtonDecoration;
        textStyle = _isDarkMode ? ThemeManager.functionButtonTextStyle : ThemeManager.lightFunctionButtonTextStyle;
        break;
      case 'clear':
        decoration = _isDarkMode ? ThemeManager.clearButtonDecoration : ThemeManager.lightClearButtonDecoration;
        textStyle = _isDarkMode ? ThemeManager.buttonTextStyle : ThemeManager.lightButtonTextStyle;
        break;
      case 'equals':
        decoration = _isDarkMode ? ThemeManager.equalsButtonDecoration : ThemeManager.lightEqualsButtonDecoration;
        textStyle = _isDarkMode ? ThemeManager.buttonTextStyle : ThemeManager.lightButtonTextStyle;
        break;
      default:
        decoration = _isDarkMode ? ThemeManager.buttonDecoration : ThemeManager.lightButtonDecoration;
        textStyle = _isDarkMode ? ThemeManager.buttonTextStyle : ThemeManager.lightButtonTextStyle;
    }

    return Container(
      width: width ?? 60,
      height: height ?? 60,
      margin: const EdgeInsets.all(3),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: decoration,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _onButtonPressed(text),
                  borderRadius: BorderRadius.circular(30),
                  child: Center(
                    child: Text(text, style: textStyle.copyWith(fontSize: 20)),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        decoration: _isDarkMode ? ThemeManager.backgroundDecoration : ThemeManager.lightBackgroundDecoration,
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedBuilder(
                      animation: _bounceAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 0.8 + (_bounceAnimation.value * 0.2),
                          child: Text(
                            'SmartCalc Pro',
                            style: (_isDarkMode ? ThemeManager.displayTextStyle : ThemeManager.lightDisplayTextStyle).copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                    Row(
                      children: [
                        // Tema değiştirme butonu
                        IconButton(
                          onPressed: _toggleTheme,
                          icon: Icon(
                            _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                            color: _isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isScientific = !_isScientific;
                            });
                          },
                          icon: Icon(
                            _isScientific ? Icons.calculate : Icons.science,
                            color: _isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isHistoryVisible = !_isHistoryVisible;
                            });
                            if (_isHistoryVisible) {
                              _slideController.forward();
                            } else {
                              _slideController.reverse();
                            }
                          },
                          icon: Icon(
                            Icons.history,
                            color: _isHistoryVisible 
                                ? (_isDarkMode ? ThemeManager.accentBlue : ThemeManager.accentBlueLight)
                                : (_isDarkMode ? Colors.white : Colors.black87),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) =>
                                    const UnitConverterWidget(),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  return SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(1.0, 0.0),
                                      end: Offset.zero,
                                    ).animate(CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeInOut,
                                    )),
                                    child: child,
                                  );
                                },
                                transitionDuration: const Duration(milliseconds: 500),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.swap_horiz,
                            color: _isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Display Area
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (_history.isNotEmpty)
                        Text(
                          _history,
                          style: _isDarkMode ? ThemeManager.historyTextStyle : ThemeManager.lightHistoryTextStyle,
                        ),
                      const SizedBox(height: 10),
                      AnimatedBuilder(
                        animation: _bounceAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 0.9 + (_bounceAnimation.value * 0.1),
                            child: Text(
                              _display,
                              style: (_isDarkMode ? ThemeManager.displayTextStyle : ThemeManager.lightDisplayTextStyle).copyWith(
                                fontSize: _display.length > 10 ? 32 : 48,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // History Panel
              if (_isHistoryVisible)
                SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    height: 200,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: _isDarkMode ? ThemeManager.historyPanelDecoration : ThemeManager.lightHistoryPanelDecoration,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _calculationHistory.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            _calculationHistory[index],
                            style: TextStyle(
                              color: _isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                          onTap: () {
                            String calculation = _calculationHistory[index];
                            String result = calculation.split(' = ').last;
                            setState(() {
                              _display = result;
                              _expression = result;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ),

              // Buttons Grid
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      // Scientific Functions Row
                      if (_isScientific)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildButton('sin', buttonType: 'function'),
                            _buildButton('cos', buttonType: 'function'),
                            _buildButton('tan', buttonType: 'function'),
                            _buildButton('log', buttonType: 'function'),
                            _buildButton('ln', buttonType: 'function'),
                          ],
                        ),
                      if (_isScientific)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildButton('√', buttonType: 'function'),
                            _buildButton('^', buttonType: 'function'),
                            _buildButton('π', buttonType: 'function'),
                            _buildButton('e', buttonType: 'function'),
                            _buildButton('±', buttonType: 'function'),
                          ],
                        ),
                      
                      // Main Calculator Buttons
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildButton('C', buttonType: 'clear'),
                                  _buildButton('⌫'),
                                  _buildButton('÷', buttonType: 'operator'),
                                  _buildButton('×', buttonType: 'operator'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildButton('7'),
                                  _buildButton('8'),
                                  _buildButton('9'),
                                  _buildButton('-', buttonType: 'operator'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildButton('4'),
                                  _buildButton('5'),
                                  _buildButton('6'),
                                  _buildButton('+', buttonType: 'operator'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildButton('1'),
                                  _buildButton('2'),
                                  _buildButton('3'),
                                  _buildButton('=', buttonType: 'equals', height: 120),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildButton('0', width: 120),
                                  _buildButton('.'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
