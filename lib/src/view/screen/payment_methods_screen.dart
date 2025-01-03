import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:bitirme/service/firestore_database.dart';

class SavedCard {
  final String cardNo;
  final String expiryDate;
  final String cardHolderName;
  final String cardNickname;
  final String documentId;

  SavedCard({
    required this.cardNo,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cardNickname,
    required this.documentId,
  });
}

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  FirebaseService _firebaseService = FirebaseService();
  String cardNo = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool isAddingCard = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final List<SavedCard> savedCards = [];
  final nicknameController = TextEditingController();
  bool showErrors = false;

  String get maskedCardNo {
    if (cardNo.isEmpty) return '';
    final cleanNumber = cardNo.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanNumber.length < 4) return cardNo;
    final lastFour = cleanNumber.substring(cleanNumber.length - 4);
    return '0000 0000 0000 $lastFour';
  }

  @override
  void initState() {
    super.initState();
    _loadCardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kayıtlı Kartlarım',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: isAddingCard ? _buildAddCardForm() : _buildCardsList(),
      floatingActionButton: isAddingCard
          ? null
          : FloatingActionButton.extended(
              onPressed: () => setState(() => isAddingCard = true),
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
              cardNumber: maskedCardNo,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              bankName: 'Banka',
              showBackView: isCvvFocused,
              obscureCardNumber: false,
              obscureCardCvv: true,
              isHolderNameVisible: true,
              onCreditCardWidgetChange: (_) {},
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
                    maxLength: 10,
                    controller: nicknameController,
                    decoration: InputDecoration(
                      labelText: 'Kart Takma Adı',
                      hintText: 'Örn: İş Bankası Kartım',
                      border: const OutlineInputBorder(),
                      errorText: showErrors && nicknameController.text.isEmpty
                          ? 'Kart takma adı boş geçilemez'
                          : null,
                    ),
                  ),
                  CreditCardForm(
                    formKey: formKey,
                    cardNumber: cardNo,
                    expiryDate: expiryDate,
                    cardHolderName: cardHolderName,
                    cvvCode: cvvCode,
                    themeColor: Colors.blue,
                    onCreditCardModelChange: onCreditCardModelChange,
                    cardNumberDecoration: const InputDecoration(
                      labelText: 'Kart Numarası',
                      hintText: 'Kart Numarası Giriniz',
                    ),
                    expiryDateDecoration: const InputDecoration(
                      labelText: 'Son Kullanma Tarihi',
                      hintText: 'GG/YY',
                    ),
                    cvvCodeDecoration: const InputDecoration(
                      labelText: 'CVV',
                      hintText: 'CVV Kodunu Giriniz',
                    ),
                    cardHolderDecoration: InputDecoration(
                      labelText: 'Kart Sahibi',
                      hintText: 'Kart Sahibini Giriniz',
                      errorText: showErrors && cardHolderName.isEmpty
                          ? 'Kart sahibi boş geçilemez'
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.white,
                      side:
                          const BorderSide(color: Colors.blueAccent, width: 2),
                    ),
                    onPressed: () => setState(() {
                      isAddingCard = false;
                      _clearForm();
                    }),
                    child: const Text(
                      'İptal',
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blueAccent,
                    ),
                    onPressed: _onValidate,
                    child: const Text(
                      'Kartı Kaydet',
                      style: TextStyle(color: Colors.white),
                    ),
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
                      '**** **** **** ${card.cardNo.substring(card.cardNo.length - 4)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      bool success = await _firebaseService
                          .deleteCreditCard(card.documentId);
                      if (success) {
                        setState(() => savedCards.removeAt(index));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Kart silindi'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          );
  }

  void _onValidate() {
    setState(() => showErrors = true);
    if ((formKey.currentState?.validate() ?? false) &&
        nicknameController.text.isNotEmpty &&
        cardHolderName.isNotEmpty) {
      _firebaseService.saveCreditCard(
          nicknameController.text, cardNo, expiryDate, cvvCode, cardHolderName);

      savedCards.add(SavedCard(
        cardNo: cardNo,
        expiryDate: expiryDate,
        cardHolderName: cardHolderName,
        cardNickname: nicknameController.text,
        documentId: '',
      ));

      setState(() {
        isAddingCard = false;
        _clearForm();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kart başarıyla kaydedildi'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void onCreditCardModelChange(CreditCardModel model) {
    setState(() {
      cardNo = model.cardNumber;
      expiryDate = model.expiryDate;
      cardHolderName = model.cardHolderName;
      cvvCode = model.cvvCode;
      isCvvFocused = model.isCvvFocused;
    });
  }

  void _clearForm() {
    cardNo = '';
    expiryDate = '';
    cardHolderName = '';
    cvvCode = '';
    nicknameController.clear();
    showErrors = false;
  }

  Future<void> _loadCardData() async {
    try {
      List<Map<String, dynamic>>? cards =
          await _firebaseService.getCreditCard();
      if (cards != null && cards.isNotEmpty) {
        setState(() {
          savedCards.clear();
          for (var card in cards) {
            savedCards.add(SavedCard(
              cardNo: card['cardNo'],
              expiryDate: card['validThru'],
              cardHolderName: card['holder'],
              cardNickname: card['cardName'],
              documentId: card['documentId'],
            ));
          }
        });
      }
    } catch (e) {
      print('Veri yüklenirken bir hata oluştu: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Kart bilgileri yüklenirken hata oluştu')),
        );
      }
    }
  }
}
