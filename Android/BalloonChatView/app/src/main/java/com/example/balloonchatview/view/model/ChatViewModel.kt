package com.example.balloonchatview.model

import androidx.compose.runtime.mutableStateListOf
import androidx.lifecycle.MutableLiveData
import com.example.balloonchatview.view.model.User
import java.util.*

class ChatViewModel {
    var messages = MutableLiveData<MutableList<ChatMessage>>(mutableStateListOf())

    fun append(message: ChatMessage) {
        messages.value?.add(message)
    }
}
