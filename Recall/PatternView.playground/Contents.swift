//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

public struct Constants {
    static let patternSize: CGFloat = 30.0
    static let patternRepeatCount = 2
}

enum PatternDirection: CaseIterable {
    case left
    case top
    case right
    case bottom
}

class PatternView: UIView {
    
    var fillColor: [CGFloat] = [1.0, 0.0, 0.0, 1.0]
    var direction: PatternDirection = .top
    
    let drawTriangle: CGPatternDrawPatternCallback = { _, context in
        let trianglePath = UIBezierPath(triangleIn:
            CGRect(x: 0, y: 0,
                   width: Constants.patternSize,
                   height: Constants.patternSize))
        context.addPath(trianglePath.cgPath)
        context.fillPath()
    }
    
    init(fillColor: [CGFloat], direction: PatternDirection = .top) {
        self.fillColor = fillColor
        self.direction = direction
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        UIColor.white.setFill()
        context.fill(rect)
        
        var callbacks = CGPatternCallbacks(version: 0, drawPattern: drawTriangle, releaseInfo: nil)
        let patternStepX: CGFloat = rect.width / CGFloat(Constants.patternRepeatCount)
        let patternStepY: CGFloat = rect.height / CGFloat(Constants.patternRepeatCount)
        let patternOffsetX: CGFloat = (patternStepX - Constants.patternSize) / 2.0
        let patternOffsetY: CGFloat = (patternStepY - Constants.patternSize) / 2.0
        
        var transform: CGAffineTransform
        switch direction {
        case .top:
            transform = .identity
        case .right:
            transform = CGAffineTransform(rotationAngle: CGFloat(0.5 * .pi))
        case .bottom:
            transform = CGAffineTransform(rotationAngle: CGFloat(1.0 * .pi))
        case .left:
            transform = CGAffineTransform(rotationAngle: CGFloat(1.5 * .pi))
        }
        transform = transform.translatedBy(x: patternOffsetX, y: patternOffsetY)
        
        let pattern = CGPattern(info: nil,
                                bounds: CGRect(x: 0, y: 0, width: 20, height: 20),
                                matrix: transform,
                                xStep: patternStepX,
                                yStep: patternStepY,
                                tiling: .constantSpacing,
                                isColored: false,
                                callbacks: &callbacks)
        
        let baseSpace = CGColorSpaceCreateDeviceRGB()
        let patternSpace = CGColorSpace(patternBaseSpace: baseSpace)!
        context.setFillColorSpace(patternSpace)
        
        context.setFillPattern(pattern!, colorComponents: fillColor)
        context.fill(rect)
    }
}

extension UIBezierPath {
    convenience init(triangleIn rect: CGRect) {
        self.init()
        
        let topOfTriangle = CGPoint(x: rect.width/2, y: 0)
        let bottomLeftOfTriangle = CGPoint(x: 0, y: rect.height)
        let bottomRightOfTriangle = CGPoint(x: rect.width, y: rect.height)
        
        self.move(to: topOfTriangle)
        self.addLine(to: bottomLeftOfTriangle)
        self.addLine(to: bottomRightOfTriangle)
        
        self.close()
    }
}

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .lightGray

        let patternView = PatternView(fillColor: [0.0, 1.0, 0.0, 1.0], direction: .right)
        patternView.frame = CGRect(x: 10, y: 10, width: 200, height: 200)
        view.addSubview(patternView)
        
        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
