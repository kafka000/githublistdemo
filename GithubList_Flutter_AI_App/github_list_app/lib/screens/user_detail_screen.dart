/*
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/github_user.dart';
import '../providers/github_users_provider.dart';

// StatefulWidget 用于需要管理内部状态的 widget
class UserDetailScreen extends StatefulWidget {
  final GitHubUser user; // 用户对象

  // 构造函数，使用 required 关键字表示 user 参数是必须的
  const UserDetailScreen({Key? key, required this.user}) : super(key: key);

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  List<dynamic> _repositories = []; // 存储用户的仓库列表
  bool _isLoading = true; // 控制加载状态

  @override
  void initState() {
    super.initState();
    _fetchRepositories(); // 在 widget 初始化时获取用户仓库
  }

  // 异步方法，用于从 GitHub API 获取用户仓库
  Future<void> _fetchRepositories() async {
    final response = await http.get(Uri.parse('https://api.github.com/users/${widget.user.login}/repos'));
    if (response.statusCode == 200) {
      setState(() {
        _repositories = json.decode(response.body); // 解析 JSON 响应
        _isLoading = false; // 更新加载状态
      });
    } else {
      throw Exception('Failed to load repositories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.login), // 显示用户登录名作为标题
      ),
      body: Column(
        children: [
          // 用户信息部分
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 用户头像
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.user.avatarUrl),
                  radius: 30,
                ),
                const SizedBox(width: 16),
                // 用户名和 URL
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.user.login, style: Theme.of(context).textTheme.titleLarge),
                      Text(widget.user.htmlUrl),
                    ],
                  ),
                ),
                // 关注按钮
                Consumer<GitHubUsersProvider>(
                  builder: (context, provider, child) {
                    return ElevatedButton(
                      child: Text(widget.user.isFollowed ? 'FOLLOWED' : 'FOLLOW'),
                      onPressed: () {
                        provider.toggleFollowUser(widget.user.id);
                        setState(() {
                          widget.user.isFollowed = !widget.user.isFollowed;
                        });
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          // 仓库列表部分
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator()) // 显示加载指示器
                : ListView.builder(
                    itemCount: _repositories.length,
                    itemBuilder: (context, index) {
                      final repo = _repositories[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(repo['owner']['avatar_url']),
                        ),
                        title: Text(repo['name']),
                        subtitle: Text(repo['html_url']),
                        trailing: Text('★ ${repo['stargazers_count']}'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}