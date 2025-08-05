class UnitConverter {
  static const Map<String, Map<String, double>> _conversionFactors = {
    'Uzunluk': {
      'metre': 1.0,
      'kilometre': 1000.0,
      'santimetre': 0.01,
      'milimetre': 0.001,
      'mikrometre': 0.000001,
      'nanometre': 0.000000001,
      'mil': 1609.344,
      'yard': 0.9144,
      'feet': 0.3048,
      'inch': 0.0254,
    },
    'Ağırlık': {
      'kilogram': 1.0,
      'gram': 0.001,
      'miligram': 0.000001,
      'ton': 1000.0,
      'pound': 0.45359237,
      'ons': 0.028349523125,
    },
    'Sıcaklık': {
      'celsius': 1.0,
      'fahrenheit': 1.0,
      'kelvin': 1.0,
    },
    'Alan': {
      'metrekare': 1.0,
      'kilometrekare': 1000000.0,
      'santimetrekare': 0.0001,
      'hektar': 10000.0,
      'acre': 4046.8564224,
      'feetkare': 0.09290304,
    },
    'Hacim': {
      'metreküp': 1.0,
      'litre': 0.001,
      'mililitre': 0.000001,
      'galon': 0.003785411784,
      'quart': 0.000946352946,
      'pint': 0.000473176473,
    },
    'Hız': {
      'metre/saniye': 1.0,
      'kilometre/saat': 0.2777777778,
      'mil/saat': 0.44704,
      'knot': 0.5144444444,
    },
    'Basınç': {
      'pascal': 1.0,
      'bar': 100000.0,
      'atmosfer': 101325.0,
      'psi': 6894.757293168,
      'torr': 133.322387415,
    },
    'Enerji': {
      'joule': 1.0,
      'kilojoule': 1000.0,
      'kalori': 4.184,
      'kilokalori': 4184.0,
      'elektronvolt': 1.602176634e-19,
      'watt-saat': 3600.0,
    },
    'Güç': {
      'watt': 1.0,
      'kilowatt': 1000.0,
      'megawatt': 1000000.0,
      'beygir': 745.69987158227022,
    },
    'Zaman': {
      'saniye': 1.0,
      'dakika': 60.0,
      'saat': 3600.0,
      'gün': 86400.0,
      'hafta': 604800.0,
      'ay': 2592000.0,
      'yıl': 31536000.0,
    },
  };

  static List<String> get categories => _conversionFactors.keys.toList();

  static List<String> getUnitsForCategory(String category) {
    return _conversionFactors[category]?.keys.toList() ?? [];
  }

  static double convert(String category, String fromUnit, String toUnit, double value) {
    if (category == 'Sıcaklık') {
      return _convertTemperature(fromUnit, toUnit, value);
    }

    final factors = _conversionFactors[category];
    if (factors == null || !factors.containsKey(fromUnit) || !factors.containsKey(toUnit)) {
      return value;
    }

    // Önce SI birimine çevir, sonra hedef birime çevir
    double siValue = value * factors[fromUnit]!;
    return siValue / factors[toUnit]!;
  }

  static double _convertTemperature(String fromUnit, String toUnit, double value) {
    // Önce Celsius'a çevir
    double celsius;
    switch (fromUnit) {
      case 'celsius':
        celsius = value;
        break;
      case 'fahrenheit':
        celsius = (value - 32) * 5 / 9;
        break;
      case 'kelvin':
        celsius = value - 273.15;
        break;
      default:
        celsius = value;
    }

    // Sonra hedef birime çevir
    switch (toUnit) {
      case 'celsius':
        return celsius;
      case 'fahrenheit':
        return celsius * 9 / 5 + 32;
      case 'kelvin':
        return celsius + 273.15;
      default:
        return celsius;
    }
  }

  static String formatResult(double value) {
    if (value == 0) return '0';
    if (value.abs() < 0.000001) return '0';
    if (value.abs() > 999999) {
      return value.toStringAsExponential(6);
    }
    return value.toStringAsFixed(6).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
  }

  static String getUnitSymbol(String unit) {
    final symbols = {
      'metre': 'm',
      'kilometre': 'km',
      'santimetre': 'cm',
      'milimetre': 'mm',
      'kilogram': 'kg',
      'gram': 'g',
      'celsius': '°C',
      'fahrenheit': '°F',
      'kelvin': 'K',
      'metrekare': 'm²',
      'litre': 'L',
      'metre/saniye': 'm/s',
      'pascal': 'Pa',
      'joule': 'J',
      'watt': 'W',
      'saniye': 's',
    };
    return symbols[unit] ?? unit;
  }
} 