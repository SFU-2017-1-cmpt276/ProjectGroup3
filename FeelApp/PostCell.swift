//FeelApp
//This is the Post Cell. It is a table view cell that displays a post from a user. The FeedVC uses this class. Connected to PostCell.xib
///Programmers: Deepak and Carson
//Version 1: Created UI.
//Version 2: Improved UI.

//Coding standard:
//all view controller files have a descriptor followed by "VC."
//all view files have a descriptor folled by "view"


import UIKit



class PostCell: UITableViewCell {

    var post:Post!
    @IBOutlet var mainView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var mainText: UILabel!
    @IBOutlet var emotionText: UILabel!
    
    @IBOutlet var likeImage: UIImageView!
    @IBOutlet var likeText: UILabel!
    @IBOutlet var likeView: UIView!
    
    @IBOutlet var commentImage: UIImageView!
    @IBOutlet var commentText: UILabel!
    @IBOutlet var commentView: UIView!
    
    @IBOutlet var photoImage: UIImageView!
    @IBOutlet var photoText: UILabel!
    @IBOutlet var photoView: UIView!
    
    let calendar = Calendar.current
    let formatter = DateFormatter()
    
    
    @IBOutlet var line: UIView!
    
    @IBOutlet var lineHeight: NSLayoutConstraint!
    //when the cell is first awakeneed from nib. Do general formatting. Set up the date formatter.
    override func awakeFromNib() {
        super.awakeFromNib()
        
        likeView.backgroundColor = UIColor.clear
        commentView.backgroundColor = UIColor.clear
        photoView.backgroundColor = UIColor.clear
        
        likeImage.changeToColor(UIColor.white)
        commentImage.changeToColor(UIColor.white)
        photoImage.changeToColor(UIColor.white)
        
        likeText.font = Font.PageSmallBold()
        likeText.textColor = UIColor.white
        commentText.font = Font.PageSmallBold()
        commentText.textColor = UIColor.white
        photoText.font = Font.PageSmallBold()
        photoText.textColor = UIColor.white
        
        timeLabel.font = Font.PageSmall()
        timeLabel.textColor = UIColor.white
        nameLabel.font = Font.PageBody()
        nameLabel.textColor = UIColor.white
        line.backgroundColor = UIColor.white
                
        
        mainText.font = Font.PageBodyBold()
        
        formatter.calendar = calendar
        formatter.timeStyle = .short
        formatter.dateStyle = .short
    }
    
    
    //Input is the post object. Using this, set the specifics for the cell. Including but not limited to text and colors. 
    func setUp(post:Post){
        self.post = post
        mainText.textColor = UIColor.white
        mainText.text = post.emotion.text
        mainText.font = Font.PageBodyBold()
        nameLabel.text = post.sender.alias
        likeText.text = String(post.likes.count)
        commentText.text = String(post.comments.count)
        photoText.text = String(post.emotion.photoInfos.count)
        emotionText.text = post.emotion.name
        emotionText.font = UIFont(name:post.emotion.font.fontName,size: 23)
        emotionText.textColor = UIColor.white
        timeLabel.text = GlobalData.FirebaseTimeStampToString(post.emotion.time)
        //line.backgroundColor = UIColor.white
        mainView.backgroundColor = post.emotion.color
        mainView.clipsToBounds = true
        mainView.layer.cornerRadius = 8
        
        
        if post.likes.map({$0.senderID}).contains(userUID){
            likeImage.image = #imageLiteral(resourceName: "heartIconFilled")
            likeText.font = Font.PageSmallBold()
            likeImage.changeToColor(UIColor.white)
        }
        else{
            likeImage.image = #imageLiteral(resourceName: "heartIcon2")
            likeText.font = Font.PageSmallBold()
            likeImage.changeToColor(UIColor.white)
        }
    }
    
}
