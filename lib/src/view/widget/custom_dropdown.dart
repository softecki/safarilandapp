import 'package:flutter/material.dart';
import '../../../core/app_color.dart';

class CustomDropdown extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final List<String> items;
  final Function(String?) onChanged;
  final String? selectedValue;

  const CustomDropdown({
    Key? key,
    required this.hintText,
    required this.icon,
    required this.items,
    required this.onChanged,
    this.selectedValue,
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedItem,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        // prefixIcon: Icon(widget.icon, color: Colors.blueGrey),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blueGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blueGrey, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColor.primaryColor, width: 2),
        ),
      ),
      hint: Text(widget.hintText, style: TextStyle(color: Colors.blueGrey)),
      items: widget.items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedItem = newValue;
        });
        widget.onChanged(newValue);
      },
    );
  }
}
