package com.example.balloonchatview.view.model

import androidx.compose.ui.graphics.Color
import java.util.*

class User(userName: String, iconName: String = "") {
    val id = UUID.randomUUID()
    val userName: String
    val iconName: String
    var color: Color = Color.Black
    var backgroundColor: Color = Color.Green
    var strokeColor: Color? = null
    //var strokeStyle: StrokeStyle? = null
    var mirrored: Boolean = false
    var flipUpsideDown: Boolean = false
    var showTime: Boolean = true

    init {
        this.userName = userName
        this.iconName = iconName
    }
}