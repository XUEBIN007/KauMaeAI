import SwiftUI

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var purchaseManager = PurchaseManager()
    let onPreviewUnlock: (() -> Void)?

    init(onPreviewUnlock: (() -> Void)? = nil) {
        self.onPreviewUnlock = onPreviewUnlock
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            Text("KauMae Pro")
                .font(.largeTitle.weight(.bold))
            Text("買い物で迷うたびに、AIが似合うか・着回せるかをチェックします。")
                .font(.body)
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 12) {
                PaywallRow(icon: "checkmark.seal", text: "月50回の買う前チェック")
                PaywallRow(icon: "tshirt", text: "手持ち服との着回し提案")
                PaywallRow(icon: "sparkles", text: "上身イメージ生成はクレジット制")
            }

            Button {
                Task {
                    await purchaseManager.purchasePro()
                    if purchaseManager.isProUnlocked {
                        onPreviewUnlock?()
                        dismiss()
                    }
                }
            } label: {
                Text("月額 ¥980 で始める")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)

            if let purchaseErrorMessage = purchaseManager.purchaseErrorMessage {
                Text(purchaseErrorMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
            }

            Button("プレビュー用にProを有効化") {
                onPreviewUnlock?()
                dismiss()
            }
            .font(.footnote)
            .buttonStyle(.plain)

            Text("サブスクリプションは自動更新です。価格、期間、キャンセル方法は購入前に表示されます。")
                .font(.footnote)
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding(24)
        .task {
            await purchaseManager.loadProducts()
        }
    }
}

private struct PaywallRow: View {
    let icon: String
    let text: String

    var body: some View {
        Label(text, systemImage: icon)
            .font(.subheadline)
    }
}
