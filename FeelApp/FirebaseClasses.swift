//FeelApp
//The Firebase class. For all data being retrieved from Firebase. Creates objects from the data
///Programmers: Deepak
//Version 1: Created the emotion class.
//Version 2: added getAll() function

//Coding standard:
//all view controller files have a descriptor followed by "VC."
//all view files have a descriptor folled by "view"
//all other files just have descriptor

import UIKit

class Post{
    var emotion = Emotion()
    var sender = Person()
    var likeCount = 0
    var commentCount = 0
    
    init(){}
    
}

class Person{
    var alias = ""
    var id = ""
    init(){}
}

class Emotion{
    
    var name = ""
    var text = ""
    var color = UIColor.black
    var font = Font.PageBody()
    var time = TimeInterval()
    var id = ""
    
    //dont use this init. alwasy use static ones
    init(name:String,color:UIColor,font:UIFont){
        self.name = name
        self.color = color
        self.font = font
    }
    
    init(){}
    
    static func Happy()->Emotion{
        return Emotion(name: "Happy", color: UIColor.orange, font: UIFont(name: "Chalkduster", size: 35)!)
    }
    static func Angry()->Emotion{
        return Emotion(name: "Angry", color: UIColor.red, font: UIFont(name: "Futura-CondensedExtraBold", size: 35)!)
    }
    static func Sad()->Emotion{
        return Emotion(name: "Sad", color: UIColor(red: 61/255, green: 132/255, blue: 225/255, alpha: 1), font: UIFont(name: "Cochin-Italic", size: 35)!)
    }
    static func Tired()->Emotion{
        return Emotion(name: "Tired", color: UIColor.darkGray, font: UIFont(name: "AvenirNextCondensed-UltraLight", size: 35)!)
    }
    static func Excited()->Emotion{
        return Emotion(name: "Excited", color: UIColor(red: 60/255, green: 243/255, blue: 100/255, alpha: 1), font: UIFont(name: "ChalkboardSE-Bold", size: 35)!)
    }
    static func Relaxed()->Emotion{
        return Emotion(name: "Relaxed", color: UIColor(red: 153/255, green: 153/255, blue: 255/255, alpha: 1), font: UIFont(name: "Helvetica-LightOblique", size: 30)!)
    }
    
    static func fromString(_ string:String)->Emotion{
        
        switch string{
        case "Happy": return Emotion.Happy()
        case "Angry": return Emotion.Angry()
        case "Sad":return Emotion.Sad()
        case "Tired":return Emotion.Tired()
        case "Excited":return Emotion.Excited()
        case "Relaxed":return Emotion.Relaxed()
        default: return Emotion.Happy()
        }
    }
    
    static func getAll()->[Emotion]{
        
        return [Emotion.Happy(),Emotion.Angry(),Emotion.Sad(),Emotion.Tired(),Emotion.Excited(),Emotion.Relaxed()]
    }
}
