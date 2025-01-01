import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class SavedCard {
  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cardNickname;

  SavedCard({
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cardNickname,
  });
}

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool isAddingCard = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final List<SavedCard> savedCards = [];
  final nicknameController = TextEditingController();
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  bool useFloatingAnimation = true;

  String get maskedCardNumber {
    if (cardNumber.isEmpty) return '';
    // Boşlukları kaldır ve sadece sayıları al
    final cleanNumber = cardNumber.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanNumber.length < 4) return cardNumber;

    // Son 4 hane hariç hepsini maskele ve 4'lü grupla
    final lastFour = cleanNumber.substring(cleanNumber.length - 4);
    return '0000 0000 0000 $lastFour'; // Sabit format kullan
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ödeme Yöntemleri'),
      ),
      body: isAddingCard ? _buildAddCardForm() : _buildCardsList(),
      floatingActionButton: isAddingCard
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  isAddingCard = true;
                });
              },
              label: const Text('+ Kart Ekle'),
              icon: const Icon(Icons.add),
            ),
    );
  }

  Widget _buildAddCardForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CreditCardWidget(
              cardNumber: maskedCardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              bankName: 'Banka',
              showBackView: isCvvFocused,
              obscureCardNumber: false,
              obscureCardCvv: true,
              isHolderNameVisible: true,
              onCreditCardWidgetChange: (brand) {},
            ),
            const SizedBox(height: 20),
            const Text(
              'Kart Bilgileri',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: nicknameController,
                    decoration: const InputDecoration(
                      labelText: 'Kart Takma Adı',
                      hintText: 'Örn: İş Bankası Kartım',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CreditCardForm(
                    formKey: formKey,
                    cardNumber: cardNumber,
                    expiryDate: expiryDate,
                    cardHolderName: cardHolderName,
                    cvvCode: cvvCode,
                    themeColor: Colors.blue,
                    onCreditCardModelChange: onCreditCardModelChange,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      setState(() {
                        isAddingCard = false;
                        _clearForm();
                      });
                    },
                    child: const Text('İptal'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _onValidate,
                    child: const Text('Kartı Kaydet'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardsList() {
    return savedCards.isEmpty
        ? const Center(
            child: Text('Henüz kayıtlı kart bulunmamaktadır.'),
          )
        : ListView.builder(
            itemCount: savedCards.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final card = savedCards[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text(card.cardNickname),
                  subtitle: Text(
                      '**** **** **** ${card.cardNumber.substring(card.cardNumber.length - 4)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        savedCards.removeAt(index);
                      });
                    },
                  ),
                ),
              );
            },
          );
  }

  void _onValidate() {
    if (formKey.currentState?.validate() ?? false) {
      if (nicknameController.text.isNotEmpty) {
        savedCards.add(SavedCard(
          cardNumber: cardNumber,
          expiryDate: expiryDate,
          cardHolderName: cardHolderName,
          cardNickname: nicknameController.text,
        ));

        setState(() {
          isAddingCard = false;
          _clearForm();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kart başarıyla kaydedildi')),
        );
      }
    }
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  void _clearForm() {
    cardNumber = '';
    expiryDate = '';
    cardHolderName = '';
    cvvCode = '';
    nicknameController.clear();
  }
}
