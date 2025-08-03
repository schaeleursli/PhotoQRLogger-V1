import XCTest
@testable import PhotoQRLogger

final class PINTests: XCTestCase {
    func testPINStorageAndValidation() {
        // Ensure a clean state
        KeychainHelper.delete(key: "userPIN")

        let authManager = AuthManager()
        authManager.saveNewPin("1234")

        authManager.enteredPin = "1234"
        authManager.checkPIN()
        XCTAssertTrue(authManager.isUnlocked)

        authManager.isUnlocked = false
        authManager.enteredPin = "0000"
        authManager.checkPIN()
        XCTAssertFalse(authManager.isUnlocked)
        XCTAssertEqual(authManager.authError, "Incorrect PIN. Try again.")
    }

    func testInvalidPINRejected() {
        KeychainHelper.delete(key: "userPIN")

        let authManager = AuthManager()
        authManager.saveNewPin("12ab")

        XCTAssertNil(KeychainHelper.load(key: "userPIN"))
        XCTAssertEqual(authManager.authError, "PIN must be 4 numeric digits.")
    }

    func testCheckPINWithNoStoredPIN() {
        KeychainHelper.delete(key: "userPIN")

        let authManager = AuthManager()
        authManager.enteredPin = "1234"
        authManager.checkPIN()
        XCTAssertFalse(authManager.isUnlocked)
        XCTAssertEqual(authManager.authError, "No PIN set.")
    }
}
