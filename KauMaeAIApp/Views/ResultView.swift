import SwiftUI
import KauMaeCore

struct ResultView: View {
    let advice: StyleAdvice
    let candidate: CandidateItem
    let hasProductPhoto: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TryOnPreview(candidate: candidate, hasProductPhoto: hasProductPhoto)

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

private struct TryOnPreview: View {
    let candidate: CandidateItem
    let hasProductPhoto: Bool

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.secondarySystemGroupedBackground))
                Image(systemName: hasProductPhoto ? "person.crop.rectangle.badge.plus" : candidate.category.iconName)
                    .font(.system(size: 42))
                    .foregroundStyle(.blue)
            }
            .frame(width: 110, height: 138)

            VStack(alignment: .leading, spacing: 6) {
                Text("試着プレビュー")
                    .font(.headline)
                Text(hasProductPhoto ? "商品写真を使って、次のAI生成ステップに進めます。" : "商品写真を追加すると、試着イメージ生成につなげられます。")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(candidate.name)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(2)
            }
            Spacer()
        }
        .padding(12)
        .background(Color(.tertiarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
