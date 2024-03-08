//
//  MessageView.swift
//  VoiceAssistent
//
//  Created by Kishor L D on 23/02/24.
//

import Foundation
import SwiftUI
struct MessageView : View {
    var message: ChatMessage
    
    var body: some View{
        Group{
            if message.isUser {
                HStack {
                   Spacer()
                    Text(message.text)
                        .padding(.horizontal, 10)
                        .padding(.vertical,30)
                        .font(Font.custom("Inter", size: 24))
                        .foregroundColor(.white)
                }
                    .background(Color(red: 0.41, green: 0.41, blue: 0.41).opacity(0.1))
                    .cornerRadius(16)
                    .overlay(
                    RoundedRectangle(cornerRadius: 16)
                    .inset(by: 0.5)
                    .stroke(.white, lineWidth: 1))
                 
            }  else {
                 
                    HStack {
                        Image("chatIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 56, height: 56)
                            .clipShape(Circle())
                        
                        
                        Text(message.text)
                            .padding(.horizontal, 10)
                            .padding(.vertical,30)
                            .font(Font.custom("Inter", size: 24))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .background(Color(red: 0.41, green: 0.27, blue: 0.96).opacity(0.08))
                        .cornerRadius(16)
                        .overlay(
                        RoundedRectangle(cornerRadius: 16)
                        .inset(by: 0.5)
                        .stroke(.white, lineWidth: 1))
                }
            }
        }
    }
    

