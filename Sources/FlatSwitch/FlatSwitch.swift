import Foundation
import SwiftUI

/// Describes how the switch should look in a particular state.
public struct FlatSwitchState {
    public var background: Color
    public var borderColor: Color
    public var title: String
    public var titleColor: Color
    public var thumbColor: Color
    public var thumbIcon: FlatSwitchIcon
    public var thumbShadowX: CGFloat

    public init(
        background: Color,
        borderColor: Color,
        title: String,
        titleColor: Color,
        thumbColor: Color,
        thumbIcon: FlatSwitchIcon = .system(name: "checkmark"),
        thumbShadowX: CGFloat = -2
    ) {
        self.background = background
        self.borderColor = borderColor
        self.title = title
        self.titleColor = titleColor
        self.thumbColor = thumbColor
        self.thumbIcon = thumbIcon
        self.thumbShadowX = thumbShadowX
    }
}

/// Wraps on/off styling plus sizing and animation options.
public struct FlatSwitchConfiguration {
    public var onState: FlatSwitchState
    public var offState: FlatSwitchState
    public var height: CGFloat
    public var width: CGFloat
    public var borderWidth: CGFloat
    public var thumbInset: CGFloat
    public var thumbShadow: Color
    public var thumbShadowRadius: CGFloat
    public var thumbShadowOpacity: Double
    public var font: Font
    public var animation: Animation
    public var disabledOpacity: Double
    public var titlePadding: CGFloat
    public var accessibilityLabel: String?

    public init(
        onState: FlatSwitchState,
        offState: FlatSwitchState,
        height: CGFloat = 44,
        width: CGFloat = 88,
        borderWidth: CGFloat = 2,
        thumbInset: CGFloat = 4,
        thumbShadow: Color = .black,
        thumbShadowRadius: CGFloat = 4,
        thumbShadowOpacity: Double = 0.3,
        font: Font = .system(size: 15, weight: .semibold, design: .rounded),
        animation: Animation = .spring(response: 0.25, dampingFraction: 0.8),
        disabledOpacity: Double = 0.45,
        titlePadding: CGFloat = 12,
        accessibilityLabel: String? = nil
    ) {
        self.onState = onState
        self.offState = offState
        self.height = height
        self.width = width
        self.borderWidth = borderWidth
        self.thumbInset = thumbInset
        self.thumbShadow = thumbShadow
        self.thumbShadowRadius = thumbShadowRadius
        self.thumbShadowOpacity = thumbShadowOpacity
        self.font = font
        self.animation = animation
        self.disabledOpacity = disabledOpacity
        self.titlePadding = titlePadding
        self.accessibilityLabel = accessibilityLabel
    }

    /// Matches the legacy FlatSwitch defaults.
    public static var `default`: FlatSwitchConfiguration {
        .init(
            onState: FlatSwitchState(
                background: Color.teal.opacity(0.9),
                borderColor: Color.teal,
                title: "On",
                titleColor: .white,
                thumbColor: Color.teal,
                thumbIcon: .system(name: "checkmark"),
                thumbShadowX: -2
            ),
            offState: FlatSwitchState(
                background: Color.gray.opacity(0.12),
                borderColor: Color.gray.opacity(0.35),
                title: "Off",
                titleColor: Color.gray,
                thumbColor: Color.gray.opacity(0.55),
                thumbIcon: .system(name: "xmark"),
                thumbShadowX: 2
            ),
            height: 44,
            width: 96,
            borderWidth: 2
        )
    }
}

/// A SwiftUI reimagining of the original FlatSwitch control.
public struct FlatSwitch: View {
    @Binding private var isOn: Bool
    private let configuration: FlatSwitchConfiguration
    private let label: String?

    public init(
        _ title: String? = nil,
        isOn: Binding<Bool>,
        configuration: FlatSwitchConfiguration = .default
    ) {
        self.label = title
        self._isOn = isOn
        self.configuration = configuration
    }

    public var body: some View {
        FlatSwitchBody(
            label: label,
            isOn: $isOn,
            configuration: configuration
        )
    }
}

private struct FlatSwitchBody: View {
    let label: String?
    @Binding var isOn: Bool
    let configuration: FlatSwitchConfiguration
    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        Button {
            guard isEnabled else { return }
            withAnimation(configuration.animation) {
                isOn.toggle()
            }
        } label: {
            GeometryReader { proxy in
                let state = isOn ? configuration.onState : configuration.offState
                let cornerRadius = proxy.size.height / 2
                let thumbSize = proxy.size.height - (configuration.thumbInset * 2)

                ZStack {
                    Capsule()
                        .fill(state.background)
                    Capsule()
                        .stroke(state.borderColor, lineWidth: configuration.borderWidth)

                    Text(state.title)
                        .font(configuration.font)
                        .foregroundColor(state.titleColor)
                        .padding(.horizontal, configuration.titlePadding)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    HStack {
                        if isOn { Spacer(minLength: 0) }
                        FlatSwitchThumb(
                            state: state,
                            thumbSize: thumbSize,
                            shadowColor: configuration.thumbShadow,
                            shadowRadius: configuration.thumbShadowRadius,
                            shadowOpacity: configuration.thumbShadowOpacity
                        )
                        if !isOn { Spacer(minLength: 0) }
                    }
                    .padding(.horizontal, configuration.thumbInset)
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            }
        }
        .buttonStyle(.plain)
        .frame(width: configuration.width, height: configuration.height)
        .contentShape(Rectangle())
        .opacity(isEnabled ? 1 : configuration.disabledOpacity)
        .accessibilityLabel(label ?? configuration.accessibilityLabel ?? "Flat switch")
        .accessibilityValue(isOn ? configuration.onState.title : configuration.offState.title)
        .accessibilityAddTraits(.isButton)
    }
}

private struct FlatSwitchThumb: View {
    let state: FlatSwitchState
    let thumbSize: CGFloat
    let shadowColor: Color
    let shadowRadius: CGFloat
    let shadowOpacity: Double

    var body: some View {
        Circle()
            .fill(state.thumbColor)
            .frame(width: thumbSize, height: thumbSize)
            .shadow(
                color: shadowColor.opacity(shadowOpacity),
                radius: shadowRadius,
                x: state.thumbShadowX,
                y: 0
            )
            .overlay(
                Group {
                    if let image = state.thumbIcon.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(Color.white)
                            .padding(thumbSize * 0.25)
                    }
                }
            )
            .accessibilityHidden(true)
    }
}

/// Supported icon sources for the thumb.
public enum FlatSwitchIcon {
    case system(name: String)
    case asset(name: String, bundle: Bundle? = nil)
    case none

    var image: Image? {
        switch self {
        case .system(let name):
            return Image(systemName: name)
        case let .asset(name, bundle):
            return Image(name, bundle: bundle ?? .main)
        case .none:
            return nil
        }
    }
}

#if DEBUG
struct FlatSwitch_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var isOn = true

        var body: some View {
            VStack(spacing: 24) {
                FlatSwitch("Wi‑Fi", isOn: $isOn)
                FlatSwitch("Custom", isOn: $isOn, configuration: .init(
                    onState: .init(
                        background: Color.indigo.opacity(0.9),
                        borderColor: Color.indigo,
                        title: "Enabled",
                        titleColor: .white,
                        thumbColor: Color.indigo,
                        thumbIcon: .system(name: "bolt.fill"),
                        thumbShadowX: -2
                    ),
                    offState: .init(
                        background: Color.gray.opacity(0.16),
                        borderColor: Color.gray.opacity(0.4),
                        title: "Disabled",
                        titleColor: Color.gray,
                        thumbColor: Color.gray.opacity(0.45),
                        thumbIcon: .system(name: "bolt.slash"),
                        thumbShadowX: 2
                    ),
                    height: 52,
                    width: 120,
                    borderWidth: 1.5,
                    thumbInset: 6,
                    animation: .easeInOut(duration: 0.2)
                ))
                .disabled(true)
            }
            .padding()
            .previewLayout(.sizeThatFits)
        }
    }

    static var previews: some View {
        PreviewWrapper()
    }
}
#endif
