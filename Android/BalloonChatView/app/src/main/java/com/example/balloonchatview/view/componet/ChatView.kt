@file:Suppress("OPT_IN_IS_NOT_ENABLED")

package com.example.balloonchatview.view.componet

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.material.MaterialTheme
import androidx.compose.material.Text
import androidx.compose.runtime.*
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.example.balloonchatview.BalloonText
import com.example.balloonchatview.model.ChatViewModel
import com.example.balloonchatview.ui.theme.BalloonChatViewTheme
import com.example.balloonchatview.view.model.ChatMessage
import com.example.balloonchatview.view.model.User
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.util.*

//class ChatMessage(userName: String, text: String) {
//    var userName: String
//    var text: String
//    var date: String
//
//    init {
//        this.userName = userName
//        this.text = text
//        this.date = SimpleDateFormat("HH:mm").format(Date())
//    }
//}

@Composable
fun ChatView(me: User, you: User, viewModel: ChatViewModel, modifier: Modifier = Modifier) {
    val state = rememberLazyListState()
    val messages = viewModel.messages.observeAsState()

    Column(modifier = modifier) {
        LazyColumn(
            modifier = modifier
                .background(Color(red = 211, green = 216, blue = 231))
                .padding(2.dp),
            state
        ) {
            if (viewModel.messages.value?.count()!! >= 0) {
                items(messages.value!!) { message ->
                    MessageItemView(me, you, message)
                    Spacer(modifier = Modifier.padding(bottom = 4.dp))
                }

                // 末尾へスクロール
                // ref: https://stackoverflow.com/questions/65065285/jetpack-compose-lazycolumn-programmatically-scroll-to-item
                CoroutineScope(Dispatchers.Main).launch {
                    state.scrollToItem(messages.value?.count()!! - 1, 0)
                }
            }
        }
    }
}

@Composable
fun MessageItemView(me: User, you: User, message: ChatMessage, modifier: Modifier = Modifier) {
    if (message.from.id != me.id) {
        Row(modifier = modifier) {
            Spacer(modifier = Modifier.weight(1f))
            Column(
                horizontalAlignment = Alignment.End,
                modifier = Modifier.weight(4f)
            ) {
                Text(
                    me.userName,
                    style = MaterialTheme.typography.caption,
                    //fontSize = 8.sp,
                    textAlign = TextAlign.End,
                    //modifier = Modifier.fillMaxWidth()
                )
                Row {
                    Column(
                        modifier = Modifier
                            .align(Alignment.Bottom)
                            .padding(end = 2.dp)
                    ) {
                        if (message.readCount > 0) {
                            Text(
                                " 既読" +
                                        if (message.readCount >= 2) {
                                            " ${message.readCount}"
                                        } else {
                                            ""
                                        },
                                style = MaterialTheme.typography.caption,
                                //fontSize = 8.sp,
                                modifier = Modifier.align(Alignment.End)
                            )
                        }
                        Text(
                            message.date.toString(),
                            style = MaterialTheme.typography.caption,
                            //fontSize = 8.sp,
                            modifier = Modifier.align(Alignment.End)
                        )
                    }
                    BalloonText(message.text)
                }
            }
//            Image(
//                painter = painterResource(id = message.user.icon),
//                contentDescription = "",
//                modifier = Modifier
//                    .height(40.dp)
//                    .padding(start = 2.dp, top = 1.dp)
//                    .clip(CircleShape)
//            )
        }

    } else {
        Row(modifier = modifier) {
//            Image(
//                painter = painterResource(id = message.user.icon),
//                contentDescription = "",
//                modifier = Modifier
//                    .height(40.dp)
//                    .padding(start = 2.dp, top = 1.dp)
//                    .clip(CircleShape)
//            )
            Column(
                modifier = Modifier.weight(4f, false)
            ) {
                Text(
                    you.userName,
                    style = MaterialTheme.typography.caption,
                    //fontSize = 8.sp
                )
                Row {
                    BalloonText(message.text, isIncoming = true)
                    Text(
                        message.date.toString(),
                        style = MaterialTheme.typography.caption,
                        //fontSize = 8.sp,
                        modifier = Modifier
                            .align(Alignment.Bottom)
                            .padding(start = 1.dp)
                    )
                }
            }
            Spacer(modifier = Modifier.weight(1f))
        }
    }
}

@Preview(showBackground = true)
@Composable
fun ChatViewPreview() {
    BalloonChatViewTheme {
        val viewModel = ChatViewModel(/*preview = true*/)
        val user1 = User(userName = "me", iconName = "person.circle")
        val user2 = User(userName = "you", iconName = "person.circle")

        viewModel.messages.value?.add(ChatMessage(from = user1, to = user2, text = "message1"))
        viewModel.messages.value?.add(ChatMessage(from = user1, to = user2, text = "message2. Sample text for longer messages. Is it displayed properly?"))

        viewModel.messages.value?.add(ChatMessage(from = user2, to = user1, text = "message3"))
        viewModel.messages.value?.add(ChatMessage(from = user2, to = user1, text = "message4. I think it's probably displayed well"))

        viewModel.messages.value?.add(ChatMessage(from = user1, to = user2, text = "message5"))

        ChatView(me = user1, you = user2, viewModel)
    }
}