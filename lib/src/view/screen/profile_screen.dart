import 'package:bitirme/service/auth.dart';
import 'package:flutter/material.dart';
import 'package:bitirme/src/view/screen/login_register_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Kullanıcı bilgileri
  Map<String, String> userInfo = {
    "name": "",
    "email": "",
    "phone": "",
  };

  @override
  Widget build(BuildContext context) {
    final currentUser = Auth().currentUser;

    if (currentUser == null) {
      return const LoginRegisterPage();
    } else {
      // Kullanıcı bilgilerini güncelle
      userInfo = {
        "name": currentUser.displayName ?? "Ad Bulunamadı",  // null olması durumunda varsayılan değer
        "email": currentUser.email ?? "Email Bulunamadı",
        "phone": currentUser.phoneNumber ?? "Telefon Bulunamadı",
      };
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profil', style: TextStyle(fontSize: 24)),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.person), text: "Bilgilerim"),
              Tab(icon: Icon(Icons.payment), text: "Ödemelerim"),
              Tab(icon: Icon(Icons.location_on), text: "Adreslerim"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            UserInfoTab(userInfo: userInfo, onUpdate: updateUserInfo),
            const PaymentInfoTab(),
            const AddressInfoTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await Auth().signOut();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginRegisterPage()),
            );
          },
          label: const Text("Çıkış Yap"),
          icon: const Icon(Icons.logout),
          backgroundColor: Colors.redAccent,
        ),
      ),
    );
  }

  // Kullanıcı bilgilerini güncelleyen metod
  void updateUserInfo(String key, String value) {
    setState(() {
      userInfo[key] = value;
    });
  }
}

/// Kullanıcı Bilgileri Sekmesi
class UserInfoTab extends StatefulWidget {
  final Map<String, String> userInfo;
  final Function(String, String) onUpdate;

  const UserInfoTab({super.key, required this.userInfo, required this.onUpdate});

  @override
  State<UserInfoTab> createState() => _UserInfoTabState();
}

class _UserInfoTabState extends State<UserInfoTab> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userInfo["name"]);
    emailController = TextEditingController(text: widget.userInfo["email"]);
    phoneController = TextEditingController(text: widget.userInfo["phone"]);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Center(
          child: CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage('assets/images/profile_pic.png'),
          ),
        ),
        const SizedBox(height: 20),
        buildEditableField("Ad Soyad", nameController, "name"),
        const SizedBox(height: 10),
        buildEditableField("E-mail", emailController, "email"),
        const SizedBox(height: 10),
        buildEditableField("Telefon", phoneController, "phone"),
      ],
    );
  }

  /// Tek bir düzenlenebilir alan oluşturan widget
  Widget buildEditableField(String label, TextEditingController controller, String key) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.edit),
      ),
      onChanged: (value) {
        widget.onUpdate(key, value); // Ana sayfadaki bilgileri günceller
      },
    );
  }
}

/// Ödeme Bilgileri Sekmesi
class PaymentInfoTab extends StatelessWidget {
  const PaymentInfoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.credit_card, color: Colors.blueAccent),
            title: const Text("Kredi Kartı"),
            subtitle: const Text("**** **** **** 1234"),
            trailing: const Icon(Icons.edit),
            onTap: () {},
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.account_balance, color: Colors.green),
            title: const Text("Banka Hesabı"),
            subtitle: const Text("TR12 1234 5678 9101 1121 00"),
            trailing: const Icon(Icons.edit),
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

/// Adres Bilgileri Sekmesi
class AddressInfoTab extends StatelessWidget {
  const AddressInfoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.home, color: Colors.orange),
            title: const Text("Ev Adresi"),
            subtitle: const Text("Cumhuriyet Mah. No:12 Daire:34, İstanbul"),
            trailing: const Icon(Icons.edit),
            onTap: () {},
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.work, color: Colors.blueGrey),
            title: const Text("İş Adresi"),
            subtitle: const Text("Sanayi Mah. No:45 Kat:3, Ankara"),
            trailing: const Icon(Icons.edit),
            onTap: () {},
          ),
        ),
      ],
    );
  }
}
