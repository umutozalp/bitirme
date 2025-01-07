import 'package:bitirme/service/auth.dart';
import 'package:flutter/material.dart';
import 'package:bitirme/service/firestore_database.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final FirebaseService _firebaseService = FirebaseService();

  // TextField'ler için controller'lar
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();

  // Cinsiyet seçimi için değişken
  String? _selectedGender;

  // Butonun aktiflik durumu
  bool _isButtonEnabled = false;

  PhoneNumber? _phoneNumber;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Sayfa açıldığında veriyi yükle
  }

  // Firestore'dan kullanıcı verilerini çekme
  Future<void> _loadUserData() async {
    var userData = await _firebaseService.getUserData();
    if (userData != null) {
      setState(() {
        _nameController.text = userData['name'] ?? '';
        _surnameController.text = userData['surname'] ?? '';
        _emailController.text = Auth().currentUser?.email ?? '';
        _phoneController.text = userData['phone'] ?? '';
        _selectedGender = userData['gender'] ?? '';

        // Eğer telefon numarası varsa, PhoneNumber nesnesine dönüştür
        if (userData['phone'] != null) {
          _phoneNumber =
              PhoneNumber(isoCode: 'TR', phoneNumber: userData['phone']);
        }
      });
    }
  }

  Future<void> _saveUserData() async {
    String name = _nameController.text;
    String surname = _surnameController.text;
    String email = Auth().currentUser?.email ?? "";
    String phone = _phoneNumber?.phoneNumber ?? "";
    String gender = _selectedGender ?? "";

    // Veritabanına kullanıcı bilgilerini kaydet
    await _firebaseService.saveUserData(name, surname, email, phone, gender);
  }

  // TextField değişikliklerini kontrol etme
  void _checkFields() {
    setState(() {
      _isButtonEnabled = _nameController.text.isNotEmpty &&
          _surnameController.text.isNotEmpty &&
          _phoneNumber != null &&
          _selectedGender != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'Kullanıcı Bilgileri',
          style: TextStyle(
              fontSize: 23, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Bu satır ekleniyor
          children: [
            // Ad Soyad TextField with Icon
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.blueAccent,
                  size: 40,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    maxLength: 20,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
                    ],
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Ad ',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _checkFields(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                SizedBox(width: 48),
                Expanded(
                  child: TextField(
                    maxLength: 20,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
                    ],
                    controller: _surnameController,
                    decoration: InputDecoration(
                      labelText: 'Soyad',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _checkFields(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Mail TextField with Icon
            Row(
              children: [
                Icon(
                  Icons.email,
                  color: Colors.blueAccent,
                  size: 40,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _emailController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Mail',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[400],
                    ),
                    onChanged: (value) => _checkFields(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Phone number with intl_phone_number_input
            InternationalPhoneNumberInput(
              maxLength: 13,
              onInputChanged: (PhoneNumber number) {
                setState(() {
                  _phoneNumber = number;
                });
                _checkFields();
              },
              onInputValidated: (bool value) {},
              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.DIALOG,
              ),
              inputDecoration: InputDecoration(
                labelText: 'Cep Telefonu',
                border: OutlineInputBorder(),
              ),
              initialValue: _phoneNumber ?? PhoneNumber(isoCode: 'TR'),
            ),
            SizedBox(height: 16),

            // Cinsiyet Seçimi (Radio Button)
            Text(
              'Cinsiyet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 25,
                ),
                Radio<String>(
                  value: 'Erkek',
                  groupValue: _selectedGender,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedGender = value;
                    });
                    _checkFields();
                  },
                ),
                Text(
                  'Erkek',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 16),
                Radio<String>(
                  value: 'Kadın',
                  groupValue: _selectedGender,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedGender = value;
                    });
                    _checkFields();
                  },
                ),
                Text(
                  'Kadın',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 16),
                Radio<String>(
                  value: 'Belirtilmedi',
                  groupValue: _selectedGender,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedGender = value;
                    });
                    _checkFields();
                  },
                ),
                Text(
                  'Belirtmek\nİstemiyorum',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Güncelle butonu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isButtonEnabled ? _saveUserData : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isButtonEnabled ? Colors.blueAccent : Colors.grey,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Güncelle',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
