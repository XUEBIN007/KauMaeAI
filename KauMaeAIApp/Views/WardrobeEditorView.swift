import SwiftUI
import KauMaeCore

struct WardrobeEditorView: View {
    let wardrobe: [WardrobeItem]
    let onAdd: (WardrobeItem) -> Void
    let onDelete: (IndexSet) -> Void

    @State private var draftName = ""
    @State private var draftCategory: ItemCategory = .top
    @State private var draftColor: ClothingColor = .white
    @State private var draftFormality: Formality = .smartCasual

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("手持ち服")
                    .font(.headline)
                Spacer()
                Text("\(wardrobe.count)点")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            WardrobeSummaryView(wardrobe: wardrobe)

            VStack(spacing: 10) {
                TextField("例: 白シャツ", text: $draftName)
                    .textFieldStyle(.roundedBorder)

                EnumPickerRow(title: "種類", selection: $draftCategory) { $0.displayName }
                EnumPickerRow(title: "色", selection: $draftColor) { $0.displayName }
                EnumPickerRow(title: "きちんと感", selection: $draftFormality) { $0.displayName }

                Button {
                    let trimmedName = draftName.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmedName.isEmpty else { return }
                    onAdd(WardrobeItem(
                        name: trimmedName,
                        category: draftCategory,
                        color: draftColor,
                        formality: draftFormality
                    ))
                    draftName = ""
                } label: {
                    Label("手持ち服に追加", systemImage: "plus.circle.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .disabled(draftName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }

            if wardrobe.isEmpty {
                Text("手持ち服を追加すると、買う前チェックの精度が上がります。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            } else {
                VStack(spacing: 8) {
                    ForEach(Array(wardrobe.enumerated()), id: \.offset) { index, item in
                        WardrobeRow(item: item) {
                            onDelete(IndexSet(integer: index))
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct WardrobeSummaryView: View {
    let wardrobe: [WardrobeItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                SummaryMetric(title: "トップス", value: count(.top))
                SummaryMetric(title: "ボトムス", value: count(.bottom))
                SummaryMetric(title: "靴", value: count(.shoes))
            }

            HStack {
                Label(missingCategoryText, systemImage: missingCategories.isEmpty ? "checkmark.seal" : "exclamationmark.circle")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(missingCategories.isEmpty ? .green : .orange)
                Spacer()
            }
            .padding(10)
            .background(Color(.tertiarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
    }

    private var missingCategories: [ItemCategory] {
        [.top, .bottom, .shoes].filter { count($0) == "0" }
    }

    private var missingCategoryText: String {
        if missingCategories.isEmpty {
            return "買う前チェックに必要な基本カテゴリが揃っています。"
        }
        let names = missingCategories.map(\.displayName).joined(separator: "・")
        return "\(names)を追加すると提案が安定します。"
    }

    private func count(_ category: ItemCategory) -> String {
        String(wardrobe.filter { $0.category == category }.count)
    }
}

private struct SummaryMetric: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title3.weight(.bold))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

private struct WardrobeRow: View {
    let item: WardrobeItem
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: item.category.iconName)
                .frame(width: 28, height: 28)
                .foregroundStyle(.blue)
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.subheadline.weight(.semibold))
                Text("\(item.color.displayName) / \(item.formality.displayName)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundStyle(.red)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("削除")
        }
        .padding(10)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}
