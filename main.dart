import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(Vyapari360LiteApp());
}

class Vyapari360LiteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vyapari 360 Lite',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: CustomerListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Customer {
  final String name;
  final String phone;
  final double bakiAmount;
  final int tokriCount;

  Customer({
    required this.name,
    required this.phone,
    required this.bakiAmount,
    required this.tokriCount,
  });
}

class CustomerListScreen extends StatefulWidget {
  @override
  _CustomerListScreenState createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  List<Customer> customers = [
    Customer(name: 'Ramesh', phone: '9876543210', bakiAmount: 200, tokriCount: 3),
    Customer(name: 'Suresh', phone: '9876509876', bakiAmount: -100, tokriCount: 1),
    Customer(name: 'Anita', phone: '9765432101', bakiAmount: 0, tokriCount: 0),
  ];

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    List<Customer> filteredCustomers = customers
        .where((c) => c.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vyapari 360 Lite'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Customer...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCustomers.length,
              itemBuilder: (context, index) {
                final customer = filteredCustomers[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(child: Text(customer.name[0])),
                    title: Text(customer.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tokri: ${customer.tokriCount}'),
                        Text(
                          customer.bakiAmount == 0
                              ? 'No Balance'
                              : customer.bakiAmount > 0
                                  ? 'Baki: ₹${customer.bakiAmount}'
                                  : 'Jama: ₹${-customer.bakiAmount}',
                          style: TextStyle(
                            color: customer.bakiAmount > 0
                                ? Colors.red
                                : customer.bakiAmount < 0
                                    ? Colors.green
                                    : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(FontAwesomeIcons.whatsapp, color: Colors.green),
                      onPressed: () async {
                        final message =
                            "Namaste ${customer.name},\nAapka Vyapari 360 account mein ${customer.bakiAmount > 0 ? 'Baki ₹${customer.bakiAmount}' : customer.bakiAmount < 0 ? 'Jama ₹${-customer.bakiAmount}' : 'koi baki nahi'} hai.\nTokri balance: ${customer.tokriCount}";
                        final url = Uri.parse("https://wa.me/91${customer.phone}?text=${Uri.encodeComponent(message)}");

                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('WhatsApp open nahi ho paya')),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
