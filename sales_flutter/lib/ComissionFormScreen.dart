import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sales_flutter/ProductFormScreen.dart';
import 'package:http/http.dart' as http;

const String apiUrl = 'https://10.0.2.2:7034/api';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de comissões',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ComissionFormScreen(), // Alterei para ComissionFormScreen
    );
  }
}

class ComissionFormScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController valueController = TextEditingController();

  Future<void> saveComission() async {
    final String name = nameController.value.text;
    final String value = valueController.value.text;

    print(int.parse(value));
    var body = json.encode({'name': name, 'percentage': int.parse(value)});

    // Aqui você faz a requisição POST para o endpoint desejado
    final response = await http.post(
      Uri.parse('$apiUrl/Comission'),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    print(response.body);

    // Verifica o código de status da resposta
    if (response.statusCode == 200) {
      // Dados salvos com sucesso
      print('Dados salvos com sucesso!');
    } else {
      // Houve algum erro ao salvar os dados
      print(
          'Erro ao salvar os dados. Código de status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de comissões'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nome da comissão'),
            ),
            TextFormField(
              controller: valueController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Valor da comissão'),
            ),
            ElevatedButton(
              onPressed: () {
                saveComission(); // Chamada da função para salvar a comissão
                print("passou onPress");
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
