import XCTest
@testable import PhotoQRLogger

final class PINTests: XCTestCase {
    func testPINStorageAndValidation() {
        let keychain = KeychainWrapper.shared
        keychain.delete("userPIN")

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
}
