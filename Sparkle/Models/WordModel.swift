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
    var lastSuccessfullReviewDate: Date?
    var rightSwipes: Int = 0
    var leftSwipes: Int = 0
    var rightSwipesInRow: Int = 0
    var repetitionStage: Int = 0

    private static let reviewIntervals: [TimeInterval] = [1, 3, 7, 14, 30].map { Double($0 * 86400) }

    var knowledgeLevel: Double {
        let totalSwipes = Double(rightSwipes + leftSwipes)
        let accuracy = totalSwipes > 0 ? Double(rightSwipes) / totalSwipes : 0

        let streakBonus = min(Double(rightSwipesInRow) / 5.0, 1.0)
        let streakMultiplier = 0.8 + 0.2 * streakBonus

        let lastDate = lastSuccessfullReviewDate ?? addedDate ?? Date()
        let timeSinceLastSuccess = Date().timeIntervalSince(lastDate)
        let currentInterval = WordModel.reviewIntervals[min(repetitionStage, WordModel.reviewIntervals.count - 1)]

        let decay = min(timeSinceLastSuccess / currentInterval, 1.0)
        let decayFactor = 1.0 - decay

        let rawScore = accuracy * streakMultiplier * decayFactor
        return min(max(rawScore, 0), 1)
    }

    init(id: UUID,
         word: String, 
         partOfSpeech: String, 
         transcription: String, 
         translation: String, 
         definition: String) {
        
        self.id = id
        self.word = word
        self.partOfSpeech = partOfSpeech
        self.transcription = transcription
        self.translation = translation
        self.definition = definition
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            self.id = try container.decode(UUID.self, forKey: .id)
        } catch {
            self.id = UUID()
        }
        

        self.rightSwipes = try container.decodeIfPresent(Int.self, forKey: .rightSwipes) ?? 0
        self.leftSwipes = try container.decodeIfPresent(Int.self, forKey: .leftSwipes) ?? 0
        self.rightSwipesInRow = try container.decodeIfPresent(Int.self, forKey: .rightSwipesInRow) ?? 0
        self.repetitionStage = try container.decodeIfPresent(Int.self, forKey: .repetitionStage) ?? 0

        self.word = try container.decode(String.self, forKey: .word)
        self.partOfSpeech = try container.decode(String.self, forKey: .partOfSpeech)
        self.transcription = try container.decode(String.self, forKey: .transcription)
        self.translation = try container.decode(String.self, forKey: .translation)
        self.definition = try container.decode(String.self, forKey: .definition)
        self.addedDate = try container.decodeIfPresent(Date.self, forKey: .addedDate)
        self.lastReviewDate = try container.decodeIfPresent(Date.self, forKey: .lastReviewDate)
        self.lastSuccessfullReviewDate = try container.decodeIfPresent(Date.self, forKey: .lastSuccessfullReviewDate)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case word
        case partOfSpeech
        case transcription
        case translation
        case definition
        case addedDate
        case lastReviewDate
        case lastSuccessfullReviewDate
        case rightSwipes
        case leftSwipes
        case rightSwipesInRow
        case repetitionStage
    }
}

extension WordModel {
    static let empty: WordModel = .init(id: UUID(), word: "", partOfSpeech: "", transcription: "", translation: "", definition: "")
}
