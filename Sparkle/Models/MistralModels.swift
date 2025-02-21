//
//  MistralTranslationModel.swift
//  Sparkle
//
//  Created by тимур on 28.01.2025.
//
import Foundation

import Foundation

struct MistralResponse: Decodable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [Choice]
}

struct Choice: Decodable {
    let index: Int
    let message: Message
    let finishReason: String
    
    enum CodingKeys: String, CodingKey {
        case index
        case message
        case finishReason = "finish_reason"
    }
}

struct Message: Decodable {
    let role: String
    let toolCalls: String?
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case role
        case toolCalls = "tool_calls"
        case content
    }
}

struct TranslationResponse: Decodable {
    let transcription: String
    let translations: [String]
}

struct DefinitionResponse: Decodable {
    let definitions: [Definition]
}

struct Definition: Decodable {
    let wordClass: String
    let definition: String
}
