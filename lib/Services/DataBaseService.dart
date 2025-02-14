import 'package:flutter/foundation.dart';
import 'package:ikrah/Models/settings.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'package:ikrah/Models/bookmark.dart';
import 'package:ikrah/Models/journalentry.dart';

class DataBaseService {
  static final DataBaseService _instance = DataBaseService._internal();
  factory DataBaseService() => _instance;
  static Database? _database;

  DataBaseService._internal();

  // Getter for the database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    late String path;
    if (kIsWeb) {
      // Change default factory on the web
      databaseFactory = databaseFactoryFfiWeb;
      path = 'ikrah.db';
    } else {
      path = join(await getDatabasesPath(), 'ikrah.db');
    }
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create the database tables
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE journal_entries (
        ayah INTEGER PRIMARY KEY,
        content TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE bookmarks (
        ayah INTEGER PRIMARY KEY,
        time TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE settings (
        DarkMode INTEGER,
        CheckUpdate INTEGER,
        PlayMode TEXT
      )
    ''');

    await db.execute('''
    CREATE TABLE current_ayah (
      ayah INTEGER
    )
    ''');

    await db.insert('current_ayah', {'ayah': 1});

    await db.insert(
        'settings',
        Settings(DarkMode: false, CheckUpdate: true, PlayMode: 'once')
            .toJson());
  }

  // Retrieve the current ayah from the database
  Future<int> getCurrentAyah() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('current_ayah');
    return maps.first['ayah'];
  }

  // Update the current ayah in the database
  Future<void> updateCurrentAyah(int ayah) async {
    Database db = await database;
    await db.update(
      'current_ayah',
      {'ayah': ayah},
    );
  }

  // Retrieve the settings from the database
  Future<Settings> getSettings() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('settings');
    return Settings.fromJson(maps.first);
  }

  // Update the settings in the database
  Future<void> updateSettings(Settings settings) async {
    Database db = await database;
    await db.update(
      'settings',
      settings.toJson(),
    );
  }

  // Insert a journal entry into the database
  Future<int> insertJournalEntry(JournalEntry journalEntry) async {
    Database db = await database;
    return await db.insert('journal_entries', journalEntry.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Update a journal entry in the database
  Future<void> updateJournalEntry(JournalEntry journalEntry) async {
    Database db = await database;
    await db.update(
      'journal_entries',
      journalEntry.toJson(),
      where: 'ayah = ?',
      whereArgs: [journalEntry.ayah],
    );
  }

  // Retrieve all journal entries from the database
  Future<List<JournalEntry>> getJournalEntries() async {
    Database db = await database;
    final maps = await db.query('journal_entries');
    return List.generate(maps.length, (i) {
      return JournalEntry.fromJson(maps[i]);
    });
  }

  // Retrieve a specific journal entry by ayah
  Future<JournalEntry> getJournalEntry(int ayah) async {
    Database db = await database;
    List<Map<String, dynamic>> entries = await db.query(
      'journal_entries',
      where: 'ayah = ?',
      whereArgs: [ayah],
    );
    return JournalEntry.fromJson(entries.first);
  }

  // Check if a journal entry exists in the database
  Future<bool> journalEntryExists(int ayah) async {
    Database db = await database;
    List<Map<String, dynamic>> entries = await db.query(
      'journal_entries',
      where: 'ayah = ?',
      whereArgs: [ayah],
    );
    return entries.isNotEmpty;
  }

  // Insert a bookmark into the database
  Future<int> insertBookmark(Bookmark bookmark) async {
    Database db = await database;
    return await db.insert('bookmarks', bookmark.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Delete a bookmark from the database by ayah
  Future<void> deleteBookmark(int ayah) async {
    Database db = await database;
    await db.delete(
      'bookmarks',
      where: 'ayah = ?',
      whereArgs: [ayah],
    );
  }

  // Check if a bookmark exists in the database
  Future<bool> bookmarkExists(int ayah) async {
    Database db = await database;
    List<Map<String, dynamic>> bookmarks = await db.query(
      'bookmarks',
      where: 'ayah = ?',
      whereArgs: [ayah],
    );
    return bookmarks.isNotEmpty;
  }

  // Retrieve all bookmarks from the database
  Future<List<Bookmark>> getBookmarks() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('bookmarks');
    return List.generate(maps.length, (i) {
      return Bookmark.fromJson(maps[i]);
    });
  }
}
