//FeelApp
//The Extension class. Functions based on iOS objects that are used throughout the app.
//Version 1: Created the extension class. Added changeToColor and minutes fron
//Version 2: added extension for rounding the top and bottom of a text field seperately 

///Programmers: Deepak

//Coding standard:
//all view controller files have a descriptor followed by "VC."
//all view files have a descriptor folled by "view"
//all other files just have descriptor





import UIKit

extension UITextField {
    func roundedTopText(){
        let maskPath1 = UIBezierPath(roundedRect: self.bounds,
                                     byRoundingCorners: [.topLeft , .topRight],
                                     cornerRadii:CGSize(width:8.0, height:8.0))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = self.bounds
        maskLayer1.path = maskPath1.cgPath
        self.layer.mask = maskLayer1
    }
    func roundedBottomText(){
        let maskPath1 = UIBezierPath(roundedRect: self.bounds,
                                     byRoundingCorners: [.bottomLeft , .bottomRight],
                                     cornerRadii:CGSize(width:8.0, height:8.0))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = self.bounds
        maskLayer1.path = maskPath1.cgPath
        self.layer.mask = maskLayer1
    }
}


extension UIButton{
    
    func changeToColor(_ color:UIColor){
        if self.imageView == nil || self.imageView?.image == nil{
            return
        }
        if self.imageView?.image == UIImage(){return}
        let image = self.imageView!.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        setImage(image, for: UIControlState())
        self.tintColor = color
        
    }
}


extension UIImageView{
    
    func changeToColor(_ color:UIColor){
        if self.image == UIImage(){return}
        self.image = image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
    
}

extension Date{
    
    func minutes(from: Date) -> Int {
        let calendar = Calendar.current as NSCalendar
        return calendar.components(.minute, from: from, to: self, options: []).minute!
    }
}

