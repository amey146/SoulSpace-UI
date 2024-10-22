import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:soul/models/chat_session.dart';
import '../models/user_profile.dart';

class HiveService {
  static const String userProfileBoxName = 'userProfile';
  static const String chatSessionBoxName = 'chatSessions';
  static const String authBoxName = 'auth';
  static const String questionnaireBoxName = 'questionnaire';

  static Future<void> init() async {
    final appDocumentDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDirectory.path);
    Hive.registerAdapter(UserProfileAdapter());
    await Hive.openBox<UserProfile>(userProfileBoxName);
    Hive.registerAdapter(ChatSessionAdapter());
    Hive.registerAdapter(ChatMessageAdapter());
    await Hive.openBox(authBoxName);
    await Hive.openBox(questionnaireBoxName);
  }

  static Future<void> saveUserProfile(UserProfile profile) async {
    final box = await Hive.openBox<UserProfile>(userProfileBoxName);
    await box.put('currentUser', profile);
  }

  static Future<UserProfile?> getUserProfile() async {
    final box = await Hive.openBox<UserProfile>(userProfileBoxName);
    return box.get('currentUser');
  }

  static Future<void> updateUserProfile(UserProfile profile) async {
    final box = await Hive.openBox<UserProfile>(userProfileBoxName);
    await box.put('currentUser', profile);
  }

  static Future<void> deleteUserProfile() async {
    final box = await Hive.openBox<UserProfile>(userProfileBoxName);
    await box.delete('currentUser');
  }

  static Future<void> initChatSessions() async {
    await Hive.openBox<ChatSession>(chatSessionBoxName);
  }

  static Future<void> saveChatSession(ChatSession session) async {
    final box = await Hive.openBox<ChatSession>(chatSessionBoxName);
    await box.put(session.id, session);
  }

  static Future<ChatSession?> getChatSession(String id) async {
    final box = await Hive.openBox<ChatSession>(chatSessionBoxName);
    return box.get(id);
  }

  static Future<List<ChatSession>> getRecentChatSessions(
      {int limit = 5}) async {
    final box = await Hive.openBox<ChatSession>(chatSessionBoxName);
    final sessions = box.values.toList();
    sessions.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return sessions.take(limit).toList();
  }

  static Future<void> deleteChatSession(String id) async {
    final box = await Hive.openBox<ChatSession>(chatSessionBoxName);
    await box.delete(id);
  }

// New methods for authentication
  static Future<bool> signUp(String email, String password) async {
    final authBox = await Hive.openBox(authBoxName);
    if (authBox.containsKey(email)) {
      return false; // User already exists
    }
    await authBox.put(email, password);
    return true;
  }

  static Future<bool> login(String email, String password) async {
    final authBox = await Hive.openBox(authBoxName);
    final storedPassword = authBox.get(email);
    return storedPassword == password;
  }

  static Future<void> logout() async {
    final authBox = await Hive.openBox(authBoxName);
    await authBox.put('currentUser', null);
  }

  static Future<bool> isLoggedIn() async {
    final authBox = await Hive.openBox(authBoxName);
    return authBox.get('currentUser') != null;
  }

  static Future<void> setCurrentUser(String email) async {
    final authBox = await Hive.openBox(authBoxName);
    await authBox.put('currentUser', email);
  }

  static Future<String?> getCurrentUser() async {
    final authBox = await Hive.openBox(authBoxName);
    return authBox.get('currentUser');
  }

  static Future<void> saveQuestionnaireResponses(
      Map<String, String> responses) async {
    final box = await Hive.openBox(questionnaireBoxName);
    await box.put('responses', responses);
  }

  static Future<Map<String, String>> getQuestionnaireResponses() async {
    final box = await Hive.openBox(questionnaireBoxName);
    final responses = box.get('responses', defaultValue: <String, String>{});
    return Map<String, String>.from(responses);
  }
}
