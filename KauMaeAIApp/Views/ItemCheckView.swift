import SwiftUI
import KauMaeCore
import PhotosUI

struct ItemCheckView: View {
    @Binding var candidate: CandidateItem
    @Binding var occasion: Occasion
    @Binding var selectedPhoto: PhotosPickerItem?
    let onCheck: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            PhotoInputView(selectedPhoto: $selectedPhoto, hasPhoto: selectedPhoto != nil)

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
