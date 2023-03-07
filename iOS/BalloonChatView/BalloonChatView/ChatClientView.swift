//
//  ChatClient.swift
//  BalloonChatView
//
//  Created by main on 2023/03/07.
//

import Foundation
import SwiftUI

struct ChatClientView: View {
    @StateObject private var myViewModel = ChatViewModel()
    @StateObject private var yourViewModel = ChatViewModel()
    @State private var inputText1 = ""
    @State private var inputText2 = ""
    private let me = User(userName: "user1", iconName: "person.circle")
    private let you = User(userName: "user2", iconName: "person.circle.fill", backgroundColor: Color(UIColor.systemBackground))

    var body: some View {
        VStack {
            VStack(spacing: 0) {
                Text("Me: " + me.userName)
                    .font(.headline)
                ChatView(me: me, you: you, viewModel: myViewModel)
                HStack {
                    TextField("Input Message...", text: $inputText1)
                        .onSubmit {
                            if !inputText1.isEmpty {
                                let message = ChatMessage(from: me, to: you, text: inputText1)
                                myViewModel.append(message)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // 1 second later
                                    yourViewModel.append(message)
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
            .background(Color(UIColor.lightGray).opacity(0.5))
            .padding()

            VStack(spacing: 0) {
                Text("You: " + you.userName)
                    .font(.headline)
                ChatView(me: you, you: me, viewModel: yourViewModel)
                HStack {
                    TextField("Input Message...", text: $inputText2)
                        .onSubmit {
                            if !inputText2.isEmpty {
                                let message = ChatMessage(from: you, to: me, text: inputText2)
                                yourViewModel.append(message)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // 1 second later
                                    myViewModel.append(message)
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
            .background(Color(UIColor.lightGray).opacity(0.5))
            .padding()

            Spacer()
            
            HStack {
                Button("Me to You") {
                    let message = ChatMessage(from: me, to: you, text: "sample message " + generator(30))
                    myViewModel.append(message)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // 1 second later
                        yourViewModel.append(message)
                    }
                }
                Button("You to Me") {
                    let message = ChatMessage(from: you, to: me, text: "sample message " + generator(30))
                    yourViewModel.append(message)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // 1 second later
                        myViewModel.append(message)
                    }
                }
                Button("Clear") {
                    myViewModel.messages.removeAll()
                    yourViewModel.messages.removeAll()
                }
            }
            .buttonStyle(.bordered)
        }
        .onAppear {
            var item = ChatMessage(from: me, to: you, text: "sample message1")
            myViewModel.append(item)
            yourViewModel.append(item)
            
            item = ChatMessage(from: me, to: you, text: "sample message2")
            myViewModel.append(item)
            yourViewModel.append(item)
            
            item = ChatMessage(from: you, to: me, text: "sample message3")
            myViewModel.append(item)
            yourViewModel.append(item)
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

struct ChatClientView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
