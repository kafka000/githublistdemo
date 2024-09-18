import 'package:flutter_test/flutter_test.dart';
import 'package:github_list_app/main.dart';
// 添加下面这行导入语句
import 'package:github_list_app/models/github_user.dart';

void main() {
  test('GitHubUser.fromJson creates a valid user', () {
    final json = {
      'login': 'testuser',
      'avatar_url': 'https://example.com/avatar.jpg',
    };

    final user = GitHubUser.fromJson(json);

    expect(user.login, 'testuser');
    expect(user.avatarUrl, 'https://example.com/avatar.jpg');
  });
}