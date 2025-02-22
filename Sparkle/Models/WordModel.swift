import Foundation

struct WordModel: Codable {
    let id: UUID
    let word: String
    let partOfSpeech: String
    let transcription: String
    let translation: String
    let definition: String

    var addedDate: Date?
    var lastReviewDate: Date?
    var reviewCount: Int?
    
    init(word: String, partOfSpeech: String, transcription: String, 
         translation: String, definition: String) {
        self.id = UUID()
        self.word = word
        self.partOfSpeech = partOfSpeech
        self.transcription = transcription
        self.translation = translation
        self.definition = definition
    }
}