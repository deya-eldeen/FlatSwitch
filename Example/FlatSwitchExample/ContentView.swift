import SwiftUI
import FlatSwitch

struct ContentView: View {
    @Binding var engineOn: Bool
    @Binding var subengine1On: Bool
    @Binding var subengine3On: Bool
    @State private var lockSwitch = false
    @State private var isLocked = false
    @State private var unlockPassword = ""
    @State private var lockError: String?

    private let autoAnimation = Animation.spring(response: 0.25, dampingFraction: 0.8)

    private var fuelUsage: Int {
        if engineOn { return 100 }
        let activeSubs = [subengine1On, subengine3On].filter { $0 }.count
        switch activeSubs {
        case 2: return 70
        case 1: return 35
        default: return 0
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 28) {
                ParentEngineButton(
                    engineOn: $engineOn,
                    subengine1On: $subengine1On,
                    subengine3On: $subengine3On,
                    animation: autoAnimation,
                    isLocked: isLocked
                )

                VStack(spacing: 20) {
                    SubEngineButton(
                        label: "Subengine 1",
                        onTitle: "Subengine 1 On",
                        offTitle: "Subengine 1 Off",
                        isOn: $subengine1On,
                        isParentOn: engineOn,
                        isLocked: isLocked,
                        onToggled: ensureParentIfSubsOff
                    )

                    SubEngineButton(
                        label: "Subengine 2",
                        onTitle: "Subengine 2 On",
                        offTitle: "Subengine 2 Off",
                        isOn: $subengine3On,
                        isParentOn: engineOn,
                        isLocked: isLocked,
                        onToggled: ensureParentIfSubsOff
                    )

                    Text("Fuel Usage: \(fuelUsage)%")
                        .font(.headline)
                        .padding(.top, 8)
                }
                .opacity(isLocked ? 0.55 : 1)

                Spacer()

                VStack(spacing: 12) {
                    FlatSwitch("Lock Controls", isOn: $lockSwitch, configuration: .init(
                        onState: .init(
                            background: Color.red.opacity(0.9),
                            borderColor: .red,
                            title: "Locked",
                            titleColor: .white,
                            thumbColor: .white,
                            thumbIcon: .system(name: "lock.fill"),
                            thumbShadowX: -3
                        ),
                        offState: .init(
                            background: Color.green.opacity(0.9),
                            borderColor: .green,
                            title: "Unlocked",
                            titleColor: .white,
                            thumbColor: .white,
                            thumbIcon: .system(name: "lock.open"),
                            thumbShadowX: 3
                        ),
                        height: 46,
                        width: 180,
                        borderWidth: 2
                    ))
                    .padding(.horizontal)
                    .onChange(of: lockSwitch) { _, locked in
                        if locked {
                            lockError = nil
                            isLocked = true
                        } else {
                            if unlockPassword == "0000" {
                                lockError = nil
                                isLocked = false
                            } else {
                                lockError = "Incorrect password"
                                lockSwitch = true
                                isLocked = true
                            }
                        }
                    }

                    if isLocked {
                        VStack(alignment: .leading, spacing: 6) {
                            SecureField("Unlock password", text: $unlockPassword)
                                .textFieldStyle(.roundedBorder)
                            if let lockError {
                                Text(lockError)
                                    .foregroundColor(.red)
                                    .font(.footnote)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding()
            .navigationTitle("Engine Room")
        }
    }

    private func ensureParentIfSubsOff() {
        guard !engineOn && !subengine1On && !subengine3On else { return }
        withAnimation(autoAnimation) {
            engineOn = true
        }
    }
}

#Preview {
    ContentView(
        engineOn: .constant(false),
        subengine1On: .constant(true),
        subengine3On: .constant(false)
    )
}
