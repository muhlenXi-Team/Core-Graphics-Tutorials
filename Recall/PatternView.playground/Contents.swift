//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport


class PatternView: UIView {
    
    let drawPattern: CGPatternDrawPatternCallback = { _, context in
        context.addArc(center: CGPoint(x: 20, y: 20),
                       radius: 10.0,
                       startAngle: 0,
                       endAngle: CGFloat(2.0 * .pi),
                       clockwise: false)
        context.setFillColor(UIColor.black.cgColor)
        context.fillPath()
    }
    
    
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        UIColor.orange.setFill()
        context.fill(rect)
        
        var callbacks = CGPatternCallbacks(version: 0, drawPattern: drawPattern, releaseInfo: nil)
        let pattern = CGPattern(info: nil,
                                bounds: CGRect(x: 0, y: 0, width: 20, height: 20),
                                matrix: .identity,
                                xStep: 50,
                                yStep: 50,
                                tiling: .constantSpacing,
                                isColored: true,
                                callbacks: &callbacks)
        
        let patternSpace = CGColorSpace(patternBaseSpace: nil)!
        context.setFillColorSpace(patternSpace)
        var alpha: CGFloat = 1.0
        context.setFillPattern(pattern!, colorComponents: &alpha)
        context.fill(rect)
    }
}



class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let patternView = PatternView()
        patternView.frame = CGRect(x: 10, y: 10, width: 200, height: 200)
        view.addSubview(patternView)
        
        
        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
