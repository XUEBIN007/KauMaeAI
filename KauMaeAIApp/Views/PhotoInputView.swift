import PhotosUI
import SwiftUI
import UIKit

struct PhotoInputView: View {
    @Binding var selectedPhoto: PhotosPickerItem?
    let selectedPhotoData: Data?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("商品写真")
                .font(.headline)

            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                HStack(spacing: 12) {
                    ProductPhotoThumbnail(data: selectedPhotoData)
                    VStack(alignment: .leading, spacing: 3) {
                        Text(selectedPhotoData == nil ? "写真を選ぶ" : "写真を変更")
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

private struct ProductPhotoThumbnail: View {
    let data: Data?

    var body: some View {
        Group {
            if
                let data,
                let uiImage = UIImage(data: data)
            {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "photo.badge.plus")
                    .font(.title2)
                    .foregroundStyle(.blue)
            }
        }
        .frame(width: 58, height: 58)
        .background(Color(.tertiarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
