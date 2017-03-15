//FeelApp
//The draw class. Draws different style lines. Useful UI Tool
///Programmers: Deepak
//Version 1: Created the draw class.

//Coding standard:
//all view controller files have a descriptor followed by "VC."
//all view files have a descriptor folled by "view"
//all other files just have descriptor

import UIKit

class Draw{
    
    static func createLineFromPoint(_ start : CGPoint, toPoint end:CGPoint, ofColor lineColor: UIColor, lineWidth:CGFloat) -> CAShapeLayer{
        
        let bezier = UIBezierPath()
        bezier.move(to: start)
        bezier.addLine(to: end)
        
        let line = CAShapeLayer()
        line.path = bezier.cgPath
        line.lineWidth = lineWidth
        line.strokeColor = lineColor.cgColor
        
        return line
    }
    
    static func createLineUnderView(_ view:UIView,color:UIColor, width:CGFloat = 1,inset:CGFloat = 0,viewOffset:CGFloat = 0) -> CAShapeLayer {
        
        
        let layer =  Draw.createLineFromPoint(CGPoint(x:inset, y:view.frame.height-width - viewOffset), toPoint: CGPoint(x:view.frame.width-inset,y:view.frame.height-width - viewOffset), ofColor: color, lineWidth: width)
        view.layer.addSublayer(layer)
        return layer
        
    }
    
}
