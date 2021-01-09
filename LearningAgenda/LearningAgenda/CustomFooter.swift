/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class CustomFooter: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    isOpaque = true
    backgroundColor = .clear
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func draw(_ rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()!
    
    let footerRect = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height)
    var arcRect = footerRect
    arcRect.size.height = 8.0
    context.saveGState()
    
    let arcPath = CGContext.createArcPathFromBottom(of: arcRect, arcHeight: 4, startAngle: Angle(degress: 180), endAngle: Angle(degress: 360))
    context.addPath(arcPath)
    context.clip()
    
    context.drawLinearGradient(rect: footerRect, startColor: .rwLightGray, endColor: .rwDarkGray)
    context.restoreGState()
    
    context.addRect(footerRect)
    context.addPath(arcPath)
    context.clip(using: .evenOdd)
    context.addPath(arcPath)
    context.setShadow(offset: CGSize(width: 0, height: 2), blur: 3, color: UIColor.rwShadow.cgColor)
    context.fillPath()
  }
  
}
