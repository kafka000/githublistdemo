import SwiftUI

struct UserDetailView: View {
    // @ObservedObject 用于观察外部传入的对象，当对象发生变化时更新视图
    @ObservedObject var user: GitHubUser
    @ObservedObject var userStore: UserStore
    
    // @State 用于管理视图内部的状态
    @State private var repositories: [Repository] = []
    @State private var isLoading = false
    
    var body: some View {
        // List 创建一个可滚动的列表视图
        List {
            // 用户信息部分
            Section {
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
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    
                    // 显示用户信息
                    VStack(alignment: .leading) {
                        Text(user.login)
                            .font(.title2)
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
            
            // 仓库列表部分
            Section("仓库") {
                if isLoading {
                    ProgressView()
                } else if repositories.isEmpty {
                    Text("没有找到仓库")
                } else {
                    ForEach(repositories) { repo in
                        RepositoryRow(repository: repo)
                    }
                }
            }
        }
        .navigationTitle(user.login)
        // 当视图出现时加载仓库数据
        .onAppear {
            loadRepositories()
        }
    }
    
    // 加载用户仓库的函数
    private func loadRepositories() {
        isLoading = true
        
        // 构建 API URL
        guard let url = URL(string: "https://api.github.com/users/\(user.login)/repos") else {
            print("Invalid URL")
            isLoading = false
            return
        }
        
        // 创建网络请求
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        
        // 执行网络请求
        URLSession.shared.dataTask(with: request) { data, response, error in
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
                    let decodedRepos = try decoder.decode([Repository].self, from: data)
                    self.repositories = decodedRepos
                } catch {
                    print("Decoding error: \(error)")
                }
            }
        }.resume()
    }
}

// 仓库行视图
struct RepositoryRow: View {
    let repository: Repository
    
    var body: some View {
        HStack {
            // 异步加载仓库所有者头像
            AsyncImage(url: URL(string: repository.owner.avatarUrl ?? "")) { phase in
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
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            
            // 显示仓库信息
            VStack(alignment: .leading) {
                HStack {
                    Text(repository.name)
                        .lineLimit(1)
                    Spacer()
                    Text("\(repository.stargazersCount)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Text(repository.htmlUrl)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// 仓库模型
struct Repository: Identifiable, Decodable {
    let id: Int
    let name: String
    let htmlUrl: String
    let stargazersCount: Int
    let owner: RepositoryOwner
    
    // CodingKeys 用于自定义 JSON 键和 Swift 属性之间的映射
    enum CodingKeys: String, CodingKey {
        case id, name
        case htmlUrl = "html_url"
        case stargazersCount = "stargazers_count"
        case owner
    }
}

// 仓库所有者模型
struct RepositoryOwner: Decodable {
    let avatarUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
    }
}
