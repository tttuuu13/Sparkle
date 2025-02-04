//
//  TextToSpeechWorker.swift
//  Sparkle
//
//  Created by тимур on 31.01.2025.
//
import AVFoundation

final class TextToSpeechWorker {
    func fetchPronunciation(for text: String, completion: @escaping (Result<URL, Error>) -> Void) {
        // TODO: Add implementation
        completion(.success(URL(string: "https://upload.wikimedia.org/wikipedia/commons/e/ea/En-us-beautiful.ogg")!))
    }
}
