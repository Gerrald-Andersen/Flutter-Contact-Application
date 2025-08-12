import 'package:contact_list_2/contact.dart';
import 'package:contact_list_2/local_databse.dart';
import 'package:flutter/material.dart';

class ContactDialog extends StatelessWidget {
  ContactDialog({
    super.key,
    required this.isNew,
    required this.name,
    required this.phone,
    required this.onDone,
  });

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final bool isNew;
  final String name;
  final String phone;
  final Function onDone;

  @override
  Widget build(BuildContext context) {
    nameController.text = name;
    phoneController.text = phone;

    return Dialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Wrap(children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    contentPadding: EdgeInsets.zero,
                  ),
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Phone No',
                    contentPadding: EdgeInsets.zero,
                  ),
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isEmpty ||
                        phoneController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Legkapi kolom telebih dahulu'),
                        duration: Duration(seconds: 1),
                      ));
                      return;
                    }

                    Contact contact =
                        Contact(nameController.text, phoneController.text);

                    if (isNew) {
                      LocalDatabse.addNewContact(contact).then(
                        (value) {
                          if (value >= 0) {
                            onDone("Berhasil memasukkan kontak baru");
                          } else {
                            onDone("Gagal memasukkan kontak baru");
                          }
                        },
                      );
                    } else {
                      LocalDatabse.updateContact(phone, contact).then((value) {
                        if (value >= 1) {
                          onDone("Berhasil mengupdate kontak");
                        } else {
                          onDone("Gagal mengupdate kontak");
                        }
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    isNew ? "Add Contact" : "Update Contact",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ]));
  }
}
