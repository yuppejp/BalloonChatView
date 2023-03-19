package com.example.balloonchatview

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.CircularProgressIndicator
import androidx.compose.material.OutlinedTextField
import androidx.compose.material.Text
import androidx.compose.material.TextButton
import androidx.compose.runtime.*
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.ExperimentalComposeUiApi
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalSoftwareKeyboardController
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.example.balloonchatview.ui.theme.BalloonChatViewTheme
import com.example.balloonchatview.view.componet.ChatView
import com.example.balloonchatview.view.model.ChatViewModel

@OptIn(ExperimentalComposeUiApi::class)
@Composable
fun ChatSampleView(viewModel: ChatViewModel, modifier: Modifier = Modifier) {
    val busy by viewModel.busy.observeAsState()
    var inputText by remember { mutableStateOf("") }
    val keyboardController = LocalSoftwareKeyboardController.current

    Column(modifier = modifier) {
        ChatView(viewModel, modifier = Modifier.weight(1f))

        Row {
            OutlinedTextField(
                value = inputText,
                onValueChange = { inputText = it },
                placeholder = { Text("メッセージを入力してください") },
                keyboardOptions = KeyboardOptions(imeAction = ImeAction.Done),
                keyboardActions = KeyboardActions(onDone = {
                    // close the software keyboard
                    // ref: https://qiita.com/penguinshunya/items/a9986fa2a0663d07e1cc
                    keyboardController?.hide()

                    if (inputText.trim().isNotEmpty()) {
                        viewModel.send(inputText.trim())
                    }
                    inputText = ""
                }),
                modifier = Modifier
                    .padding(6.dp)
                    .weight(1f)
            )

            Box(modifier = Modifier.align(Alignment.CenterVertically)) {
                if (busy!!) {
                    Box(contentAlignment = Alignment.Center) {
                        CircularProgressIndicator(modifier = Modifier.padding(8.dp))
                    }
                } else {
                    TextButton(onClick = {
                        keyboardController?.hide()
                        //viewModel.send(LocalContext.current, inputText.trim())
                        inputText = ""
                    }, enabled = inputText.trim().isNotEmpty()) {
                        Text("送信")
                    }
                }
            }
        }
    }}


@Preview(showBackground = true, showSystemUi = true)
@Composable
fun ChatClientPreview() {
    BalloonChatViewTheme {
        val viewModel = ChatViewModel(isPreview = true)
        ChatSampleView(viewModel)
    }
}