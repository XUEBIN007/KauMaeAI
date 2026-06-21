import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var appState = AppState()
    @State private var selectedPhoto: PhotosPickerItem?

    var body: some View {
        @Bindable var appState = appState

        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("KauMae AI")
                            .font(.system(size: 30, weight: .bold))
                        Text("この服、買っていい？")
                            .font(.system(size: 22, weight: .semibold))
                        Text("買う前に、似合うか・着回せるかをAIでチェック。")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }

                    FreeCheckBanner(remainingFreeChecks: appState.remainingFreeChecks)

                    ProfileSetupView(profile: $appState.profile)

                    WardrobeEditorView(
                        wardrobe: appState.wardrobe,
                        onAdd: appState.addWardrobeItem,
                        onDelete: appState.removeWardrobeItem
                    )

                    ItemCheckView(
                        candidate: $appState.candidate,
                        occasion: $appState.occasion,
                        selectedPhoto: $selectedPhoto
                    ) {
                        appState.runCheck()
                    }

                    if let advice = appState.latestAdvice {
                        ResultView(advice: advice)
                    }

                    Button(role: .destructive) {
                        appState.resetLocalDataForPreview()
                    } label: {
                        Label("入力をリセット", systemImage: "arrow.counterclockwise")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("買う前チェック")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $appState.showPaywall) {
                PaywallView {
                    appState.unlockProForPreview()
                }
            }
        }
    }
}

private struct FreeCheckBanner: View {
    let remainingFreeChecks: Int

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("無料チェック")
                    .font(.headline)
                Text(remainingFreeChecks > 0 ? "残り \(remainingFreeChecks) 回" : "次回からProが必要です")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "sparkles")
                .font(.title2)
        }
        .padding(16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    ContentView()
}
