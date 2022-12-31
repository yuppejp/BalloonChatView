//
//  BalloonChatView.swift
//  BalloonChatView
//

import SwiftUI

struct User {
    var userName: String
}

struct ChatMessageItem: Identifiable {
    var id = UUID()
    var date = Date()
    var from: User
    var to: User
    var text: String
}

class ChatMessage: ObservableObject {
    @Published var items: [ChatMessageItem] = []
    
    func send(item: ChatMessageItem) {
        items.append(item)
    }
}


struct BalloonChatView: View {
    let me: User
    let you: User
    @ObservedObject var message: ChatMessage
    @State private var inputText = ""
    @State private var scrollViewContentSize: CGSize = .zero

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { reader in
                VStack {
                    //List { // https://developer.apple.com/forums/thread/712510
                    ScrollView {
                        VStack {
                            ForEach(message.items) { item in
                                MessageItemView(me: me, message: item)
                                    .id(item.id)
                                    .font(.footnote)
                                    //.background(.bar)
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        }
                        .background(
                            // ScrollView shrink to fit
                            // https://developer.apple.com/forums/thread/671690
                            GeometryReader { geometry -> Color in
                                DispatchQueue.main.async {
                                    scrollViewContentSize = geometry.size
                                }
                                return Color.clear
                            }
                        )

                    }
                    .frame(maxHeight: scrollViewContentSize.height)
                    //.background(.bar)
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
                            message.send(item: item)
                            inputText = ""
                        }
                    }
                    .font(.footnote)
                    .keyboardType(.default)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(4)
            }
            //.background(.background)
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
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text(message.from.userName)
                    .font(.caption2)
                    .padding(.leading, 4)
                
                BalloonText(message.text, color: .green, mirrored: true)
                    //.font(.body)
                    .padding(.leading, 8)
            }
            
            VStack() {
                Text(message.date, style: .time)
                    .font(.caption2)
                    .padding(.leading, 4)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
            
            Spacer()
                .frame(maxWidth: .infinity)
        }
    }
}

struct MyMessageItemView: View {
    @State var message: ChatMessageItem
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
                .frame(maxWidth: .infinity)
            
            VStack() {
                Text(message.date, style: .time)
                    .font(.caption2)
                    .padding(.trailing, 4)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
            
            VStack(alignment: .trailing, spacing: 0) {
                Text(message.from.userName)
                    .font(.caption2)
                    .padding(.trailing, 4)
                
                BalloonText(message.text, color: .green, mirrored: false)
                    //.font(.body)
                    .padding(.trailing, 8)
            }
        }
    }
}

//extension Date {
//    func formatTime() -> String {
//        let f = DateFormatter()
//        f.timeStyle = .short
//        f.dateStyle = .none
//        f.locale = Locale(identifier: "ja_JP")
//        let time = f.string(from: self)
//        return time
//    }
//}

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct BalloonChatView_Previews: PreviewProvider {
    static var previews: some View {
        let message = ChatMessage()
        let user1 = User(userName: "user1")
        let user2 = User(userName: "user2")
        
        VStack {
            Text("Me")
            BalloonChatView(me: user1, you: user2, message: message)
                .background(Color.gray)
            
            Divider()
            
            Text("You")
            BalloonChatView(me: user2, you: user1, message: message)
                .background(Color.gray)
            
            Spacer()
            
            HStack {
                Button("me to you") {
                    let item = ChatMessageItem(from: user1, to: user2, text: "demo message " + generator(30))
                    message.send(item: item)
                }
                Button("you to me") {
                    let item = ChatMessageItem(from: user2, to: user1, text: "demo message " + generator(30))
                    message.send(item: item)
                }
                Button("Clear") {
                    message.items.removeAll()
                }
            }
            .buttonStyle(.bordered)
            
        }
        .onAppear {
            message.send(item: ChatMessageItem(from: user1, to: user2, text: "message1"))
            message.send(item: ChatMessageItem(from: user1, to: user2, text: "message2"))
            message.send(item: ChatMessageItem(from: user2, to: user1, text: "message3"))
        }
        .padding()
    }
    
    
    static func generator(_ length: Int) -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz0123456789"
        var randomString = ""
        for _ in 0 ..< length {
            randomString += String(letters.randomElement()!)
        }
        return randomString
    }
}
