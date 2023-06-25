import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sales_flutter/EditProductScreen.dart';
import 'package:sales_flutter/ProductFormScreen.dart';

const String apiUrl = 'https://10.0.2.2:7034/api';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<dynamic> productList = [];

  @override
  void initState() {
    super.initState();
    fetchProductList();
  }

  Future<void> fetchProductList() async {
    final response = await http.get(Uri.parse('$apiUrl/Product'));

    if (response.statusCode == 200) {
      setState(() {
        productList = jsonDecode(response.body);
      });
      print(productList);
    } else {
      print(
          'Erro ao buscar os produtos. Código de status: ${response.statusCode}');
    }
  }

  void editProduct(int index) {
    final product = productList[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductScreen(product: product),
      ),
    ).then((result) {
      if (result != null) {
        // Atualizar a lista de produtos com os dados editados
        setState(() {
          productList[index] = result;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Produtos'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: (){
                Navigator.pushNamed(context, '/productsform');
              },
              child: Text("Cadastro de Produtos"),
            ),
          ListView.builder(
            itemCount: productList.length,
            itemBuilder: (BuildContext context, int index) {
              final product = productList[index];
              final double price = product['price'].toDouble();
              final int amount = product['amount'];
              final double totalPrice = product['totalPrice'].toDouble();
              final double commissionPrice = product['comissionPrice'].toDouble();

              return Card(
                elevation: 2.0,
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ListTile(
                  title: Text(product['name']),
                  onTap: () => editProduct(index),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Valor Und: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          children: [
                            TextSpan(
                              text: 'R\$ $price',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Quantidade: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          children: [
                            TextSpan(
                              text: '$amount',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Valor de Comissão: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          children: [
                            TextSpan(
                              text: 'R\$ $commissionPrice',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Valor Final: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          children: [
                            TextSpan(
                              text: 'R\$ $totalPrice',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

