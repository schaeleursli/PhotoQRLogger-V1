import SwiftUI

struct AuthGateView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var authManager = AuthManager()

    var body: some View {
        Group {
            if authManager.isUnlocked {
                MainAppView() // Replace with your actual app view
            } else {
                VStack(spacing: 24) {
                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 64))
                        .foregroundColor(.blue)

                    Button("Unlock with Face ID / Touch ID") {
                        authManager.authenticate()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    if let error = authManager.authError {
                        Text(error)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                }
                .sheet(isPresented: $authManager.showPinPrompt) {
                    VStack(spacing: 16) {
                        Text("Enter your PIN")
                            .font(.headline)

                        SecureField("PIN", text: $authManager.enteredPin)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)

                        Button("Unlock") {
                            authManager.checkPIN()
                        }
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)

                        Button("Cancel") {
                            authManager.showPinPrompt = false
                        }
                        .foregroundColor(.red)
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            authManager.authenticate()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background {
                authManager.shouldLock = true
            } else if newPhase == .active && authManager.shouldLock {
                authManager.isUnlocked = false
                authManager.shouldLock = false
                authManager.authenticate()
            }
        }
    }
}
