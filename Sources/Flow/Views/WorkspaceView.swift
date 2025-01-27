// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Flow/

import SwiftUI

/// Provides pan and zoom gestures. Unfortunately it seems this
/// can't be accomplished using purely SwiftUI because MagnificationGesture
/// doesn't provide a center point.
#if os(iOS)
struct WorkspaceView: UIViewRepresentable {

    @Binding var pan: CGSize
    @Binding var zoom: CGFloat

    class Coordinator: NSObject {

        @Binding var pan: CGSize
        @Binding var zoom: CGFloat

        init(pan: Binding<CGSize>, zoom: Binding<CGFloat>) {
            self._pan = pan
            self._zoom = zoom
        }

        @objc func panGesture(sender: UIPanGestureRecognizer) {
            let t = sender.translation(in: nil)
            self.pan.width += t.x / self.zoom
            self.pan.height += t.y / self.zoom

            // Reset translation.
            sender.setTranslation(CGPoint.zero, in: nil)
        }

        @objc func zoomGesture(sender: UIPinchGestureRecognizer) {
            let p = sender.location(in: nil).size

            let newZoom = sender.scale * self.zoom

            let pLocal = p * (1.0 / self.zoom) - self.pan
            let newPan = p * (1.0 / newZoom) - pLocal

            self.pan = newPan
            self.zoom = newZoom

            // Reset scale.
            sender.scale = 1.0
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(pan: self.$pan, zoom: self.$zoom)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()

        let coordinator = context.coordinator

        let panRecognizer = UIPanGestureRecognizer(target: coordinator, action: #selector(Coordinator.panGesture(sender:)))
        view.addGestureRecognizer(panRecognizer)
        panRecognizer.delegate = coordinator
        panRecognizer.minimumNumberOfTouches = 2

        let pinchGesture = UIPinchGestureRecognizer(target: coordinator, action:
                                                        #selector(Coordinator.zoomGesture(sender:)))
        view.addGestureRecognizer(pinchGesture)
        pinchGesture.delegate = coordinator

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // Do nothing.
    }

}

extension WorkspaceView.Coordinator: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        true
    }
}

#else
struct WorkspaceView: NSViewRepresentable {

    @Binding var pan: CGSize
    @Binding var zoom: CGFloat

    class Coordinator: NSObject {

        @Binding var pan: CGSize
        @Binding var zoom: CGFloat

        init(pan: Binding<CGSize>, zoom: Binding<CGFloat>) {
            self._pan = pan
            self._zoom = zoom
        }

        @objc func panGesture(
            sender: NSPanGestureRecognizer
        ) {
            print("pan at location: \(sender.location(in: nil))")
            let t = sender.translation(in: nil)
            self.pan.width += t.x / self.zoom
            self.pan.height -= t.y / self.zoom

            // Reset translation.
            sender.setTranslation(.zero, in: nil)
        }

        @objc func zoomGesture(
            sender: NSMagnificationGestureRecognizer
        ) {
            print("pinch at location: \(sender.location(in: nil)), scale: \(sender.magnification)")

            let p = sender.location(in: nil).size

            let newZoom = sender.magnification * self.zoom

            let pLocal = p * (1.0 / self.zoom) - self.pan
            let newPan = p * (1.0 / newZoom) - pLocal

            self.pan = newPan
            self.zoom = newZoom

            // Reset scale.
            sender.magnification = 1.0
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(pan: self.$pan, zoom: self.$zoom)
    }

    func makeNSView(context: Context) -> NSView {
        let view = NSView()

        let coordinator = context.coordinator

        let panRecognizer = NSPanGestureRecognizer(target: coordinator, action: #selector(Coordinator.panGesture(sender:)))
        view.addGestureRecognizer(panRecognizer)
        panRecognizer.delegate = coordinator

        let zoomRecognizer = NSMagnificationGestureRecognizer(target: coordinator, action: #selector(Coordinator.zoomGesture(sender:)))
        view.addGestureRecognizer(zoomRecognizer)
        zoomRecognizer.delegate = coordinator

        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        // Do nothing.
    }
}

extension WorkspaceView.Coordinator: NSGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: NSGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: NSGestureRecognizer
    ) -> Bool {
        true
    }
}

#endif

struct WorkspaceTestView: View {
    @State var pan: CGSize = .zero
    @State var zoom: CGFloat = 0.0

    var body: some View {
        WorkspaceView(pan: self.$pan, zoom: self.$zoom)
    }
}

struct WorkspaceView_Previews: PreviewProvider {
    static var previews: some View {
        WorkspaceTestView()
    }
}
