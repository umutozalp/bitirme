import 'package:bitirme/service/auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kayıt Ol", style: TextStyle(
            fontSize: 23, fontWeight: FontWeight.w600, color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery
              .of(context)
              .viewInsets
              .bottom, // Klavye için ayarlama
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Merhaba,",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const Text("Modo'da hesap oluştur, indirimleri kaçırma!",
                    style: TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 15)),
                const SizedBox(height: 15),
                // E-posta TextField
                TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                  maxLength: 30,
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "E-posta",
                    prefixIcon: Icon(Icons.email, color: Colors.blue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.blue, width: 4),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 4),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Şifre TextField
                TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Şifre",
                    labelStyle: TextStyle(color: Colors.black87),
                    prefixIcon: Icon(Icons.lock, color: Colors.blue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 3),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Password Strength Validator
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
                      isPasswordValid =
                      true; // Şifre geçerliyse durumu güncelle
                    });
                  },
                  onFail: () {
                    setState(() {
                      isPasswordValid =
                      false; // Şifre geçersizse durumu güncelle
                    });
                  },
                ),
                SizedBox(height: 20),
                const SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (EmailValidator.validate(emailController.text) && isPasswordValid) {
                        // E-posta adresi geçerli, Firebase'de daha önce kayıtlı olup olmadığını kontrol et
                        bool isRegistered = await Auth().isEmailRegistered(emailController.text);
                        if (isRegistered) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Bu e-posta adresi zaten kayıtlı!"),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } else {
                          // E-posta ve şifre geçerli, kullanıcıyı oluştur
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Kullanıcı başarıyla oluşturuldu!"),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 2),
                            ),
                          );
                          await Auth().createUser(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                        }
                      } else {
                        // E-posta veya şifre geçersizse SnackBar göster
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Geçersiz e-posta adresi veya şifre"),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 40),
                    ),
                    child: const Text(
                      "Kayıt Ol",
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
        ),
      ),
    );
  }
}
