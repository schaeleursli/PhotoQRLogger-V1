import SwiftUI

struct ZoomableScrollView<Content: View>: UIViewRepresentable {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.maximumZoomScale = 4.0
        scrollView.minimumZoomScale = 1.0

        let hosted = UIHostingController(rootView: content)
        hosted.view.translatesAutoresizingMaskIntoConstraints = true
        hosted.view.frame = CGRect(origin: .zero, size: CGSize(width: 300, height: 300))

        scrollView.addSubview(hosted.view)
        context.coordinator.hostingController = hosted
        return scrollView
    }

    func updateUIView(_ scrollView: UIScrollView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, UIScrollViewDelegate {
        var hostingController: UIHostingController<Content>?

        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return hostingController?.view
        }
    }
}