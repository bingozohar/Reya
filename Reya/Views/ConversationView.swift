//
//  ConversationView.swift
//  Reya
//
//  Created by Romaryc Pelissie on 05/06/2025.
//

import SwiftUI

import MarkdownUI

struct MessageView: View {
    var role: Role
    var content: String
    
    private var color: Color {
        switch role {
        case .user:
            return .mint
        case .assistant:
            return .purple
        default:
            return .gray
        }
    }
    
    private var edge: Edge {
        switch role {
        case .user:
            return .trailing
        default:
            return .leading
        }
    }
    
    var body: some View {
        
        
        HStack(alignment: .center) {
            if (role == .assistant) {
                Spacer()
                Rectangle().fill(
                    Color.mint)
                .frame(width: 2)
            }
            Markdown(content)
                .textSelection(.enabled)
            //.border(width: 2, edges: [edge], color: color)
                .padding(10)
            if (role == .user) {
                Rectangle().fill(
                    Color.purple)
                .frame(width: 2)
                Spacer()
            }
        }
        .padding(5)
    }
}

struct ConversationView: View {
    
    var conversation: Conversation
    var tempResponse: String
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ForEach(conversation.sortedItems) { message in
                    MessageView(role: message.role, content: message.content.isNotEmpty ? message.content : tempResponse)
                        .id(message.id)
                    //Divider()
                }
            }
            /*.onAppear {
             self.scrollProxy = proxy
             }*/
            //TODO: remplacer par une meilleure solution car ne fonctionne pas à 100%
            .defaultScrollAnchor(.bottom)
        }
    }
}
