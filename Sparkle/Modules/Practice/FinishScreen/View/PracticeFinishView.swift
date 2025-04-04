//
//  PracticeFinishViewController.swift
//  Sparkle
//
//  Created by тимур on 17.04.2025.
//

import SwiftUI

struct PracticeFinishView: View {
    let wordsPracticed: Int
    let wordsTotal: Int
    var buttonAction: () -> Void = {}
    @State private var progress: Double = 0
    @State private var counter: Int = 0

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()

            VStack {
                Spacer()

                Image(systemName: "sparkle")
                    .resizable()
                    .frame(width: 250, height: 250)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.green, .gray.opacity(0.3)],
                            startPoint: UnitPoint(x: 0.5, y: 1 - progress),
                            endPoint: UnitPoint(x: 0.5, y: 1 - progress - 0.1)
                        )
                    )
                    .shadow(color: .green.opacity(progress), radius: 40)
                    .animation(.easeInOut(duration: progress * 3), value: progress)

                Text("\(counter) из \(wordsTotal)")
                    .font(.system(size: 40, weight: .bold))
                    .fontWeight(.bold)

                Text("слов повторено")
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .foregroundStyle(.gray)

                Spacer()

                Button(action: buttonAction) {
                    Text("Cупер!")
                        .font(.system(size: 18))
                        .foregroundStyle(.white)
                }
                .frame(width: 140, height: 50)
                .background(RoundedRectangle(cornerRadius: 12).fill(.green))
                .padding(.bottom, 25)
            }
        }
        .onAppear {
            progress = Double(wordsPracticed) / Double(wordsTotal)
            startCounting(to: wordsPracticed, duration: progress * 3)
        }
    }

    private func startCounting(to target: Int, duration: Double) {
        counter = 0
        let totalSteps = target
        guard totalSteps > 0 else { return }
        let stepTime = duration / Double(totalSteps)

        var current = 0
        Timer.scheduledTimer(withTimeInterval: stepTime, repeats: true) { timer in
            if current >= target {
                timer.invalidate()
            } else {
                current += 1
                counter = current
            }
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    PracticeFinishView(wordsPracticed: 70, wordsTotal: 100, buttonAction: { print("tap") })
}
