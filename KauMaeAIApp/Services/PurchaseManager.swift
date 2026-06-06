import Foundation
import StoreKit

@MainActor
@Observable
final class PurchaseManager {
    static let proMonthlyProductID = "kaumae.pro.monthly"
    static let tenChecksProductID = "kaumae.checks.10"
    static let tenImagesProductID = "kaumae.images.10"

    private(set) var products: [Product] = []
    private(set) var isProUnlocked = false
    private(set) var purchaseErrorMessage: String?

    func loadProducts() async {
        do {
            products = try await Product.products(for: [
                Self.proMonthlyProductID,
                Self.tenChecksProductID,
                Self.tenImagesProductID
            ])
        } catch {
            purchaseErrorMessage = "商品情報を読み込めませんでした。時間をおいて再度お試しください。"
        }
    }

    func purchasePro() async {
        guard let product = products.first(where: { $0.id == Self.proMonthlyProductID }) else {
            purchaseErrorMessage = "Proプランは現在準備中です。"
            return
        }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified = verification {
                    isProUnlocked = true
                } else {
                    purchaseErrorMessage = "購入を確認できませんでした。"
                }
            case .pending:
                purchaseErrorMessage = "購入は保留中です。"
            case .userCancelled:
                purchaseErrorMessage = nil
            @unknown default:
                purchaseErrorMessage = "購入を完了できませんでした。"
            }
        } catch {
            purchaseErrorMessage = "購入処理に失敗しました。"
        }
    }
}
