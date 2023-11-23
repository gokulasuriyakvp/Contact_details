import 'package:flutter/material.dart';
import 'package:flutter_contact_details/optimized_contact_detail_form_screen.dart';
import 'contact_details_model.dart';
import 'database_helper.dart';
import 'main.dart';

class ContactDetailsListScreen extends StatefulWidget {
  const ContactDetailsListScreen({super.key});

  @override
  State<ContactDetailsListScreen> createState() =>
      _ContactDetailsListScreenState();
}

class _ContactDetailsListScreenState extends State<ContactDetailsListScreen> {
  late List<ContactDetailsModel> _contactDetailsList;

  @override
  void initState() {
    super.initState();
    _getAllContactDetails();
  }

  _getAllContactDetails() async {
    _contactDetailsList = <ContactDetailsModel>[];

    var _contactDetailRecords = await dbHelper.queryAllRows(DatabaseHelper.contactDetailsTable);

    _contactDetailRecords.forEach((row) {
      setState(() {
        print(row['_id']);
        print(row['_name']);
        print(row['_mobileNo']);
        print(row['_emailID']);

        var contactDetailsModel = ContactDetailsModel(
          row['_id'],
          row['_name'],
          row['_mobileNo'],
          row['_emailID'],
        );

        _contactDetailsList.add(contactDetailsModel);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Details'),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: _contactDetailsList.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  print('---------->Edit or Delete invoked: Send Data');
                  print(_contactDetailsList[index].id);
                  print(_contactDetailsList[index].name);
                  print(_contactDetailsList[index].mobileNo);
                  print(_contactDetailsList[index].emailID);

                  /*Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditContactDetailsFormScreen(),
                    settings: RouteSettings(
                      arguments: _contactDetailsList[index],
                    ),
                  ));*/

                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => OptimziedContactDetailsFormScreen(),
                    settings: RouteSettings(
                      arguments: _contactDetailsList[index],
                    ),
                  ));

                },
                child: ListTile(
                  title: Text(_contactDetailsList[index].name +
                      '\n' + _contactDetailsList[index].mobileNo +
                      '\n' + _contactDetailsList[index].emailID),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('--------------> Launch Contact Details Form Screen');
          //Navigator.of(context).push(
          //    MaterialPageRoute(builder: (context) => ContactDetailsFormScreen()));
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => OptimziedContactDetailsFormScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
