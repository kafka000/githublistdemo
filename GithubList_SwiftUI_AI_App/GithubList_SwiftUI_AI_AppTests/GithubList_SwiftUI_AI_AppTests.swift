//
//  GithubList_SwiftUI_AI_AppTests.swift
//  GithubList_SwiftUI_AI_AppTests
//
//  Created by Leo on 2024/9/11.
//

import XCTest
@testable import GithubList_SwiftUI_AI_App

class GithubList_SwiftUI_AI_AppTests: XCTestCase {

    // 声明一个 UserStore 实例，用于测试
    var userStore: UserStore!

    // 在每个测试用例开始前调用，用于设置测试环境
    override func setUpWithError() throws {
        // 初始化 UserStore 实例
        userStore = UserStore()
    }

    // 在每个测试用例结束后调用，用于清理测试环境
    override func tearDownWithError() throws {
        // 清空 UserStore 实例
        userStore = nil
    }

    // 测试 GitHubUser 类的初始化
    func testGitHubUserInitialization() {
        // 创建一个测试用的 GitHubUser 实例
        let user = GitHubUser(id: 1, login: "testuser", avatarUrl: "https://example.com/avatar.jpg", htmlUrl: "https://github.com/testuser", score: 100.0)
        
        // 验证各个属性是否正确初始化
        XCTAssertEqual(user.id, 1)
        XCTAssertEqual(user.login, "testuser")
        XCTAssertEqual(user.avatarUrl, "https://example.com/avatar.jpg")
        XCTAssertEqual(user.htmlUrl, "https://github.com/testuser")
        XCTAssertEqual(user.score, 100.0)
        XCTAssertFalse(user.isFollowed)
    }

    // 测试 UserStore 的 toggleFollow 方法
    func testUserStoreToggleFollow() {
        // 创建一个测试用的 GitHubUser 实例并添加到 UserStore
        let user = GitHubUser(id: 1, login: "testuser", avatarUrl: "https://example.com/avatar.jpg", htmlUrl: "https://github.com/testuser", score: 100.0)
        userStore.users.append(user)

        // 测试关注用户
        userStore.toggleFollow(for: user)
        XCTAssertTrue(userStore.users[0].isFollowed)

        // 测试取消关注用户
        userStore.toggleFollow(for: user)
        XCTAssertFalse(userStore.users[0].isFollowed)
    }

    // 测试 GitHubUser 类的 Codable 协议实现
    func testGitHubUserCodable() throws {
        // 创建一个包含 GitHubUser 信息的 JSON 字符串
        let jsonString = """
        {
            "id": 1,
            "login": "testuser",
            "avatar_url": "https://example.com/avatar.jpg",
            "html_url": "https://github.com/testuser",
            "score": 100.0
        }
        """
        let jsonData = jsonString.data(using: .utf8)!
        
        // 解码 JSON 数据为 GitHubUser 实例
        let decoder = JSONDecoder()
        let user = try decoder.decode(GitHubUser.self, from: jsonData)

        // 验证解码后的属性是否正确
        XCTAssertEqual(user.id, 1)
        XCTAssertEqual(user.login, "testuser")
        XCTAssertEqual(user.avatarUrl, "https://example.com/avatar.jpg")
        XCTAssertEqual(user.htmlUrl, "https://github.com/testuser")
        XCTAssertEqual(user.score, 100.0)
        XCTAssertFalse(user.isFollowed)

        // 测试编码 GitHubUser 实例为 JSON 数据
        let encoder = JSONEncoder()
        let encodedData = try encoder.encode(user)
        let decodedUser = try decoder.decode(GitHubUser.self, from: encodedData)

        // 验证编码后再解码的数据是否与原始数据一致
        XCTAssertEqual(user.id, decodedUser.id)
        XCTAssertEqual(user.login, decodedUser.login)
        XCTAssertEqual(user.avatarUrl, decodedUser.avatarUrl)
        XCTAssertEqual(user.htmlUrl, decodedUser.htmlUrl)
        XCTAssertEqual(user.score, decodedUser.score)
    }

    // 测试 SearchBar 的绑定功能
    func testSearchBarBinding() {
        // 创建一个空的绑定
        let searchText = Binding<String>(get: { "" }, set: { _ in })
        // 使用绑定创建 SearchBar 实例
        let searchBar = SearchBar(text: searchText)

        // 验证 SearchBar 的 body 是否成功创建
        XCTAssertNotNil(searchBar.body)
    }

    // 测试 ContentView 的初始化
    func testContentViewInitialization() {
        // 创建 ContentView 实例
        let contentView = ContentView()

        // 验证 ContentView 的 body 是否成功创建
        XCTAssertNotNil(contentView.body)
        // 验证初始状态是否正确
        XCTAssertEqual(contentView.searchText, "")
        XCTAssertEqual(contentView.page, 1)
        XCTAssertFalse(contentView.isLoading)
    }

    // 测试 UserDetailView 的初始化
    func testUserDetailViewInitialization() {
        // 创建测试用的 GitHubUser 和 UserStore 实例
        let user = GitHubUser(id: 1, login: "testuser", avatarUrl: "https://example.com/avatar.jpg", htmlUrl: "https://github.com/testuser", score: 100.0)
        let userStore = UserStore()
        // 创建 UserDetailView 实例
        let userDetailView = UserDetailView(user: user, userStore: userStore)

        // 验证 UserDetailView 的 body 是否成功创建
        XCTAssertNotNil(userDetailView.body)
    }

    // 模拟网络请求的测试用例
    func testLoadUsers() {
        // 创建一个期望，用于异步测试
        let expectation = XCTestExpectation(description: "Load users")
        
        // 创建 ContentView 实例并调用 loadUsers 方法
        let contentView = ContentView()
        contentView.loadUsers()
        
        // 等待5秒，模拟网络请求的时间
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            // 验证加载状态和用户列表
            XCTAssertFalse(contentView.isLoading)
            XCTAssertFalse(contentView.userStore.users.isEmpty)
            // 标记期望已满足
            expectation.fulfill()
        }
        
        // 等待期望被满足，最多等待10秒
        wait(for: [expectation], timeout: 10)
    }
}
