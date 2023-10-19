import 'package:desafio_calculadora_imc/model/list_imc.dart';
import 'package:desafio_calculadora_imc/repositories/list_imc_repository.dart';
import 'package:flutter/material.dart';

class ListImcPage extends StatefulWidget {
  const ListImcPage({Key? key}) : super(key: key);

  @override
  State<ListImcPage> createState() => _ListImcPageState();
}

class _ListImcPageState extends State<ListImcPage> {
  var listRepository = ListIMCRepository();
  var _lists = <ListIMC>[];
  var alturaController = TextEditingController();
  var pesoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    obeterList();
  }

  void obeterList() async {
    _lists = await listRepository.listar();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculadora de IMC"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          alturaController.text = "";
          pesoController.text = "";
          showDialog(
            context: context,
            useRootNavigator: false,
            builder: (context) {
              return AlertDialog(
                title: const Text(
                  "Adicionar Peso e Altura",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                content: Wrap(
                  alignment: WrapAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: const Text(
                        "Peso",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                    TextField(
                      controller: pesoController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(top: -2),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.purpleAccent)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.purple)),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: const Text(
                        "Altura",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                    TextField(
                      controller: alturaController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(top: -2),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.purpleAccent)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.purple)),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancelar")),
                  TextButton(
                      onPressed: () async {
                        if (pesoController.text.isEmpty) {
                          pesoController.selection;
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("O peso não foi preenchido")));
                          return;
                        } else if (double.parse(pesoController.text) <= 0) {
                          pesoController.selection;
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("O peso deve ser maior que 0")));
                          return;
                        } else if (alturaController.text.isEmpty) {
                          alturaController.selection;
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("O altura não foi preenchido")));
                          return;
                        } else if (double.parse(alturaController.text) <= 0) {
                          alturaController.selection;
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("O altura deve ser maior que 0")));
                          return;
                        }

                        String altura = double.parse(alturaController.text)
                            .toStringAsFixed(2);
                        String peso = double.parse(pesoController.text)
                            .toStringAsFixed(2);

                        await listRepository.adicionar(
                            ListIMC(double.parse(altura), double.parse(peso)));
                        Navigator.pop(context);
                        obeterList();
                      },
                      child: const Text("Salvar")),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListView.builder(
          itemCount: _lists.length,
          itemBuilder: (context, index) {
            var listImc = _lists[index];
            double imc = listImc.peso / (listImc.altura * listImc.altura);

            String classificacao = "";

            if (imc < 16) {
              classificacao = "Magreza grave";
            } else if (imc >= 16 && imc < 17) {
              classificacao = "Magreza moderada";
            } else if (imc >= 17 && imc < 18.5) {
              classificacao = "Magreza leve";
            } else if (imc >= 18.5 && imc < 25) {
              classificacao = "Saudável";
            } else if (imc >= 25 && imc < 30) {
              classificacao = "Sobrepeso";
            } else if (imc >= 30 && imc < 35) {
              classificacao = "Obesidade Grau I";
            } else if (imc >= 35 && imc < 40) {
              classificacao = "Obesidade Grau II (severa)";
            } else {
              classificacao = "Obesidade Grau III (móbida)";
            }

            return Column(
              children: [
                InkWell(
                  onTap: () => showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      builder: (context) => Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 12),
                            child: Wrap(
                              children: [
                                const ListTile(
                                  title: Text(
                                    "Classificação IMC",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                ListTile(
                                  minVerticalPadding: 0,
                                  title: Text(
                                    "IMC: ${imc.toStringAsFixed(2)}",
                                    style: const TextStyle(fontSize: 16),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    classificacao,
                                    style: const TextStyle(fontSize: 16),
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                              ],
                            ),
                          )),
                  child: Dismissible(
                    key: Key(listImc.id),
                    onDismissed: (direction) async {
                      await listRepository.remove(listImc.id);
                      obeterList();
                    },
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ListTile(
                            title: const Text("Peso",
                                style: TextStyle(fontWeight: FontWeight.w700)),
                            subtitle: Text(listImc.peso.toString()),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text("Altura",
                                style: TextStyle(fontWeight: FontWeight.w700)),
                            subtitle: Text(listImc.altura.toString()),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text("IMC",
                                style: TextStyle(fontWeight: FontWeight.w700)),
                            subtitle: Text(imc.toStringAsFixed(2)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  thickness: 1,
                  color: Colors.purple,
                ),
                const SizedBox(height: 10),
              ],
            );
          },
        ),
      ),
    );
  }
}
