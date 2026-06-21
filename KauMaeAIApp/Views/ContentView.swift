import SwiftUI
import PhotosUI
import KauMaeCore

struct ContentView: View {
    @State private var appState = AppState()
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedPhotoData: Data?
    @State private var profilePhoto: PhotosPickerItem?
    @State private var profilePhotoData: Data?

    var body: some View {
        @Bindable var appState = appState

        TabView {
            NavigationStack {
                CheckTabView(
                    appState: appState,
                    profile: $appState.profile,
                    candidate: $appState.candidate,
                    occasion: $appState.occasion,
                    selectedPhoto: $selectedPhoto,
                    selectedPhotoData: selectedPhotoData,
                    profilePhoto: $profilePhoto,
                    profilePhotoData: profilePhotoData
                )
                .navigationTitle("買う前チェック")
                .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("チェック", systemImage: "checkmark.seal")
            }

            NavigationStack {
                WardrobeTabView(appState: appState)
                    .navigationTitle("手持ち服")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("クローゼット", systemImage: "tshirt")
            }

            NavigationStack {
                HistoryTabView(
                    history: appState.history,
                    onReuse: appState.reuseHistoryEntry
                )
                    .navigationTitle("履歴")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("履歴", systemImage: "clock.arrow.circlepath")
            }

            NavigationStack {
                ProTabView(
                    remainingFreeChecks: appState.remainingFreeChecks,
                    isPaid: appState.isPaid,
                    onUnlock: appState.unlockProForPreview,
                    onReset: appState.resetLocalDataForPreview
                )
                .navigationTitle("KauMae Pro")
                .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("Pro", systemImage: "sparkles")
            }
        }
        .sheet(isPresented: $appState.showPaywall) {
            PaywallView {
                appState.unlockProForPreview()
            }
        }
        .task(id: selectedPhoto) {
            selectedPhotoData = try? await selectedPhoto?.loadTransferable(type: Data.self)
        }
        .task(id: profilePhoto) {
            profilePhotoData = try? await profilePhoto?.loadTransferable(type: Data.self)
        }
    }
}

private struct CheckTabView: View {
    let appState: AppState
    @Binding var profile: StyleProfile
    @Binding var candidate: CandidateItem
    @Binding var occasion: Occasion
    @Binding var selectedPhoto: PhotosPickerItem?
    let selectedPhotoData: Data?
    @Binding var profilePhoto: PhotosPickerItem?
    let profilePhotoData: Data?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HeroHeader()
                FreeCheckBanner(remainingFreeChecks: appState.remainingFreeChecks)
                ItemCheckView(
                    candidate: $candidate,
                    occasion: $occasion,
                    selectedPhoto: $selectedPhoto,
                    selectedPhotoData: selectedPhotoData
                ) {
                    appState.runCheck()
                }

                if let advice = appState.latestAdvice {
                    ResultView(
                        advice: advice,
                        candidate: candidate,
                        hasProductPhoto: selectedPhotoData != nil
                    )
                }
                ProfileSetupView(
                    profile: $profile,
                    profilePhoto: $profilePhoto,
                    profilePhotoData: profilePhotoData
                )
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
    }
}

private struct WardrobeTabView: View {
    let appState: AppState

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                WardrobeEditorView(
                    wardrobe: appState.wardrobe,
                    onAdd: appState.addWardrobeItem,
                    onDelete: appState.removeWardrobeItem
                )
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
    }
}

private struct HistoryTabView: View {
    let history: [CheckHistoryEntry]
    let onReuse: (CheckHistoryEntry) -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                CheckHistoryView(history: history, onReuse: onReuse)
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
    }
}

private struct ProTabView: View {
    let remainingFreeChecks: Int
    let isPaid: Bool
    let onUnlock: () -> Void
    let onReset: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                FreeCheckBanner(remainingFreeChecks: remainingFreeChecks)
                VStack(alignment: .leading, spacing: 14) {
                    Text(isPaid ? "Pro 有効" : "KauMae Pro")
                        .font(.title2.weight(.bold))
                    Text("迷った服を何度でもチェック。試着イメージ生成はクレジット制で追加予定です。")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    PricingPlanRow(
                        title: "Pro 月額",
                        price: "¥980",
                        detail: "月50回の買う前チェック",
                        icon: "checkmark.seal"
                    )
                    PricingPlanRow(
                        title: "チェック10回",
                        price: "¥480",
                        detail: "サブスクなしで買い物前だけ使う",
                        icon: "bag"
                    )
                    PricingPlanRow(
                        title: "画像10枚",
                        price: "¥500",
                        detail: "試着イメージ生成のAPIコストを回収",
                        icon: "photo.on.rectangle"
                    )
                    Button(action: onUnlock) {
                        Label(isPaid ? "Pro有効化済み" : "プレビュー用にProを有効化", systemImage: "sparkles")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(isPaid)
                }
                .padding(16)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))

                Button(role: .destructive, action: onReset) {
                    Label("入力をリセット", systemImage: "arrow.counterclockwise")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
    }
}

private struct PricingPlanRow: View {
    let title: String
    let price: String
    let detail: String
    let icon: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.blue)
                .frame(width: 30)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(price)
                .font(.headline)
        }
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct HeroHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("KauMae AI")
                .font(.system(size: 30, weight: .bold))
            Text("この服、買っていい？")
                .font(.system(size: 22, weight: .semibold))
            Text("10秒で、似合うか・着回せるか・買うべきかを判断。")
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }
}

struct FreeCheckBanner: View {
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
