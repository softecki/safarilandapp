import 'package:flutter/material.dart';

class MobileMoneyDropdown extends StatefulWidget {
  final TextEditingController controller;

  const MobileMoneyDropdown(this.controller, {super.key});

  @override
  _MobileMoneyDropdownState createState() => _MobileMoneyDropdownState();
}

class _MobileMoneyDropdownState extends State<MobileMoneyDropdown> {
  String? selectedService;

  final List<Map<String, String>> services = [
    {
      'name': 'M-Pesa',
      'logo': 'assets/images/mpesa.png',
    },
    {
      'name': 'Airtel Money',
      'logo': 'assets/images/airtel.png',
    },
    {
      'name': 'Tigo Pesa',
      'logo': 'assets/images/tigo.png',
    },
    {
      'name': 'HaloPesa',
      'logo': 'assets/images/halopesa.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Select Payment Service',
        filled: true,
        fillColor: Colors.blue.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      value: selectedService,
      items: services.map((service) {
        return DropdownMenuItem<String>(
          value: service['name'],
          child: Row(
            children: [
              Image.asset(
                service['logo']!,
                height: 24,
                width: 24,
              ),
              const SizedBox(width: 10),
              Text(service['name']!),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedService = value;
          widget.controller.text = value ?? '';
        });
      },
    );
  }
}


class BankDropdown extends StatefulWidget {
  final TextEditingController controller;

  const BankDropdown(this.controller, {super.key});

  @override
  _BankDropdownState createState() => _BankDropdownState();
}

class _BankDropdownState extends State<BankDropdown> {
  String? selectedService;

  final List<Map<String, String>> services = [
    {
      'name': 'CRDB',
      'logo': 'assets/images/crdb.png',
    },
    {
      'name': 'NMB',
      'logo': 'assets/images/nmb.png',
    },
    {
      'name': 'AKIBA COMMERCIAL BANK',
      'logo': 'assets/images/akiba.png',
    },
    {
      'name': 'MWANGA HAKIKA BANK',
      'logo': 'assets/images/mwanga.png',
    },
    {
      'name': 'TCB',
      'logo': 'assets/images/tcb.png',
    },
    {
      'name': 'MKOMBOZI BANK',
      'logo': 'assets/images/mkombozi.png',
    },
    {
      'name': 'MWALIMU BANK',
      'logo': 'assets/images/mwalimu.png',
    },
    {
      'name': 'AMANA BANK',
      'logo': 'assets/images/amana.png',
    },

  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Select Payment Service',
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      value: selectedService,
      items: services.map((service) {
        return DropdownMenuItem<String>(
          value: service['name'],
          child: Row(
            children: [
              Image.asset(
                service['logo']!,
                height: 24,
                width: 24,
              ),
              const SizedBox(width: 10),
              Text(service['name']!),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedService = value;
          widget.controller.text = value ?? '';
        });
      },
    );
  }
}
