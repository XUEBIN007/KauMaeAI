import SwiftUI
import KauMaeCore

struct ResultView: View {
    let advice: StyleAdvice
    let candidate: CandidateItem
    let hasProfilePhoto: Bool
    let hasProductPhoto: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TryOnPreview(
                candidate: candidate,
                hasProfilePhoto: hasProfilePhoto,
                hasProductPhoto: hasProductPhoto
            )

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

            if let factors = advice.scoreFactors, !factors.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("スコアの内訳")
                        .font(.headline)
                    ForEach(factors, id: \.title) { factor in
                        ScoreFactorRow(factor: factor)
                    }
                }
            }

            if let nextActions = advice.nextActions, !nextActions.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("次にすること")
                        .font(.headline)
                    ForEach(nextActions, id: \.self) { action in
                        Label(action, systemImage: "arrow.right.circle")
                            .font(.subheadline)
                            .padding(10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
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

private struct ScoreFactorRow: View {
    let factor: ScoreFactor

    var body: some View {
        HStack(spacing: 10) {
            Text(factor.title)
                .font(.subheadline.weight(.semibold))
                .frame(width: 78, alignment: .leading)
            Text(factor.note)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            Spacer()
            Text(factor.points >= 0 ? "+\(factor.points)" : "\(factor.points)")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(factor.points >= 0 ? .green : .orange)
        }
        .padding(10)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

private struct TryOnPreview: View {
    let candidate: CandidateItem
    let hasProfilePhoto: Bool
    let hasProductPhoto: Bool
    @State private var showGenerationPreview = false

    private var isReady: Bool {
        hasProfilePhoto && hasProductPhoto
    }

    private var statusText: String {
        if isReady {
            return "本人写真と商品写真がそろいました。AI生成API接続後、このまま試着画像を作れます。"
        }
        if hasProfilePhoto {
            return "商品写真を追加すると、試着イメージ生成につなげられます。"
        }
        if hasProductPhoto {
            return "本人写真を追加すると、試着イメージ生成につなげられます。"
        }
        return "本人写真と商品写真を追加すると、試着イメージ生成につなげられます。"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isReady ? Color.blue.opacity(0.12) : Color(.secondarySystemGroupedBackground))
                    Image(systemName: isReady ? "sparkles.rectangle.stack" : candidate.category.iconName)
                        .font(.system(size: 42))
                        .foregroundStyle(isReady ? .blue : .secondary)
                }
                .frame(width: 110, height: 138)

                VStack(alignment: .leading, spacing: 6) {
                    Text("AI試着イメージ")
                        .font(.headline)
                    Text(statusText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(candidate.name)
                        .font(.subheadline.weight(.semibold))
                        .lineLimit(2)
                }
                Spacer()
            }

            Button {
                showGenerationPreview = true
            } label: {
                Label(isReady ? "試着画像を生成" : "写真を追加してください", systemImage: isReady ? "wand.and.sparkles" : "photo.badge.plus")
                    .font(.subheadline.weight(.semibold))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!isReady)

            HStack(spacing: 8) {
                Image(systemName: "creditcard")
                Text("生成時に画像クレジットを1枚使用")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(Color(.tertiarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .alert("AI生成は次の開発ステップです", isPresented: $showGenerationPreview) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("本人写真と商品写真はそろっています。OpenAI APIまたは画像生成バックエンド接続後、このボタンから試着画像を生成します。")
        }
    }
}
