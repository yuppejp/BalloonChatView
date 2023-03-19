@file:Suppress("OPT_IN_IS_NOT_ENABLED")

package com.example.balloonchatview.view.componet

import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.MaterialTheme
import androidx.compose.material.Text
import androidx.compose.runtime.*
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.example.balloonchatview.view.model.ChatMessage
import com.example.balloonchatview.view.model.ChatViewModel
import com.example.balloonchatview.view.model.User
import com.example.balloonchatview.ui.theme.BalloonChatViewTheme
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.time.LocalDate
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import java.util.*

@Composable
fun ChatView(viewModel: ChatViewModel, modifier: Modifier = Modifier) {
    val state = rememberLazyListState()
    val messages by viewModel.messages.observeAsState()

    Column(modifier = modifier) {
        LazyColumn(
            modifier = modifier
                .background(Color(red = 211, green = 216, blue = 231))
                .padding(2.dp),
            state
        ) {
            items(messages!!) { message ->
                MessageItemView(viewModel.me, viewModel.you, message)
                Spacer(modifier = Modifier.padding(bottom = 4.dp))
            }

            // scroll to the bottom item
            // ref: https://stackoverflow.com/questions/65065285/jetpack-compose-lazycolumn-programmatically-scroll-to-item
            val count = messages?.count()?.minus(0)
            if (count!! > 0) {
                CoroutineScope(Dispatchers.Main).launch {
                    val index = messages?.count()?.minus(1)
                    state.scrollToItem(index!!, 0)
                }
            }
        }
    }
}

@Composable
fun MessageItemView(me: User, you: User, message: ChatMessage, modifier: Modifier = Modifier) {
    if (message.from.id == me.id) {
        OutgoingMessageItemView(message, modifier)
    } else {
        IncomingMessageItemView(message, modifier)
    }
}

@Composable
fun OutgoingMessageItemView(
    message: ChatMessage,
    modifier: Modifier = Modifier
) {
    Row(modifier = modifier) {
        Spacer(modifier = Modifier.weight(1f))
        Column(
            horizontalAlignment = Alignment.End,
            modifier = Modifier.weight(4f)
        ) {
            Text(
                message.from.userName,
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
                            " read" +
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
                        DateUtil.toShorString(message.date),
                        style = MaterialTheme.typography.caption,
                        //fontSize = 8.sp,
                        modifier = Modifier.align(Alignment.End)
                    )
                }
                BalloonText(
                    message.text,
                    isIncoming = false,
                    color = message.from.color,
                    backgroundColor = message.from.backgroundColor,
                    borderWidth = message.from.borderWidth,
                    borderColor = message.from.borderColor
                )
            }
        }
        if (message.from.icon != 0) {
            Image(
                painter = painterResource(id = message.from.icon),
                contentDescription = "",
                modifier = Modifier
                    .height(40.dp)
                    .padding(start = 2.dp, top = 1.dp)
                    .clip(CircleShape)
            )
        }
    }

}

@Composable
fun IncomingMessageItemView(
    message: ChatMessage,
    modifier: Modifier = Modifier
) {
    Row(modifier = modifier) {
        if (message.from.icon != 0) {
            Image(
                painter = painterResource(id = message.from.icon),
                contentDescription = "",
                modifier = Modifier
                    .height(40.dp)
                    .padding(start = 2.dp, top = 1.dp)
                    .clip(CircleShape)
            )
        }
        Column(
            modifier = Modifier.weight(4f, false)
        ) {
            Text(
                message.from.userName,
                style = MaterialTheme.typography.caption,
                //fontSize = 8.sp
            )
            Row {
                BalloonText(
                    message.text,
                    isIncoming = true,
                    color = message.from.color,
                    backgroundColor = message.from.backgroundColor,
                    borderWidth = message.from.borderWidth,
                    borderColor = message.from.borderColor
                )
                Text(
                    DateUtil.toShorString(message.date),
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

@Preview(showBackground = true)
@Composable
fun ChatViewPreview() {
    BalloonChatViewTheme {
        val viewModel = ChatViewModel(isPreview = true)
        ChatView(viewModel)
    }
}

class DateUtil {
    companion object {
        fun toShorString(date: Date): String {
            val currentDateTime = date.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime()
            val currentDate = currentDateTime.toLocalDate()
            val currentTime = currentDateTime.toLocalTime()
            val formatterDate = DateTimeFormatter.ofPattern("yyyy/MM/dd")
            val formatterTime = DateTimeFormatter.ofPattern("HH:mm") // "HH:mm:ss"

            val result: String
            if (currentDate != LocalDate.now()) {
                result =
                    "${currentDateTime.format(formatterDate)} ${currentTime.format(formatterTime)}"
            } else {
                result = currentTime.format(formatterTime)
            }
            return result
        }
    }
}