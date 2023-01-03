//
//  ContentView.swift
//  BalloonChatView
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        SampleView()
    }
}

struct SampleView: View {
    @StateObject var message1 = ChatMessage()
    @StateObject var message2 = ChatMessage()

    var body: some View {
        let user1 = User(userName: "Alex", iconName: "person.circle")
        let user2 = User(userName: "Taylor", iconName: "person.crop.circle")
        
        VStack {
            Text("Me: " + user1.userName)
                .font(.headline)
            BalloonChatView(me: user1, you: user2, message: message1, onMessageSubmit: { item in
                message2.send(item)
            })
            .background(Color(UIColor(red: 212/255, green: 216/255, blue: 228/255, alpha: 1.0)))
            
            Divider()
            
            Text("You: " + user2.userName)
                .font(.headline)
            BalloonChatView(me: user2, you: user1, message: message2, onMessageSubmit: { item in
                message1.send(item)
            })
            .background(Color(UIColor(red: 212/255, green: 216/255, blue: 228/255, alpha: 1.0)))

            Spacer()
            
            HStack {
                Button("me to you") {
                    let item = ChatMessageItem(from: user1, to: user2, text: "sample message " + generator(30))
                    message1.append(item)
                    message2.send(item)
                }
                Button("you to me") {
                    let item = ChatMessageItem(from: user2, to: user1, text: "sample message " + generator(30))
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
            var item = ChatMessageItem(from: user1, to: user2, text: "sample message1")
            message1.append(item)
            message2.append(item)

            item = ChatMessageItem(from: user1, to: user2, text: "sample message2")
            message1.append(item)
            message2.append(item)

            item = ChatMessageItem(from: user2, to: user1, text: "sample message3")
            message1.append(item)
            message2.append(item)
        }
        .padding()
    }

    private func generator(_ length: Int) -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz0123456789"
        var randomString = ""
        for _ in 0 ..< length {
            randomString += String(letters.randomElement()!)
        }
        return randomString
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
