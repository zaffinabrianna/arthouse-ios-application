//
//  CustomTabShape.swift
//  Arthouse
//
//  Created by Roberto Chavez on 7/25/25.
//


import SwiftUI

struct CustomTabShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        let cornerRadius: CGFloat = 20
        
        // Start from top-left with rounded corner
        path.move(to: CGPoint(x: 0, y: cornerRadius))
        
        // Top-left corner
        path.addQuadCurve(
            to: CGPoint(x: cornerRadius, y: 0),
            control: CGPoint(x: 0, y: 0)
        )
        
        // Top edge
        path.addLine(to: CGPoint(x: width - cornerRadius, y: 0))
        
        // Top-right corner
        path.addQuadCurve(
            to: CGPoint(x: width, y: cornerRadius),
            control: CGPoint(x: width, y: 0)
        )
        
        // Right edge
        path.addLine(to: CGPoint(x: width, y: height))
        
        // Bottom edge
        path.addLine(to: CGPoint(x: 0, y: height))
        
        // Left edge back to start
        path.addLine(to: CGPoint(x: 0, y: cornerRadius))
        
        return path
    }
}
