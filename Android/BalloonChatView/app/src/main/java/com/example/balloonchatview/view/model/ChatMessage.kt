package com.example.balloonchatview.view.model

import java.util.*

class ChatMessage(from: User, to: User, text: String) {
    var id = UUID.randomUUID()
    var date = Date()
    var from: User
    var to: User
    var text: String
    var readCount: Int = 1

    init {
        this.from = from
        this.to = to
        this.text = text
    }
}
