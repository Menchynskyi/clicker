//
//  ContentView.swift
//  Shared
//
//  Created by Oleksandr Menchynskyi on 15.06.2022.
//

import SwiftUI

let maxCount = 999

enum ButtonVariants {
    case res
    case inc
}

func getRandomEmoji() -> String {
    return String(UnicodeScalar(Array(0x1F300...0x1F3F0).randomElement()!)!)
}

struct ContentView: View {
    @AppStorage("count") private var count: Int = 0
    @AppStorage("emoji") private var emoji: String = getRandomEmoji()
    @State private var isShowingConfirmReset: Bool = false
    
    var body: some View {
        ZStack {
            Color(.black).edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 120) {
                Spacer()
                createCounterText()
                Spacer()
                
                HStack(alignment: .bottom, spacing: 24) {
                    createButton(ButtonVariants.inc)
                    createButton(ButtonVariants.res)
                }
            }
        }
    }
    
    
    private func createCounterText() -> Text {
        return Text("\(emoji) \(count) \(emoji)")
            .foregroundColor(.white)
            .font(Font.system(size: 68))
    }
    
    private func createButton(_ btnVariant: ButtonVariants) -> some View {
        return Button(action: {
            switch btnVariant {
            case .inc:
                if (count < maxCount) {
                    count += 1
                    emoji = getRandomEmoji()
                }
            case .res:
                isShowingConfirmReset = true
            }
        }) {
            Text(btnVariant == ButtonVariants.inc ? "Add" : "Reset")
                .foregroundColor(.white)
                .bold()
        }
        .confirmationDialog("Are you sure?", isPresented: $isShowingConfirmReset, titleVisibility: .visible) {
            Button("Reset", role: .destructive) {
                count = 0
                emoji = getRandomEmoji()
            }
        }
        .disabled(btnVariant == .res && count == 0)
        .frame(width: 170, height: 50, alignment: .center)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke())
        .background(btnVariant == ButtonVariants.inc ? Color.cyan : Color.pink)
        .cornerRadius(8)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
