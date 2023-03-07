//
//  ContentView.swift
//  BalloonChatView
//
//  Created by yuppe on 2023/01/11.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            VStack {
                Text("Chat View Smaple")
                    .font(.title)
                ChatClientView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
