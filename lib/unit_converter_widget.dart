import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme_manager.dart';
import 'unit_converter.dart';

class UnitConverterWidget extends StatefulWidget {
  const UnitConverterWidget({super.key});

  @override
  State<UnitConverterWidget> createState() => _UnitConverterWidgetState();
}

class _UnitConverterWidgetState extends State<UnitConverterWidget>
    with TickerProviderStateMixin {
  String _selectedCategory = 'Uzunluk';
  String _fromUnit = 'metre';
  String _toUnit = 'kilometre';
  String _inputValue = '';
  String _result = '';

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _animationController.forward();
    _updateUnits();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updateUnits() {
    final units = UnitConverter.getUnitsForCategory(_selectedCategory);
    if (units.isNotEmpty) {
      setState(() {
        _fromUnit = units.first;
        _toUnit = units.length > 1 ? units[1] : units.first;
      });
      _convert();
    }
  }

  void _convert() {
    if (_inputValue.isNotEmpty) {
      try {
        double input = double.parse(_inputValue);
        double result = UnitConverter.convert(_selectedCategory, _fromUnit, _toUnit, input);
        setState(() {
          _result = UnitConverter.formatResult(result);
        });
      } catch (e) {
        setState(() {
          _result = 'Error';
        });
      }
    }
  }

  void _onButtonPressed(String value) {
    HapticFeedback.lightImpact();
    setState(() {
      if (value == 'C') {
        _inputValue = '';
        _result = '';
      } else if (value == '⌫') {
        if (_inputValue.isNotEmpty) {
          _inputValue = _inputValue.substring(0, _inputValue.length - 1);
        }
      } else if (value == '=') {
        _convert();
      } else if (value == '±') {
        if (_inputValue.isNotEmpty && _inputValue != '0') {
          if (_inputValue.startsWith('-')) {
            _inputValue = _inputValue.substring(1);
          } else {
            _inputValue = '-$_inputValue';
          }
        }
      } else if (value == '.') {
        if (!_inputValue.contains('.')) {
          _inputValue += value;
        }
      } else {
        if (_inputValue == '0') {
          _inputValue = value;
        } else {
          _inputValue += value;
        }
      }
    });
    _convert();
  }

  Widget _buildButton(String text, {String? buttonType, double? width}) {
    BoxDecoration decoration;
    TextStyle textStyle;
    
    switch (buttonType) {
      case 'clear':
        decoration = ThemeManager.clearButtonDecoration;
        textStyle = ThemeManager.buttonTextStyle;
        break;
      case 'equals':
        decoration = ThemeManager.equalsButtonDecoration;
        textStyle = ThemeManager.buttonTextStyle;
        break;
      default:
        decoration = ThemeManager.buttonDecoration;
        textStyle = ThemeManager.buttonTextStyle;
    }

    return Container(
      width: width ?? 35,
      height: 35,
      margin: const EdgeInsets.all(0.5),
      child: Container(
        decoration: decoration,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _onButtonPressed(text),
            borderRadius: BorderRadius.circular(17.5),
            child: Center(
              child: Text(
                text,
                style: textStyle.copyWith(fontSize: 12),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: ThemeManager.backgroundDecoration,
            child: SafeArea(
              child: Column(
                children: [
                  // App Bar
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Birim Çevirici',
                          style: ThemeManager.displayTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Category Selector
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      dropdownColor: ThemeManager.secondaryDark,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      decoration: InputDecoration(
                        labelText: 'Kategori',
                        labelStyle: const TextStyle(color: Colors.white70, fontSize: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white24),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white24),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      ),
                      items: UnitConverter.categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category, style: const TextStyle(fontSize: 10)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedCategory = value;
                          });
                          _updateUnits();
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Unit Selectors
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        // From Unit
                        DropdownButtonFormField<String>(
                          value: _fromUnit,
                          dropdownColor: ThemeManager.secondaryDark,
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                          decoration: InputDecoration(
                            labelText: 'Kaynak Birim',
                            labelStyle: const TextStyle(color: Colors.white70, fontSize: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.white24),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.white24),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          ),
                          items: UnitConverter.getUnitsForCategory(_selectedCategory).map((unit) {
                            return DropdownMenuItem(
                              value: unit,
                              child: Text(
                                '$unit (${UnitConverter.getUnitSymbol(unit)})',
                                style: const TextStyle(fontSize: 10),
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _fromUnit = value;
                              });
                              _convert();
                            }
                          },
                        ),
                        
                        const SizedBox(height: 6),
                        
                        // Swap Icon
                        const Icon(
                          Icons.swap_vert,
                          color: Colors.white,
                          size: 16,
                        ),
                        
                        const SizedBox(height: 6),
                        
                        // To Unit
                        DropdownButtonFormField<String>(
                          value: _toUnit,
                          dropdownColor: ThemeManager.secondaryDark,
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                          decoration: InputDecoration(
                            labelText: 'Hedef Birim',
                            labelStyle: const TextStyle(color: Colors.white70, fontSize: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.white24),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.white24),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          ),
                          items: UnitConverter.getUnitsForCategory(_selectedCategory).map((unit) {
                            return DropdownMenuItem(
                              value: unit,
                              child: Text(
                                '$unit (${UnitConverter.getUnitSymbol(unit)})',
                                style: const TextStyle(fontSize: 10),
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _toUnit = value;
                              });
                              _convert();
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Display Area
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Giriş: ${_inputValue.isEmpty ? '0' : _inputValue} ${UnitConverter.getUnitSymbol(_fromUnit)}',
                          style: ThemeManager.historyTextStyle.copyWith(fontSize: 10),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _result.isEmpty ? '0' : _result,
                          style: ThemeManager.displayTextStyle.copyWith(
                            fontSize: _result.length > 10 ? 18 : 24,
                          ),
                          textAlign: TextAlign.end,
                        ),
                        const SizedBox(height: 1),
                        Text(
                          UnitConverter.getUnitSymbol(_toUnit),
                          style: ThemeManager.historyTextStyle.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                  // Calculator Buttons
                  Expanded(
                    flex: 5,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildButton('C', buttonType: 'clear'),
                                _buildButton('⌫', buttonType: 'clear'),
                                _buildButton('±', buttonType: 'clear'),
                                _buildButton('÷', buttonType: 'clear'),
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
                                _buildButton('×', buttonType: 'clear'),
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
                                _buildButton('-', buttonType: 'clear'),
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
                                _buildButton('+', buttonType: 'clear'),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildButton('0', width: 70),
                                _buildButton('.'),
                                _buildButton('=', buttonType: 'equals', width: 70),
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
        ),
      ),
    );
  }
} 