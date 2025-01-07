import 'package:flutter/material.dart';
import 'package:bitirme/service/firestore_database.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class AddressInfo extends StatefulWidget {
  final Map<String, dynamic>? address;
  const AddressInfo({Key? key, this.address}) : super(key: key);

  @override
  State<AddressInfo> createState() => _AddressInfoState();
}

class _AddressInfoState extends State<AddressInfo> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Map<String, dynamic>> cities = [];
  List<String> counties = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _addressTitleController = TextEditingController();

  String? selectedCity;
  String? selectedCounty;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await loadCities(); // Önce şehirleri yükle

    if (widget.address != null) {
      _nameController.text = widget.address!['name'];
      _surnameController.text = widget.address!['surname'];
      _phoneController.text = widget.address!['phone'];
      _addressController.text = widget.address!['address'];
      _addressTitleController.text = widget.address!['address_header'];
      selectedCity = widget.address!['city'];

      if (selectedCity != null) {
        updateCounties(selectedCity!);
        selectedCounty = widget.address!['county'];
      }
    }

    if (mounted) {
      setState(() {}); // UI'ı güncelle
    }
  }

  Future<void> loadCities() async {
    final String response =
        await rootBundle.loadString('assets/data/cities.json');
    final List<dynamic> citiesJson = json.decode(response);
    if (mounted) {
      setState(() {
        cities = List<Map<String, dynamic>>.from(citiesJson);
      });
    }
  }

  void updateCounties(String cityName) {
    final city = cities.firstWhere((city) => city['name'] == cityName);
    setState(() {
      counties = List<String>.from(city['counties']);
      selectedCounty = null;
    });
  }

  Future<void> _updateAddress() async {
    if (_validateForm()) {
      try {
        bool success = await _firebaseService.updateAddress(
          widget.address!['documentId'],
          _nameController.text,
          _surnameController.text,
          _phoneController.text,
          selectedCity!,
          selectedCounty!,
          _addressController.text,
          _addressTitleController.text,
        );

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Adres başarıyla güncellendi'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Adres güncellenirken bir hata oluştu')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata oluştu: $e')),
        );
      }
    }
  }

  bool _validateForm() {
    if (_nameController.text.isEmpty ||
        _surnameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        selectedCity == null ||
        selectedCounty == null ||
        _addressController.text.isEmpty ||
        _addressTitleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurun')),
      );
      return false;
    }
    return true;
  }

  Future<void> _deleteAddress() async {
    try {
      bool success =
          await _firebaseService.deleteAddress(widget.address!['documentId']);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Adres başarıyla silindi'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Adres silinirken bir hata oluştu')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata oluştu: $e')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _addressTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Adres Detayı',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                'İletişim Bilgileri',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 2),
            const Divider(),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.person, color: Colors.blueAccent, size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Ad',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _surnameController,
                        decoration: InputDecoration(
                          labelText: 'Soyad',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.blueAccent, size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Cep Telefonu',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                'Adres Bilgisi',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 2),
            const Divider(),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.pin_drop, color: Colors.blueAccent, size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text('İl'),
                        value: selectedCity,
                        items: cities.map((city) {
                          return DropdownMenuItem<String>(
                            value: city['name'] as String,
                            child: Text(city['name'] as String),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCity = value;
                            if (value != null) updateCounties(value);
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text('İlçe'),
                        value: selectedCounty,
                        items: counties.map((county) {
                          return DropdownMenuItem<String>(
                            value: county,
                            child: Text(county),
                          );
                        }).toList(),
                        onChanged: selectedCity == null
                            ? null
                            : (value) {
                                setState(() => selectedCounty = value);
                              },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const SizedBox(width: 42),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: 'Adres',
                          hintText: 'Açık adresinizi giriniz',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0, left: 4.0),
                        child: Text(
                          'Ürünün size güvenle ulaşması için mahalle, cadde, sokak, bina ve kat bilgilerini lütfen eksiksiz doldurunuz.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.apartment, color: Colors.blueAccent, size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _addressTitleController,
                    decoration: InputDecoration(
                      labelText: 'Adres Başlığı',
                      hintText: 'Örn: Ev, İş',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _updateAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Güncelle',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _deleteAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[100],
                  foregroundColor: Colors.red[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Adresi Sil',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
