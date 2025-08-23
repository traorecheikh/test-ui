import 'package:hive_ce/hive.dart';

import '../data/models/contribution.dart';
import '../data/models/tontine.dart';
import '../data/models/user.dart';

class StorageService {
  static const String _userBoxName = 'user_box';
  static const String _tontinesBoxName = 'tontines_box';
  static const String _contributionsBoxName = 'contributions_box';

  static Box<AppUser>? _userBox;
  static Box<Contribution>? _contributionsBox;
  static Box<Tontine>? _tontinesBox;

  /// Initializes Hive boxes for all persisted entities.
  static Future<void> init() async {
    _userBox = await Hive.openBox<AppUser>(_userBoxName);
    _contributionsBox = await Hive.openBox<Contribution>(_contributionsBoxName);
    _tontinesBox = await Hive.openBox<Tontine>(_tontinesBoxName);
  }

  // User management
  /// Persists the current user in Hive.
  static Future<void> saveUser(AppUser user) async {
    if (_userBox == null) {
      print('ERROR: User box is not initialized!');
      return;
    }
    await _userBox?.put('current_user', user);
    print('User saved: ${user.name}');
    print('User box keys after save: \\${_userBox?.keys}');
  }

  /// Retrieves the current user from Hive.
  static AppUser? getCurrentUser() {
    if (_userBox == null) {
      print('ERROR: User box is not initialized!');
      return null;
    }
    final user = _userBox?.get('current_user');
    print('Loaded user from box: \\${user?.name}');
    return user;
  }

  // Tontine management
  /// Persists all tontines in Hive, replacing existing ones.
  static Future<void> saveTontines(List<Tontine> tontines) async {
    await _tontinesBox?.clear();
    for (var t in tontines) {
      await _tontinesBox?.put(t.id, t);
    }
  }

  /// Returns all tontines from Hive.
  static List<Tontine> getTontines() {
    if (_tontinesBox == null) return [];
    return _tontinesBox!.values.toList();
  }

  /// Adds a tontine to Hive.
  static Future<void> addTontine(Tontine tontine) async {
    await _tontinesBox?.put(tontine.id, tontine);
  }

  /// Updates a tontine in Hive.
  static Future<void> updateTontine(Tontine tontine) async {
    await _tontinesBox?.put(tontine.id, tontine);
  }

  /// Deletes a tontine from Hive.
  static Future<void> deleteTontine(String id) async {
    await _tontinesBox?.delete(id);
  }

  // Contributions management
  /// Persists all contributions in Hive, replacing existing ones.
  static Future<void> saveContributions(
    List<Contribution> contributions,
  ) async {
    await _contributionsBox?.clear();
    for (var c in contributions) {
      await _contributionsBox?.put(c.id, c);
    }
  }

  /// Returns all contributions from Hive.
  static List<Contribution> getContributions() {
    if (_contributionsBox == null) return [];
    return _contributionsBox!.values.toList();
  }

  /// Adds a contribution to Hive.
  static Future<void> addContribution(Contribution contribution) async {
    await _contributionsBox?.put(contribution.id, contribution);
  }

  /// Updates a contribution in Hive.
  static Future<void> updateContribution(Contribution contribution) async {
    await _contributionsBox?.put(contribution.id, contribution);
  }

  /// Deletes a contribution from Hive.
  static Future<void> deleteContribution(String id) async {
    await _contributionsBox?.delete(id);
  }

  /// Clears all data from all Hive boxes.
  static Future<void> clearAllData() async {
    await _userBox?.clear();
    await _tontinesBox?.clear();
    await _contributionsBox?.clear();
  }
}
