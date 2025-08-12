import 'package:contact_list_2/contact.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabse {
  static Database? db;

// buat inisialisasi database
  static Future<void> initializeDataBase() async {
    String databasePath = await getDatabasesPath();
    String path = '$databasePath/contact_september_2024_database.db';

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE contact(phoneNo TEXT PRIMARY KEY, name TEXT)');
      },
    );
  }

//buat funsgi create
  static Future<int> addNewContact(Contact contact) async {
    try {
      int result = await db!.insert(
        'contact',
        contact.toMap(),
      );

      return result;
    } on DatabaseException catch (e) {
      debugPrint(e.toString());
      return -1;
    }
  }

  //buat fungsi get
  static Future<List<Contact>> getContactList() async {
    if (db == null) {
      await LocalDatabse.initializeDataBase();
    }
    final List<Map<String, dynamic>> maps = await db!.query('contact');

    List<Contact> contactList = [];

    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        Contact contact = Contact(maps[i]['name'], maps[i]['phoneNo']);

        contactList.add(contact);
      }
    }
    return contactList;
  }

//buat fungsi update
  static Future<int> updateContact(String oldPhoneNo, Contact contact) async {
    try {
      int result = await db!.update(
        'contact',
        contact.toMap(),
        where: "phoneNo = ?",
        whereArgs: [oldPhoneNo],
      );

      return result;
    } on DatabaseException catch (e) {
      debugPrint(e.toString());
      return 0;
    }
  }

  //buat fungsi delete
  static Future<int> deleteContact(String phoneNo) async {
    int result = await db!.delete(
      'contact',
      where: "phoneNo = ?",
      whereArgs: [phoneNo],
    );
    return result;
  }
}
