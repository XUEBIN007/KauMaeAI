import Foundation
import KauMaeCore

@discardableResult
func expect(_ condition: @autoclosure () -> Bool, _ message: String) -> Bool {
    if condition() {
        return true
    }
    print("FAIL: \(message)")
    return false
}

func testBuyDecisionScoresWardrobeCompatibilityAndScenarioFit() -> Bool {
    let profile = StyleProfile(
        ageRange: .forties,
        gender: .male,
        bodyShape: .straight,
        skinTone: .warm,
        hairStyle: .short,
        wearsGlasses: true,
        styleGoal: .cleanWork
    )
    let wardrobe = [
        WardrobeItem(name: "White shirt", category: .top, color: .white, formality: .businessCasual),
        WardrobeItem(name: "Gray trousers", category: .bottom, color: .gray, formality: .businessCasual),
        WardrobeItem(name: "Black loafers", category: .shoes, color: .black, formality: .businessCasual)
    ]
    let candidate = CandidateItem(
        name: "Navy jacket",
        category: .outerwear,
        color: .navy,
        formality: .businessCasual,
        pattern: .solid,
        priceJPY: 7990
    )

    let advice = StyleAdvisor().evaluate(
        candidate: candidate,
        profile: profile,
        wardrobe: wardrobe,
        occasion: .work
    )

    return [
        expect(advice.score >= 80, "expected buy score >= 80"),
        expect(advice.decision == .buy, "expected buy decision"),
        expect(advice.headline == "買ってOK", "expected buy headline"),
        expect(advice.reasons.contains("手持ちの白シャツ・グレーパンツと着回しやすいです。"), "expected wardrobe compatibility reason"),
        expect(advice.suggestedOutfit == ["White shirt", "Gray trousers", "Black loafers"], "expected suggested outfit"),
        expect(advice.scoreFactors?.contains { $0.title == "着回し" && $0.points == 18 } == true, "expected wardrobe score factor")
    ].allSatisfy { $0 }
}

func testBuyDecisionRejectsLowFormalityMismatchForWork() -> Bool {
    let profile = StyleProfile(
        ageRange: .forties,
        gender: .female,
        bodyShape: .natural,
        skinTone: .cool,
        hairStyle: .medium,
        wearsGlasses: false,
        styleGoal: .polished
    )
    let wardrobe = [
        WardrobeItem(name: "Black skirt", category: .bottom, color: .black, formality: .businessCasual),
        WardrobeItem(name: "Brown sandals", category: .shoes, color: .brown, formality: .casual)
    ]
    let candidate = CandidateItem(
        name: "Bright orange hoodie",
        category: .top,
        color: .orange,
        formality: .casual,
        pattern: .logo,
        priceJPY: 3990
    )

    let advice = StyleAdvisor().evaluate(
        candidate: candidate,
        profile: profile,
        wardrobe: wardrobe,
        occasion: .work
    )

    return [
        expect(advice.score < 65, "expected work mismatch score < 65"),
        expect(advice.decision == .skip, "expected skip decision"),
        expect(advice.headline == "今回は見送り", "expected skip headline"),
        expect(advice.reasons.contains("仕事用としてはカジュアル感が強すぎます。"), "expected formality reason")
    ].allSatisfy { $0 }
}

func testBuyDecisionSuggestsAlternativeColorWhenItemIsUsefulButColorIsRisky() -> Bool {
    let profile = StyleProfile(
        ageRange: .thirties,
        gender: .female,
        bodyShape: .wave,
        skinTone: .cool,
        hairStyle: .long,
        wearsGlasses: true,
        styleGoal: .softCasual
    )
    let wardrobe = [
        WardrobeItem(name: "Navy denim", category: .bottom, color: .navy, formality: .casual),
        WardrobeItem(name: "White sneakers", category: .shoes, color: .white, formality: .casual)
    ]
    let candidate = CandidateItem(
        name: "Mustard cardigan",
        category: .outerwear,
        color: .mustard,
        formality: .smartCasual,
        pattern: .solid,
        priceJPY: 4990
    )

    let advice = StyleAdvisor().evaluate(
        candidate: candidate,
        profile: profile,
        wardrobe: wardrobe,
        occasion: .weekend
    )

    return [
        expect(advice.decision == .tryDifferentColor, "expected alternative color decision"),
        expect(advice.alternativeColor == .navy, "expected navy alternative"),
        expect(advice.reasons.contains("形は使いやすいですが、肌色にはネイビーの方がなじみます。"), "expected color risk reason")
    ].allSatisfy { $0 }
}

func testQuotaAllowsThreeFreeChecksBeforePaywall() -> Bool {
    var quota = CheckQuota.freeTrial(limit: 3)

    let first = quota.consumeCheck()
    let second = quota.consumeCheck()
    let third = quota.consumeCheck()
    let fourth = quota.consumeCheck()

    return [
        expect(first == .allowed(remaining: 2), "expected first free check to leave 2"),
        expect(second == .allowed(remaining: 1), "expected second free check to leave 1"),
        expect(third == .allowed(remaining: 0), "expected third free check to leave 0"),
        expect(fourth == .requiresPayment, "expected fourth free check to require payment"),
        expect(quota.remainingFreeChecks == 0, "expected remaining free checks to stay 0")
    ].allSatisfy { $0 }
}

func testPaidQuotaAllowsChecksWithoutReducingFreeBalance() -> Bool {
    var quota = CheckQuota.paid(remainingFreeChecks: 0)

    let result = quota.consumeCheck()

    return [
        expect(result == .allowed(remaining: nil), "expected paid checks to be allowed"),
        expect(quota.remainingFreeChecks == 0, "expected paid check not to change free balance")
    ].allSatisfy { $0 }
}

func testAnalysisPromptAvoidsGuaranteesAndIncludesDecisionFrame() -> Bool {
    let request = StyleAnalysisRequest(
        profile: StyleProfile(
            ageRange: .forties,
            gender: .male,
            bodyShape: .straight,
            skinTone: .warm,
            hairStyle: .short,
            wearsGlasses: true,
            styleGoal: .cleanWork
        ),
        candidate: CandidateItem(
            name: "Navy jacket",
            category: .outerwear,
            color: .navy,
            formality: .businessCasual,
            pattern: .solid,
            priceJPY: 7990
        ),
        wardrobe: [
            WardrobeItem(name: "White shirt", category: .top, color: .white, formality: .businessCasual)
        ],
        occasion: .work,
        userQuestion: "この服、買っていい？"
    )

    let prompt = StylePromptBuilder().makeJapanesePrompt(for: request)

    return [
        expect(prompt.contains("買う前の判断サポート"), "expected buy-before decision framing"),
        expect(prompt.contains("買ってOK / 見送り / 色違いおすすめ"), "expected decision choices"),
        expect(prompt.contains("サイズや購入結果を保証しない"), "expected no-guarantee instruction"),
        expect(prompt.contains("Navy jacket"), "expected candidate name"),
        expect(prompt.contains("White shirt"), "expected wardrobe item")
    ].allSatisfy { $0 }
}

func testCoreModelsRoundTripThroughJSON() -> Bool {
    let profile = StyleProfile(
        ageRange: .thirties,
        gender: .female,
        bodyShape: .wave,
        skinTone: .cool,
        hairStyle: .long,
        wearsGlasses: false,
        styleGoal: .polished
    )
    let candidate = CandidateItem(
        name: "Black dress",
        category: .top,
        color: .black,
        formality: .smartCasual,
        pattern: .solid,
        priceJPY: 5990
    )
    let wardrobe = WardrobeItem(
        name: "White sneakers",
        category: .shoes,
        color: .white,
        formality: .casual
    )

    guard
        let profileData = try? JSONEncoder().encode(profile),
        let candidateData = try? JSONEncoder().encode(candidate),
        let wardrobeData = try? JSONEncoder().encode(wardrobe),
        let decodedProfile = try? JSONDecoder().decode(StyleProfile.self, from: profileData),
        let decodedCandidate = try? JSONDecoder().decode(CandidateItem.self, from: candidateData),
        let decodedWardrobe = try? JSONDecoder().decode(WardrobeItem.self, from: wardrobeData)
    else {
        return expect(false, "expected core models to encode and decode")
    }

    return [
        expect(decodedProfile == profile, "expected profile JSON round trip"),
        expect(decodedCandidate == candidate, "expected candidate JSON round trip"),
        expect(decodedWardrobe == wardrobe, "expected wardrobe JSON round trip")
    ].allSatisfy { $0 }
}

let results = [
    testBuyDecisionScoresWardrobeCompatibilityAndScenarioFit(),
    testBuyDecisionRejectsLowFormalityMismatchForWork(),
    testBuyDecisionSuggestsAlternativeColorWhenItemIsUsefulButColorIsRisky(),
    testQuotaAllowsThreeFreeChecksBeforePaywall(),
    testPaidQuotaAllowsChecksWithoutReducingFreeBalance(),
    testAnalysisPromptAvoidsGuaranteesAndIncludesDecisionFrame(),
    testCoreModelsRoundTripThroughJSON()
]

if results.allSatisfy({ $0 }) {
    print("All KauMaeCore tests passed")
} else {
    fatalError("KauMaeCore tests failed")
}
