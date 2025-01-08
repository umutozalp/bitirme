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

  Future<void> _deleteAddress(String documentId) async {
    try {
      if (await _firebaseService.deleteAddress(documentId)) {
        _loadAddresses();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Adres başarıyla silindi')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Adres silinirken bir hata oluştu')));
      }
    } catch (e) {
      // baska bi hata olursa diye kontrol icin koydum
      print('Hata: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Adreslerim',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
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
                Text('Adres Ekle',
                    style: TextStyle(
                        fontSize: 16, color: Color.fromRGBO(10, 61, 51, 1.0))),
                SizedBox(width: 4),
                Icon(Icons.add, color: Color.fromRGBO(10, 61, 51, 1.0)),
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
                        child: Padding(
                          padding: const EdgeInsets.all(16),
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
                      ),
                    );
                  },
                ),
    );
  }
}
