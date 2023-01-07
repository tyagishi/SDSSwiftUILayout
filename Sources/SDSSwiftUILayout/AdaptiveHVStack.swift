//
//  AdaptiveHVStack.swift
//
//  Created by : Tomoaki Yagishita on 2023/01/07
//  © 2023  SmallDeskSoftware
//

import Foundation
import SwiftUI
import SDSSwiftExtension

enum StackLayoutDirection {
    case horizontal, vertical
    case minimum
}

public struct StackCache {
    var usedLayout: StackLayoutDirection = .horizontal
}

public struct AdaptiveHVStack: Layout {
    public typealias Cache = StackCache

    public init() {}

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout StackCache) -> CGSize {
        let stackLayoutDirection = layoutDirection(proposal) ?? cache.usedLayout
        var width: CGFloat = 0
        var height: CGFloat = 0
        switch stackLayoutDirection {
        case .minimum: // minimum width/height
            var iterator = PairIterator(subviews)
            while let (current, _) = iterator.next() {
                let size = current.sizeThatFits(.unspecified)
                width = max(width, size.width)
                height = max(height, size.height)
            }
        case .horizontal:
            var iterator = PairIterator(subviews)
            while let (current, next) = iterator.next() {
                let size = current.sizeThatFits(.unspecified)
                height = max(height, size.height)
                width += size.width
                if let next = next {
                    let padding = current.spacing.distance(to: next.spacing, along: .horizontal)
                    width += padding
                }
            }
        case .vertical:
            var iterator = PairIterator(subviews)
            while let (current, next) = iterator.next() {
                let size = current.sizeThatFits(.unspecified)
                width = max(width, size.width)
                height += size.height
                if let next = next {
                    let padding = current.spacing.distance(to: next.spacing, along: .vertical)
                    height += padding
                }
            }
        }
        return CGSize(width: width, height: height)
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout StackCache) {
        guard !subviews.isEmpty else { return }
        guard let proposalWidth = proposal.width,
              let proposalHeight = proposal.height else { return }
        if proposalWidth > proposalHeight {
            // HStack
            var x = bounds.minX
            var iterator = PairIterator(subviews)
            while let (current, next) = iterator.next() {
                current.place(at: CGPoint(x: x, y: bounds.midY),
                              anchor: .leading,
                              proposal: .unspecified)
                let size = current.sizeThatFits(.unspecified)
                x += size.width
                if let next = next {
                    let padding = current.spacing.distance(to: next.spacing, along: .horizontal)
                    x += padding
                }
            }
            cache.usedLayout = .horizontal
        } else {
            // VStack
            var y = bounds.minY
            var iterator = PairIterator(subviews)
            while let (current, next) = iterator.next() {
                current.place(at: CGPoint(x: bounds.midX, y: y),
                              anchor: .top,
                              proposal: .unspecified)
                let size = current.sizeThatFits(.unspecified)
                y += size.height
                if let next = next {
                    let padding = current.spacing.distance(to: next.spacing, along: .vertical)
                    y += padding
                }
            }
            cache.usedLayout = .vertical
        }

    }

    func layoutDirection(_ proposal: ProposedViewSize) -> StackLayoutDirection? {
        if proposal == .zero { return nil }
        guard let width = proposal.width,
              let height = proposal.height else { return nil }
        return width > height ? .horizontal : .vertical
    }

    public func makeCache(subviews: Subviews) -> StackCache {
        StackCache()
    }
}
