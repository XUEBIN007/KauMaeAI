import Foundation
import KauMaeCore

@Observable
final class AppState {
    private static let storageKey = "KauMaeAI.AppState.v1"

    @ObservationIgnored private let defaults: UserDefaults

    private var quota = CheckQuota.freeTrial(limit: 3) {
        didSet { save() }
    }
    var profile = StyleProfile(
        ageRange: .forties,
        gender: .male,
        bodyShape: .straight,
        skinTone: .warm,
        hairStyle: .short,
        wearsGlasses: true,
        styleGoal: .cleanWork
    ) {
        didSet { save() }
    }
    var candidate = CandidateItem(
        name: "Navy jacket",
        category: .outerwear,
        color: .navy,
        formality: .businessCasual,
        pattern: .solid,
        priceJPY: 7990
    ) {
        didSet { save() }
    }
    var wardrobe = [
        WardrobeItem(name: "White shirt", category: .top, color: .white, formality: .businessCasual),
        WardrobeItem(name: "Gray trousers", category: .bottom, color: .gray, formality: .businessCasual),
        WardrobeItem(name: "Black loafers", category: .shoes, color: .black, formality: .businessCasual)
    ] {
        didSet { save() }
    }
    var latestAdvice: StyleAdvice?
    var history: [CheckHistoryEntry] = [] {
        didSet { save() }
    }
    var showPaywall = false
    var occasion: Occasion = .work {
        didSet { save() }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        restore()
    }

    var remainingFreeChecks: Int {
        quota.remainingFreeChecks
    }

    var isPaid: Bool {
        quota.isPaid
    }

    func runCheck() {
        switch quota.consumeCheck() {
        case .allowed:
            let advice = StyleAdvisor().evaluate(
                candidate: candidate,
                profile: profile,
                wardrobe: wardrobe,
                occasion: occasion
            )
            latestAdvice = advice
            history.insert(CheckHistoryEntry(
                checkedAt: Date(),
                candidate: candidate,
                occasion: occasion,
                advice: advice
            ), at: 0)
        case .requiresPayment:
            showPaywall = true
        }
    }

    func addWardrobeItem(_ item: WardrobeItem) {
        wardrobe.append(item)
        latestAdvice = nil
    }

    func removeWardrobeItem(at offsets: IndexSet) {
        wardrobe.remove(atOffsets: offsets)
        latestAdvice = nil
    }

    func unlockProForPreview() {
        quota = .paid(remainingFreeChecks: quota.remainingFreeChecks)
        showPaywall = false
    }

    func resetLocalDataForPreview() {
        defaults.removeObject(forKey: Self.storageKey)
        quota = .freeTrial(limit: 3)
        profile = Self.defaultProfile
        candidate = Self.defaultCandidate
        wardrobe = Self.defaultWardrobe
        occasion = .work
        history = []
        latestAdvice = nil
        showPaywall = false
    }

    private func save() {
        let snapshot = PersistedAppState(
            quota: quota,
            profile: profile,
            candidate: candidate,
            wardrobe: wardrobe,
            occasion: occasion,
            history: history
        )
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        defaults.set(data, forKey: Self.storageKey)
    }

    private func restore() {
        guard
            let data = defaults.data(forKey: Self.storageKey),
            let snapshot = try? JSONDecoder().decode(PersistedAppState.self, from: data)
        else {
            return
        }
        quota = snapshot.quota
        profile = snapshot.profile
        candidate = snapshot.candidate
        wardrobe = snapshot.wardrobe
        occasion = snapshot.occasion
        history = snapshot.history ?? []
    }
}

struct CheckHistoryEntry: Codable, Identifiable {
    let id: UUID
    let checkedAt: Date
    let candidate: CandidateItem
    let occasion: Occasion
    let advice: StyleAdvice

    init(
        id: UUID = UUID(),
        checkedAt: Date,
        candidate: CandidateItem,
        occasion: Occasion,
        advice: StyleAdvice
    ) {
        self.id = id
        self.checkedAt = checkedAt
        self.candidate = candidate
        self.occasion = occasion
        self.advice = advice
    }
}

private extension AppState {
    static let defaultProfile = StyleProfile(
        ageRange: .forties,
        gender: .male,
        bodyShape: .straight,
        skinTone: .warm,
        hairStyle: .short,
        wearsGlasses: true,
        styleGoal: .cleanWork
    )

    static let defaultCandidate = CandidateItem(
        name: "Navy jacket",
        category: .outerwear,
        color: .navy,
        formality: .businessCasual,
        pattern: .solid,
        priceJPY: 7990
    )

    static let defaultWardrobe = [
        WardrobeItem(name: "White shirt", category: .top, color: .white, formality: .businessCasual),
        WardrobeItem(name: "Gray trousers", category: .bottom, color: .gray, formality: .businessCasual),
        WardrobeItem(name: "Black loafers", category: .shoes, color: .black, formality: .businessCasual)
    ]
}

private struct PersistedAppState: Codable {
    let quota: CheckQuota
    let profile: StyleProfile
    let candidate: CandidateItem
    let wardrobe: [WardrobeItem]
    let occasion: Occasion
    let history: [CheckHistoryEntry]?
}
