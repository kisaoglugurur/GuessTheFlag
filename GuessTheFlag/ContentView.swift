//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Gurur on 12.06.2025.
//

import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.secondary)
            .font(.largeTitle)
            .bold()
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct FlagImage: View {
    var imageName: String
    
    var body: some View {
        Image(imageName)
            .clipShape(.rect(cornerRadius: 4))
            .shadow(radius: 4)
    }
}

struct ContentView: View {
    @State private var questionAsked: Int = 1
    @State private var gameState: Bool = true
    @State private var finalAlert: Bool = false

    @State private var countries: [String] = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer: Int = Int.random(in: 0...2)
    
    @State private var showingScore: Bool = false
    @State private var scoreTitle: String = ""
    @State private var message: String = ""
    
    @State private var score: Int = 0

    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.75, green: 0.85, blue: 1.0), location: 0.0),
                .init(color: Color(red: 0.85, green: 0.75, blue: 1.0), location: 0.5),
                .init(color: Color(red: 1.0, green: 0.8, blue: 0.8), location: 1.0)
            ], center: .top, startRadius: 100, endRadius: 500)
            .ignoresSafeArea()

            VStack {
                Spacer()
                Text("Guess the Flag")
                    .titleStyle()

                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                        Text(countries[correctAnswer])
                            .titleStyle()
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(imageName: countries[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.ultraThinMaterial)
                .clipShape(.rect(cornerRadius: 20))

                Spacer()
                Spacer()

                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue") {
                askQuestion()
            }
        } message: {
            Text(message)
        }
        .alert("Final", isPresented: $finalAlert) {
            Button("OK") {
                resetGame()
            }
        } message: {
            Text("Game over! Your score is: \(score)")
        }
    }
    
    func flagTapped(_ number: Int) {
        if questionAsked <= 8 {
            if number == correctAnswer {
                scoreTitle = "Correct"
                score += 1
                questionAsked += 1
                message = "You got it right! Score: \(score)"
            } else {
                scoreTitle = "Wrong!"
                score -= 1
                questionAsked += 1
                message = "Wrong answer! That was the flag of \(countries[number])"
            }
            
            showingScore = true
        }
        
        if questionAsked > 8 {
            showingScore = false
            finalAlert = true
            gameState = false
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func resetGame() {
        questionAsked = 1
        score = 0
        gameState = true
    }
}

#Preview {
    ContentView()
}
