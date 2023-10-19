import 'package:flutter/material.dart';

class ListIMC {
  String _id = UniqueKey().toString();
  double _peso = 0;
  double _altura = 0;

  ListIMC(this._altura, this._peso);

  String get id => _id;
  double get altura => _altura;
  double get peso => _peso;

  set altura(double value) {
    _altura = value;
  }

  set peso(double value) {
    _peso = value;
  }
}
