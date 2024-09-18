/*
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:github_list_app/screens/home_screen.dart'; // 更新这行
import 'providers/github_users_provider.dart';

// 应用程序的入口点
void main() {
  runApp(const MyApp());
}

// 应用程序的根 Widget
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider 用于在整个应用中共享 GitHubUsersProvider 的状态
    return ChangeNotifierProvider(
      create: (context) => GitHubUsersProvider(),
      child: MaterialApp(
        title: 'GitHub用户列表',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white, // 设置应用的背景色为白色
        ),
        home: const HomeScreen(), // 设置应用的首页为 HomeScreen
      ),
    );
  }
}