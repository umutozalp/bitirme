import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bitirme/service/firestore_database.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final FirebaseService _firebase = FirebaseService();

  List<Map<String, dynamic>> ordersList = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    getOrders();
  }

  // Firebase'den siparis verileri ceker
  void getOrders() async {
    var result = await _firebase.getOrders();
    setState(() {
      ordersList = result ?? [];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Siparişlerim", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromRGBO(10,61,61, 1.0),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _buildScreen(),
    );
  }

  Widget _buildScreen() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(child: Text('Hata: $error'));
    }

    if (ordersList.isEmpty) {
      return Center(child: Text('Henüz Siparişiniz yok.'));
    }

    return ListView.builder(
      itemCount: ordersList.length,
      itemBuilder: (context, index) {
        return _buildOrderCard(ordersList[index]);
      },
    );
  }


  Widget _buildOrderCard(Map<String, dynamic> order) {
    final date = (order['siparisTarihi'] as Timestamp).toDate();
    final products = List<Map<String, dynamic>>.from(order['urunler']);

    //Siparişler ekranındaki siparişlerin yerleştirildiği kartın widgetı.
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              '${date.day}/${date.month}/${date.year}',
              style: TextStyle(fontSize: 16),
            ),
            Divider(),
            ...products.map((product) => _buildProductRow(product)).toList(),
            Divider(),
            Text(
              'Toplam: ${order['toplamTutar'] ?? 0} TL',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  // Siparişteki her bir ürün için satır widget'ı oluşturur
  Widget _buildProductRow(Map<String, dynamic> product) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          Image.asset(
            product['resim'],
            width: 50,
            height: 50,
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product['urunAdi']),
              Text('${product['fiyat']} TL x ${product['adet']} adet'),
            ],
          ),
        ],
      ),
    );
  }
}
