import SwiftUI
import XCTest
@testable import FlatSwitch

final class FlatSwitchTests: XCTestCase {
    func testDefaultConfigurationMatchesExpectations() {
        let configuration = FlatSwitchConfiguration.default
        XCTAssertEqual(configuration.onState.title, "On")
        XCTAssertEqual(configuration.offState.title, "Off")
        XCTAssertEqual(configuration.height, 44)
        XCTAssertEqual(configuration.borderWidth, 2)
    }

    func testCustomConfigurationKeepsValues() {
        let on = FlatSwitchState(
            background: .blue,
            borderColor: .blue,
            title: "Yes",
            titleColor: .white,
            thumbColor: .blue,
            thumbIcon: .system(name: "heart.fill"),
            thumbShadowX: -4
        )
        let off = FlatSwitchState(
            background: .gray,
            borderColor: .gray,
            title: "No",
            titleColor: .white,
            thumbColor: .gray,
            thumbIcon: .system(name: "heart.slash"),
            thumbShadowX: 4
        )

        let configuration = FlatSwitchConfiguration(
            onState: on,
            offState: off,
            height: 60,
            width: 140,
            borderWidth: 3,
            thumbInset: 10,
            thumbShadowOpacity: 0.5,
            accessibilityLabel: "Consent switch"
        )

        XCTAssertEqual(configuration.onState.title, "Yes")
        XCTAssertEqual(configuration.offState.title, "No")
        XCTAssertEqual(configuration.width, 140)
        XCTAssertEqual(configuration.thumbInset, 10)
        XCTAssertEqual(configuration.thumbShadowOpacity, 0.5)
        XCTAssertEqual(configuration.accessibilityLabel, "Consent switch")
    }
}
