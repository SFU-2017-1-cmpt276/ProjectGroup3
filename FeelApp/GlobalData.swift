//FeelApp
//The Global Data class. For all data and constants being used globally.
///Programmers: Deepak
//Version 1: Created the Global data class.

//Coding standard:
//all view controller files have a descriptor followed by "VC."
//all view files have a descriptor folled by "view"
//all other files just have descriptor

import UIKit
import FirebaseAuth
import FirebaseStorage

var userUID:String{
    return FIRAuth.auth()!.currentUser!.uid
}
let globalGreyColor = UIColor(white: 0.75, alpha: 1)
let globalLightGrey = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1)
let nowColor = UIColor(red: 80/255, green: 150/255, blue: 255/255, alpha: 1)

class GlobalData{
    
    static var You = Person()
    
    static func FirebaseTimeStampToString(_ timeStamp:TimeInterval)->String{
        let datePosted = Date(timeIntervalSince1970: timeStamp/1000)
        
        let minutesSincePosted = Int(-datePosted.timeIntervalSinceNow/60)
        let hoursSincePosted = Int(-datePosted.timeIntervalSinceNow/3600)
        let daysSincePosted = Int(-datePosted.timeIntervalSinceNow/86400)
        
        let minuteString = "\(minutesSincePosted) min ago"
        let hourString = "\(hoursSincePosted) hrs ago"
        let dayString = "\(daysSincePosted) days ago"
        
        var stringToUse = minuteString
        
        if minutesSincePosted > 59{
            stringToUse = hourString
        }
        
        if hoursSincePosted > 23{
            stringToUse = dayString
        }
        
        return stringToUse
        
    }
    
    static func getPhotosStorageRef()->FIRStorageReference{
        return FIRStorage.storage().reference(forURL: "gs://feelapp-385f5.appspot.com").child("Post Photos")
    }
}
