import XCTest
@testable import PhotoQRLogger

final class PINTests: XCTestCase {
    func testPINStorageAndValidation() {
        let pinManager = PINManager()
        pinManager.setPIN("1234")
        XCTAssertTrue(pinManager.validatePIN("1234"))
        XCTAssertFalse(pinManager.validatePIN("0000"))
    }
}