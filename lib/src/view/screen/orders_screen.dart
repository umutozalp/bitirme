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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Siparişlerim",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
        backgroundColor: Color.fromRGBO(10,61,61, 1.0),
        iconTheme:  IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder(
        future: _firebase.getSiparisler(),
        builder: (context, snapshot) {
          // Yükleniyor
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Hata varsa
          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }

          // Veri yoksa
          var siparisler = snapshot.data;
          if (siparisler == null || siparisler.isEmpty) {
            return Center(child: Text('Henüz Siparişiniz yok.'));
          }

          return ListView.builder(
            itemCount: siparisler.length,
            itemBuilder: (context, index) {
              var siparis = siparisler[index];
              var tarih = (siparis['siparisTarihi'] as Timestamp).toDate();
              var urunler = List<Map<String, dynamic>>.from(siparis['urunler']);

              return Card(
                color: Colors.grey.shade300,
                margin: EdgeInsets.all(8),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tarih: ${tarih.day}/${tarih.month}/${tarih.year}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Divider(),
                      // Ürünleri listele
                      for (var urun in urunler)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Image.asset(
                                urun['resim'],
                                width: 60,
                                height: 60,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(urun['urunAdi'],style: TextStyle(fontSize: 16),),
                                    Text('${urun['fiyat']} TL  x  ${urun['adet']} adet',style: TextStyle(fontSize: 16),),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      Divider(),
                      Text(
                        'Toplam: ${siparis['toplamTutar']} TL',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
