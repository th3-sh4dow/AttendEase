import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/student_group.dart';


class StorageService {
  static const String _groupsKey = 'student_groups';
  static const String _lastUsedGroupKey = 'last_used_group';

  static Future<List<StudentGroup>> getGroups() async {
    final prefs = await SharedPreferences.getInstance();
    final groupsJson = prefs.getString(_groupsKey);
    
    if (groupsJson == null) return [];
    
    final List<dynamic> groupsList = jsonDecode(groupsJson);
    return groupsList.map((json) => StudentGroup.fromJson(json)).toList();
  }

  static Future<void> saveGroups(List<StudentGroup> groups) async {
    final prefs = await SharedPreferences.getInstance();
    final groupsJson = jsonEncode(groups.map((group) => group.toJson()).toList());
    await prefs.setString(_groupsKey, groupsJson);
  }

  static Future<void> saveGroup(StudentGroup group) async {
    final groups = await getGroups();
    final existingIndex = groups.indexWhere((g) => g.id == group.id);
    
    if (existingIndex != -1) {
      groups[existingIndex] = group;
    } else {
      groups.add(group);
    }
    
    await saveGroups(groups);
  }

  static Future<void> deleteGroup(String groupId) async {
    final groups = await getGroups();
    groups.removeWhere((group) => group.id == groupId);
    await saveGroups(groups);
  }

  static Future<StudentGroup?> getGroup(String groupId) async {
    final groups = await getGroups();
    try {
      return groups.firstWhere((group) => group.id == groupId);
    } catch (e) {
      return null;
    }
  }

  static Future<void> setLastUsedGroup(String groupId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastUsedGroupKey, groupId);
  }

  static Future<String?> getLastUsedGroup() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastUsedGroupKey);
  }

  static String generateGroupId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}