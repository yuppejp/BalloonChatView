//
//  BalloonChatView.swift
//  BalloonChatView
//

import SwiftUI

struct BalloonChatView: View {
    let me: User
    let you: User
    @ObservedObject var message: ChatMessage
    var onMessageSubmit: (_ item: ChatMessageItem) -> Void = { item in }
    @State private var inputText = ""

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { reader in
                VStack {
                    ScrollView {
                        VStack {
                            ForEach(message.items) { item in
                                MessageItemView(me: me, message: item)
                                    .id(item.id)
                                    .font(.footnote)
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                .padding(4)
                .onAppear {
                    withAnimation() {
                        if let lastItem = message.items.last {
                            reader.scrollTo(lastItem.id, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: message.items.count) { _ in
                    withAnimation() {
                        if let lastItem = message.items.last {
                            reader.scrollTo(lastItem.id, anchor: .bottom)
                        }
                    }
                }
            }
            .onTapGesture {
                UIApplication.shared.closeKeyboard()
            }

            HStack {
                TextField("Input Message...", text: $inputText)
                    .onSubmit {
                        if !inputText.isEmpty {
                            let item = ChatMessageItem(from: me, to: you, text: inputText)
                            message.append(item)
                            inputText = ""
                            onMessageSubmit(item)
                        }
                    }
                    .font(.footnote)
                    .keyboardType(.default)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(4)
            }
        }
        .background(.background.opacity(0.5))
    }
}

struct MessageItemView: View {
    var me: User
    var message: ChatMessageItem
    
    var body: some View {
        if message.from.userName == me.userName {
            MyMessageItemView(message: message)
        } else {
            YourMessageItemView(message: message)
        }
    }
}

struct YourMessageItemView: View {
    var message: ChatMessageItem
    
    var body: some View {
        HStack(spacing: 2) {
            VStack {
                Image(systemName: message.from.iconName)
                    .font(.largeTitle)
                    .foregroundColor(.primary.opacity(0.5))
                Spacer()
            }
            VStack(alignment: .leading, spacing: 0) {
                Text(message.from.userName)
                    .font(.caption2)
                    .padding(.bottom, 4)
                HStack(spacing: 2) {
                    BalloonText(message.text, color: .white, mirrored: true)
                        .font(.body)
                        .foregroundColor(.black)
                    Text(message.date, style: .time)
                        .font(.caption2)
                        .padding(.leading, 4)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                }
            }
            Spacer(minLength: 50)
        }
    }
}

struct MyMessageItemView: View {
    @State var message: ChatMessageItem
    
    var body: some View {
        HStack(spacing: 2) {
            Spacer(minLength: 50)
            VStack(alignment: .trailing, spacing: 0) {
                Text(message.from.userName)
                    .font(.caption2)
                    .padding(.bottom, 4)
                HStack(spacing: 2) {
                    Text(message.date, style: .time)
                        .font(.caption2)
                        .padding(.trailing, 4)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                    BalloonText(message.text, mirrored: false)
                        .font(.body)
                        .foregroundColor(.black)
                }
            }
            VStack {
                Image(systemName: message.from.iconName)
                    .font(.largeTitle)
                    .foregroundColor(.primary.opacity(0.5))
                Spacer()
            }
        }
    }
}

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct BalloonChatView_Previews: PreviewProvider {
    static var previews: some View {
        let message1 = ChatMessage()
        let user1 = User(userName: "user1", iconName: "person.circle")
        let user2 = User(userName: "user2", iconName: "person.crop.circle")

        VStack {
            BalloonChatView(me: user1, you: user2, message: message1, onMessageSubmit: { item in
                print(item.text)
            })
            .background(Color.secondary)
            .padding()
        }
        .onAppear {
            message1.append(ChatMessageItem(from: user1, to: user2, text: "message1"))
            message1.append(ChatMessageItem(from: user1, to: user2, text: "message2"))
            
            message1.append(ChatMessageItem(from: user2, to: user1, text: "message3"))
            message1.append(ChatMessageItem(from: user2, to: user1, text: "message4"))
            
            message1.append(ChatMessageItem(from: user1, to: user2, text: "message5"))
        }
    }
}
