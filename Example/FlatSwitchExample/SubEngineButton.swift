import SwiftUI
import FlatSwitch

struct SubEngineButton: View {
    let label: String
    let onTitle: String
    let offTitle: String
    @Binding var isOn: Bool
    let isParentOn: Bool
    let isLocked: Bool
    let onToggled: () -> Void

    var body: some View {
        FlatSwitch(label, isOn: $isOn, configuration: .init(
            onState: .init(
                background: ExampleColors.subOnBackground,
                borderColor: ExampleColors.subOnBorder,
                title: onTitle,
                titleColor: ExampleColors.subOnTitle,
                thumbColor: ExampleColors.subOnThumb,
                thumbIcon: ExampleIcons.subOn,
                thumbShadowX: -3
            ),
            offState: .init(
                background: ExampleColors.subOffBackground,
                borderColor: ExampleColors.subOffBorder,
                title: offTitle,
                titleColor: ExampleColors.subOffTitle,
                thumbColor: ExampleColors.subOffThumb,
                thumbIcon: ExampleIcons.subOff,
                thumbShadowX: 3
            ),
            height: 52,
            width: 260
        ))
        .disabled(isParentOn || isLocked)
        .padding(.horizontal)
        .onChange(of: isOn) { _, _ in
            onToggled()
        }
    }
}
