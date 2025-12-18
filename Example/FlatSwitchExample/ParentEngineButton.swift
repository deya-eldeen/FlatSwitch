import SwiftUI
import FlatSwitch

struct ParentEngineButton: View {
    @Binding var engineOn: Bool
    @Binding var subengine1On: Bool
    @Binding var subengine3On: Bool
    let animation: Animation
    let isLocked: Bool

    var body: some View {
        FlatSwitch("Engine", isOn: $engineOn, configuration: .init(
            onState: .init(
                background: ExampleColors.engineOnBackground,
                borderColor: ExampleColors.engineOnBorder,
                title: "Engine On",
                titleColor: ExampleColors.engineOnTitle,
                thumbColor: ExampleColors.engineOnThumb,
                thumbIcon: ExampleIcons.engineOn,
                thumbShadowX: -4
            ),
            offState: .init(
                background: ExampleColors.engineOffBackground,
                borderColor: ExampleColors.engineOffBorder,
                title: "Engine Off",
                titleColor: ExampleColors.engineOffTitle,
                thumbColor: ExampleColors.engineOffThumb,
                thumbIcon: ExampleIcons.engineOff,
                thumbShadowX: 4
            ),
            height: 70,
            width: 260,
            borderWidth: 2.5,
            thumbInset: 10
        ))
        .padding(.horizontal)
        .disabled(isLocked)
        .onChange(of: engineOn) { _, isOn in
            withAnimation(animation) {
                if isOn {
                    subengine1On = false
                    subengine3On = false
                } else {
                    subengine1On = true
                }
            }
        }
    }
}
