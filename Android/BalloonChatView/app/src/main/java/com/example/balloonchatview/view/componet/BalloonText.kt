package com.example.balloonchatview.view.componet

import android.content.res.Configuration
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.GenericShape
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import com.example.balloonchatview.ui.theme.BalloonChatViewTheme

@Composable
fun BalloonText(
    text: String,
    modifier: Modifier = Modifier,
    isIncoming: Boolean = false,
    color: Color = Color.Black,
    backgroundColor: Color = Color(red = 109, green = 230, blue = 123),
    borderWidth: Dp? = null,
    borderColor: Color? = null
) {
    val cornerRadius = with(LocalDensity.current) { 10.dp.toPx() }
    val tailSize = Size(cornerRadius * 0.8f, cornerRadius * 0.2f)
    val tailWidthDp = with(LocalDensity.current) { tailSize.width.toDp() }
    val balloonShape = BalloonShape(cornerRadius, tailSize, isIncoming)

    val startPadding: Dp
    val endPadding: Dp
    if (isIncoming) {
        startPadding = tailWidthDp + 6.dp
        endPadding = 6.dp
    } else {
        startPadding = 6.dp
        endPadding = tailWidthDp + 6.dp
    }

    var mod = modifier
    if (borderWidth != null && borderColor != null) {
        mod = mod
            .border(BorderStroke(borderWidth, borderColor), shape = balloonShape)
            .background(backgroundColor, shape = balloonShape)
    } else {
        mod = mod.background(backgroundColor, shape = balloonShape)
    }
    mod = mod
        .padding(start = startPadding, end = endPadding)
        .padding(top = 2.dp, bottom = 4.dp)

    Text(text, color = color, modifier = mod)
}

fun BalloonShape(cornerRadius: Float, tailSize: Size, isIncoming: Boolean = false): GenericShape {
    val arcSize = Size(cornerRadius * 2, cornerRadius * 2)

    val outgoingBalloonShape = GenericShape { size, _ ->
        val shapeRect = Rect(Offset(0f, 0f), Size(size.width, size.height))
        var arcRect: Rect
        var x: Float
        var y: Float
        var controlX: Float
        var controlY: Float

        //
        // draw clockwise
        //

        // rounded upper left corner
        x = shapeRect.left
        y = shapeRect.top
        arcRect = Rect(Offset(x, y), arcSize)
        arcTo(
            rect = arcRect,
            startAngleDegrees = 180f,
            sweepAngleDegrees = 90f,
            forceMoveTo = false
        )

        // rounded upper right corner
        x = shapeRect.right - (cornerRadius * 2) - tailSize.width
        y = shapeRect.top
        arcRect = Rect(Offset(x, y), arcSize)
        arcTo(arcRect, 270f, 45f, false)

        // upper tail
        x = shapeRect.right
        y = shapeRect.top
        controlX = shapeRect.right - tailSize.width / 2
        controlY = shapeRect.top
        //lineTo(x, y)
        quadraticBezierTo(controlX, controlY, x, y)

        // lower tail
        x = shapeRect.right - tailSize.width
        y = shapeRect.top + (cornerRadius / 2) + tailSize.height
        controlX = shapeRect.right - tailSize.width / 2
        controlY = shapeRect.top
        //lineTo(x, y)
        quadraticBezierTo(controlX, controlY, x, y)

        // bottom right rounded
        x = shapeRect.right - tailSize.width - cornerRadius * 2
        y = shapeRect.bottom - (cornerRadius * 2)
        arcRect = Rect(Offset(x, y), arcSize)
        arcTo(arcRect, 0f, 90f, false)

        // rounded lower left corner
        x = shapeRect.left
        y = shapeRect.bottom - (cornerRadius * 2)
        arcRect = Rect(Offset(x, y), arcSize)
        arcTo(arcRect, 90f, 90f, false)
    }

    val incomingBalloonShape = GenericShape { size, _ ->
        val shapeRect = Rect(Offset(0f, 0f), Size(size.width, size.height))
        var arcRect: Rect
        var x: Float
        var y: Float
        var controlX: Float
        var controlY: Float

        //
        // draw counterclockwise
        //

        // rounded upper left corner
        x = shapeRect.left + tailSize.width
        y = shapeRect.top
        arcRect = Rect(Offset(x, y), arcSize)
        arcTo(arcRect, 270f, -45f, false)

        // upper tail
        x = shapeRect.left
        y = shapeRect.top
        controlX = shapeRect.left + tailSize.width / 2
        controlY = shapeRect.top
        //lineTo(x, y)
        quadraticBezierTo(controlX, controlY, x, y)

        // lower tail
        x = shapeRect.left + tailSize.width
        y = shapeRect.top + (cornerRadius / 2) + tailSize.height
        controlX = shapeRect.left + tailSize.width / 2
        controlY = shapeRect.top
        //lineTo(x, y)
        quadraticBezierTo(controlX, controlY, x, y)

        // rounded lower left corner
        x = shapeRect.left + tailSize.width
        y = shapeRect.bottom - (cornerRadius * 2)
        arcRect = Rect(Offset(x, y), arcSize)
        arcTo(arcRect, 180f, -90f, false)

        // bottom right rounded
        x = shapeRect.right - cornerRadius
        y = shapeRect.bottom - cornerRadius * 2
        arcRect = Rect(Offset(x - cornerRadius, y), arcSize)
        arcTo(arcRect, 90f, -90f, false)

        // rounded upper right corner
        x = shapeRect.right - cornerRadius * 2
        y = shapeRect.top
        arcRect = Rect(Offset(x, y), arcSize)
        arcTo(arcRect, 0f, -90f, false)
    }

    if (isIncoming) {
        return incomingBalloonShape
    } else {
        return outgoingBalloonShape
    }
}

@Preview(showSystemUi = true, showBackground = true, uiMode = Configuration.UI_MODE_NIGHT_YES)
@Composable
fun BalloonTextPreview() {
    BalloonChatViewTheme {
        Column(
            verticalArrangement = Arrangement.Center,
            horizontalAlignment = Alignment.CenterHorizontally,
        ) {
            BalloonText(
                text = "outgoing message",
                color = Color.Black,
                backgroundColor = Color.Green,
                modifier = Modifier.padding(4.dp)
            )
            BalloonText(
                text = "incoming messages",
                backgroundColor = Color.White,
                borderWidth = 1.dp,
                borderColor = Color.LightGray,
                isIncoming = true,
                modifier = Modifier.padding(4.dp)
            )
        }
    }
}