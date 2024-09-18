/*
 * @Description: 
 */
import 'package:flutter/material.dart';
import '../models/github_user.dart';
import '../screens/user_detail_screen.dart';
import '../providers/github_users_provider.dart';
import 'package:provider/provider.dart';

// StatelessWidget 用于不需要管理内部状态的 widget
class UserListItem extends StatelessWidget {
  final GitHubUser user;

  // 构造函数，使用 required 关键字表示 user 参数是必须的
  const UserListItem({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // 左侧显示用户头像
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.avatarUrl),
      ),
      // 标题部分显示用户名和分数
      title: Row(
        children: [
          Expanded(
            child: Text(
              user.login,
              overflow: TextOverflow.ellipsis, // 文本过长时显示省略号
            ),
          ),
          const SizedBox(width: 8),
          Text(
            user.score.toStringAsFixed(2), // 保留两位小数
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
      // 副标题显示用户的 HTML URL
      subtitle: Text(
        user.htmlUrl,
        overflow: TextOverflow.ellipsis,
      ),
      // 右侧显示关注按钮
      trailing: ElevatedButton(
        child: Text(user.isFollowed ? 'FOLLOWED' : 'FOLLOW'),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            user.isFollowed ? Colors.grey : Colors.blue,
          ),
        ),
        onPressed: () {
          // 使用 Provider 来更新用户的关注状态
          Provider.of<GitHubUsersProvider>(context, listen: false).toggleFollowUser(user.id);
        },
      ),
      // 点击整个 ListTile 时导航到用户详情页面
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetailScreen(user: user),
          ),
        );
      },
    );
  }
}