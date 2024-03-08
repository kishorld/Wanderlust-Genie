//
//  Constants.swift
//  Wanderlust
//
//  Created by Kishor L D on 29/02/24.
//

import Foundation

struct ChatMessage:  Identifiable, Equatable  {
    var id: UUID
    let text: String
    let isUser: Bool
}

struct Constants {
    
    static var botresponse: [ChatMessage] = [
        .init(id: UUID(), text: "Welcome to the Big Apple! What are you interested in? Museums, shopping, or maybe some iconic landmarks?", isUser: false),
        .init(id: UUID(), text: "I suggest starting your day at Times Square since it's bustling with energy. After that, take a ferry to Liberty Island to see the Statue of Liberty up close.", isUser: false),
        .init(id: UUID(), text: "Absolutely! What are you looking for in a hotel?", isUser: false),
        .init(id: UUID(), text: "Sure! Would you like to view them on the map?", isUser: false),
        .init(id: UUID(), text: "Of course! On the map, you can choose the hotel you like and want to explore.", isUser: false),
    ]
    static var messages: [ChatMessage] = [.init(id: UUID(), text: "Hi there! How can I assist you today? ", isUser: false)]
  static var demoResponses : [String] = ["Hi there! I'm so excited to be in New York for the first time! Can you recommend some must-visit places?","Definitely iconic landmarks! Where should I start?","That sounds fantastic! By the way, do you have any recommendations for a good hotel around Times Square?","I want something centrally located with easy access to Times Square and the other attractions in NYC.","Yes, that will be great. Can I also view the hotel rooms?","Thanks a bunch! Let's get started."]
    static var ErrorMessage = "it seems I'm unable to provide information on that specific query. Please feel free to ask another question"
    
//    static var apikey = ProcessInfo.processInfo.environment["Apikey"]
}

struct Config {
    static let apiKey = "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"
}

