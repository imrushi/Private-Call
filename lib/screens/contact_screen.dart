import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

import 'package:private_call/components/appBar.dart';
// import 'package:simple_permissions/simple_permissions.dart';
import 'package:private_call/components/cards_1.dart';
import 'package:private_call/database/TaskModel.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final TodoHelper _todoHelper = TodoHelper();
  Color primaryColorButton = Color(0xFF4C4F5E);
  Icon changeIcon = Icon(Icons.add);
  String private_call = 'Select Contacts';
  // bool selected = false;
  List<Contact> fcontact = [];
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];
  TextEditingController searchController = new TextEditingController();

  List<TaskModel> tasks = [];

  TaskModel currentTask;

  @override
  void initState() {
    getAllContacts();
    super.initState();

    searchController.addListener(() {
      filterContacts();
    });
  }

  List<TaskModel> retList() {
    return tasks;
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  filterContacts() {
    setState(() {
      List<Contact> _contacts = [];
      _contacts.addAll(contacts);
      if (searchController.text.isNotEmpty) {
        _contacts.retainWhere(
          (contact) {
            String searchTerm = searchController.text.toLowerCase();
            String searchTermFlatten = flattenPhoneNumber(searchTerm);
            String contactName = contact.displayName.toLowerCase();
            bool nameMatches = contactName.contains(searchTerm);
            if (nameMatches == true) {
              return true;
            }

            if (searchTermFlatten.isEmpty) {
              return false;
            }

            var phone = contact.phones.firstWhere((phn) {
              String phnFlattened = flattenPhoneNumber(phn.value);
              return phnFlattened.contains(searchTermFlatten);
            }, orElse: () => null);

            return phone != null;
          },
        );

        contactsFiltered = _contacts;
      }
    });
  }

  getAllContacts() async {
    List<Contact> _contacts = (await ContactsService.getContacts()).toList();
    setState(() {
      contacts = _contacts;
    });
  }

  // getAllSelected() async {
  //   List<Contact> _fcontacts = (await ContactsService.getContacts()).toList();
  //   setState(() {
  //     fcontact = _fcontacts;
  //   });
  // }
  afterSelecting() async {
    for (int i = 0; i <= contacts.length - 1; i++) {
      if (contacts[i].isSelected) {
        currentTask = TaskModel(
            name: contacts[i].displayName,
            phoneno: contacts[i].phones.elementAt(0).value);
        _todoHelper.insertTask(currentTask);
        print(contacts[i].displayName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // checkPermissions(context);
    bool isSearching = searchController.text.isNotEmpty;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(children: <Widget>[
        AppbarCustom(
          tMain: private_call,
        ),
        Expanded(
          child: Container(
            child: Column(
              children: <Widget>[
                searchBar(context),
                contactListView(isSearching),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                        child: Text('After Selecting Click Here'),
                        color: Color(0xFF4C4F5E),
                        onPressed: () {
                          setState(() {
                            afterSelecting();
                            print('Inserted');
                          });
                        }),
                  ],
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Expanded contactListView(bool isSearching) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount:
            isSearching == true ? contactsFiltered.length : contacts.length,
        itemBuilder: (context, index) {
          Contact contact =
              isSearching == true ? contactsFiltered[index] : contacts[index];
          return ListTile(
            onTap: () {
              setState(() {
                (!contacts[index].isSelected)
                    ? contacts[index].isSelected = true
                    : contacts[index].isSelected = false;
              });
              print(index);
              print(contacts[index].isSelected);
              print(contact);
            },
            title: Text(contact.displayName),
            selected: contacts[index].isSelected,
            subtitle: CardType(
                ttText: contact.phones.isNotEmpty
                    ? contact.phones.elementAt(0).value
                    : 'No Phone no.'),
            leading: (contact.avatar != null && contact.avatar.length > 0)
                ? CircleAvatar(
                    backgroundImage: MemoryImage(contact.avatar),
                  )
                : CircleAvatar(
                    child: Text(contact.initials()),
                  ),
            trailing: (contacts[index].isSelected)
                ? Icon(Icons.check)
                : Icon(Icons.add),
          );
        },
      ),
    );
  }

  Container searchBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
            labelText: 'Search',
            border: new OutlineInputBorder(
              borderSide: new BorderSide(
                color: Theme.of(context).primaryColor,
              ),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.teal.shade300,
            )),
      ),
    );
  }
}
