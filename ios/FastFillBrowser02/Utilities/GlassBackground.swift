import SwiftUI

/// Centralized Liquid Glass styling helpers.
///
/// On iOS 26+ (the design language carried forward into iOS 27) these use the
/// native `glassEffect` API for the refreshed translucent depth/edge treatment.
/// On iOS 18–25 they fall back cleanly to `Material` so the app keeps a polished
/// classic look without any visual breakage.
extension View {
    /// Applies a rounded Liquid Glass surface, falling back to a material fill
    /// inside the same rounded shape on older systems.
    @ViewBuilder
    func glassSurface(
        cornerRadius: CGFloat = 18,
        fallbackMaterial: Material = .ultraThinMaterial
    ) -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect(.regular, in: .rect(cornerRadius: cornerRadius))
        } else {
            self.background(fallbackMaterial, in: .rect(cornerRadius: cornerRadius))
        }
    }

    /// Applies an interactive (tap-reactive) Liquid Glass capsule, used for
    /// floating pills and toolbars. Falls back to a material capsule.
    @ViewBuilder
    func glassCapsule(
        interactive: Bool = false,
        tint: Color? = nil,
        fallbackMaterial: Material = .ultraThinMaterial
    ) -> some View {
        if #available(iOS 26.0, *) {
            let effect: Glass = {
                let base: Glass = interactive ? .regular.interactive() : .regular
                if let tint { return base.tint(tint) }
                return base
            }()
            self.glassEffect(effect, in: .capsule)
        } else {
            self.background(
                (tint ?? Color.clear).opacity(tint == nil ? 0 : 0.18),
                in: .capsule
            )
            .background(fallbackMaterial, in: .capsule)
        }
    }
}

/// Wraps content in a `GlassEffectContainer` on iOS 26+ so multiple nearby glass
/// surfaces blend and morph together; a plain passthrough on older systems.
struct GlassGroup<Content: View>: View {
    var spacing: CGFloat = 8
    @ViewBuilder var content: () -> Content

    var body: some View {
        if #available(iOS 26.0, *) {
            GlassEffectContainer(spacing: spacing) { content() }
        } else {
            content()
        }
    }
}
