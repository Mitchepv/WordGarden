//
//  ContentView.swift
//  WordGarden
//
//  Created by Nia Mitchell on 1/31/26.
//

import SwiftUI

struct ContentView: View {
    @State private var wordsGuessed = 0
    @State private var wordsMissed = 0
    @State private var gameStatusMess = "How Many Guesses to Uncover the Hidden Word? "
    @State private var currentWordIndex = 0
    @State private var wordsToGuess = ""
    @State private var revealedWord = ""
    @State private var lettersGuessed = ""
    @State private var guessedLetter = ""
    @State private var imageName = "flower8"
    @State private var playAgainHidden = true
    @FocusState private var textFieldFocus : Bool
    private let wordToGuess=["DOGGYMANS", "SWIFT", "CODE"]
    
    
    var body: some View {
        VStack {
            
            HStack {
                VStack (alignment: .leading) {
                    Text ("Words Guessed: \(wordsGuessed)")
                    Text ("Words Missed: \(wordsMissed)")
                 }
                
                Spacer()
                
                VStack (alignment: .trailing) {
                    Text ("Words to Guess : \(wordsToGuess.count - (wordsGuessed + wordsMissed))")
                    Text ("Words in Game: \(wordsToGuess.count)")
                    
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            Text ( gameStatusMess)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
            
            Text (revealedWord)
                .font(.title)
            
            if playAgainHidden {
                HStack{
                    TextField( "", text: $guessedLetter )
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 30)
                        .overlay {
                            RoundedRectangle (cornerRadius: 5)
                                .stroke(.gray , lineWidth: 2)
                        }
                        .keyboardType(.asciiCapable)
                        .submitLabel(.done)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.characters)
                        .onChange(of: guessedLetter){
                            guessedLetter = guessedLetter.trimmingCharacters(in: .letters.inverted)
                            guard let lastChar = guessedLetter.last else { return }
                            guessedLetter = String(lastChar).uppercased()
                        }
                        .focused($textFieldFocus)
                        .onSubmit {
                            guard guessedLetter != "" else {
                                return
                            }
                            guessALetter()
                        }
                    
                    Button ("Guess a letter") {
                        guessALetter()
            
                    }
                    .buttonStyle(.bordered)
                    .tint(.mint)
                    .disabled(guessedLetter.isEmpty)
                    
                }
            } else {
                Button ("Another Word?") {
                }
                .buttonStyle(.borderedProminent)
                .tint(.mint)
            }
            
            Spacer()
            Image(imageName)
                .resizable()
                .scaledToFit()
                
        }
        .ignoresSafeArea(edges: .bottom )
        .onAppear {
            wordsToGuess = wordToGuess[currentWordIndex]
            revealedWord =  "_"  + String(repeating: " _", count: wordsToGuess.count - 1)
        }
    
    }
    func guessALetter() {
        textFieldFocus = false
        lettersGuessed = lettersGuessed + guessedLetter
        revealedWord = wordsToGuess.map {
             letter in lettersGuessed.contains(letter) ? "\(letter)" : "_"
        }.joined(separator: " ")
        guessedLetter = " "
    }
    
}

#Preview {
    ContentView()
}
