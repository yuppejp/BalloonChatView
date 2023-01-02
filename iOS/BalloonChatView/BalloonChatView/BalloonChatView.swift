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
    
    func append(_ item: ChatMessageItem) {
        self.items.append(item)
    }

    func send(_ item: ChatMessageItem) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.items.append(item)
        }
    }
}


struct BalloonChatView: View {
    let me: User
    let you: User
    @ObservedObject var message: ChatMessage
    var onMessage: (_ item: ChatMessageItem) -> Void = { item in }
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
                            onMessage(item)
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
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text(message.from.userName)
                    .font(.caption2)
                    .padding(.leading, 4)
                
                BalloonText(message.text, color: .white, mirrored: true)
                    .font(.body)
                    .foregroundColor(.black)
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
                
                BalloonText(message.text, mirrored: false)
                    .font(.body)
                    .foregroundColor(.black)
                    .padding(.trailing, 8)
            }
        }
    }
}

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct SampleView: View {
    @StateObject var message1 = ChatMessage()
    @StateObject var message2 = ChatMessage()

    var body: some View {
        let user1 = User(userName: "user1")
        let user2 = User(userName: "user2")
        
        VStack {
            Text("Me")
            BalloonChatView(me: user1, you: user2, message: message1, onMessage: { item in
                message2.send(item)
            })
            .background(Color(UIColor(red: 212/255, green: 216/255, blue: 228/255, alpha: 1.0)))
            
            
            Divider()
            
            Text("You")
            BalloonChatView(me: user2, you: user1, message: message2, onMessage: { item in
                message1.send(item)
            })
            .background(Color(UIColor(red: 212/255, green: 216/255, blue: 228/255, alpha: 1.0)))

            Spacer()
            
            HStack {
                Button("me to you") {
                    let item = ChatMessageItem(from: user1, to: user2, text: "demo message " + generator(30))
                    message1.append(item)
                    message2.send(item)
                }
                Button("you to me") {
                    let item = ChatMessageItem(from: user2, to: user1, text: "demo message " + generator(30))
                    message2.append(item)
                    message1.send(item)
                }
                Button("Clear") {
                    message1.items.removeAll()
                    message2.items.removeAll()
                }
            }
            .buttonStyle(.bordered)
            
        }
        .onAppear {
            var item = ChatMessageItem(from: user1, to: user2, text: "message1")
            message1.append(item)
            message2.append(item)

            item = ChatMessageItem(from: user1, to: user2, text: "message2")
            message1.append(item)
            message2.append(item)

            item = ChatMessageItem(from: user2, to: user1, text: "message3")
            message1.append(item)
            message2.append(item)
        }
        .padding()
    }

    func generator(_ length: Int) -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz0123456789"
        var randomString = ""
        for _ in 0 ..< length {
            randomString += String(letters.randomElement()!)
        }
        return randomString
    }
}

struct BalloonChatView_Previews: PreviewProvider {
    static var previews: some View {
        SampleView()
    }
}
