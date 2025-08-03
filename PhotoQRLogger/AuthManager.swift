import LocalAuthentication
import SwiftUI

class AuthManager: ObservableObject {
    @Published var isUnlocked = false
    @Published var shouldLock = false
    @Published var authError: String?
    @Published var showPinPrompt = false
    @Published var enteredPin = ""

    private var correctPin = UserDefaults.standard.string(forKey: "userPIN") ?? "1234"

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
            authError = nil
        } else {
            authError = "Incorrect PIN. Try again."
        }
    }

    func saveNewPin(_ pin: String) {
        let isValid = pin.count == 4 && pin.allSatisfy { $0.isNumber }
        if isValid {
            UserDefaults.standard.set(pin, forKey: "userPIN")
            correctPin = pin
            authError = nil
        } else {
            authError = "PIN must be 4 numeric digits."
        }
    }
}
