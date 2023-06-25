import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String apiUrl = 'https://10.0.2.2:7034/api';

class EditProductScreen extends StatefulWidget {
  final dynamic product;

  EditProductScreen({required this.product});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  List<dynamic> comissionsList = [];
  dynamic selectedComission;

  @override
  void initState() {
    super.initState();
    getCommissions();
    initializeFields();
  }

  void initializeFields() {
    final product = widget.product;
    nameController.text = product['name'];
    priceController.text = product['price'].toString();
    quantityController.text = product['amount'].toString();
    selectedComission = product['comission'];
  }

  Future<void> saveProduct() async {
    final String name = nameController.text;
    final String price = priceController.text;
    final String quantity = quantityController.text;

    var body = json.encode({
      'id': widget.product['id'],
      'name': name,
      'price': double.parse(price),
      'amount': int.parse(quantity),
      'comissionId': selectedComission['id']
    });

    final response = await http.put(
      Uri.parse('$apiUrl/Product/'),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      print('Dados salvos com sucesso!');
      Navigator.pop(context);
    } else {
      print(
          'Erro ao salvar os dados. Código de status: ${response.statusCode}');
    }
  }

  Future<void> getCommissions() async {
    final response = await http.get(Uri.parse('$apiUrl/Comission'));

    if (response.statusCode == 200) {
      setState(() {
        comissionsList = jsonDecode(response.body);
      });
    } else {
      print(
          'Erro ao buscar as comissões. Código de status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Produto'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nome do produto'),
            ),
            TextFormField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Preço'),
            ),
            TextFormField(
              controller: quantityController,
              decoration: InputDecoration(labelText: 'Qntd.'),
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(labelText: 'Comissão'),
              value: selectedComission,
              onChanged: (dynamic newValue) {
                setState(() {
                  selectedComission = newValue;
                });
              },
              items: comissionsList.map((dynamic comission) {
                return DropdownMenuItem(
                  value: comission,
                  child: Text(comission['name']),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                saveProduct();
                Navigator.pushReplacementNamed(context, '/products');
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
