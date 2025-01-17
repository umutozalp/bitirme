import 'package:flutter/material.dart';
import 'package:bitirme/service/firestore_database.dart';
import 'add_address_screen.dart';
import 'address_info_screen.dart';
import 'package:bitirme/src/view/screen/address_info_screen.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Map<String, dynamic>> addresses = [];
  bool isLoading = true;
  String? selectedAddressId;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    setState(() => isLoading = true);
    try {
      addresses = await _firebaseService.getAddress() ?? [];
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Adresler yüklenirken bir hata oluştu')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Adreslerim',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color.fromRGBO(10, 61, 51, 1.0),
          actions: [
            TextButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddAddressScreen()),
                );
                _loadAddresses();
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: Colors.white),
                  Text('Adres Ekle',
                      style: TextStyle(
                          fontSize: 16, color:Colors.white)),
                  SizedBox(width: 4),
                ],
              ),
            ),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : addresses.isEmpty
            ? const Center(
          child: Text(
            'Henüz kayıtlı adresiniz bulunmamaktadır',
            style: TextStyle(fontSize: 16),
          ),
        )
            : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final address = addresses[index];
              return InkWell(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddressInfo(address: address),
                    ),
                  );

                  if (result == true) {
                    _loadAddresses();
                  }
                },
                child: Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 8,
                        top: 8,
                        child: Radio<String>(
                          value: address['documentId'],
                          groupValue: selectedAddressId,
                          onChanged: (String? value) {
                            setState(() {
                              selectedAddressId = value;
                            });
                          },
                          activeColor: Color.fromRGBO(10, 61, 51, 1.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(48, 16, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: Color.fromRGBO(10, 61, 51, 1.0),
                                    size: 24),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    address['address_header'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(10, 61, 51, 1.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            Text(
                              '${address['name']} ${address['surname']}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              address['phone'],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${address['city']} / ${address['county']}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              address['address'],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
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
    );
    }
}
