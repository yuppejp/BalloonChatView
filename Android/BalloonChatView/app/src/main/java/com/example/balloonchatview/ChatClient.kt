package com.example.balloonchatview

import androidx.compose.foundation.layout.*
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateListOf
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.example.balloonchatview.ui.theme.BalloonChatViewTheme

class ChatViewModel(preview: Boolean = false) : ViewModel() {
    //    val messages = MutableLiveData<ArrayList<ChatMessage>>()
    val messages = MutableLiveData<MutableList<ChatMessage>>(mutableStateListOf())
    val myName = MutableLiveData("user1")

    init {
        if (preview) {
            sendMessage(ChatMessage("user1", "メッセージ1"))
            sendMessage(ChatMessage("user2", "メッセージ2"))
            sendMessage(ChatMessage("user3", "メッセージ3"))
            sendMessage(ChatMessage(myName.value!!, "返信メッセージ1"))
        }
    }

    fun sendMessage(message: ChatMessage) {
        messages.value?.add(message)
    }
}


@Composable
fun ChatClient(modifier: Modifier = Modifier) {
    val viewModel = ChatViewModel(preview = true)

    Column {
        ChatView(viewModel, modifier)
        Spacer(modifier = Modifier.fillMaxHeight(0.5f))
        ChatView(viewModel, modifier)
    }
}


@Preview(showBackground = true, showSystemUi = true)
@Composable
fun ChatClientPreview() {
    BalloonChatViewTheme {
        ChatClient()
    }
}