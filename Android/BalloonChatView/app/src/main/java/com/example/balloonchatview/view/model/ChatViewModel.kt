package com.example.balloonchatview.view.model

import androidx.compose.runtime.mutableStateListOf
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.Dp
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.example.balloonchatview.R
import java.util.*

class User(
    var id: UUID = UUID.randomUUID(),
    var userName: String,

    // ChatView appearance
    var icon: Int = 0,
    var showUserName: Boolean = true,
    var showTime: Boolean = true,

    // BalloonText appearance
    var color: Color = Color.Black,
    var backgroundColor: Color = Color.Green,
    var borderColor: Color? = null,
    var borderWidth: Dp? = null,
    var flipUpsideDown: Boolean = false
)

class ChatMessage(
    var id: UUID = UUID.randomUUID(),
    var date: Date = Date(),
    var from: User,
    var to: User,
    var text: String,
    var readCount: Int = 0
)

class ChatViewModel(isPreview: Boolean = false) : ViewModel() {
    var messages = MutableLiveData<MutableList<ChatMessage>>(mutableStateListOf())
    var busy = MutableLiveData(false)
    val me = User(
        userName = "me",
        color = Color.Black,
        backgroundColor = Color(red = 142, green = 227, blue = 134),
        icon = R.drawable.person
    )
    val you = User(
        userName = "you",
        color = Color.Black,
        backgroundColor = Color.White,
        icon = R.drawable.person_circle
    )

    init {
        if (isPreview) {
            // demo data
            append(ChatMessage(from = me, to = you, text = "message1"))
            append(
                ChatMessage(
                    from = me,
                    to = you,
                    text = "message2. Sample text for longer messages. Is it displayed properly?"
                )
            )
            append(ChatMessage(from = you, to = me, text = "message3"))
            append(
                ChatMessage(
                    from = you,
                    to = me,
                    text = "message4. I think it's probably displayed well"
                )
            )
            append(ChatMessage(from = me, to = you, text = "message5"))
        }
    }

    fun append(message: ChatMessage) {
        messages.value?.add(message)
    }

    fun send(text: String) {
        // echo back
        append(ChatMessage(from = me, to = you, text = text))

        // send message
        append(ChatMessage(from = you, to = me, text = text))
    }

    fun clear() {
        messages.value?.clear()
    }
}
