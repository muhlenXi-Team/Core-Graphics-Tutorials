//
//  GraphView.swift
//  TestController
//
//  Created by muhlenXi on 2019/7/31.
//  Copyright © 2019 muhlenXi. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView {

    @IBInspectable var startColor: UIColor = .red
    @IBInspectable var endColor: UIColor = .green
    
    var graphicPoints = [4, 2, 6, 4, 5, 8, 3]
    
    private struct Constansts {
        static let cornerRadiusSize = CGSize(width: 8.0, height: 8.0)
        static let margin: CGFloat = 20.0
        static let topBorder: CGFloat = 60
        static let bottomBorder: CGFloat = 50
        static let colorAlpha: CGFloat = 0.3
        static let circleDiameter: CGFloat = 5.0
    }
    
    override func draw(_ rect: CGRect) {
        let width = rect.width
        let height = rect.height
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: Constansts.cornerRadiusSize)
        path.addClip()
        
        let context = UIGraphicsGetCurrentContext()!
        let colors = [startColor.cgColor, endColor.cgColor]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocation: [CGFloat] = [0.0, 1.0]
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocation)!
        
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: bounds.height)
        
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
        
        // calculate the x point
        let margin = Constansts.margin
        let graphWidth = width - margin*2 - 4
        let columnXPoint = { (column: Int) -> CGFloat in
            let spacing = graphWidth / CGFloat(self.graphicPoints.count-1)
            return CGFloat(column)*spacing+margin+2
        }
        
        // calculate the y point
        let topBorder = Constansts.topBorder
        let bottomBorder = Constansts.bottomBorder
        let graphHeight = height - topBorder - bottomBorder
        let maxValue = graphicPoints.max()!
        let columnYPoint = { (graphPoint: Int) -> CGFloat in
            let y = CGFloat(graphPoint)/CGFloat(maxValue)*graphHeight
            return graphHeight-y+topBorder
        }
        
        UIColor.white.setFill()
        UIColor.white.setStroke()
        let graphPath = UIBezierPath()
        graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(graphicPoints[0])))
        for i in 1..<graphicPoints.count {
            let nexPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(graphicPoints[i]))
            graphPath.addLine(to: nexPoint)
        }
        
        // create the cliping path for the graph gradient
        context.saveGState()
        let clipingPath = graphPath.copy() as! UIBezierPath
        clipingPath.addLine(to: CGPoint(x: columnXPoint(graphicPoints.count-1), y: height))
        clipingPath.addLine(to: CGPoint(x: columnXPoint(0), y: height))
        clipingPath.close()
        clipingPath.addClip()
        
        let highestYPoint = columnYPoint(maxValue)
        let graphStartPoint = CGPoint(x: margin, y: highestYPoint)
        let graphEndPoint = CGPoint(x: margin, y: bounds.height)
        context.drawLinearGradient(gradient, start: graphStartPoint, end: graphEndPoint, options: [])
        context.restoreGState()
        
        graphPath.lineWidth = 2.0
        graphPath.stroke()
        
        // Draw the circles on top of the graph stroke
        for i in 0..<graphicPoints.count {
            var point = CGPoint(x: columnXPoint(i), y: columnYPoint(graphicPoints[i]))
            point.x -= Constansts.circleDiameter / 2
            point.y -= Constansts.circleDiameter / 2
            
            let circle = UIBezierPath(ovalIn: CGRect(x: point.x, y: point.y, width: Constansts.circleDiameter, height: Constansts.circleDiameter))
            circle.fill()
        }
        
        // Draw horizontal graph lines on the top of everything
        let linePath = UIBezierPath()
        
        linePath.move(to: CGPoint(x: margin, y: topBorder))
        linePath.addLine(to: CGPoint(x: width-margin, y: topBorder))
        
        linePath.move(to: CGPoint(x: margin, y: topBorder+graphHeight/2))
        linePath.addLine(to: CGPoint(x: width-margin, y: topBorder+graphHeight/2))
        
        linePath.move(to: CGPoint(x: margin, y: height-bottomBorder))
        linePath.addLine(to: CGPoint(x: width-margin, y: height-bottomBorder))
        
        let color = UIColor(white: 1.0, alpha: Constansts.colorAlpha)
        color.setStroke()
        
        linePath.lineWidth = 1.0
        linePath.stroke()
    }
}
