//
//  Array+Chanked.swift
//  Sparkle
//
//  Created by тимур on 09.02.2025.
//

extension Array {
    func chuncked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
