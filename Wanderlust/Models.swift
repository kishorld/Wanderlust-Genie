//
//  Models.swift
//  VoiceAssistent
//
//  Created by Kishor L D on 22/02/24.
//
import Foundation

enum VoiceType: String, Codable, Hashable, Sendable, CaseIterable {
    case alloy
    case echo
    case fable
    case onyx
    case nova
    case shimmer
}

enum VoiceChatState: Equatable {
    static func == (lhs: VoiceChatState, rhs: VoiceChatState) -> Bool {
        switch (lhs, rhs) {
              case (.idle, .idle):
                  return true
              case (.recordingSpeech, .recordingSpeech):
                  return true
              case (.processingSpeech, .processingSpeech):
                  return true
              case (.playingSpeech, .playingSpeech):
                  return true
              case let (.error(lhsMessage), .error(rhsMessage)):
                  return true
              default:
                  return false
              }
    }
    
    case idle
    case recordingSpeech
    case processingSpeech
    case playingSpeech
    case error(Error)
}
