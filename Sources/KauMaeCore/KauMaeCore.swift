public enum AgeRange: String, CaseIterable, Codable, Sendable {
    case twenties
    case thirties
    case forties
    case fifties
}

public enum Gender: String, CaseIterable, Codable, Sendable {
    case female
    case male
    case other
}

public enum BodyShape: String, CaseIterable, Codable, Sendable {
    case straight
    case wave
    case natural
}

public enum SkinTone: String, CaseIterable, Codable, Sendable {
    case warm
    case cool
    case neutral
}

public enum HairStyle: String, CaseIterable, Codable, Sendable {
    case short
    case medium
    case long
}

public enum StyleGoal: String, CaseIterable, Codable, Sendable {
    case cleanWork
    case polished
    case softCasual
}

public enum ItemCategory: String, CaseIterable, Codable, Sendable {
    case top
    case bottom
    case outerwear
    case shoes
}

public enum ClothingColor: String, CaseIterable, Codable, Sendable {
    case white
    case black
    case gray
    case navy
    case brown
    case orange
    case mustard
}

public enum Formality: Int, CaseIterable, Codable, Sendable {
    case casual = 0
    case smartCasual = 1
    case businessCasual = 2
}

public enum Pattern: String, CaseIterable, Codable, Sendable {
    case solid
    case logo
}

public enum Occasion: String, CaseIterable, Codable, Sendable {
    case work
    case weekend
}

public enum BuyDecision: String, CaseIterable, Codable, Sendable {
    case buy
    case skip
    case tryDifferentColor
}

public struct StyleProfile: Codable, Equatable, Sendable {
    public let ageRange: AgeRange
    public let gender: Gender
    public let bodyShape: BodyShape
    public let skinTone: SkinTone
    public let hairStyle: HairStyle
    public let wearsGlasses: Bool
    public let styleGoal: StyleGoal

    public init(
        ageRange: AgeRange,
        gender: Gender,
        bodyShape: BodyShape,
        skinTone: SkinTone,
        hairStyle: HairStyle,
        wearsGlasses: Bool,
        styleGoal: StyleGoal
    ) {
        self.ageRange = ageRange
        self.gender = gender
        self.bodyShape = bodyShape
        self.skinTone = skinTone
        self.hairStyle = hairStyle
        self.wearsGlasses = wearsGlasses
        self.styleGoal = styleGoal
    }
}

public struct WardrobeItem: Codable, Equatable, Sendable {
    public let name: String
    public let category: ItemCategory
    public let color: ClothingColor
    public let formality: Formality

    public init(name: String, category: ItemCategory, color: ClothingColor, formality: Formality) {
        self.name = name
        self.category = category
        self.color = color
        self.formality = formality
    }
}

public struct CandidateItem: Codable, Equatable, Sendable {
    public let name: String
    public let category: ItemCategory
    public let color: ClothingColor
    public let formality: Formality
    public let pattern: Pattern
    public let priceJPY: Int

    public init(
        name: String,
        category: ItemCategory,
        color: ClothingColor,
        formality: Formality,
        pattern: Pattern,
        priceJPY: Int
    ) {
        self.name = name
        self.category = category
        self.color = color
        self.formality = formality
        self.pattern = pattern
        self.priceJPY = priceJPY
    }
}

public struct StyleAdvice: Codable, Equatable, Sendable {
    public let score: Int
    public let decision: BuyDecision
    public let headline: String
    public let reasons: [String]
    public let suggestedOutfit: [String]
    public let alternativeColor: ClothingColor?
}

public struct StyleAdvisor: Sendable {
    public init() {}

    public func evaluate(
        candidate: CandidateItem,
        profile: StyleProfile,
        wardrobe: [WardrobeItem],
        occasion: Occasion
    ) -> StyleAdvice {
        var score = 64
        var reasons: [String] = []

        if occasion == .work && candidate.formality.rawValue < Formality.businessCasual.rawValue {
            score -= 24
            reasons.append("仕事用としてはカジュアル感が強すぎます。")
        }

        let compatibleItems = suggestedOutfit(for: candidate, wardrobe: wardrobe)
        if compatibleItems.count >= 2 {
            score += 18
        }
        if compatibleItems.map(\.name).contains("White shirt"),
           compatibleItems.map(\.name).contains("Gray trousers") {
            reasons.append("手持ちの白シャツ・グレーパンツと着回しやすいです。")
        }

        if candidate.formality == .businessCasual && occasion == .work {
            score += 10
        }
        if candidate.pattern == .logo && occasion == .work {
            score -= 8
        }
        if candidate.color == .navy {
            score += 8
        }

        if shouldSuggestNavyInstead(candidate: candidate, profile: profile) {
            return StyleAdvice(
                score: min(max(score, 0), 79),
                decision: .tryDifferentColor,
                headline: "色違いがおすすめ",
                reasons: ["形は使いやすいですが、肌色にはネイビーの方がなじみます。"],
                suggestedOutfit: compatibleItems.map(\.name),
                alternativeColor: .navy
            )
        }

        let finalScore = min(max(score, 0), 100)
        let decision: BuyDecision = finalScore >= 75 ? .buy : .skip
        let headline = decision == .buy ? "買ってOK" : "今回は見送り"

        return StyleAdvice(
            score: finalScore,
            decision: decision,
            headline: headline,
            reasons: reasons.isEmpty ? ["手持ち服との相性をもう少し確認しましょう。"] : reasons,
            suggestedOutfit: compatibleItems.map(\.name),
            alternativeColor: nil
        )
    }

    private func suggestedOutfit(for candidate: CandidateItem, wardrobe: [WardrobeItem]) -> [WardrobeItem] {
        let neededCategories: [ItemCategory]
        switch candidate.category {
        case .top:
            neededCategories = [.bottom, .shoes]
        case .bottom:
            neededCategories = [.top, .shoes]
        case .outerwear:
            neededCategories = [.top, .bottom, .shoes]
        case .shoes:
            neededCategories = [.top, .bottom]
        }

        return neededCategories.compactMap { category in
            wardrobe.first { $0.category == category }
        }
    }

    private func shouldSuggestNavyInstead(candidate: CandidateItem, profile: StyleProfile) -> Bool {
        profile.skinTone == .cool && candidate.color == .mustard
    }
}

public enum CheckAccessResult: Equatable, Sendable {
    case allowed(remaining: Int?)
    case requiresPayment
}

public struct CheckQuota: Codable, Equatable, Sendable {
    public private(set) var remainingFreeChecks: Int
    public private(set) var isPaid: Bool

    public static func freeTrial(limit: Int) -> CheckQuota {
        CheckQuota(remainingFreeChecks: max(limit, 0), isPaid: false)
    }

    public static func paid(remainingFreeChecks: Int) -> CheckQuota {
        CheckQuota(remainingFreeChecks: max(remainingFreeChecks, 0), isPaid: true)
    }

    public init(remainingFreeChecks: Int, isPaid: Bool) {
        self.remainingFreeChecks = max(remainingFreeChecks, 0)
        self.isPaid = isPaid
    }

    public mutating func consumeCheck() -> CheckAccessResult {
        if isPaid {
            return .allowed(remaining: nil)
        }
        guard remainingFreeChecks > 0 else {
            return .requiresPayment
        }
        remainingFreeChecks -= 1
        return .allowed(remaining: remainingFreeChecks)
    }
}

public struct StyleAnalysisRequest: Equatable, Sendable {
    public let profile: StyleProfile
    public let candidate: CandidateItem
    public let wardrobe: [WardrobeItem]
    public let occasion: Occasion
    public let userQuestion: String

    public init(
        profile: StyleProfile,
        candidate: CandidateItem,
        wardrobe: [WardrobeItem],
        occasion: Occasion,
        userQuestion: String
    ) {
        self.profile = profile
        self.candidate = candidate
        self.wardrobe = wardrobe
        self.occasion = occasion
        self.userQuestion = userQuestion
    }
}

public struct StylePromptBuilder: Sendable {
    public init() {}

    public func makeJapanesePrompt(for request: StyleAnalysisRequest) -> String {
        let wardrobeNames = request.wardrobe.map(\.name).joined(separator: ", ")
        return """
        あなたは日本市場向けのファッション判断アシスタントです。
        目的は「買う前の判断サポート」です。ユーザーに、買ってOK / 見送り / 色違いおすすめ のいずれかを明確に提案してください。

        ユーザー質問:
        \(request.userQuestion)

        ユーザー条件:
        年代=\(request.profile.ageRange.rawValue), 性別=\(request.profile.gender.rawValue), 体型=\(request.profile.bodyShape.rawValue), 肌色=\(request.profile.skinTone.rawValue), 髪型=\(request.profile.hairStyle.rawValue), メガネ=\(request.profile.wearsGlasses ? "あり" : "なし"), 目標=\(request.profile.styleGoal.rawValue)

        チェックする服:
        名前=\(request.candidate.name), 種類=\(request.candidate.category.rawValue), 色=\(request.candidate.color.rawValue), 場面のきちんと感=\(request.candidate.formality.rawValue), 柄=\(request.candidate.pattern.rawValue), 価格=\(request.candidate.priceJPY)円

        手持ち服:
        \(wardrobeNames.isEmpty ? "未登録" : wardrobeNames)

        場面:
        \(request.occasion.rawValue)

        出力:
        1. おすすめ度を0-100点で出す
        2. 買ってOK / 見送り / 色違いおすすめ の判断
        3. 理由を3つ以内
        4. 手持ち服との合わせ方
        5. 必要なら別の色や形を提案

        注意:
        サイズや購入結果を保証しない。身体的特徴を否定的に表現しない。ブランド名や価格を根拠に過度な断定をしない。
        """
    }
}
