import SwiftUI
import KauMaeCore

struct CheckHistoryView: View {
    let history: [CheckHistoryEntry]
    let onReuse: ((CheckHistoryEntry) -> Void)?

    init(history: [CheckHistoryEntry], onReuse: ((CheckHistoryEntry) -> Void)? = nil) {
        self.history = history
        self.onReuse = onReuse
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("チェック履歴")
                    .font(.headline)
                Spacer()
                Text("\(history.count)件")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            if history.isEmpty {
                Text("チェックすると、ここに買う前判断の記録が残ります。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            } else {
                VStack(spacing: 8) {
                    ForEach(history.prefix(5)) { entry in
                        HistoryRow(entry: entry, onReuse: onReuse)
                    }
                }
            }
        }
        .padding(16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct HistoryRow: View {
    let entry: CheckHistoryEntry
    let onReuse: ((CheckHistoryEntry) -> Void)?

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(alignment: .leading, spacing: 3) {
                Text(entry.candidate.name)
                    .font(.subheadline.weight(.semibold))
                Text("\(entry.occasion.displayName) / \(entry.candidate.color.displayName) / \(entry.candidate.category.displayName)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 3) {
                Text("\(entry.advice.score)点")
                    .font(.headline)
                    .foregroundStyle(scoreColor)
                Text(entry.advice.headline)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                if let onReuse {
                    Button("再チェック") {
                        onReuse(entry)
                    }
                    .font(.caption.weight(.semibold))
                    .buttonStyle(.plain)
                    .foregroundStyle(.blue)
                }
            }
        }
        .padding(10)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }

    private var scoreColor: Color {
        entry.advice.score >= 75 ? .green : .orange
    }
}
