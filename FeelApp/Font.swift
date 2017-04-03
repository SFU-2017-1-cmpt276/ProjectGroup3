//FeelApp
//The Font class. So that there are standardized fonts being used in this app.
///Programmers: Deepak
//Version 1: Created the font class.

//Coding standard:
//all view controller files have a descriptor followed by "VC."
//all view files have a descriptor folled by "view"
//all other files just have descriptor

import UIKit

class Font{
    
    static func NoPostsFont()->UIFont{
        return Font.PageHeaderSmallUnbold()
    }
    
    static func CustomEmotionFont()-> UIFont{
        
        let fontString = "AvenirNext-DemiBold"
        return UIFont(name: fontString, size: 35)!
    }
    
    static func PageHeaderSmall()-> UIFont{
        
        let fontString = "AvenirNext-DemiBold"
        return UIFont(name: fontString, size: 21)!
    }
    
    static func PageHeaderSmallUnbold()-> UIFont{
        
        let fontString = "AvenirNext-Regular"
        return UIFont(name: fontString, size: 21)!
    }
    
    
    static func PageSmall()-> UIFont{
        
        let fontString = "AvenirNext-Regular"
        return UIFont(name: fontString, size: 15)!
    }
    
    static func PageSmallBold()-> UIFont{
        
        let fontString = "AvenirNext-DemiBold"
        return UIFont(name: fontString, size: 15)!
    }
    
    static func PageBody()-> UIFont{
        
        let fontString = "AvenirNext-Regular"
        return UIFont(name: fontString, size: 17)!
    }
    
    static func PageBodyBold()-> UIFont{
        
        let fontString = "AvenirNext-DemiBold"
        return UIFont(name: fontString, size: 17)!
    }
    
}
