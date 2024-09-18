import Foundation

// GitHubUser 类表示一个 GitHub 用户
// 遵循 Identifiable 协议使其可以在 List 中唯一标识
// 遵循 ObservableObject 协议使其可以在视图中被观察
// 遵循 Codable 协议使其可以进行 JSON 编码和解码
class GitHubUser: Identifiable, ObservableObject, Codable {
    // 用户的唯一标识符
    let id: Int
    // 用户的登录名
    let login: String
    // 用户头像的 URL
    let avatarUrl: String
    // 用户 GitHub 主页的 URL
    let htmlUrl: String
    // 用户的搜索得分
    let score: Double
    // 表示当前用户是否被关注，使用 @Published 使其变化可以被观察
    @Published var isFollowed: Bool
    
    // 定义 CodingKeys 枚举来映射 JSON 键到属性
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
        case score
    }
    
    // 初始化方法
    init(id: Int, login: String, avatarUrl: String, htmlUrl: String, score: Double, isFollowed: Bool = false) {
        self.id = id
        self.login = login
        self.avatarUrl = avatarUrl
        self.htmlUrl = htmlUrl
        self.score = score
        self.isFollowed = false
    }
    
    // 实现 Decodable 协议的初始化方法
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // 解码各个属性
        id = try container.decode(Int.self, forKey: .id)
        login = try container.decode(String.self, forKey: .login)
        
        // 解码 avatarUrl，如果失败则设置为空字符串
        do {
            avatarUrl = try container.decode(String.self, forKey: .avatarUrl)
        } catch {
            print("Error decoding avatarUrl: \(error)")
            avatarUrl = ""
        }
        
        // 解码 htmlUrl，如果失败则设置为空字符串
        do {
            htmlUrl = try container.decode(String.self, forKey: .htmlUrl)
        } catch {
            print("Error decoding htmlUrl: \(error)")
            htmlUrl = ""
        }
        
        // 解码 score，如果不存在则默认为 0.0
        score = try container.decodeIfPresent(Double.self, forKey: .score) ?? 0.0
        // 初始化 isFollowed 为 false
        isFollowed = false
        
        // 打印解码后的用户信息，用于调试
        print("Decoded user: id=\(id), login=\(login), avatarUrl=\(avatarUrl), htmlUrl=\(htmlUrl), score=\(score)")
    }
    
    // 实现 Encodable 协议的编码方法
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        // 编码各个属性
        try container.encode(id, forKey: .id)
        try container.encode(login, forKey: .login)
        try container.encode(avatarUrl, forKey: .avatarUrl)
        try container.encode(htmlUrl, forKey: .htmlUrl)
        try container.encode(score, forKey: .score)
        // 注意：isFollowed 属性没有被编码，因为它不是从 API 获取的数据
    }
}
