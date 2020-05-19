import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:private_call/resuable_card.dart';
import 'package:random_color/random_color.dart';
import 'cards_1.dart';
import 'round_icon_button.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Color primaryColorButton = Color(0xFF4C4F5E);
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    getAllContacts();
  }

  getAllContacts() async {
    List<Contact> _contacts = (await ContactsService.getContacts()).toList();
    setState(() {
      contacts = _contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Private Call'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            ListView.builder(
              shrinkWrap: true,
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                Contact contact = contacts[index];
                return ListTile(
                  title: Text(contact.displayName),
                  subtitle: CardType(),
                  leading: (contact.avatar != null && contact.avatar.length > 0)
                      ? CircleAvatar(
                          backgroundImage: MemoryImage(contact.avatar),
                        )
                      : CircleAvatar(
                          child: Text(contact.initials()),
                        ),
                  trailing: RoundIconButton(
                    icon: Icons.add,
                    onPressed: () {
                      setState(() {
                        // primaryColorButton = Color(0xFFE5FAF7);
                      });
                    },
                    colo: primaryColorButton,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
