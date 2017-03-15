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

var userUID:String{
    return FIRAuth.auth()!.currentUser!.uid
}
let globalGreyColor = UIColor(white: 0.75, alpha: 1)
let globalLightGrey = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1)
let nowColor = UIColor(red: 80/255, green: 150/255, blue: 255/255, alpha: 1)

class GlobalData{
    
    
}
