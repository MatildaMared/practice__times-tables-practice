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
    @State private var guess = 0
    
    var body: some View {
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
    
    var completedView: some View {
        Text("Completed")
    }
    
    var gameView: some View {
        VStack {
            Spacer ()
            
            Image("giraffe")
                .scaleEffect(0.7)
            
            Text("Question \(currentQuestionIndex + 1)")
                .font(.title)
            
            Text(questions[currentQuestionIndex].questionString)
                .font(.title2)
                .fontWeight(.light)
                .padding()
            
            Form {
                TextField("Guess", value: $guess, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                    //.listRowBackground(Color.white.opacity(0.5))
            }
            .frame(maxHeight: 100)
            .padding()
            .scrollContentBackground(.hidden)
            
            HStack {
                ForEach(1..<4) {
                    Button("\($0)") { }
                }
            }
            
            Button("Make Guess") {}
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
            
            let question = Question(questionString: "\(firstNumber) * \(secondNumber) = ?", answer: firstNumber * secondNumber)
            print(question)
            
            questions.append(question)
        }
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
