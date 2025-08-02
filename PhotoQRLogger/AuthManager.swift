import LocalAuthentication
import SwiftUI

class AuthManager: ObservableObject {
    @Published var isUnlocked = false
    @Published var shouldLock = false
    @Published var authError: String?
    @Published var showPinPrompt = false
    @Published var enteredPin = ""

    private let correctPin = UserDefaults.standard.string(forKey: "userPIN") ?? "1234"

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
                        self.showPinPrompt = true
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.showPinPrompt = true
            }
        }
    }

    func checkPIN() {
        if enteredPin == correctPin {
            isUnlocked = true
        } else {
            authError = "Incorrect PIN. Try again."
        }
    }

    func saveNewPin(_ pin: String) {
        UserDefaults.standard.set(pin, forKey: "userPIN")
    }
}