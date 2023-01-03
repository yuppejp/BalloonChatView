//
//  ChatMessage.swift
//  BalloonChatView
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

    func send(_ item: ChatMessageItem) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.items.append(item)
        }
    }
}
