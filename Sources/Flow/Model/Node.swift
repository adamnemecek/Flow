// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Flow/

import CoreGraphics

/// Nodes are identified by index in `Patch/nodes``.
public typealias NodeIndex = Int

/// Nodes are identified by index in ``Patch/nodes``.
///
/// Using indices as IDs has proven to be easy and fast for our use cases. The ``Patch`` should be
/// generated from your own data model, not used as your data model, so there isn't a requirement that
/// the indices be consistent across your editing operations (such as deleting nodes).
public struct Node: Equatable {
    public var name: String
    public var position: CGPoint

    /// Is the node position fixed so it can't be edited in the UI?
    public var locked = false

    public var inputs: [Port]
    public var outputs: [Port]
    
    @_disfavoredOverload
    public init(
        name: String,
        position: CGPoint = .zero,
        locked: Bool = false,
        inputs: [Port] = [],
        outputs: [Port] = []
    ) {
        self.name = name
        self.position = position
        self.locked = locked
        self.inputs = inputs
        self.outputs = outputs
    }

    public init(
        name: String,
        position: CGPoint = .zero,
        locked: Bool = false,
        inputs: [String] = [],
        outputs: [String] = []
    ) {
        self.name = name
        self.position = position
        self.locked = locked
        self.inputs = inputs.map { Port(name: $0) }
        self.outputs = outputs.map { Port(name: $0) }
    }

    public func translate(by offset: CGSize) -> Node {
        var result = self
        result.position.x += offset.width
        result.position.y += offset.height
        return result
    }

    /// Calculates the bounding rectangle for a node.
    public func rect(layout: LayoutConstants) -> CGRect {
        let maxio = max(self.inputs.count, self.outputs.count)
        let size = layout.rectSize(for: maxio)

        return CGRect(origin: self.position, size: size)
    }

    /// Calculates the bounding rectangle for an input port (not including the name).
    @inlinable @inline(__always)
    public func inputRect(input: PortIndex, layout: LayoutConstants) -> CGRect {
        self.position + layout.inputRect(input: input)
    }

    /// Calculates the bounding rectangle for an output port (not including the name).
    @inlinable @inline(__always)
    public func outputRect(output: PortIndex, layout: LayoutConstants) -> CGRect {
        self.position + layout.outputRect(output: output)
    }

    func hitTest(nodeIndex: Int, point: CGPoint, layout: LayoutConstants) -> Patch.HitTestResult? {
        for (inputIndex, _) in self.inputs.enumerated() {
            if self.inputRect(input: inputIndex, layout: layout).contains(point) {
                return .input(nodeIndex, inputIndex)
            }
        }
        for (outputIndex, _) in self.outputs.enumerated() {
            if self.outputRect(output: outputIndex, layout: layout).contains(point) {
                return .output(nodeIndex, outputIndex)
            }
        }

        if self.rect(layout: layout).contains(point) {
            return .node(nodeIndex)
        }

        return nil
    }

    /// Search for inputs.
    func findInput(
        point: CGPoint,
        layout: LayoutConstants
    ) -> PortIndex? {
        self.inputs.enumerated().first { portIndex, _ in
            self.inputRect(input: portIndex, layout: layout).contains(point)
        }?.0
    }

    /// Search for outputs.
    func findOutput(
        point: CGPoint,
        layout: LayoutConstants
    ) -> PortIndex? {
        self.outputs.enumerated().first { portIndex, _ in
            self.outputRect(output: portIndex, layout: layout).contains(point)
        }?.0
    }
}

