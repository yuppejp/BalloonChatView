//
//  BalloonText.swift
//  BalloonChatView
//
//  Created by yuppe on 2023/01/11.
//

import SwiftUI

struct BalloonText: View {
    var text: String
    var fourgroundColor: Color = .primary
    var backgroundColor: Color = Color(UIColor(red: 0x6d/0xff, green: 0xe6/0xff, blue: 0x7b/0xff, alpha: 1.0))
    var strokeColor: Color? = nil
    var strokeStyle: StrokeStyle? = nil
    var flipHorizontal: Bool = false
    var flipUpsideDown: Bool  = false

    var body: some View {
        let cornerRadius = 10.0
        
        Text(text)
            .padding(.leading, 8 + (flipHorizontal ? cornerRadius * 0.6 : 0))
            .padding(.trailing, 8 + (!flipHorizontal ? cornerRadius * 0.6 : 0))
            .padding(.vertical, 8 / 2)
            .foregroundColor(fourgroundColor)
            .background(BalloonShape(
                cornerRadius: cornerRadius,
                backgroundColor: backgroundColor,
                strokeColor: strokeColor,
                strokeStyle: strokeStyle,
                flipHorizontal: flipHorizontal,
                flipUpsideDown: flipUpsideDown)
            )
    }
}

struct BalloonShape: View {
    var cornerRadius: Double
    var backgroundColor: Color
    var strokeColor: Color?
    var strokeStyle: StrokeStyle? = nil
    var flipHorizontal = false
    var flipUpsideDown = false

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let tailSize = CGSize(
                    width: cornerRadius * 0.6,
                    height: cornerRadius * 0.2)
                let shapeRect = CGRect(
                    x: 0,
                    y: 0,
                    width: geometry.size.width,
                    height: geometry.size.height)
                
                //
                // draw clockwise
                //
                
                // rounded upper left corner
                path.addArc(
                    center: CGPoint(
                        x: shapeRect.minX + cornerRadius,
                        y: shapeRect.minY + cornerRadius),
                    radius: cornerRadius,
                    startAngle: Angle(degrees: 180),
                    endAngle: Angle(degrees: 279), clockwise: false)
                
                // rounded upper right corner
                path.addArc(
                    center: CGPoint(
                        x: shapeRect.maxX - cornerRadius - tailSize.width,
                        y: shapeRect.minY + cornerRadius),
                    radius: cornerRadius,
                    startAngle: Angle(degrees: 270),
                    endAngle: Angle(degrees: 270 + 45), clockwise: false)

                // upper tail
                path.addQuadCurve(
                    to: CGPoint(
                        x: shapeRect.maxX,
                        y: shapeRect.minY),
                    control: CGPoint(
                        x: shapeRect.maxX - (tailSize.width / 2),
                        y: shapeRect.minY))

                // lower tail
                path.addQuadCurve(
                    to: CGPoint(
                        x: shapeRect.maxX - tailSize.width,
                        y: shapeRect.minY + (cornerRadius / 2) + tailSize.height),
                    control: CGPoint(
                        x: shapeRect.maxX - (tailSize.width / 2),
                        y: shapeRect.minY))

                // bottom right rounded
                path.addArc(
                    center: CGPoint(
                        x: shapeRect.maxX - cornerRadius - tailSize.width,
                        y: shapeRect.maxY - cornerRadius),
                    radius: cornerRadius,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 90), clockwise: false)

                // rounded lower left corner
                path.addArc(
                    center: CGPoint(
                        x: shapeRect.minX + cornerRadius,
                        y: shapeRect.maxY - cornerRadius),
                    radius: cornerRadius,
                    startAngle: Angle(degrees: 90),
                    endAngle: Angle(degrees: 180), clockwise: false)
                
                path.closeSubpath()
            }
            //.stroke()
            //.fill(self.color)
            .fill(backgroundColor, strokeContent: strokeColor, strokeStyle: strokeStyle)
            .rotation3DEffect(.degrees(flipHorizontal ? 180 : 0), axis: (x: 0, y: 1, z: 0))
            .rotation3DEffect(.degrees(flipUpsideDown ? 180 : 0), axis: (x: 1, y: 0, z: 0))
        }
    }
}

struct BalloonText_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            BalloonText(text: "message1", backgroundColor: .green)
            BalloonText(text: "message2", backgroundColor: .white, strokeColor: .gray, flipHorizontal: true)

            BalloonText(text: "message3", backgroundColor: .green, flipUpsideDown: true)
            BalloonText(text: "message4", backgroundColor: .primary.opacity(0.3), flipHorizontal: true, flipUpsideDown: true)
        }
    }
}

extension Shape {
    public func fill<S:ShapeStyle>(
        _ fillContent: S,
        strokeContent: S?,
        strokeStyle: StrokeStyle?
    ) -> some View {
        ZStack {
            self.fill(fillContent)
            
            if let strokeContent, let strokeStyle {
                self.stroke(strokeContent, style: strokeStyle)
            } else if let strokeContent {
                self.stroke(strokeContent)
            }
        }
    }
}
