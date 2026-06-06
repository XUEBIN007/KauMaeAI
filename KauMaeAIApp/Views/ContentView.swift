import SwiftUI

struct ContentView: View {
    @State private var appState = AppState()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("KauMae AI")
                            .font(.system(size: 34, weight: .bold))
                        Text("この服、買っていい？")
                            .font(.system(size: 24, weight: .semibold))
                        Text("買う前に、似合うか・着回せるかをAIでチェック。")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }

                    FreeCheckBanner(remainingFreeChecks: appState.remainingFreeChecks)

                    ProfileSetupView(profile: appState.profile)

                    ItemCheckView(candidate: appState.candidate, selectedPhoto: $appState.selectedPhoto) {
                        appState.runCheck()
                    }

                    if let advice = appState.latestAdvice {
                        ResultView(advice: advice)
                    }
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("買う前チェック")
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
                Text("残り \(remainingFreeChecks) 回")
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
