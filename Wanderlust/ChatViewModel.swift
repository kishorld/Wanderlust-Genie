//
//  ChatViewModel.swift
//  Wanderlust
//
//  Created by Arun Kulkarni on 22/02/24.
//

import Foundation
import Observation

enum FlowState {
    case idle
    case intro
    case listening
    case output
}

@Observable
class ChatViewModel {
    var flowState = FlowState.idle
    
    var introText = "How may i help you?"
}
