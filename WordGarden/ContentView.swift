//
//  ContentView.swift
//  WordGarden
//
//  Created by Nia Mitchell on 1/31/26.
//

import SwiftUI

struct ContentView: View {
    private static let maxGuess = 8
    @State private var wordsGuessed = 0
    @State private var wordsMissed = 0
    @State private var gameStatusMess = "How Many Guesses to Uncover the Hidden Word? "
    @State private var currentWordIndex = 0
    @State private var wordsToGuess = ""
    @State private var revealedWord = ""
    @State private var lettersGuessed = ""
    @State private var guessRemain = maxGuess
    @State private var guessedLetter = ""
    @State private var imageName = "flower8"
    @State private var playAgainHidden = true
    @State private var playAgainButon = "Another Word "
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
                .frame(height: 80)
                .minimumScaleFactor(0.5)
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
                            updateGamePlay()
                        }
                    
                    Button ("Guess a letter") {
                        guessALetter()
                        updateGamePlay()
            
                    }
                    .buttonStyle(.bordered)
                    .tint(.mint)
                    .disabled(guessedLetter.isEmpty)
                    
                }
            } else {
                Button (playAgainButon) {
                    if currentWordIndex == wordToGuess.count {
                        currentWordIndex = 0
                        wordsGuessed = 0
                        wordsMissed = 0
                        playAgainButon = "Another Word"
                    }
                    wordsToGuess =  wordToGuess[currentWordIndex]
                    revealedWord =  "_"  + String(repeating: " _", count: wordsToGuess.count - 1)
                    lettersGuessed = " "
                    guessRemain = Self.maxGuess
                    imageName = "flower\(guessRemain)"
                    gameStatusMess = "How Many Guesss To Uncover The Hidden Word?"
                    playAgainHidden = true
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
    }
    
    func updateGamePlay() {
     
        if !wordsToGuess.contains(guessedLetter) {
            guessRemain -= 1
            imageName = "flower\(guessRemain)"
        }
        
        if revealedWord.contains("_") {
            gameStatusMess =  ("You Made It!! It took you \(lettersGuessed.count) Guesses To Guess The Word ")
            wordsGuessed += 1
            currentWordIndex += 1
            playAgainHidden = false
        } else if guessRemain == 0 {
            gameStatusMess =  ("Sorry You Are Out Of Guesses!")
            wordsMissed += 1
            currentWordIndex += 1
            playAgainHidden = false
        } else {
            gameStatusMess = ("You Have Made \(lettersGuessed.count) Guesses\(lettersGuessed.count==1 ? "" : "es"  )")
            
        }
        
        if currentWordIndex == wordToGuess.count{
            playAgainButon = "Restart Game"
            gameStatusMess = gameStatusMess + "\nYou Have Tried All Word, Start Over!"
        }
    
        
        guessedLetter =  ""
    }
     
}

#Preview {
    ContentView()
}
