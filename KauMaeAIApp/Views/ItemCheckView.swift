import SwiftUI
import KauMaeCore
import PhotosUI
import UIKit

struct ItemCheckView: View {
    @Binding var candidate: CandidateItem
    @Binding var occasion: Occasion
    @Binding var selectedPhoto: PhotosPickerItem?
    let selectedPhotoData: Data?
    let onCheck: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            PhotoInputView(
                selectedPhoto: $selectedPhoto,
                selectedPhotoData: selectedPhotoData
            )

            PresetCandidateStrip { preset in
                candidate = preset.item
                occasion = preset.occasion
            }

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("チェックする服")
                        .font(.headline)
                    TextField("例: ユニクロ ネイビージャケット", text: candidateBinding(\.name))
                        .font(.title3.weight(.semibold))
                        .textFieldStyle(.roundedBorder)
                    TextField("価格", value: candidateBinding(\.priceJPY), format: .number)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                }
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.blue.opacity(0.14))
                    Image(systemName: "jacket")
                        .font(.system(size: 42))
                        .foregroundStyle(.blue)
                }
                .frame(width: 86, height: 86)
            }

            VStack(spacing: 10) {
                EnumPickerRow(title: "種類", selection: candidateBinding(\.category)) { $0.displayName }
                EnumPickerRow(title: "色", selection: candidateBinding(\.color)) { $0.displayName }
                EnumPickerRow(title: "きちんと感", selection: candidateBinding(\.formality)) { $0.displayName }
                EnumPickerRow(title: "柄", selection: candidateBinding(\.pattern)) { $0.displayName }
                EnumPickerRow(title: "使う場面", selection: $occasion) { $0.displayName }
            }

            Button(action: onCheck) {
                Label("買う前にチェック", systemImage: "checkmark.seal.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private func candidateBinding<Value>(_ keyPath: KeyPath<CandidateItem, Value>) -> Binding<Value> {
        Binding(
            get: { candidate[keyPath: keyPath] },
            set: { candidate = candidate.replacing(keyPath, with: $0) }
        )
    }
}

private struct PresetCandidate {
    let title: String
    let item: CandidateItem
    let occasion: Occasion
}

private struct PresetCandidateStrip: View {
    let onSelect: (PresetCandidate) -> Void

    private let presets = [
        PresetCandidate(
            title: "通勤ジャケット",
            item: CandidateItem(name: "Navy jacket", category: .outerwear, color: .navy, formality: .businessCasual, pattern: .solid, priceJPY: 7990),
            occasion: .work
        ),
        PresetCandidate(
            title: "休日カーディガン",
            item: CandidateItem(name: "Mustard cardigan", category: .outerwear, color: .mustard, formality: .smartCasual, pattern: .solid, priceJPY: 4990),
            occasion: .weekend
        ),
        PresetCandidate(
            title: "ロゴT",
            item: CandidateItem(name: "Logo T-shirt", category: .top, color: .white, formality: .casual, pattern: .logo, priceJPY: 1990),
            occasion: .weekend
        )
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("すぐ試す")
                .font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(presets, id: \.title) { preset in
                        Button {
                            onSelect(preset)
                        } label: {
                            Text(preset.title)
                                .font(.subheadline.weight(.semibold))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color(.secondarySystemGroupedBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

private extension CandidateItem {
    func replacing<Value>(_ keyPath: KeyPath<CandidateItem, Value>, with value: Value) -> CandidateItem {
        CandidateItem(
            name: keyPath == \CandidateItem.name ? value as! String : name,
            category: keyPath == \CandidateItem.category ? value as! ItemCategory : category,
            color: keyPath == \CandidateItem.color ? value as! ClothingColor : color,
            formality: keyPath == \CandidateItem.formality ? value as! Formality : formality,
            pattern: keyPath == \CandidateItem.pattern ? value as! Pattern : pattern,
            priceJPY: keyPath == \CandidateItem.priceJPY ? value as! Int : priceJPY
        )
    }
}
