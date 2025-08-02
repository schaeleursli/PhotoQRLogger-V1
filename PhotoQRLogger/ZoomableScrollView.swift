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
        hosted.view.frame = scrollView.bounds

        scrollView.addSubview(hosted.view)
        scrollView.contentSize = hosted.view.bounds.size
        context.coordinator.hostingController = hosted
        return scrollView
    }

    func updateUIView(_ scrollView: UIScrollView, context: Context) {
        if let hostedView = context.coordinator.hostingController?.view {
            if hostedView.frame != scrollView.bounds {
                hostedView.frame = scrollView.bounds
            }
            scrollView.contentSize = hostedView.bounds.size
        }
        context.coordinator.hostingController?.rootView = content
    }

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