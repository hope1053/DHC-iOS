//
//  TooltipShape.swift
//  Flifin
//
//  Created by 최혜린 on 2/22/26.
//

import SwiftUI

struct TooltipShape: Shape {
    var cornerRadius: CGFloat
    var arrowWidth: CGFloat
    var arrowHeight: CGFloat

    func path(in rect: CGRect) -> Path {
        let bubbleRect = CGRect(
            x: rect.minX,
            y: rect.minY,
            width: rect.width,
            height: rect.height - arrowHeight
        )

        var path = Path(
            roundedRect: bubbleRect,
            cornerRadius: cornerRadius
        )

        // 아래 화살표 추가
        let arrowMidX = rect.midX
        path.move(to: CGPoint(x: arrowMidX - arrowWidth / 2, y: bubbleRect.maxY))
        path.addLine(to: CGPoint(x: arrowMidX + arrowWidth / 2, y: bubbleRect.maxY))
        path.addLine(to: CGPoint(x: arrowMidX, y: rect.maxY))
        path.closeSubpath()

        return path
    }
}
