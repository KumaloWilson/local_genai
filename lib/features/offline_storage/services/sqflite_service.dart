import 'dart:convert';
import 'package:local_gen_ai/core/utils/logs.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import '../../../core/constants/default_models.dart';
import '../../../core/error_handling/db_exceptions.dart';
import '../../ai_model_management/models/ai_model.dart';

class DatabaseService {
  static const String _tableName = 'models';
  static const String _settingsTable = 'settings';
  static sqflite.Database? _database;
  static const String _initializedFlagKey = 'models_initialized';

  Future<void> init() async {
    try {
      if (_database != null) return;

      final path = join(await sqflite.getDatabasesPath(), 'ai_models.db');

      // Delete the database if it exists (for development purposes)
      // Comment this out in production
      if (await sqflite.databaseExists(path)) {
        await sqflite.deleteDatabase(path);
      }

      _database = await sqflite.openDatabase(
        path,
        version: 1,
        onCreate: _createDatabase,
        onOpen: _onDatabaseOpen,
      );
    } catch (e) {
      // Handle the error here, e.g., log it or display an error message
      DevLogs.logError('Error initializing database: $e');
    }
  }

  Future<void> _createDatabase(sqflite.Database db, int version) async {
    try {
      // Create models table
      await db.execute('''
        CREATE TABLE $_tableName (
          id TEXT PRIMARY KEY,
          model_data TEXT NOT NULL,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL
        )
      ''');

      // Create settings table
      await db.execute('''
        CREATE TABLE $_settingsTable (
          key TEXT PRIMARY KEY,
          value TEXT NOT NULL
        )
      ''');

      DevLogs.logInfo('Database tables created successfully.');
    } catch (e) {
      DevLogs.logError('Error creating database tables: $e');
    }
  }

  Future<void> _onDatabaseOpen(sqflite.Database db) async {
    final isInitialized = await _isInitialized(db);
    if (!isInitialized) {
      await _populateDefaultModels(db);
    }
  }

  Future<bool> _isInitialized(sqflite.Database db) async {
    try {
      final result = await db.query(
        _settingsTable,
        where: 'key = ?',
        whereArgs: [_initializedFlagKey],
      );
      return result.isNotEmpty && result.first['value'] == 'true';
    } catch (e) {
      return false;
    }
  }

  Future<void> _populateDefaultModels(sqflite.Database db) async {
    try {
      // Begin transaction
      await db.transaction((txn) async {
        // Get default models
        final defaultModels = DefaultModels().models;

        DevLogs.logWarning(defaultModels.toString());

        for (var modelData in defaultModels) {
          final model = AIModel.fromJson(modelData);
          final now = DateTime.now().millisecondsSinceEpoch;

          await txn.insert(
            _tableName,
            {
              'id': model.id,
              'model_data': jsonEncode(model.toJson()),
              'created_at': now,
              'updated_at': now,
            },
            conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
          );
        }

        // Mark as initialized
        await txn.insert(
          _settingsTable,
          {'key': _initializedFlagKey, 'value': 'true'},
          conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
        );
      });
    } catch (e) {
      DevLogs.logError('Error populating default models: $e');
      rethrow;
    }
  }

  Future<void> saveModel(AIModel model) async {
    try {
      final db = _database;
      if (db == null) throw DatabaseException('Database not initialized');

      final now = DateTime.now().millisecondsSinceEpoch;
      await db.insert(
        _tableName,
        {
          'id': model.id,
          'model_data': jsonEncode(model.toJson()),
          'created_at': now,
          'updated_at': now,
        },
        conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
      );
    } catch (e) {
      DevLogs.logError('Error saving model: $e');
      rethrow;
    }
  }

  Future<void> deleteModel(AIModel model) async {
    try {
      final db = _database;
      if (db == null) throw DatabaseException('Database not initialized');

      await db.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [model.id],
      );
    } catch (e) {
      DevLogs.logError('Error deleting model: $e');
      rethrow;
    }
  }

  Future<List<AIModel>> getAllModels() async {
    try {
      final db = _database;
      if (db == null) throw DatabaseException('Database not initialized');

      final tableExists = await doesTableExist(db, _tableName);
      if (!tableExists) throw DatabaseException('Table $_tableName does not exist');

      final maps = await db.query(_tableName);
      return maps.map((map) {
        final modelData = jsonDecode(map['model_data'] as String);
        return AIModel.fromJson(modelData);
      }).toList();
    } catch (e) {
      DevLogs.logError('Error fetching models: $e');
      rethrow; // Optional: rethrow the error if you want it to propagate further
    }
  }

  Future<bool> doesTableExist(sqflite.Database db, String tableName) async {
    final result = await db.rawQuery('SELECT name FROM sqlite_master WHERE type="table" AND name="$tableName"');
    return result.isNotEmpty;
  }

  Future<bool> isModelsInitialized() async {
    final db = _database;
    if (db == null) return false;

    return _isInitialized(db);
  }
}
