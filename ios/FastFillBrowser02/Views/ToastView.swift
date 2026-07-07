import SwiftUI

struct ToastView: View {
    let message: String

    var body: some View {
        Text(message)
            .font(.subheadline.weight(.medium))
            .foregroundStyle(.primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .glassCapsule(fallbackMaterial: .ultraThinMaterial)
            .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
    }
}
