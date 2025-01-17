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

  static const primaryColor = Color.fromRGBO(10, 61, 51, 1.0);
  final FirebaseService _firebaseService = FirebaseService();

  //TextField'lardaki girilen verileri tutacak olan değişkenler.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();


  String? _selectedGender;
  bool _isButtonEnabled = false;
  PhoneNumber? _phoneNumber;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  //Ekran yüklendiğinde varsa verileri veritabanından çekip TextField'lara yazdıran metot.
  Future<void> _loadUserData() async {
    var userData = await _firebaseService.getUserData();
    if (userData != null) {
      setState(() {
        _nameController.text = userData['name'];
        _surnameController.text = userData['surname'];
        _emailController.text = Auth().currentUser?.email ?? '';
        String phoneNumber = userData['phone'];
        _phoneController.text = phoneNumber.startsWith('+90') 
            ? phoneNumber.substring(3) 
            : phoneNumber;
        _selectedGender = userData['gender'];
      });
    }
  }
  // Yeni girilen verilere göre kullanıcı bilgilerini güncelleyen metot.
  Future<void> _saveUserData() async {
    String name = _nameController.text;
    String surname = _surnameController.text;
    String email = Auth().currentUser?.email ?? "";
    String phone = _phoneNumber?.phoneNumber ?? "";
    String gender = _selectedGender ?? "";

    await _firebaseService.saveUserData(name, surname, email, phone, gender);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kullanıcı başarıyla güncellendi'),
        backgroundColor: Colors.green,
      ),
    );
  }
  //Form alanlarının doluluğunu kontrol eder.
  // Güncelle butonunun aktif olup olmamasını yönetmek için kullanılır
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
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Kullanıcı Bilgileri',
          style: TextStyle(
              fontSize: 23, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: primaryColor,
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
            Row(
              children: [
                Icon(
                  Icons.email,
                  color: primaryColor,
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
            Row(
              children: [
                Icon(
                  Icons.phone,
                  color: primaryColor,
                  size: 40,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Cep Telefonu',
                      border: OutlineInputBorder(),
                      prefixText: '+90 ',
                      counterText: '',
                      errorText: _phoneController.text.length != 10 &&
                              _phoneController.text.isNotEmpty
                          ? 'Telefon numarası 10 haneli olmalıdır'
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (value.length == 10) {
                          _phoneNumber = PhoneNumber(
                              isoCode: 'TR', phoneNumber: '+90$value');
                        } else {
                          _phoneNumber = null;
                        }
                      });
                      _checkFields();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Cinsiyet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            Row(
              children: [
                SizedBox(width: 25),
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
            SizedBox(
              width: double.infinity,
              height: 63,
              child: ElevatedButton(
                onPressed: _isButtonEnabled ? _saveUserData : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isButtonEnabled
                      ? primaryColor
                      : Colors.grey,
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
