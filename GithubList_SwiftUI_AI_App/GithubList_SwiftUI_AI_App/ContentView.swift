//
//  ContentView.swift
//  GithubList_SwiftUI_AI_App
//
//  Created by Leo on 2024/9/11.
//

import SwiftUI

struct ContentView: View {
    // @StateObject 用于创建和管理一个引用类型的对象，确保其在视图的生命周期内保持存在
    @StateObject private var userStore = UserStore()
    
    // @State 用于在视图中创建可变状态，当这些值改变时，视图会自动更新
    @State private var searchText = ""
    @State private var page = 1
    @State private var isLoading = false
    
    var body: some View {
        // NavigationView 创建一个导航界面，允许在视图之间进行导航
        NavigationView {
            // List 创建一个可滚动的列表视图
            List {
                // 自定义搜索栏组件
                SearchBar(text: $searchText)
                    // onChange 监听搜索文本的变化，并触发新的搜索
                    .onChange(of: searchText) { _ in
                        page = 1
                        userStore.users.removeAll()
                        loadUsers()
                    }
                
                // 显示加载的用户数量
                Text("Loaded \(userStore.users.count) users")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                // 遍历并显示所有用户
                ForEach(userStore.users) { user in
                    // NavigationLink 创建一个可以导航到用户详情页的链接
                    NavigationLink(destination: UserDetailView(user: user, userStore: userStore)) {
                        UserRow(user: user, userStore: userStore)
                    }
                }
                
                // 当列表不为空时，在底部显示一个加载指示器，���于触发加载更多用户
                if !userStore.users.isEmpty {
                    ProgressView()
                        .onAppear {
                            loadUsers()
                        }
                }
            }
            .navigationTitle("GitHub Users")
            // 当视图首次出现时，如果用户列表为空，则加载用户
            .onAppear {
                if userStore.users.isEmpty {
                    loadUsers()
                }
            }
        }
    }
    
    // 加载用户的函数
    func loadUsers() {
        // 防止重复加载
        guard !isLoading else { return }
        isLoading = true
        
        // 如果搜索文本为空，则默认搜索 "swift"
        let query = searchText.isEmpty ? "swift" : searchText
        
        // 构建 URL 组件
        guard var urlComponents = URLComponents(string: "https://api.github.com/search/users") else {
            print("Invalid URL")
            isLoading = false
            return
        }
        
        // 添加查询参数
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: "30")
        ]
        
        // 创建最终的 URL
        guard let url = urlComponents.url else {
            print("Failed to create URL")
            isLoading = false
            return
        }
        
        // 创建网络请求
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        
        // 执行网络请求
        URLSession.shared.dataTask(with: request) { data, response, error in
            // 确保 UI 更新在主线程进行
            DispatchQueue.main.async {
                self.isLoading = false
                
                // 错误处理
                if let error = error {
                    print("Network error: \(error.localizedDescription)")
                    return
                }
                
                // 检查 HTTP 响应状态码
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    print("Invalid response")
                    return
                }
                
                // 确保收到数据
                guard let data = data, !data.isEmpty else {
                    print("No data received")
                    return
                }
                
                // 解码 JSON 数据
                do {
                    let decoder = JSONDecoder()
                    let searchResult = try decoder.decode(SearchResult.self, from: data)
                    self.userStore.users.append(contentsOf: searchResult.items)
                    self.page += 1
                    print("Loaded \(searchResult.items.count) users")
                } catch {
                    print("Decoding error: \(error)")
                    if let decodingError = error as? DecodingError {
                        switch decodingError {
                        case .keyNotFound(let key, let context):
                            print("Key '\(key)' not found: \(context.debugDescription)")
                            print("codingPath:", context.codingPath)
                        case .valueNotFound(let value, let context):
                            print("Value '\(value)' not found: \(context.debugDescription)")
                            print("codingPath:", context.codingPath)
                        case .typeMismatch(let type, let context):
                            print("Type '\(type)' mismatch: \(context.debugDescription)")
                            print("codingPath:", context.codingPath)
                        case .dataCorrupted(let context):
                            print("Data corrupted: \(context.debugDescription)")
                            print("codingPath:", context.codingPath)
                        @unknown default:
                            print("Unknown decoding error")
                        }
                    }
                }
            }
        }.resume()
    }
}

// 用户行视图
struct UserRow: View {
    @ObservedObject var user: GitHubUser
    @ObservedObject var userStore: UserStore
    
    var body: some View {
        HStack {
            // 异步加载用户头像
            AsyncImage(url: URL(string: user.avatarUrl)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure(_):
                    Image(systemName: "person.circle.fill")
                        .resizable()
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            
            // 显示用户信息
            VStack(alignment: .leading) {
                Text(user.login)
                    .lineLimit(1)
                Text(user.htmlUrl)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // 关注/取消关注按钮
            Button(action: {
                userStore.toggleFollow(for: user)
            }) {
                Text(user.isFollowed ? "已关注" : "关注")
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

// 搜索结果结构体，用于解码 JSON 数据
struct SearchResult: Codable {
    let items: [GitHubUser]
}

// 预览提供器
#Preview {
    ContentView()
}
