//
//  TextToSpeechWorker.swift
//  Sparkle
//
//  Created by тимур on 31.01.2025.
//
import AVFoundation

protocol TextToSpeechWorkerProtocol {
    func playSpeech(for text: String, completion: @escaping (Result<Void, Error>) -> Void)
}

final class ElevenLabsWorker: TextToSpeechWorkerProtocol {
    private let apiKey = "sk_d9f59da2815028c1492414eab11b2bc43b0e1980f6fe60df"
    private var audioPlayer: AVAudioPlayer?

    func playSpeech(for text: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let headers = [
            "xi-api-key": apiKey,
            "Content-Type": "application/json"
        ]

        let parameters: [String: Any] = [
            "text": text,
            "model_id": "eleven_flash_v2",
            "voice_settings": [
                "speed": 0.7
            ]
        ]


        guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to encode JSON"])))
            return
        }

        guard let url = URL(string: "https://api.elevenlabs.io/v1/text-to-speech/JBFqnCBsd6RMkjVDRZzb?output_format=mp3_22050_32") else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No audio data received"])))
                return
            }

            DispatchQueue.main.async {
                do {
                    self?.audioPlayer = try AVAudioPlayer(data: data)
                    self?.audioPlayer?.prepareToPlay()
                    self?.audioPlayer?.play()
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            }
        }

        task.resume()
    }
}

