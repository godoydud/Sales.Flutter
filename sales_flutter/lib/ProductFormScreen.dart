import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String apiUrl = 'https://10.0.2.2:7034/api';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu Formulário de Produto',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductFormScreen(),
    );
  }
}

class ProductFormScreen extends StatefulWidget {
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  List<dynamic> comissionsList = [];
  dynamic selectedComission;

  @override
  void initState() {
    super.initState();
    getCommissions();
  }

  Future<void> saveProduct() async {
    final String name = nameController.text;
    final String price = priceController.text;
    final String quantity = quantityController.text;

    var body = json.encode({
      'name': name,
      'price': double.parse(price),
      'amount': quantity,
      'comissionId': selectedComission['id']
    });

    final response = await http.post(
      Uri.parse('$apiUrl/Product'),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    print(response.body);

    if (response.statusCode == 200) {
      print('Dados salvos com sucesso!');
      setState(() {
        nameController.text = '';
        priceController.text = '';
        quantityController.text = '';
        selectedComission = null;
      });
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
      print(comissionsList);
    } else {
      print(
          'Erro ao buscar as comissões. Código de status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de venda'),
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
                saveProduct().then((_) {
                  Navigator.pushReplacementNamed(context, '/products');
                });
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
