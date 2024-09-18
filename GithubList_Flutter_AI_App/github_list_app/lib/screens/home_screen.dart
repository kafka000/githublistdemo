/*
 * @Description: 
 */
/*
 * @Description: 
 */
import 'package:flutter/material.dart';
import '../widgets/github_user_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub Users'),
        backgroundColor: Colors.blue, // 保持 AppBar 颜色为蓝色
      ),
      body: const GithubUserList(),
      backgroundColor: Colors.white, // 将背景色设置为白色
    );
  }
}