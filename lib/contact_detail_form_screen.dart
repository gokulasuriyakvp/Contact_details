import 'package:flutter/material.dart';

import 'contact_details_list_screen.dart';
import 'database_helper.dart';
import 'main.dart';

class ContactDetailsFormScreen extends StatefulWidget {
  const ContactDetailsFormScreen({super.key});

  @override
  State<ContactDetailsFormScreen> createState() =>
      _ContactDetailsFormScreenState();
}

class _ContactDetailsFormScreenState extends State<ContactDetailsFormScreen> {
  var _nameController = TextEditingController();
  var _mobileNumberController = TextEditingController();
  var _emailIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Details Form'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      labelText: 'Contact Name',
                      hintText: 'Enter Contact Name'),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _mobileNumberController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      labelText: 'Mobile Number',
                      hintText: 'Enter Mobile Number'),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _emailIdController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      labelText: 'Email ID',
                      hintText: 'Enter Email ID'),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    print('--------------> Save Button Clicked');
                    _save();
                  },
                  child: Text('Save'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _save() async {
    print('--------------> _save');
    print('--------------> Contact Name: ${_nameController.text}');
    print('--------------> Mobile Number: ${_mobileNumberController.text}');
    print('--------------> Email ID: ${_emailIdController.text}');

    Map<String, dynamic> row = {
      DatabaseHelper.colName: _nameController.text,
      DatabaseHelper.colMobileNo: _mobileNumberController.text,
      DatabaseHelper.colEmailID: _emailIdController.text,
    };

    final result = await dbHelper.insertContactDetails(row, DatabaseHelper.contactDetailsTable);
    debugPrint('--------> Inserted Row Id: $result');

    if (result > 0) {
      Navigator.pop(context);
      _showSuccessSnackBar(context, 'Saved');
      setState(() {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => ContactDetailsListScreen()));
      });
    }
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(message)));
  }
}
