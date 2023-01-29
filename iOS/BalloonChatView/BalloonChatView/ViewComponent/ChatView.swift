//
//  ChatView.swift
//  BalloonChatView
//
//  Created by yuppe on 2023/01/11.
//

import SwiftUI

struct ChatView: View {
    let me: User
    let you: User
    @ObservedObject var message: ChatMessageHolder

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { reader in
                VStack {
                    ScrollView {
                        VStack {
                            ForEach(message.items) { item in
                                MessageItemView(me: me, you: you, message: item)
                                    .id(item.id)
                                    .font(.footnote)
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                .padding(4)
                .onAppear {
                    withAnimation() {
                        if let lastItem = message.items.last {
                            reader.scrollTo(lastItem.id, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: message.items.count) { _ in
                    withAnimation() {
                        if let lastItem = message.items.last {
                            reader.scrollTo(lastItem.id, anchor: .bottom)
                        }
                    }
                }
            }
        }
    }
}

struct MessageItemView: View {
    var me: User
    var you: User
    var message: ChatMessageItem
    
    var body: some View {
        if message.from.id == me.id {
            MyMessageItemView(
                message: message,
                fourgroundColor: me.foregroundColor,
                backgroundColor: me.backgroundColor,
                strokeColor: me.strokeColor,
                strokeStyle: me.strokeStyle,
                flipUpsideDown: me.flipUpsideDown,
                showTime: me.showTime)
        } else {
            YourMessageItemView(
                message: message,
                fourgroundColor: you.foregroundColor,
                backgroundColor: you.backgroundColor,
                strokeColor: you.strokeColor,
                strokeStyle: you.strokeStyle,
                flipUpsideDown: you.flipUpsideDown,
                showTime: you.showTime)
        }
    }
}

struct MyMessageItemView: View {
    @State var message: ChatMessageItem
    var fourgroundColor: Color = .primary
    var backgroundColor: Color = .green
    var strokeColor: Color? = nil
    var strokeStyle: StrokeStyle? = nil
    var flipUpsideDown = false
    var showTime = true

    var body: some View {
        HStack(spacing: 2) {
            Spacer(minLength: 50)
            VStack(alignment: .trailing, spacing: 0) {
                if flipUpsideDown {
                    Spacer()
                } else {
                    if !message.from.userName.isEmpty {
                        Text(message.from.userName)
                            .font(.caption2)
                            .padding(.bottom, 4)
                    }
                }
                HStack(spacing: 2) {
                    if showTime {
                        Text(message.date, style: .time)
                            .font(.caption2)
                            .padding(.trailing, 4)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                    BalloonText(text: message.text,
                                fourgroundColor: fourgroundColor,
                                backgroundColor: backgroundColor,
                                strokeColor: strokeColor,
                                strokeStyle: strokeStyle,
                                flipHorizontal: false,
                                flipUpsideDown: flipUpsideDown)
                        .font(.body)
                }
                if flipUpsideDown {
                    if !message.from.userName.isEmpty {
                        Text(message.from.userName)
                            .font(.caption2)
                            .padding(.bottom, 4)
                    }
                } else  {
                    Spacer()
                }
            }
            if !message.from.iconName.isEmpty {
                VStack {
                    if flipUpsideDown {
                        Spacer()
                    }
                    Image(systemName: message.from.iconName)
                        .resizable()
                        .frame(width: 30, height: 30)
                        //.clipShape(Circle())
                        .offset(y: flipUpsideDown ? 4 : 0)
                    if !flipUpsideDown {
                        Spacer()
                    }
                }
            }
        }
    }
}

struct YourMessageItemView: View {
    var message: ChatMessageItem
    var fourgroundColor: Color = .primary
    var backgroundColor: Color = .white
    var strokeColor: Color? = .gray
    var strokeStyle: StrokeStyle? = nil
    var flipUpsideDown = false
    var showTime = true
    
    var body: some View {
        HStack(spacing: 2) {
            if !message.from.iconName.isEmpty {
                VStack {
                    if flipUpsideDown {
                        Spacer()
                    }
                    Image(systemName: message.from.iconName)
                        .resizable()
                        .frame(width: 30, height: 30)
                        //.clipShape(Circle())
                    if !flipUpsideDown {
                        Spacer()
                    }
                }
                .offset(y: flipUpsideDown ? 4 : 0)
            }
            VStack(alignment: .leading, spacing: 0) {
                if flipUpsideDown {
                    Spacer()
                } else {
                    if !message.from.userName.isEmpty {
                        Text(message.from.userName)
                            .font(.caption2)
                            .padding(.bottom, 4)
                    }
                }
                HStack(spacing: 2) {
                    BalloonText(text: message.text,
                                fourgroundColor: fourgroundColor,
                                backgroundColor: backgroundColor,
                                strokeColor: strokeColor,
                                strokeStyle: strokeStyle,
                                flipHorizontal: true,
                                flipUpsideDown: flipUpsideDown)
                        .font(.body)
                    if showTime {
                        Text(message.date, style: .time)
                            .font(.caption2)
                            .padding(.leading, 4)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                }
                if flipUpsideDown {
                    if !message.from.userName.isEmpty {
                        Text(message.from.userName)
                            .font(.caption2)
                            .padding(.bottom, 4)
                    }
                } else {
                    Spacer()
                }
            }
            Spacer(minLength: 50)
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        let model = ChatMessageHolder()
        let user1 = User(userName: "me", iconName: "person.circle")
        let user2 = User(userName: "you", iconName: "person.circle")

        VStack {
            ChatView(me: user1, you: user2, message: model)
        }
        .onAppear {
            model.append(ChatMessageItem(from: user1, to: user2, text: "message1"))
            model.append(ChatMessageItem(from: user1, to: user2, text: "message2. Sample text for longer messages. Is it displayed properly?"))
            
            model.append(ChatMessageItem(from: user2, to: user1, text: "message3"))
            model.append(ChatMessageItem(from: user2, to: user1, text: "message4. I think it's probably displayed well"))
            
            model.append(ChatMessageItem(from: user1, to: user2, text: "message5"))
        }
    }
}
