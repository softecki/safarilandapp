import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wicom/core/app_color.dart';
import '../../services/api_service.dart';

class ClientRegistrationScreen extends StatefulWidget {
  const ClientRegistrationScreen({Key? key}) : super(key: key);

  @override
  _ClientRegistrationScreenState createState() =>
      _ClientRegistrationScreenState();
}

class _ClientRegistrationScreenState extends State<ClientRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _loanAmountController = TextEditingController();
  final _purposeController = TextEditingController();

  String? _selectedGender;
  DateTime? _selectedDob;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<Map<String, dynamic>> _loanPurposes = [
    {'name': 'Business', 'icon': Icons.business},
    {'name': 'Education', 'icon': Icons.school},
    {'name': 'Medical', 'icon': Icons.medical_services},
    {'name': 'Personal', 'icon': Icons.person},
    {'name': 'Agriculture', 'icon': Icons.agriculture},
    {'name': 'Other', 'icon': Icons.more_horiz},
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguageCode = prefs.getString('selected_language_code');
      
      if (savedLanguageCode != null && mounted) {
        context.setLocale(Locale(savedLanguageCode));
      }
    } catch (e) {
      print('Error loading saved language: $e');
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _idNumberController.dispose();
    _addressController.dispose();
    _loanAmountController.dispose();
    _purposeController.dispose();
    super.dispose();
  }


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDob) {
      setState(() {
        _selectedDob = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDob == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please_select_date_of_birth'.tr())),
        );
        return;
      }

      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(color: AppColor.primaryColor),
        ),
      );

      try {
        final response = await ApiService().registerClient(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          phone: _phoneController.text,
          email: _emailController.text,
          gender: _selectedGender!,
          dateOfBirth: '${_selectedDob!.year}-${_selectedDob!.month.toString().padLeft(2, '0')}-${_selectedDob!.day.toString().padLeft(2, '0')}',
          idNumber: _idNumberController.text,
          address: _addressController.text,
          loanAmount: _loanAmountController.text,
          loanPurpose: _purposeController.text,
        );

        if (!mounted) return;
        Navigator.pop(context); // Close loading

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Application_Submitted'.tr()),
            content: Text(
              response['message'] ?? 'Thank_you_for_registering_a_new_client_The_application_is_under_review'.tr(),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('OK'.tr()),
              ),
            ],
          ),
        );
      } catch (e) {
        if (!mounted) return;
        Navigator.pop(context); // Close loading
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${'Failed_to_register_client'.tr()}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register_A_Friend'.tr()),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Personal Information Section
              Text(
                'Personal_Information'.tr(),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        labelText: 'First_Name'.tr(),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please_enter_first_name'.tr();
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        labelText: 'Last_Name'.tr(),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please_enter_last_name'.tr();
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Gender and Date of Birth
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: InputDecoration(
                        labelText: 'Gender'.tr(),
                        border: const OutlineInputBorder(),
                      ),
                      items: _genders.map((String gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender.tr()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please_select_gender'.tr();
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: TextEditingController(
                        text: _selectedDob != null
                            ? '${_selectedDob!.day}/${_selectedDob!.month}/${_selectedDob!.year}'
                            : '',
                      ),
                      decoration: InputDecoration(
                        labelText: 'Date_of_Birth'.tr(),
                        border: const OutlineInputBorder(),
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                      onTap: () => _selectDate(context),
                      validator: (value) {
                        if (_selectedDob == null) {
                          return 'Please_select_date_of_birth'.tr();
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              // Contact Information Section
              const SizedBox(height: 24),
              Text(
                'Contact_Information'.tr(),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),

              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone_Number'.tr(),
                  border: const OutlineInputBorder(),
                  prefixText: '+255 ',
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please_enter_phone_number'.tr();
                  }
                  if (value.length < 9) {
                    return 'Please_enter_a_valid_phone_number'.tr();
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email_Optional'.tr(),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Physical_Address'.tr(),
                  border: const OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please_enter_address'.tr();
                  }
                  return null;
                },
              ),

              // Loan Information Section
              const SizedBox(height: 24),
              Text(
                'Loan_Information'.tr(),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),

              TextFormField(
                controller: _loanAmountController,
                decoration: InputDecoration(
                  labelText: 'Loan_Amount_TZS'.tr(),
                  border: const OutlineInputBorder(),
                  prefixText: 'TZS ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please_enter_loan_amount'.tr();
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please_enter_a_valid_amount'.tr();
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _purposeController.text.isEmpty
                    ? null
                    : _purposeController.text,
                decoration: InputDecoration(
                  labelText: 'Loan_Purpose'.tr(),
                  border: const OutlineInputBorder(),
                ),
                items: _loanPurposes.map((purpose) {
                  return DropdownMenuItem<String>(
                    value: purpose['name'],
                    child: Row(
                      children: [
                        Icon(purpose['icon'], size: 20),
                        const SizedBox(width: 10),
                        Text(purpose['name'].toString().tr()),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _purposeController.text = value ?? '';
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please_select_loan_purpose'.tr();
                  }
                  return null;
                },
              ),

              // ID Verification Section
              const SizedBox(height: 24),
              Text(
                'ID_Verification'.tr(),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),

              TextFormField(
                controller: _idNumberController,
                decoration: InputDecoration(
                  labelText: 'ID_Passport_Number'.tr(),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please_enter_ID_Passport_number'.tr();
                  }
                  return null;
                },
              ),

              // Submit Button
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Submit_Application'.tr(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

}
