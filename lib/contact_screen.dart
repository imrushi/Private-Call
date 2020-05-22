import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:private_call/appBar.dart';
// import 'package:simple_permissions/simple_permissions.dart';
import 'cards_1.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  permissionMethod() async {
    if (await Permission.contacts.request().isGranted) {}
    Map<Permission, PermissionStatus> statuses =
        await [Permission.contacts].request();
  }

  Color primaryColorButton = Color(0xFF4C4F5E);
  Icon changeIcon = Icon(Icons.add);
  String private_call = 'Private Call';
  // bool selected = false;
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];
  TextEditingController searchController = new TextEditingController();

  @override
  void initState() {
    permissionMethod();
    super.initState();
    getAllContacts();
    // getContactsPermission();
    searchController.addListener(() {
      filterContacts();
    });
  }

  // getContactsPermission() async {
  //   PermissionStatus permissionResult =
  //       await SimplePermissions.requestPermission(Permission.ReadContacts);
  //   if (permissionResult == PermissionStatus.authorized) {
  //     // code of read or write file in external storage (SD card)
  //   }
  // }

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

  // waitContact() async {
  //   return await getAllContacts();
  // }

  getAllContacts() async {
    List<Contact> _contacts = (await ContactsService.getContacts()).toList();
    setState(() {
      contacts = _contacts;
    });
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

// Container(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           children: <Widget>[

//           ],
//         ),
//       ),

// Container(
//         padding: EdgeInsets.all(20.0),
//         child: Column(
//           children: <Widget>[
//             Container(
//               height: 120.0,
//               color: Theme.of(context).primaryColor,
//               alignment: Alignment.center,
//               padding: EdgeInsets.only(top: 25.0),
//               child: Text(
//                 'Private Call',
//                 style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).accentColor,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30.0),
//                     topRight: Radius.circular(30.0),
//                   ),
//                 ),
//                 child: searchBar(context),
//               ),
//             ),
//             contactListView(isSearching),
//           ],
//         ),
//       ),
