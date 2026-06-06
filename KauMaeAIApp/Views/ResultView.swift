import SwiftUI
import KauMaeCore

struct ResultView: View {
    let advice: StyleAdvice

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .firstTextBaseline) {
                Text(advice.headline)
                    .font(.title2.weight(.bold))
                Spacer()
                Text("\(advice.score)点")
                    .font(.title.weight(.bold))
                    .foregroundStyle(scoreColor)
            }

            VStack(alignment: .leading, spacing: 8) {
                ForEach(advice.reasons, id: \.self) { reason in
                    Label(reason, systemImage: "checkmark.circle")
                        .font(.subheadline)
                }
            }

            if !advice.suggestedOutfit.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("おすすめ合わせ")
                        .font(.headline)
                    ForEach(advice.suggestedOutfit, id: \.self) { item in
                        Text(item)
                            .font(.subheadline)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)
                            .background(Color(.secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                }
            }
        }
        .padding(16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var scoreColor: Color {
        advice.score >= 75 ? .green : .orange
    }
}
