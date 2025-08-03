import LocalAuthentication
import SwiftUI

class AuthManager: ObservableObject {
    @Published var isUnlocked = false
    @Published var shouldLock = false
    @Published var authError: String?
    @Published var showPinPrompt = false
    @Published var enteredPin = ""

    private var correctPin: String? {
        KeychainHelper.load(key: "userPIN")
    }

    func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Unlock PhotoQRLogger"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, err in
                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                    } else {
                        self.authError = err?.localizedDescription
                        self.showPinPrompt = true
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.authError = error?.localizedDescription
                self.showPinPrompt = true
            }
        }
    }

    func checkPIN() {
        guard let storedPin = correctPin else {
            authError = "No PIN set."
            return
        }
        if enteredPin == storedPin {
            isUnlocked = true
            authError = nil
            enteredPin = ""
        } else {
            authError = "Incorrect PIN. Try again."
        }
    }

    func saveNewPin(_ pin: String) {
        let isValid = pin.count == 4 && pin.allSatisfy { $0.isNumber }
        if isValid {
            if KeychainHelper.save(pin, for: "userPIN") {
                authError = nil
            } else {
                authError = "Failed to save PIN."
            }
        } else {
            authError = "PIN must be 4 numeric digits."
        }
    }
}
