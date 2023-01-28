//
//  ChatMessage.swift
//  BalloonChatView
//
//  Created by yuppe on 2023/01/11.
//

import Foundation

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
}
