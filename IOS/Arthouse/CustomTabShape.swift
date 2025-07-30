//
//  CustomTabShape.swift
//  Arthouse
//
//  Created on 7/25/25.
//

import SwiftUI

struct CustomTabShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        let radius: CGFloat = 38
        let cutoutDepth: CGFloat = 30
        let cutoutCornerRadius: CGFloat = 10
        
        let center = width / 2
        let cutoutStartX = center - radius
        let cutoutEndX = center + radius
        
        // Start from bottom-left
        path.move(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        // Left straight section
        path.addLine(to: CGPoint(x: cutoutStartX - cutoutCornerRadius, y: 0))
    
        path.addQuadCurve(
            to: CGPoint(x: cutoutStartX, y: cutoutCornerRadius),
            control: CGPoint(x: cutoutStartX, y: 0)
        )
        
        // Circular cutout
        path.addArc(
            center: CGPoint(x: center, y: cutoutDepth),
            radius: radius,
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: true
        )
        
        path.addQuadCurve(
            to: CGPoint(x: cutoutEndX + cutoutCornerRadius, y: 0),
            control: CGPoint(x: cutoutEndX, y: 0)
        )
        
        // Right straight section
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: height))
        path.closeSubpath()
        
        return path
    }
}
