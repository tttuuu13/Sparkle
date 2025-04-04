import Foundation

protocol WordsStorageProtocol {
    func getWords() throws -> [WordModel]
    func addWord(_ word: WordModel) throws
    func deleteWord(_ word: WordModel) throws
    func updateWord(_ word: WordModel) throws
}

final class WordsStorage: WordsStorageProtocol {
    static let shared = WordsStorage()
    private let defaults = UserDefaults.standard
    private let wordsKey = "words"

    private init() {}

    func getWords() throws -> [WordModel] {
//        let now = Date()
//        let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: now)!
//        
//        // Create array of dates between threeDaysAgo and now
//        let timeInterval = now.timeIntervalSince(threeDaysAgo)
//        
//        var words = [
//            WordModel(id: UUID(), word: "serendipity", partOfSpeech: "noun", transcription: "/ˌserənˈdɪpɪti/", translation: "счастливая случайность", definition: "The occurrence of finding valuable things not sought for"),
//            WordModel(id: UUID(), word: "ephemeral", partOfSpeech: "adjective", transcription: "/ɪˈfemərəl/", translation: "недолговечный", definition: "Lasting for a very short time"),
//            WordModel(id: UUID(), word: "ubiquitous", partOfSpeech: "adjective", transcription: "/juːˈbɪkwɪtəs/", translation: "вездесущий", definition: "Present, appearing, or found everywhere"),
//            WordModel(id: UUID(), word: "mellifluous", partOfSpeech: "adjective", transcription: "/məˈlɪfluəs/", translation: "сладкозвучный", definition: "Sweet or musical; pleasant to hear"),
//            WordModel(id: UUID(), word: "paradigm", partOfSpeech: "noun", transcription: "/ˈpærəˌdaɪm/", translation: "парадигма", definition: "A typical example or pattern of something"),
//            WordModel(id: UUID(), word: "eloquent", partOfSpeech: "adjective", transcription: "/ˈeləkwənt/", translation: "красноречивый", definition: "Fluent or persuasive in speaking or writing"),
//            WordModel(id: UUID(), word: "resilient", partOfSpeech: "adjective", transcription: "/rɪˈzɪliənt/", translation: "устойчивый", definition: "Able to recover quickly from difficulties"),
//            WordModel(id: UUID(), word: "profound", partOfSpeech: "adjective", transcription: "/prəˈfaʊnd/", translation: "глубокий", definition: "Very great or intense; showing great knowledge or insight"),
//            WordModel(id: UUID(), word: "ethereal", partOfSpeech: "adjective", transcription: "/ɪˈθɪəriəl/", translation: "воздушный", definition: "Extremely delicate and light; heavenly or celestial"),
//            WordModel(id: UUID(), word: "meticulous", partOfSpeech: "adjective", transcription: "/məˈtɪkjʊləs/", translation: "скрупулёзный", definition: "Showing great attention to detail"),
//            WordModel(id: UUID(), word: "ambiguous", partOfSpeech: "adjective", transcription: "/æmˈbɪɡjuəs/", translation: "двусмысленный", definition: "Open to more than one interpretation"),
//            WordModel(id: UUID(), word: "endeavor", partOfSpeech: "verb", transcription: "/ɪnˈdevər/", translation: "стараться", definition: "Try hard to do or achieve something"),
//            WordModel(id: UUID(), word: "quintessential", partOfSpeech: "adjective", transcription: "/ˌkwɪntɪˈsenʃəl/", translation: "типичный", definition: "Representing the most perfect example of a quality"),
//            WordModel(id: UUID(), word: "pragmatic", partOfSpeech: "adjective", transcription: "/præɡˈmætɪk/", translation: "прагматичный", definition: "Dealing with things sensibly and realistically"),
//            WordModel(id: UUID(), word: "arbitrary", partOfSpeech: "adjective", transcription: "/ˈɑːrbɪtreri/", translation: "произвольный", definition: "Based on random choice or personal whim"),
//            WordModel(id: UUID(), word: "eloquence", partOfSpeech: "noun", transcription: "/ˈeləkwəns/", translation: "красноречие", definition: "Fluent or persuasive speaking or writing"),
//            WordModel(id: UUID(), word: "tenacious", partOfSpeech: "adjective", transcription: "/təˈneɪʃəs/", translation: "упорный", definition: "Tending to keep a firm hold of something"),
//            WordModel(id: UUID(), word: "adamant", partOfSpeech: "adjective", transcription: "/ˈædəmənt/", translation: "непреклонный", definition: "Refusing to be persuaded or to change one's mind"),
//            WordModel(id: UUID(), word: "benevolent", partOfSpeech: "adjective", transcription: "/bəˈnevələnt/", translation: "доброжелательный", definition: "Kind and generous"),
//            WordModel(id: UUID(), word: "cacophony", partOfSpeech: "noun", transcription: "/kəˈkɒfəni/", translation: "какофония", definition: "A harsh discordant mixture of sounds"),
//            WordModel(id: UUID(), word: "diligent", partOfSpeech: "adjective", transcription: "/ˈdɪlɪdʒənt/", translation: "усердный", definition: "Having or showing care and conscientiousness"),
//            WordModel(id: UUID(), word: "euphoria", partOfSpeech: "noun", transcription: "/juːˈfɔːriə/", translation: "эйфория", definition: "A feeling or state of intense excitement and happiness"),
//            WordModel(id: UUID(), word: "facade", partOfSpeech: "noun", transcription: "/fəˈsɑːd/", translation: "фасад", definition: "The front of a building or a deceptive outward appearance"),
//            WordModel(id: UUID(), word: "gregarious", partOfSpeech: "adjective", transcription: "/ɡrɪˈɡeəriəs/", translation: "общительный", definition: "Fond of company; sociable"),
//            WordModel(id: UUID(), word: "hierarchy", partOfSpeech: "noun", transcription: "/ˈhaɪərɑːrki/", translation: "иерархия", definition: "A system in which members are ranked according to relative status")
//            ]
//            
//            // Set random addedDate for each word
//            for i in 0..<words.count {
//                let randomTimeInterval = Double.random(in: 0...timeInterval)
//                let randomDate = threeDaysAgo.addingTimeInterval(randomTimeInterval)
//                let randomScore = Double.random(in: 0..<5)
//                words[i].addedDate = randomDate
//                words[i].knowlageLevel = randomScore
//            }
//            
//            return words
        guard let data = defaults.data(forKey: wordsKey) else {
            return []
        }
        return try JSONDecoder().decode([WordModel].self, from: data)
    }

    func addWord(_ word: WordModel) throws {
        var words = try getWords()
        words.append(word)
        try saveWords(words)
    }

    func deleteWord(_ word: WordModel) throws {
        var words = try getWords()
        words.removeAll { $0.id == word.id }
        try saveWords(words)
    }

    func updateWord(_ word: WordModel) throws {
        var words = try getWords()
        if let index = words.firstIndex(where: { $0.id == word.id }) {
            words[index] = word
        }
        try saveWords(words)
    }

    private func saveWords(_ words: [WordModel]) throws {
        let data = try JSONEncoder().encode(words)
        defaults.set(data, forKey: wordsKey)
    }
}
