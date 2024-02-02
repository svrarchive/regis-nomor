import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:onscreen_num_keyboard/onscreen_num_keyboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // ignore: unused_field
  final GlobalKey<FormState> _formKey = GlobalKey();

  MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WhatsApp Number Input',
      theme: ThemeData(),
      home: const MyHomePage(title: ''),
    );
  }
}

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
     final String title;

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
  
}

  
class _MyHomePageState extends State<MyHomePage> {
  String text = '';
  String _selectedCountryCode = '';
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _phoneController = TextEditingController();
     
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.centerLeft,
              child: Text(
                'Masukkan Nomor WhatsApp',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              IntlPhoneField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: "Nomor Handphone",
                ),
                onCountryChanged: (phone) {
                  setState(() {
                    _selectedCountryCode = phone.fullCountryCode;
                  });
                },
              ),
              const Text(
                'Kami akan kirim ',
                style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              RichText(
                text: const TextSpan(
                  text: 'Kode Verifikasi',
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14),
                  children: [
                    TextSpan(
                      text: ' ke nomor handphone anda',
                      style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  _showConfirmationDialog(
                    nomorHandphone: _phoneController.text, 
                    countryCode: _selectedCountryCode,
                    );
                },
                icon: Image.asset(
                  'assets/whatsapp_logo.png',
                  width: 30,
                  height: 30,
                ),
                label: const Column(
                  children: [
                    Text('Kirim via', style: TextStyle(fontSize: 10)),
                    Text('   WhatsApp', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                   minimumSize: const Size(50, 50), // Atur lebar dan tinggi sesuai kebutuhan
                   padding: const EdgeInsets.symmetric(horizontal: 60), // Atur padding sesuai kebutuhan
                ), 
              ),
              const SizedBox(height: 21),
              const Text(
                'Dengan melanjutkan saya menerima ',
                style: TextStyle(color: Colors.blueGrey, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              RichText(
                text: const TextSpan(
                  text: 'Ketentuan Layanan',
                  style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: ' dan telah membaca',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 12, fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(text: ' Kebijakan Privasi', style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold)),
                        TextSpan(text: ' dari Dreamwash', style: TextStyle(color: Colors.blueGrey, fontSize: 12, fontWeight: FontWeight.bold)),
                      ]
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
               Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  NumericKeyboard(
                    onKeyboardTap: _onKeyboardTap,
                    rightButtonFn: () {
                      _onKeyboardTap('backspace');
                      setState(() {
                        text = text.substring(0, text.length - 1);
                      });
                    },
                    rightIcon: const Icon(
                      Icons.backspace,
                      color: Colors.black,
                    ),
                    leftButtonFn: () {
                      print('left button clicked');
                    },
                    leftIcon: const Icon(
                      Icons.check,
                      color: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  _onKeyboardTap(String value) {
    setState(() {
      if (value == 'backspace') {
        if (text.isNotEmpty) {
          text = text.substring(0, text.length - 1);
          _phoneController.text = text;
        }
      } else {
      text = text + value;
      _phoneController.text = text;
      }
    });
  }
  Future<void> _showConfirmationDialog({ required String nomorHandphone, required String countryCode}) async {
  if (_phoneController.text.isEmpty) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Perhatian'),
          content: const Text('Harap isi nomor handphone terlebih dahulu.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    return;
  }
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Perhatian',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
            
             const Text(
              'Pastikan nomor handphone yang anda masukan ',
              style: TextStyle(fontSize: 13, color: Colors.grey),
             ),
             const Row(
              children: [
                Text(
                  'sudah benar dan terdaftar dalam aplikasi',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
              ],
             ),
             const Row(
              children: [
                Text(
                  'WhatsApp',
                  style: TextStyle(color: Colors.blue, fontSize: 13),
                  ),
              ],
             ),
              const SizedBox(height: 20),
             Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.lightBlue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Text(
                '+$countryCode', 
                style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                nomorHandphone,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
                ],
              ),
            ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Ganti Nomor', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Sudah Benar', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
              const SizedBox(width: 15),
              const SizedBox(height: 20),
        ],
      );
    },
  );
  }
}
