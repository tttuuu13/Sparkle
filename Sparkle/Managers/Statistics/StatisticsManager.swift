//
//  StatisticsManager.swift
//  Sparkle
//
//  Created by тимур on 12.03.2025.
//

import Foundation

final class StatisticsManager {
    //MARK: - Enum
    enum Keys: String {
        case streak = "streak"
        case maxStreak = "maxStreak"
        case activeDays = "activeDays"
    }
    
    // MARK: - Properties
    private let wordsStorage = WordsStorage.shared
    private let defaults = UserDefaults.standard
    
    // MARK: - Public Methods
    func getWordsReviewedCount(days: Int) -> [Int] {
        var wordsReviewedCount = Array(repeating: 0, count: days)
        guard let words = try? wordsStorage.getWords() else { return wordsReviewedCount }
        for i in 0..<days {
            let date = Calendar.current.date(byAdding: .day, value: -i, to: Date())!
            wordsReviewedCount[i] = words.count { Calendar.current.isDate(date, inSameDayAs: $0.lastSuccessfullReviewDate ?? .distantPast) }
        }

        return wordsReviewedCount.reversed()
    }

    func getWordsTotalCount(days: Int) -> [Int] {
        var wordsTotalCount = Array(repeating: 0, count: days)
        guard let words = try? wordsStorage.getWords() else { return wordsTotalCount }
        for i in 0..<days {
            let date = Date().addingTimeInterval(TimeInterval(-i * 24 * 60 * 60))
            wordsTotalCount[i] = words.count { $0.addedDate ?? date <= date }
        }
        
        return wordsTotalCount.reversed()
    }
    
    func getStreakDays() -> [WeekDay] {
        var streakDays: [WeekDay] = []
        let activeDays = defaults.array(forKey: Keys.activeDays.rawValue) as? [Date] ?? []
        for day in activeDays {
            if areDatesInSameWeek(date1: day, date2: Date()) {
                streakDays.append(WeekDay.from(date: day))
            }
        }
        
        return streakDays;
    }
    
    func getStreak() -> (Int, Bool) {
        let streak = defaults.integer(forKey: Keys.streak.rawValue)
        let lastDayActive: Date = defaults.array(forKey: Keys.activeDays.rawValue)?.last as? Date ?? Date()
        let calendar = Calendar.current
        if (calendar.isDateInToday(lastDayActive)) {
            return (6, true)
        } else if (calendar.isDateInYesterday(lastDayActive)) {
            return (6, false)
        }
        
        defaults.set(0, forKey: Keys.streak.rawValue)
        return (0, true)
    }
    
    func setTodayAsActiveDay() {
        var activeDays = defaults.array(forKey: Keys.activeDays.rawValue) as? [Date] ?? []
        if !activeDays.contains(Date()) {
            activeDays.append(Date())
            let streak = defaults.integer(forKey: Keys.streak.rawValue)
            defaults.set(streak + 1, forKey: Keys.streak.rawValue)
            defaults.set(activeDays, forKey: Keys.activeDays.rawValue)
        }
    }
    
    // MARK: - Private Methods
    private func areDatesInSameWeek(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        
        let weekOfYear1 = calendar.component(.weekOfYear, from: date1)
        let weekOfYear2 = calendar.component(.weekOfYear, from: date2)
        
        let year1 = calendar.component(.yearForWeekOfYear, from: date1)
        let year2 = calendar.component(.yearForWeekOfYear, from: date2)
        
        return year1 == year2 && weekOfYear1 == weekOfYear2
    }
}
