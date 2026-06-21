import KauMaeCore

extension AgeRange {
    var displayName: String {
        switch self {
        case .twenties: "20代"
        case .thirties: "30代"
        case .forties: "40代"
        case .fifties: "50代"
        }
    }
}

extension Gender {
    var displayName: String {
        switch self {
        case .female: "女性"
        case .male: "男性"
        case .other: "その他"
        }
    }
}

extension BodyShape {
    var displayName: String {
        switch self {
        case .straight: "ストレート"
        case .wave: "ウェーブ"
        case .natural: "ナチュラル"
        }
    }
}

extension SkinTone {
    var displayName: String {
        switch self {
        case .warm: "ウォーム"
        case .cool: "クール"
        case .neutral: "ニュートラル"
        }
    }
}

extension HairStyle {
    var displayName: String {
        switch self {
        case .short: "短髪"
        case .medium: "ミディアム"
        case .long: "ロング"
        }
    }
}

extension StyleGoal {
    var displayName: String {
        switch self {
        case .cleanWork: "清潔感のある仕事服"
        case .polished: "きちんと見える"
        case .softCasual: "やわらかい普段着"
        }
    }
}

extension ItemCategory {
    var displayName: String {
        switch self {
        case .top: "トップス"
        case .bottom: "ボトムス"
        case .outerwear: "アウター"
        case .shoes: "靴"
        }
    }

    var iconName: String {
        switch self {
        case .top: "tshirt"
        case .bottom: "figure.stand"
        case .outerwear: "jacket"
        case .shoes: "shoe"
        }
    }
}

extension ClothingColor {
    var displayName: String {
        switch self {
        case .white: "白"
        case .black: "黒"
        case .gray: "グレー"
        case .navy: "ネイビー"
        case .brown: "ブラウン"
        case .orange: "オレンジ"
        case .mustard: "マスタード"
        }
    }
}

extension Formality {
    var displayName: String {
        switch self {
        case .casual: "カジュアル"
        case .smartCasual: "スマートカジュアル"
        case .businessCasual: "ビジネス寄り"
        }
    }
}

extension Pattern {
    var displayName: String {
        switch self {
        case .solid: "無地"
        case .logo: "ロゴあり"
        }
    }
}

extension Occasion {
    var displayName: String {
        switch self {
        case .work: "仕事"
        case .weekend: "休日"
        }
    }
}
