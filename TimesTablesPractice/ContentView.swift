//
//  ContentView.swift
//  TimesTablesPractice
//
//  Created by Matilda Mared on 2022-10-25.
//

import SwiftUI

struct ContentView: View {
    let yellowColor = Color(hue: 0.121, saturation: 1.0, brightness: 0.939, opacity: 1.0)
    
    @State private var gameStatus = "notStarted"
    
    var body: some View {
        ZStack {
            Color(hue: 0.1339, saturation: 0.4, brightness: 1)
                .ignoresSafeArea()
            if gameStatus == "notStarted" {
                initialView
            }
        }
    }
    
    var initialView: some View {
        VStack {
            Spacer()
            
            Image("giraffe")
                .padding()
            
            Text("Hello there, friend!")
                .font(.title)
            
            Text("Would you like to practice the times tables with me? It will be fun!")
                .padding()
                .fontWeight(.light)
            
            Button("Practice") {}
                .padding()
                .foregroundColor(.white)
                .background(yellowColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Spacer()
            
            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
