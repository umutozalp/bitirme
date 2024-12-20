import 'package:bitirme/service/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showRegisterModal(BuildContext context) {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,  // Tam ekran gibi görünmesini sağlar
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    backgroundColor: Colors.white, // Arka plan rengini beyaz yapalım
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, // Klavye için ayarlama
        ),
        child: SizedBox(
          height: 600, // Yüksekliği daha küçük yapalım
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center, // Ortalamak için
                children: [
                  const Text(
                    "Merhaba,",
                    style: TextStyle(
                      fontSize: 28, // Başlık font büyüklüğünü arttıralım
                      fontWeight: FontWeight.w500,
                      color: Colors.black87, // Başlık rengi siyah
                    ),
                  ),
                  const Text("Modo'da hesap oluştur, indirimleri kaçırma!",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                  const SizedBox(height: 15),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "E-posta",
                      labelStyle: TextStyle(color: Colors.black87), // E-posta etiket rengi
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Arayı biraz daha açalım
                  TextField(
                    obscureText: true, // Şifreyi gizler
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Şifre",
                      labelStyle: TextStyle(color: Colors.black87), // Şifre etiket rengi
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const Text("Şifreniz en az 6 karakter olmalı 1 büyük harf ve, 1 küçük harf ve rakam içermelidir.", style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                  const SizedBox(height: 30), // Arayı biraz daha açalım
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Auth().createUser(email: emailController.text, password: passwordController.text);
                         Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:Color.fromRGBO(150, 85, 80, 50.0), // Buton rengi mavi
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0), // Köşeleri yuvarlayalım
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                      ),
                      child: const Text(
                        "Kayıt Ol",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Buton yazı rengi beyaz
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
    },
  );
}
