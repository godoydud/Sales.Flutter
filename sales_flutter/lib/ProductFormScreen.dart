import 'package:flutter/material.dart';

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

class ProductFormScreen extends StatelessWidget {
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
              decoration: InputDecoration(labelText: 'Nome do produto'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Preço'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Qntd.'),
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(labelText: 'Comissão'),
              items: [
                DropdownMenuItem(
                  child: Text('5%'),
                  value: 0.05,
                ),
                DropdownMenuItem(
                  child: Text('10%'),
                  value: 0.1,
                ),
                DropdownMenuItem(
                  child: Text('15%'),
                  value: 0.15,
                ),
              ],
              onChanged: (value) {
                // Adicione aqui a lógica para salvar o tipo de produto
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Adicione aqui a lógica para processar os dados do formulário
              },
              // setar cor do botão para verde
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
