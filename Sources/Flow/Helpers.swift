// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Flow/

import Foundation
import SwiftUI

extension String {
    @_disfavoredOverload
    func removing(prefix: String) -> String? {
        guard self.hasPrefix(prefix) else { return nil }
        return String(dropFirst(prefix.count))
    }
}

extension CGPoint {
    @_disfavoredOverload
    @inlinable @inline(__always)
    static func +(lhs: Self, rhs: CGSize) -> Self {
        Self(x: lhs.x + rhs.width, y: lhs.y + rhs.height)
    }

    @_disfavoredOverload
    @inlinable @inline(__always)
    static func -(lhs: Self, rhs: Self) -> CGSize {
        CGSize(width: lhs.x - rhs.x, height: lhs.y - rhs.y)
    }

    @_disfavoredOverload
    @inlinable @inline(__always)
    static func - (pt: Self, sz: CGSize) -> Self {
        Self(x: pt.x - sz.width, y: pt.y - sz.height)
    }
}

extension CGSize {

    @_disfavoredOverload
    @inlinable @inline(__always)
    var point: CGPoint {
        CGPoint(x: self.width, y: self.height)
    }

    @inlinable @inline(__always)
    static func /(lhs: Self, rhs: CGFloat) -> Self {
        Self(width: lhs.width / rhs, height: lhs.height / rhs)
    }

    @_disfavoredOverload
    @inlinable @inline(__always)
    static func + (lhs: Self, rhs: Self) -> Self {
        Self(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }

    @_disfavoredOverload
    @inlinable @inline(__always)
    static func - (lhs: Self, rhs: Self) -> Self {
        Self(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }

    @_disfavoredOverload
    @inlinable @inline(__always)
    static func * (s: Double, sz: Self) -> Self {
        Self(width: s * sz.width, height: s * sz.height)
    }

    @_disfavoredOverload
    @inlinable @inline(__always)
    static func * (sz: Self, s: Double) -> Self {
        Self(width: s * sz.width, height: s * sz.height)
    }
}


extension CGRect {
    @inlinable @inline(__always)
    init(size: CGSize) {
        self.init(origin: .zero, size: size)
    }

    @_disfavoredOverload
    @inlinable @inline(__always)
    var center: CGPoint {
        CGPoint(x: self.midX, y: self.midY)
    }

    @_disfavoredOverload
    @inlinable @inline(__always)
    func offset(by off: CGSize) -> CGRect {
        self.offsetBy(dx: off.width, dy: off.height)
    }

    @_disfavoredOverload
    @inlinable @inline(__always)
    init(a: CGPoint, b: CGPoint) {
        self.init(
            origin: CGPoint(x: min(a.x, b.x), y: min(a.y, b.y)),
            size: CGSize(width: abs(a.x - b.x), height: abs(a.y - b.y))
        )
    }

    @inlinable @inline(__always)
    static func +(lhs: Self, rhs: CGPoint) -> Self {
        Self(origin: lhs.origin + rhs, size: rhs.size)
    }

    @inlinable @inline(__always)
    static func +(lhs: CGPoint, rhs: Self) -> Self {
        Self(origin: lhs + rhs.origin, size: rhs.size)
    }
}

extension CGPoint {
    @inlinable @inline(__always)
    var size: CGSize {
        CGSize(width: self.x, height: self.y)
    }

    @inlinable @inline(__always)
    var simd: SIMD2<Float> {
        .init(x: Float(self.x), y: Float(self.y))
    }

    @inlinable @inline(__always)
    func distance(to p: CGPoint) -> CGFloat {
        hypot(self.x - p.x, self.y - p.y)
    }

    @_disfavoredOverload
    static func += (lhs: inout Self, rhs: CGSize) {
        lhs = lhs + rhs
    }

    @inlinable @inline(__always)
    static func +(lhs: Self, rhs: Self) -> Self {
        Self(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    @inlinable @inline(__always)
    static func /(lhs: Self, rhs: CGFloat) -> Self {
        Self(x: lhs.x / rhs, y: lhs.y / rhs)
    }
}


extension Color {
    static let magenta = Color(.sRGB, red: 1, green: 0, blue: 1, opacity: 1)
}

