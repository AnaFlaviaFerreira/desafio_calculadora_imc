import 'package:desafio_calculadora_imc/model/list_imc.dart';

class ListIMCRepository {
  List<ListIMC> _list = [];

  Future<void> adicionar(ListIMC list) async {
    await Future.delayed(const Duration(microseconds: 100));
    _list.add(list);
  }

  Future<List<ListIMC>> listar() async {
    await Future.delayed(const Duration(microseconds: 100));
    return _list;
  }

  Future<void> remove(String id) async {
    await Future.delayed(const Duration(microseconds: 100));
    _list.remove(_list.where((list) => list.id == id).first);
  }
}
