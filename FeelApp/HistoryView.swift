//FeelApp
//This is the History collection view. It displays the emotions given to it in a timeline format. The History VC uses this class. 
///Programmers: Deepak and Carson
//Version 1: Created UI.
//Version 2: Improved UI.

//Coding standard:
//all view controller files have a descriptor followed by "VC."
//all view files have a descriptor folled by "view"

import UIKit

protocol HistoryViewDelegate{
    func photoButtonClicked(emotion:Emotion)->Void
}
class HistoryView: UICollectionView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    var someDelegate:HistoryViewDelegate?
    var emotions:[Emotion] = []
    var expandedIndexes:[Int] = []
    
    var showTimeAlways = false
    
    //the initializer. Input a size. Sets this to be the size of the HistoryView. then calls setup()
    init(size:CGSize,showTimeAlways:Bool = false){
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        super.init(frame: CGRect(origin:CGPoint.zero,size: size), collectionViewLayout: layout)
        self.showTimeAlways = showTimeAlways
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //set the cell it will use, and other characteristics.
    fileprivate func setUp(){
        
        register(HistoryCell.self, forCellWithReuseIdentifier: "cell")
        delegate = self
        dataSource = self
        backgroundColor = UIColor.white
        alwaysBounceVertical = true
        showsVerticalScrollIndicator = false
        
        
    }
    
    //collection view data source method. set the number of items to be the count of the emotions array
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emotions.count
    }
    
    func showPhotos(sender:UIButton){
        
        var someView = sender.superview!
        while !(someView is HistoryCell){
            someView = someView.superview!
        }
        let emotion = (someView as! HistoryCell).emotion!
        someDelegate?.photoButtonClicked(emotion: emotion)
    }
    
    //collection view data source method. Set up the cell to be used.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HistoryCell
        if expandedIndexes.contains(indexPath.item){cell.expanded = true}
        else{cell.expanded = false}
        cell.photoButton.addTarget(self, action: #selector(HistoryView.showPhotos(sender:)), for: .touchUpInside)
        cell.setUp(emotion: emotions[indexPath.item],width:frame.width - 20,showTime:showTimeAlways)
        return cell
    }
    
    //collection view delegate method. Set the size of each cell.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = HistoryCell(frame: CGRect())
        if expandedIndexes.contains(indexPath.item){cell.expanded = true}
        else{cell.expanded = false}
        cell.setUp(emotion: emotions[indexPath.item],width:frame.width - 20,showTime:showTimeAlways)
        return CGSize(width:frame.width - 20,height:cell.frame.height)
    }
    
    //collection view delegate method. WHen the cell is clicked, expand if currently contracted, and vice versa.
    //The purpose of this is to show/hide the description text that appears for each emotion.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if expandedIndexes.contains(indexPath.item){
            let index = expandedIndexes.index(of: indexPath.item)!
            expandedIndexes.remove(at: index)
            reloadData()
            return
        }
        expandedIndexes.append(indexPath.item)
        reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }


}


//the cell to be used by this class/
class HistoryCell:UICollectionViewCell{
    
    var emotion:Emotion!
    let button = UIButton()
    let emotionLabel = UILabel()
    let textLabel = UILabel()
    
    let topBottomOffset:CGFloat = 15
    
    var expanded = false
    
    var showTime = false
    
    var photoButton = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialStuff()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //when cell is first created. general formatting.
    func initialStuff(){
        
        addSubview(photoButton)
        photoButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        photoButton.frame.size = CGSize(width: 40, height: 40)
        photoButton.setImage(#imageLiteral(resourceName: "photoIcon2"), for: .normal)
        photoButton.changeToColor(UIColor.white)
        
        addSubview(button)
        button.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        
        addSubview(emotionLabel)
        
        textLabel.font = Font.PageBodyBold()
        addSubview(textLabel)
        textLabel.textColor = UIColor.white
        clipsToBounds = true
        layer.cornerRadius = 6
        
    }
    
    //outputs the attributed string that says the time posted for the emotion. In the format "8:48 pm."
    func createTimeString()->NSMutableAttributedString{
        
        let formatter = DateFormatter()
        let datePosted = Date(timeIntervalSince1970: emotion.time/1000)
        
        
        formatter.calendar = Calendar.current
        formatter.dateFormat = "h:mm"
        let string = formatter.string(from: datePosted).lowercased()
        formatter.dateFormat = "a"
        let string2 = formatter.string(from: datePosted).lowercased()
        
        
        
        let string3 = NSMutableAttributedString(string: string, attributes: [NSFontAttributeName:Font.PageBodyBold(),NSForegroundColorAttributeName:UIColor.white])
        let string4 = NSMutableAttributedString(string: "\n\(string2)", attributes: [NSFontAttributeName:Font.PageBody(),NSForegroundColorAttributeName:UIColor.white])
        string3.append(string4)

        return string3
    }
    
    //outputs the attributed string that says the day posted for the emotion. In the format "20 Mar". Use this if the post is more than a day old
    func createDayString()->NSMutableAttributedString{
        
        let formatter = DateFormatter()
        let datePosted = Date(timeIntervalSince1970: emotion.time/1000)
        
        formatter.calendar = Calendar.current
        formatter.dateFormat = "d"
        let string = formatter.string(from: datePosted).lowercased()
        formatter.dateFormat = "MMM"
        let string2 = formatter.string(from: datePosted)
        
        let string3 = NSMutableAttributedString(string: string, attributes: [NSFontAttributeName:Font.PageBodyBold(),NSForegroundColorAttributeName:UIColor.white])
        let string4 = NSMutableAttributedString(string: "\n\(string2)", attributes: [NSFontAttributeName:Font.PageBody(),NSForegroundColorAttributeName:UIColor.white])
        
        string3.append(string4)
            
        return string3
    }
    
    
    
    //use the inputted emotion object to set up the cell with specific characteristics. Size and rearrange the elements based on the inputted width of the cell. 
    func setUp(emotion:Emotion,width:CGFloat,showTime:Bool = false){
        self.showTime = showTime
        self.emotion = emotion
        backgroundColor = emotion.color
        
        button.titleLabel?.numberOfLines = 0

        let datePosted = Date(timeIntervalSince1970: emotion.time/1000)
        
        if Date().minutes(from: datePosted) > 60*24{
            button.setAttributedTitle(createDayString(), for: .normal)
        }
        else{
            button.setAttributedTitle(createTimeString(), for: .normal)
        }
        
        if showTime{button.setAttributedTitle(createTimeString(), for: .normal)}
        
        button.setTitleColor(UIColor.white, for: .normal)
        button.sizeToFit()
        button.titleLabel?.textAlignment = .center
        button.frame.origin.x = topBottomOffset
        
        photoButton.frame.origin.x = width - photoButton.frame.width - 10
        
        emotionLabel.font = UIFont(name: emotion.font.fontName,size:25)
        emotionLabel.text = emotion.name
        emotionLabel.textColor = UIColor.white
        emotionLabel.sizeToFit()
        emotionLabel.frame.origin.x = button.frame.maxX + topBottomOffset
        emotionLabel.frame.origin.y = topBottomOffset

        textLabel.isHidden = false
        textLabel.frame.origin.x = emotionLabel.frame.origin.x
        textLabel.preferredMaxLayoutWidth = photoButton.frame.origin.x - textLabel.frame.origin.y - 10
        textLabel.frame.size.width = photoButton.frame.origin.x - textLabel.frame.origin.y - 10
        textLabel.numberOfLines = 0
        textLabel.text = emotion.text
        textLabel.sizeToFit()
        textLabel.frame.origin.y = emotionLabel.frame.maxY + 5
        frame.size.height = textLabel.frame.maxY + topBottomOffset
        
        button.center.y = frame.height/2
        photoButton.center.y = frame.height/2
        
        if emotion.photoInfos.count == 0{photoButton.isHidden = true}
        else{photoButton.isHidden = false}
    }
    
}
