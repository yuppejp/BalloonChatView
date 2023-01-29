//
//  ContentView.swift
//  BalloonChatView
//
//  Created by yuppe on 2023/01/11.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            VStack {
                Text("Chat View Smaple")
                    .font(.title)
                SampleView()
            }
        }
    }
}

struct SampleView: View {
    @StateObject var myMessage = ChatMessageHolder()
    @StateObject var yourMessage = ChatMessageHolder()
    @State private var inputText1 = ""
    @State private var inputText2 = ""
    let me = User(userName: "user1", iconName: "person.circle")
    let you = User(userName: "user2", iconName: "person.circle.fill")

    var body: some View {
        VStack {
            VStack(spacing: 0) {
                Text("Me: " + me.userName)
                    .font(.headline)
                ChatView(me: me, you: you, message: myMessage)
                HStack {
                    TextField("Input Message...", text: $inputText1)
                        .onSubmit {
                            if !inputText1.isEmpty {
                                let item = ChatMessageItem(from: me, to: you, text: inputText1)
                                myMessage.append(item)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // 1 second later
                                    yourMessage.append(item)
                                }
                                inputText1 = ""
                            }
                        }
                        .font(.footnote)
                        .keyboardType(.default)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(4)
                }
            }
            .background(Color(UIColor(red: 212/255, green: 216/255, blue: 228/255, alpha: 1.0)))
            .padding()

            VStack(spacing: 0) {
                Text("You: " + you.userName)
                    .font(.headline)
                ChatView(me: you, you: me, message: yourMessage)
                HStack {
                    TextField("Input Message...", text: $inputText2)
                        .onSubmit {
                            if !inputText2.isEmpty {
                                let item = ChatMessageItem(from: me, to: you, text: inputText2)
                                yourMessage.append(item)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // 1 second later
                                    myMessage.append(item)
                                }
                                inputText2 = ""
                            }
                        }
                        .font(.footnote)
                        .keyboardType(.default)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(4)
                }
            }
            .background(Color(UIColor(red: 212/255, green: 216/255, blue: 228/255, alpha: 1.0)))
            .padding()

            Spacer()
            
            HStack {
                Button("Me to You") {
                    let item = ChatMessageItem(from: me, to: you, text: "sample message " + generator(30))
                    myMessage.append(item)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // 1 second later
                        yourMessage.append(item)
                    }
                }
                Button("You to Me") {
                    let item = ChatMessageItem(from: you, to: me, text: "sample message " + generator(30))
                    yourMessage.append(item)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // 1 second later
                        myMessage.append(item)
                    }
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
