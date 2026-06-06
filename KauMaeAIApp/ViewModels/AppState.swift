import Foundation
import KauMaeCore
import PhotosUI

@Observable
final class AppState {
    private var quota = CheckQuota.freeTrial(limit: 3)
    var profile = StyleProfile(
        ageRange: .forties,
        gender: .male,
        bodyShape: .straight,
        skinTone: .warm,
        hairStyle: .short,
        wearsGlasses: true,
        styleGoal: .cleanWork
    )
    var candidate = CandidateItem(
        name: "Navy jacket",
        category: .outerwear,
        color: .navy,
        formality: .businessCasual,
        pattern: .solid,
        priceJPY: 7990
    )
    var wardrobe = [
        WardrobeItem(name: "White shirt", category: .top, color: .white, formality: .businessCasual),
        WardrobeItem(name: "Gray trousers", category: .bottom, color: .gray, formality: .businessCasual),
        WardrobeItem(name: "Black loafers", category: .shoes, color: .black, formality: .businessCasual)
    ]
    var latestAdvice: StyleAdvice?
    var showPaywall = false
    var selectedPhoto: PhotosPickerItem?

    var remainingFreeChecks: Int {
        quota.remainingFreeChecks
    }

    var isPaid: Bool {
        quota.isPaid
    }

    func runCheck() {
        switch quota.consumeCheck() {
        case .allowed:
            latestAdvice = StyleAdvisor().evaluate(
                candidate: candidate,
                profile: profile,
                wardrobe: wardrobe,
                occasion: .work
            )
        case .requiresPayment:
            showPaywall = true
        }
    }

    func unlockProForPreview() {
        quota = .paid(remainingFreeChecks: quota.remainingFreeChecks)
        showPaywall = false
    }
}
