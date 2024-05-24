import 'package:flutter/material.dart';
import 'package:grocery_user_student/firebase/firebase_servicies.dart';
import 'package:grocery_user_student/model/address_model.dart';

class AddressManageScreen extends StatefulWidget {
  const AddressManageScreen({super.key});

  @override
  State<AddressManageScreen> createState() => _AddressManageScreenState();
}

class _AddressManageScreenState extends State<AddressManageScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Address"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _addressController,
                  decoration:
                      const InputDecoration(labelText: 'Flat No / House No'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _addressLine1Controller,
                  decoration:
                      const InputDecoration(labelText: 'Address Line 1'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter address line 1';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _addressLine2Controller,
                  decoration:
                      const InputDecoration(labelText: 'Address Line 2'),
                ),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(labelText: 'City'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a city';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _pincodeController,
                  decoration: const InputDecoration(labelText: 'Pincode'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a pincode';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _stateController,
                  decoration: const InputDecoration(labelText: 'State'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a state';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.amber.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _saveAddress,
                  child: const Text('Save Address'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveAddress() {
    try {
      Address address = Address(
          address: _addressController.text.toString(),
          addressLine1: _addressLine1Controller.text.toString(),
          addressLine2: _addressLine2Controller.text.toString(),
          city: _cityController.text.toString(),
          pincode: _pincodeController.text.toString(),
          state: _stateController.text.toString());

      FirebaseServicies().saveAddressInDatabase(address).then((value) {
        Navigator.pop(context);
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
