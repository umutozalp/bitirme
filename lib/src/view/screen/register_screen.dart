import 'package:bitirme/service/auth.dart';
import 'package:bitirme/src/view/screen/home_screen.dart';
import 'package:bitirme/src/view/screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Kontrolcüler
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordValid = false;
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kayıt Ol",
            style: TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromRGBO(10, 61, 51, 1.0),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Merhaba,",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
            ),
            Text(
              "Modo'da hesap oluştur, indirimleri kaçırma!",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 40),

            // Email girişi
            TextFormField(
              controller: emailController,
              maxLength: 30,
              decoration: InputDecoration(
                labelText: "E-posta",
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),

            TextFormField(
              controller: passwordController,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                labelText: "Şifre",
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),

            FlutterPwValidator(
              controller: passwordController,
              minLength: 6,
              uppercaseCharCount: 1,
              numericCharCount: 1,
              specialCharCount: 1,
              width: 400,
              height: 198,
              onSuccess: () {
                setState(() {
                  isPasswordValid = true;
                });
              },
              onFail: () {
                setState(() {
                  isPasswordValid = false;
                });
              },
            ),
            SizedBox(height: 30),

            ElevatedButton(
              onPressed: () async {
                if (!EmailValidator.validate(emailController.text)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Geçerli bir email adresi girin"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                if (!isPasswordValid) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Geçerli bir şifre girin"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                try {
                  await Auth().createUser(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Kayıt başarılı!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Bu e-posta adresi zaten kullanılıyor."),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(10, 61, 51, 1.0),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                "Kayıt Ol",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
