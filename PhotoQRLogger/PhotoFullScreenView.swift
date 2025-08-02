import SwiftUI

struct PhotoFullScreenView: View {
    let imageURL: URL
    let onDelete: (() -> Void)?

    @Environment(\.dismiss) var dismiss
    @State private var image: UIImage? = nil

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if let img = image {
                ZoomableScrollView {
                    Image(uiImage: img)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            } else {
                ProgressView("Loading...")
            }

            VStack {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Button(action: share) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                    Button(role: .destructive, action: {
                        delete()
                        dismiss()
                    }) {
                        Image(systemName: "trash")
                            .font(.system(size: 24))
                            .foregroundColor(.red)
                    }
                }
                .padding()
                Spacer()
            }
        }
        .onAppear {
            loadImage()
        }
    }

    func loadImage() {
        if let data = try? Data(contentsOf: imageURL) {
            image = UIImage(data: data)
        }
    }

    func share() {
        guard let img = image else { return }
        let activityVC = UIActivityViewController(activityItems: [img], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true)
    }

    func delete() {
        try? FileManager.default.removeItem(at: imageURL)
        let metadataURL = imageURL.deletingPathExtension().appendingPathExtension("json")
        try? FileManager.default.removeItem(at: metadataURL)
        onDelete?()
    }
}
