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
    }
    
    var completedView: some View {
        Text("Completed")
    }
    
    var gameView: some View {
        VStack {
            Text("Game running")
            
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
                    ForEach(1..<13) {
                        Text("\($0)")
                    }
                }
                .listRowBackground(Color.white.opacity(0.5))
                
                Picker("Number of questions", selection: $numberOfQuestions) {
                    Text("5").tag(5)
                    Text("10").tag(10)
                    Text("15").tag(15)
                    Text("20").tag(20)
                }
                .listRowBackground(Color.white.opacity(0.5))
            }
            .scrollContentBackground(.hidden)
            
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
    }
    
    func startGame() {
        gameStatus = GameStatus.Running
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
