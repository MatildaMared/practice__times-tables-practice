//
//  ContentView.swift
//  TimesTablesPractice
//
//  Created by Matilda Mared on 2022-10-25.
//

import SwiftUI

enum GameStatus {
    case Initial, Running, Completed
}

extension View {
    func buttonStyles() -> some View {
        modifier(StyledButton())
    }
}

struct StyledButton: ViewModifier {
    let yellowColor = Color(hue: 0.121, saturation: 1.0, brightness: 0.939, opacity: 1.0)
    func body(content: Content) -> some View {
        content
            .padding()
            .foregroundColor(.white)
            .background(yellowColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}


struct ContentView: View {
    @State private var scaleEffect = 0.5
    @State private var gameStatus = GameStatus.Initial
    @State private var timesTableToPractice = 1
    @State private var numberOfQuestions = 5
    @State private var questions = [Question]()
    @State private var currentQuestionIndex = 0
    @State private var correctAnswers = 0
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var guess = 0
    @FocusState private var inputIsActive: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hue: 0.1339, saturation: 0.4, brightness: 1)
                    .ignoresSafeArea()
                
                switch gameStatus {
                case GameStatus.Initial:
                    initialView
                case GameStatus.Running:
                    gameView
                case GameStatus.Completed:
                    completedView
                }
            }
            .foregroundColor(.black)
        }
    }
    
    var completedView: some View {
        VStack {
            Spacer()
            
            Image("giraffe")
                .padding()
                .scaleEffect(scaleEffect)
                .onAppear(perform: {
                    withAnimation(.easeInOut(duration: 1.25)) {
                        scaleEffect = 1
                    }
                })
            
            Text("Good work, my friend! 🥳")
                .font(.title)
            
            Text("You got \(correctAnswers) of \(questions.count) questions correct! Want to play again?")
                .padding()
                .fontWeight(.light)
            
            Spacer()
            
            Spacer()
            
            Button("Play Again") {
                resetGame()
            }
            .buttonStyles()
        }
    }
    
    var gameView: some View {
        VStack {
            Spacer ()
            
            Image("giraffe")
                .scaleEffect(0.7)
            
            Text("Question \(currentQuestionIndex + 1)")
                .font(.title)
            
            Form {
                
                Text(questions[currentQuestionIndex].questionString)
                
                TextField("Guess", value: $guess, formatter: NumberFormatter())
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .keyboardType(.numberPad)
                    .focused($inputIsActive)
                    .toolbar {
                       ToolbarItem(placement: .keyboard) {
                          Button("Done") {
                            inputIsActive = false
                        }
                    }
                }
                
            }
            .padding()
            .scrollContentBackground(.hidden)
            .foregroundColor(.primary)
            .opacity(0.7)

            
            Button("Make Guess") {
                inputIsActive = false
                makeGuess(guess)
            }
                .padding()
                .foregroundColor(.white)
                .background(.purple)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Spacer()
            
            Spacer()
            
            Button("Reset Game") {
                resetGame()
            }
            .buttonStyles()
        }
        .alert(alertTitle, isPresented: $showAlert) {
            Text(alertMessage)
            
            if currentQuestionIndex == questions.count - 1 {
                Button("Show Score") {
                    gameStatus = GameStatus.Completed
                }
            } else {
                Button("Next Question") {
                    guess = 0
                    currentQuestionIndex += 1
                }
            }
        }
    }
    
    var initialView: some View {
        VStack {
            Spacer()
            
            Image("giraffe")
                .padding()
                .scaleEffect(scaleEffect)
                .onAppear(perform: {
                    withAnimation(.easeInOut(duration: 1.25)) {
                        scaleEffect = 1
                    }
                })
            
            Text("Hello there, friend!")
                .font(.title)
            
            Text("Would you like to practice the times tables with me? It will be fun!")
                .padding()
                .fontWeight(.light)
            
            List {
                Picker("Times table", selection: $timesTableToPractice) {
                    ForEach(0..<13) {
                        Text("\($0 + 1)").tag($0 + 1)
                    }
                }
                
                
                Picker("Number of questions", selection: $numberOfQuestions) {
                    Text("5").tag(5)
                    Text("10").tag(10)
                    Text("15").tag(15)
                    Text("20").tag(20)
                }

            }
            .foregroundColor(.primary)
            .scrollContentBackground(.hidden)
            .opacity(0.7)
            
            Button("Practice") {
                startGame()
            }
                .buttonStyles()
            
            Spacer()
            
            Spacer()
        }
        .padding()
    }
    
    func resetGame() {
        gameStatus = GameStatus.Initial
        numberOfQuestions = 5
        timesTableToPractice = 1
        correctAnswers = 0
        guess = 0
        questions.removeAll()
    }
    
    func startGame() {
        generateQuestions()
        currentQuestionIndex = 0
        correctAnswers = 0
        gameStatus = GameStatus.Running
    }
    
    func generateQuestions() {
        let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
        for _ in 1...numberOfQuestions {
            var numbersForQuestion = [Int]()
            numbersForQuestion.append(timesTableToPractice)
            numbersForQuestion.append(numbers[Int.random(in: 0..<12)])
            numbersForQuestion.shuffle()
            
            let firstNumber = numbersForQuestion[0]
            let secondNumber = numbersForQuestion[1]
            
            let question = Question(questionString: "What is \(firstNumber) * \(secondNumber)?", answer: firstNumber * secondNumber)
            
            questions.append(question)
        }
    }
    
    func makeGuess(_ userGuess: Int) {
        let answer = questions[currentQuestionIndex].answer

        if userGuess == answer {
            alertTitle = "Correct! 🥳"
            alertMessage = "Good work, keep going!"
            correctAnswers += 1
        } else {
            alertTitle = "Incorrect... 😞"
            alertMessage = "The correct answer was \(answer). Better luck next time!"
        }
        
        showAlert = true
    }
}

struct Question {
    var questionString: String
    var answer: Int
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
