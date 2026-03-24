import XCTest
@testable import DisturbMyLive

final class DisturbMyLiveTests: XCTestCase {
    func testTriggerKindsContainGift() {
        XCTAssertTrue(TriggerKind.allCases.contains(.gift))
    }

    func testInitialConnectionStateIsIdle() {
        let viewModel = ConnectViewModel()
        XCTAssertEqual(viewModel.connectionState, .idle)
    }
}
