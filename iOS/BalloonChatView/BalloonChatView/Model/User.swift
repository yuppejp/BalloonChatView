//
//  User.swift
//  BalloonChatView
//
//  Created by yuppe on 2023/01/11.
//

import Foundation
import SwiftUI

struct User {
    var id = UUID()
    var userName: String = ""
    var iconName: String = ""
    
    var foregroundColor: Color = .primary
    var backgroundColor: Color = .green
    var strokeColor: Color? = nil
    var strokeStyle: StrokeStyle? = nil
    var mirrored: Bool = false
    var flipUpsideDown: Bool = false
    var showTime: Bool = true
}
