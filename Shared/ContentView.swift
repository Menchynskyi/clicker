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
        return Button {
            switch btnVariant {
            case .res:
                isShowingConfirmReset = true
            case .inc:
                if count < maxCount {
                    count += 1
                }
                emoji = getRandomEmoji()
            }
        } label: {
            let isMaxCount = count == maxCount
            let incBtnLabel = isMaxCount ? "Emoji" : "Add"
            let incBtnImage = isMaxCount ? "heart" : "plus"
            
            Label(btnVariant == .inc ? incBtnLabel : "Reset", systemImage: btnVariant == .inc ? incBtnImage : "arrow.2.squarepath")
                .font(Font.system(size: 24))
                .frame(width: 140, height: 40)
        }
        .confirmationDialog("Are you sure?", isPresented: $isShowingConfirmReset, titleVisibility: .visible) {
            Button("Reset", role: .destructive) {
                count = 0
                emoji = getRandomEmoji()
            }
        }
        .buttonStyle(.bordered)
        .tint(btnVariant == .inc ? .cyan : .pink)
        .disabled(btnVariant == .res && count == 0)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
