import XCTest

@testable import DisturbMyLive

final class DisturbMyLiveTests: XCTestCase {
    func testTriggerKindsContainGift() {
        XCTAssertTrue(TriggerKind.allCases.contains(.gift))
    }

    @MainActor
    func testInitialConnectionStateIsIdle() {
        let viewModel = ConnectViewModel()
        let state = viewModel.connectionState

        switch state {
        case .idle:
            XCTAssertTrue(true)
        default:
            XCTFail("Expected idle state, got \(state)")
        }
    }
}
