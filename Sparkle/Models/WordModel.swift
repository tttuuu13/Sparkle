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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            self.id = try container.decode(UUID.self, forKey: .id)
        } catch {
            self.id = UUID()
        }
        
        self.word = try container.decode(String.self, forKey: .word)
        self.partOfSpeech = try container.decode(String.self, forKey: .partOfSpeech)
        self.transcription = try container.decode(String.self, forKey: .transcription)
        self.translation = try container.decode(String.self, forKey: .translation)
        self.definition = try container.decode(String.self, forKey: .definition)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case word
        case partOfSpeech
        case transcription
        case translation
        case definition
    }
}