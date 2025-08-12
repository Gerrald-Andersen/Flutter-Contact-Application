import 'package:contact_list_2/contact.dart';
import 'package:contact_list_2/contact_dialog.dart';
import 'package:contact_list_2/local_databse.dart';
import 'package:flutter/material.dart';

class ContactListPage extends StatefulWidget {
  const ContactListPage({super.key});

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  TextEditingController searchController = TextEditingController();

  late Future contactListFuture;
  List<Contact> contactList = [];

  @override
  void initState() {
    super.initState();

    contactListFuture = LocalDatabse.getContactList().then((value) {
      contactList = value;
    });

    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact List"),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.all(8),
            child: InkWell(
              onTap: () {
                showContactDialog(true, "", "");
              },
              child: const Icon(
                Icons.add,
                size: 30,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                  hintText: "Search ...", prefixIcon: Icon(Icons.search)),
            ),
          ),
          FutureBuilder(
              future: contactListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Expanded(
                    child: createFilteredContact(searchController.text),
                  );
                } else {
                  return Container();
                }
              }),
        ],
      ),
    );
  }

  void updateDisplay(String msg) {
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

    contactListFuture = LocalDatabse.getContactList().then((value) {
      setState(() {
        contactList = value;
      });
    });
  }

  void showContactDialog(bool isNew, String name, String phoneNo) {
    showDialog(
        context: context,
        builder: (BuildContext) {
          return ContactDialog(
              isNew: isNew, name: name, phone: phoneNo, onDone: updateDisplay);
        });
  }

  void showDeleteDialog(String currentPhoneNo) {
    TextButton yesButton = TextButton(
        onPressed: () {
          LocalDatabse.deleteContact(currentPhoneNo).then((value) {
            if (value >= 1) {
              updateDisplay('Berhasil menghapus kontak');
            } else {
              updateDisplay('Gagal menghapus kontak');
            }
          });
        },
        child: const Text('YES'));

    TextButton noButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('NO'));

    AlertDialog alertDialog = AlertDialog(
      title: const Text('Konfirmasi Delete'),
      content: Text('Delete kontak dengan nomor $currentPhoneNo?'),
      actions: [
        yesButton,
        noButton,
      ],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  Widget createFilteredContact(String searchText) {
    List<Contact> filteredContactList = [];

    for (int i = 0; i < contactList.length; i++) {
      Contact contact = contactList[i];

      if (contact.name.toLowerCase().contains(searchText.toLowerCase()) ||
          contact.phoneNo.toLowerCase().contains(searchText.toLowerCase())) {
        filteredContactList.add(contact);
      }
    }
    Widget listViewWidget = createFilteredListView(filteredContactList);
    return listViewWidget;
  }

  Widget createFilteredListView(List<Contact> filteredContactList) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            showContactDialog(false, filteredContactList[index].name,
                filteredContactList[index].phoneNo);
          },
          title: Text(
            filteredContactList[index].name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            filteredContactList[index].phoneNo,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: InkWell(
            onTap: () {
              showDeleteDialog(filteredContactList[index].phoneNo);
            },
            child: Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        );
      },
      itemCount: filteredContactList.length,
    );
  }
}
