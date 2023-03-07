//
//  ChatMessage.swift
//  BalloonChatView
//
//  Created by yuppe on 2023/01/11.
//

import Foundation

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    
    func append(_ message: ChatMessage) {
        self.messages.append(message)
    }
}

struct ChatMessage: Identifiable {
    var id = UUID()
    var date = Date()
    var from: User
    var to: User
    var text: String
}
