/*
 * @Description: 
 */
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/github_user.dart';

/// GitHubUsersProvider 类
/// 
/// 这个类负责管理GitHub用户数据,包括获取用户列表、搜索用户和管理用户关注状态。
/// 它使用ChangeNotifier混入,以便在数据变化时通知监听器。
class GitHubUsersProvider with ChangeNotifier {
  final List<GitHubUser> _users = []; // 存储GitHub用户列表
  bool _isLoading = false; // 标记是否正在加载数据
  String _searchQuery = ''; // 当前搜索查询
  int _page = 1; // 当前页码

  /// 获取用户列表
  List<GitHubUser> get users => _users;

  /// 获取加载状态
  bool get isLoading => _isLoading;

  /// 获取GitHub用户数据
  ///
  /// [refresh] 如果为true,则刷新整个列表
  Future<void> fetchUsers({bool refresh = false}) async {
    if (refresh) {
      _page = 1;
      _users.clear();
    }

    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://api.github.com/search/users?q=$_searchQuery&page=$_page'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> items = data['items'];
        
        _users.addAll(items.map((item) => GitHubUser.fromJson(item)));
        _page++;
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('Error fetching users: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 设置搜索查询并刷新用户列表
  ///
  /// [query] 新的搜索查询字符串
  void setSearchQuery(String query) {
    _searchQuery = query;
    fetchUsers(refresh: true);
  }

  /// 切换用户的关注状态
  ///
  /// [userId] 要切换关注状态的用户ID
  void toggleFollowUser(int userId) {
    final userIndex = _users.indexWhere((user) => user.id == userId);
    if (userIndex != -1) {
      _users[userIndex].isFollowed = !(_users[userIndex].isFollowed);
      notifyListeners();
    }
  }
}
