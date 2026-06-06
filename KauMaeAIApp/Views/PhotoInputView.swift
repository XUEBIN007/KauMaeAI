import PhotosUI
import SwiftUI

struct PhotoInputView: View {
    @Binding var selectedPhoto: PhotosPickerItem?
    let hasPhoto: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("商品写真")
                .font(.headline)

            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                HStack {
                    Image(systemName: hasPhoto ? "photo.fill" : "photo.badge.plus")
                        .font(.title2)
                    VStack(alignment: .leading, spacing: 3) {
                        Text(hasPhoto ? "写真を選択済み" : "写真を選ぶ")
                            .font(.subheadline.weight(.semibold))
                        Text("店舗やネットショップの商品写真を使えます。")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding(12)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(.plain)
        }
    }
}
