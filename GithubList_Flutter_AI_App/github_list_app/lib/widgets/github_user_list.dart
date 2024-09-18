/*
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/github_users_provider.dart';
import './user_list_item.dart';

// GithubUserList 是一个有状态的 widget，用于显示 GitHub 用户列表
class GithubUserList extends StatefulWidget {
  const GithubUserList({Key? key}) : super(key: key);

  @override
  _GithubUserListState createState() => _GithubUserListState();
}

class _GithubUserListState extends State<GithubUserList> {
  // 滚动控制器，用于监听列表滚动事件
  final ScrollController _scrollController = ScrollController();
  // 文本编辑控制器，用于管理搜索框的文本
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 在 widget 完成构建后，触发首次数据加载
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GitHubUsersProvider>(context, listen: false).fetchUsers();
    });
    // 添加滚动监听器
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    // 清理资源
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // 滚动监听函数
  void _onScroll() {
    // 当滚动到列表底部时，加载更多数据
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      Provider.of<GitHubUsersProvider>(context, listen: false).fetchUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 搜索框
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search GitHub users',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (value) {
              // 当搜索文本改变时，更新搜索查询
              Provider.of<GitHubUsersProvider>(context, listen: false).setSearchQuery(value);
            },
          ),
        ),
        // 用户列表
        Expanded(
          child: Consumer<GitHubUsersProvider>(
            builder: (context, usersProvider, child) {
              if (usersProvider.users.isEmpty && usersProvider.isLoading) {
                // 显示加载指示器
                return const Center(child: CircularProgressIndicator());
              } else if (usersProvider.users.isEmpty) {
                // 显示无结果提示
                return const Center(child: Text('No users found'));
              } else {
                // 显示用户列表
                return RefreshIndicator(
                  onRefresh: () => usersProvider.fetchUsers(refresh: true),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: usersProvider.users.length,
                    itemBuilder: (context, index) {
                      return UserListItem(user: usersProvider.users[index]);
                    },
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}