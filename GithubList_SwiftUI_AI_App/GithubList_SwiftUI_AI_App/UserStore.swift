import Foundation

// UserStore 类用于管理 GitHub 用户列表
// 遵循 ObservableObject 协议，使其可以在 SwiftUI 视图中被观察
class UserStore: ObservableObject {
    // 使用 @Published 属性包装器，当 users 数组发生变化时，会自动通知观察者
    @Published var users: [GitHubUser] = []
    
    // 切换用户的关注状态
    func toggleFollow(for user: GitHubUser) {
        // 在 users 数组中查找匹配的用户
        if let index = users.firstIndex(where: { $0.id == user.id }) {
            // 切换找到的用户的 isFollowed 状态
            users[index].isFollowed.toggle()
            // 手动触发 objectWillChange 通知
            // 这是因为 isFollowed 是 GitHubUser 类的 @Published 属性，
            // 而不是 UserStore 的直接属性，所以需要手动通知 UserStore 的观察者
            objectWillChange.send()
        }
    }
}
