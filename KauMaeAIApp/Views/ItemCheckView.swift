import SwiftUI
import KauMaeCore
import PhotosUI

struct ItemCheckView: View {
    let candidate: CandidateItem
    @Binding var selectedPhoto: PhotosPickerItem?
    let onCheck: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            PhotoInputView(selectedPhoto: $selectedPhoto, hasPhoto: selectedPhoto != nil)

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("チェックする服")
                        .font(.headline)
                    Text("Navy jacket")
                        .font(.title3.weight(.semibold))
                    Text("¥\(candidate.priceJPY)")
                        .foregroundStyle(.secondary)
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
}
