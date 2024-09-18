/*
 * @Description: 
 */
class GitHubUser {
  final int id;
  final String login;
  final String avatarUrl;
  final String htmlUrl;
  final double score;
  bool isFollowed;  // 改回非空类型

  GitHubUser({
    required this.id,
    required this.login,
    required this.avatarUrl,
    required this.htmlUrl,  // 添加这行
    required this.score,
    this.isFollowed = false,  // 保持默认值为 false
  });

  factory GitHubUser.fromJson(Map<String, dynamic> json) {
    return GitHubUser(
      id: json['id'],
      login: json['login'],
      avatarUrl: json['avatar_url'],
      htmlUrl: json['html_url'],
      score: (json['score'] as num).toDouble(),
      isFollowed: false,  // 确保这里始终设置为 false
    );
  }
}