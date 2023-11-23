import 'package:flutter/material.dart';

import 'contact_details_list_screen.dart';
import 'contact_details_model.dart';
import 'database_helper.dart';
import 'main.dart';

class OptimziedContactDetailsFormScreen extends StatefulWidget {
  const OptimziedContactDetailsFormScreen({super.key});

  @override
  State<OptimziedContactDetailsFormScreen> createState() =>
      _OptimziedContactDetailsFormScreenState();
}

class _OptimziedContactDetailsFormScreenState
    extends State<OptimziedContactDetailsFormScreen> {
  var _nameController = TextEditingController();
  var _mobileNumberController = TextEditingController();
  var _emailIdController = TextEditingController();

  // Edit mode
  bool firstTimeFlag = false;
  int _selectedId = 0;

  // Optimized
  String buttonText = 'Save';

  _deleteFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  print('--------------> Delete Button Clicked');
                  _delete();
                },
                child: const Text('Delete'),
              )
            ],
            title: const Text('Are you sure you want to delete this?'),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // Edit - Receive Data
    if (firstTimeFlag == false) {
      print('---------->once execute');

      firstTimeFlag = true;

      // get data
      //final contactDetails = ModalRoute.of(context)!.settings.arguments as ContactDetailsModel;
      final contactDetails = ModalRoute.of(context)!.settings.arguments;

      if(contactDetails == null){
        print('----------->FAB: Insert/Save:'); // save
      }else {
        print('----------->ListView: Received Data: Edit/Delete');

        contactDetails as ContactDetailsModel;

        print(contactDetails.id);
        print(contactDetails.name);
        print(contactDetails.mobileNo);
        print(contactDetails.emailID);

        _selectedId = contactDetails.id!;
        buttonText = 'Update';

        _nameController.text = contactDetails.name;
        _mobileNumberController.text = contactDetails.mobileNo;
        _emailIdController.text = contactDetails.emailID;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Details $buttonText'),
        actions: _selectedId == 0 ? null : [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete Record',
            onPressed: () {
              print('--------------> Delete Button Clicked');
              _deleteFormDialog(context);
            },
          ),
        ],
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
                    print('--------------> Update Button Clicked');
                    if(_selectedId == 0) {
                      print('---------------> Save');
                      _save();
                    } else{
                      print('---------------> Update');
                      _update();
                    }
                  },
                  child: Text(buttonText),
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

  void _update() async {
    print('--------------> _update');
    // edit - id
    print('---------------> Selected ID: $_selectedId');

    print('--------------> Contact Name: ${_nameController.text}');
    print('--------------> Mobile Number: ${_mobileNumberController.text}');
    print('--------------> Email ID: ${_emailIdController.text}');

    Map<String, dynamic> row = {
      // edit - id ***
      DatabaseHelper.columnId: _selectedId,
      DatabaseHelper.colName: _nameController.text,
      DatabaseHelper.colMobileNo: _mobileNumberController.text,
      DatabaseHelper.colEmailID: _emailIdController.text,
    };

    final result = await dbHelper.updateContactDetails(
        row, DatabaseHelper.contactDetailsTable);
    debugPrint('--------> Updated Row Id: $result');

    if (result > 0) {
      Navigator.pop(context);
      _showSuccessSnackBar(context, 'Updated');
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

  void _delete() async {
    print('--------------> _delete');

    final result = await dbHelper.deleteContactDetails(
        _selectedId, DatabaseHelper.contactDetailsTable);

    debugPrint('-----------------> Deleted Row Id: $result');

    if (result > 0) {
      _showSuccessSnackBar(context, 'Deleted.');
      Navigator.pop(context);
      setState(() {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ContactDetailsListScreen()));
      });
    }
  }
}
