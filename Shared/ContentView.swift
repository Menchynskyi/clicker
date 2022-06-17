//
//  Created by Oleksandr Menchynskyi on 15.06.2022.
//

import SwiftUI

func getRandomEmoji() -> String {
    return String(UnicodeScalar(Array(0x1F300...0x1F3F0).randomElement()!)!)
}

struct ContentView: View {
    private let maxCount = 999

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
                    createAddButton()
                    createResetButton()
                }
            }
            .padding()
        }
    }

    private func createCounterText() -> Text {
        return Text("\(emoji) \(count) \(emoji)")
            .foregroundColor(.white)
            .font(Font.system(size: 68))
    }

    private func createAddButton() -> some View {
        return Button {
            if count < maxCount {
                count += 1
            }
            emoji = getRandomEmoji()
        } label: {
            let isMaxCount = count == maxCount
            let incBtnLabel = isMaxCount ? "Emoji" : "Add"
            let incBtnImage = isMaxCount ? "heart" : "plus"

            Label(incBtnLabel, systemImage: incBtnImage)
                .font(Font.system(size: 24))
                .frame(width: 140, height: 40)
        }
        .buttonStyle(.bordered)
        .tint(.cyan)
    }

    private func createResetButton() -> some View {
        return Button {
            isShowingConfirmReset = true
        } label: {
            Label("Reset", systemImage: "arrow.2.squarepath")
                .font(Font.system(size: 24))
                .frame(width: 140, height: 40)
        }
        .confirmationDialog("Are you sure?", isPresented: $isShowingConfirmReset, titleVisibility: .visible) {
            Button("Reset", role: .destructive) {
                count = 0
                emoji = getRandomEmoji()
            }
        }
        .disabled(count == 0)
        .buttonStyle(.bordered)
        .tint(.pink)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
