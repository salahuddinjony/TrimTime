import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class CountryCodePickerField extends StatefulWidget {
  final bool readOnly;
  final Function onTap;

  const CountryCodePickerField({
    super.key,
    required this.readOnly,
    required this.onTap,
  });

  @override
  CountryCodePickerFieldState createState() => CountryCodePickerFieldState();
}

class CountryCodePickerFieldState extends State<CountryCodePickerField> {
  PhoneNumber number = PhoneNumber(isoCode: 'US'); // Default to 'US' (United States)
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap(); // Trigger the onTap function if needed
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Country Code Picker
          InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber number) {
              setState(() {
                this.number = number;
              });
              // Update the controller text with the selected country code and phone number
              controller.text = "${number.dialCode} ${number.phoneNumber}";
            },
            onInputValidated: (bool value) {},
            initialValue: number,
            selectorConfig: const SelectorConfig(
              selectorType: PhoneInputSelectorType.DIALOG,
              setSelectorButtonAsPrefixIcon: true,
            ),
            textFieldController: controller,
            inputDecoration: InputDecoration(
              hintText: 'Enter phone number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.black),
              ),
            ),
            inputBorder: InputBorder.none,
          ),
        ],
      ),
    );
  }
}

