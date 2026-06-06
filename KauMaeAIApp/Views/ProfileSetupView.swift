import SwiftUI
import KauMaeCore

struct ProfileSetupView: View {
    let profile: StyleProfile

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("あなたの条件")
                .font(.headline)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                InfoPill(title: "年代", value: "40代")
                InfoPill(title: "性別", value: "男性")
                InfoPill(title: "体型", value: "ストレート")
                InfoPill(title: "肌色", value: "ウォーム")
                InfoPill(title: "髪型", value: "短髪")
                InfoPill(title: "メガネ", value: profile.wearsGlasses ? "あり" : "なし")
            }
        }
        .padding(16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct InfoPill: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.subheadline.weight(.semibold))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}
