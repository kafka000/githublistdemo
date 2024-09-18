import SwiftUI

struct SearchBar: View {
    // 使用 @Binding 来创建一个双向绑定，允许父视图访问和修改搜索文本
    @Binding var text: String
    // 使用 @State 来管理搜索栏的编辑状态
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            // 创建一个文本输入框
            TextField("搜索用户...", text: $text)
                // 设置内边距
                .padding(7)
                .padding(.horizontal, 25)
                // 设置背景颜色
                .background(Color(.systemGray6))
                // 设置圆角
                .cornerRadius(8)
                // 添加覆盖层，包含搜索图标和清除按钮
                .overlay(
                    HStack {
                        // 搜索图标
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        // 当处于编辑状态时显示清除按钮
                        if isEditing {
                            Button(action: {
                                // 点击清除按钮时清空搜索文本
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
                // 当点击搜索栏时进入编辑状态
                .onTapGesture {
                    self.isEditing = true
                }
            
            // 当处于编辑状态时显示取消按钮
            if isEditing {
                Button(action: {
                    // 点击取消按钮时退出编辑状态，清空搜索文本，并收起键盘
                    self.isEditing = false
                    self.text = ""
                    // 使用 UIKit 的方法来收起键盘
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("取消")
                }
                .padding(.trailing, 10)
                // 添加过渡动画效果
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}

// 预览提供器，用于在 Xcode 预览中查看 SearchBar 的外观
struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        // 使用常量绑定来预览 SearchBar
        SearchBar(text: .constant(""))
    }
}