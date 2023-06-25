import 'package:flutter/material.dart';


class CommissionListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Comissões'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: (){
                Navigator.pushNamed(context, '/comissionsform');
              },
              child: Text("Cadastro de Comissão"),
            ),
            Text('Página de listagem de comissões')
          ],
        ),
      ),
    );
  }
}