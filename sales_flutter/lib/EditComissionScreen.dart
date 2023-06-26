import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String apiUrl = 'https://10.0.2.2:7034/api';

class EditComissionScreen extends StatefulWidget {
  final Map<String, dynamic> comission;

  EditComissionScreen({required this.comission});

  @override
  _EditComissionScreenState createState() => _EditComissionScreenState();
}

class _EditComissionScreenState extends State<EditComissionScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController valueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.comission['name'];
    valueController.text = widget.comission['percentage'].toString();
  }

  Future<void> updateComission() async {
    final String name = nameController.value.text;
    final String value = valueController.value.text;

    var body = json.encode({
      'id': widget.comission['id'],
      'name': name,
      'percentage': int.parse(value)
    });

    final response = await http.put(
      Uri.parse('$apiUrl/Comission/'),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    print(response.body);

    if (response.statusCode == 200) {
      print('Comissão atualizada com sucesso!');
      Navigator.pop(context, {'name': name, 'percentage': int.parse(value)});
    } else {
      print(
          'Erro ao atualizar a comissão. Código de status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Comissão'),
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
                updateComission().then((_) {
                  Navigator.pushReplacementNamed(context, '/comissions');
                });
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
              ),
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
