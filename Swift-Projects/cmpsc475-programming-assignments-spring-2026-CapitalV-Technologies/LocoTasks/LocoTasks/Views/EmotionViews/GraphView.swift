//
//  GraphView.swift
//  LocoTasks
//
//  Created by LiasPub on 4/17/26.
//

import SwiftUI
import Charts

struct GraphView: View {
    @Binding var journalEntries: [JournalEntry]
    var data: [(String, Int)] {
        var dict = ["Happiness": 0, "Anger": 0, "Disgust": 0, "Fear": 0, "Sadness": 0, "Surprise": 0,]
        for entry in journalEntries {
            dict[entry.emotion.str] = dict[entry.emotion.str]! + 1
        }
        let list = [("Happiness", dict["Happiness"] ?? 0), ("Anger", dict["Anger"] ?? 0), ("Disgust", dict["Disgust"] ?? 0), ("Fear", dict["Fear"] ?? 0), ("Sadness", dict["Sadness"] ?? 0), ("Surprise", dict["Surprise"] ?? 0)]
        return list
    }
    
//    let data = [
//            ("Happy", 40),
//            ("Sad", 30),
//            ("Angry", 30)
//        ]
//        
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            VStack{
                Text("Your Emotions")
                    .bold()
                    .font(.largeTitle)
                Chart(data, id: \.0) { item in
                    SectorMark(
                        angle: .value("Value", item.1)
                    )
                    .annotation(position: .overlay) {
                        if item.1 != 0 {
                            VStack {
                                Text("\(item.0)")
                                    .font(.title2)
                                    .foregroundStyle(.white)
                                Text("Total: \(item.1)")
                                    .font(.subheadline)
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                    .foregroundStyle(by: .value("Emotion", item.0))
                }
                .padding()
            }
        }
    }
    let backgroundColor: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.95, green: 0.94, blue: 0.88),
            Color(red: 0.93, green: 0.91, blue: 0.85),
            Color(red: 0.90, green: 0.89, blue: 0.83)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

