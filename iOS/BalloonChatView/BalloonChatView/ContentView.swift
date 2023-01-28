//
//  ContentView.swift
//  BalloonChatView
//
//  Created by yuppe on 2023/01/11.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        SampleView()
    }
}

struct SampleView: View {
    @StateObject var myMessage = ChatMessage()
    @StateObject var yourMessage = ChatMessage()
    let me = User(userName: "Me", iconName: "person.circle")
    let you = User(userName: "You", iconName: "person.crop.circle")

    var body: some View {
        
        VStack {
            Text("Me: " + me.userName)
                .font(.headline)
            ChatView(me: me, you: you, message: myMessage)
                .background(Color(UIColor(red: 212/255, green: 216/255, blue: 228/255, alpha: 1.0)))
            
            Divider()
            
            Text("You: " + you.userName)
                .font(.headline)
            ChatView(me: you, you: me, message: yourMessage)
                .background(Color(UIColor(red: 212/255, green: 216/255, blue: 228/255, alpha: 1.0)))
            
            Spacer()
            
            HStack {
                Button("me to you") {
                    let item = ChatMessageItem(from: me, to: you, text: "sample message " + generator(30))
                    myMessage.append(item)
                    yourMessage.append(item)
                }
                Button("you to me") {
                    let item = ChatMessageItem(from: you, to: me, text: "sample message " + generator(30))
                    yourMessage.append(item)
                    myMessage.append(item)
                }
                Button("Clear") {
                    myMessage.items.removeAll()
                    yourMessage.items.removeAll()
                }
            }
            .buttonStyle(.bordered)
            
        }
        .onAppear {
            var item = ChatMessageItem(from: me, to: you, text: "sample message1")
            myMessage.append(item)
            yourMessage.append(item)
            
            item = ChatMessageItem(from: me, to: you, text: "sample message2")
            myMessage.append(item)
            yourMessage.append(item)
            
            item = ChatMessageItem(from: you, to: me, text: "sample message3")
            myMessage.append(item)
            yourMessage.append(item)
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
