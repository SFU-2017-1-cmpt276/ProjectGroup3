//FeelApp
//This is the select feeling view controller. For the user to select an emotion. The Home VC uses this class
///Programmers: Deepak and Carson
//Version 1: Created UI.
//Version 2: Improved UI. Changed placeholder color and background color.

//Coding standard:
//all view controller files have a descriptor followed by "VC."
//all view files have a descriptor folled by "view"
//all other files just have descriptor

import UIKit

//delegate method. The homeVC implements this. 
protocol SelectFeelingDelegate{
    func emotionSelected(_ emotion:Emotion)->Void
    func plusButtonClicked()->Void
    func deleteButtonClicked(emotion:Emotion)->Void
}
class SelectFeelingView: UICollectionView,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    var someDelegate:SelectFeelingDelegate?
    let gap:CGFloat = 10
    let height:CGFloat = 60
    var emotions = Emotion.getAll()
    
    var cellSize:CGSize
    
    //initializer. take in size and sets that to be the size of the view. call setUp()
    init(size:CGSize){
        let layout = UICollectionViewFlowLayout()
        
        let height = (size.height - 3*gap)/3
        let width = (size.width-3*gap)/2
        layout.itemSize = CGSize(width:width,height:height)
        layout.minimumLineSpacing = gap
        cellSize = layout.itemSize
        
        super.init(frame: CGRect(origin:CGPoint.zero,size: CGSize(width:size.width,height:size.height)), collectionViewLayout: layout)
        
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //sets up the SelectFeelingView. give the cell that will be used, the delegate/data source, and other characteristics
    func setUp(){
        delegate = self
        dataSource = self
        backgroundColor = UIColor(white: 1, alpha: 1)
        alwaysBounceVertical = false
        bounces = false
        showsVerticalScrollIndicator = false
        register(EmotionCell.self, forCellWithReuseIdentifier: "cell")
        register(PlusCell.self, forCellWithReuseIdentifier: "plusCell")
    }
    
    //collection view data source method. Set the number of items to be the count of the emotions array
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emotions.count + 1
    }
    
    //collection view data source method. Set up the cell.
    //add a gesture recognizer to the label
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EmotionCell

        if indexPath.item == emotions.count{
            let plusCell = collectionView.dequeueReusableCell(withReuseIdentifier: "plusCell", for: indexPath) as! PlusCell
            plusCell.setUp(size: cellSize)
            plusCell.plusButton.addTarget(self, action: #selector(SelectFeelingView.plusButtonClicked), for: .touchUpInside)
            return plusCell
        }
        
        cell.setUp(emotions[indexPath.item], size: cellSize)
        cell.deleteButton.addTarget(self, action: #selector(SelectFeelingView.deleteButtonClicked(sender:)), for: .touchUpInside)
        return cell
    }
    
    func plusButtonClicked(){
        someDelegate?.plusButtonClicked()
    }
    
    func deleteButtonClicked(sender:UIButton){
        var someView = sender.superview!
        while !(someView is EmotionCell){
            someView = someView.superview!
        }
        let emotion = (someView as! EmotionCell).emotion!
        someDelegate?.deleteButtonClicked(emotion:emotion)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == emotions.count{return}
        
        someDelegate?.emotionSelected(emotions[indexPath.item])
    }
    
    //collection view delegate method. for the insets.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: gap, left: gap, bottom: 0, right: gap)
    }
    
    

    //cell that will be used by this class
    class EmotionCell:UICollectionViewCell{
        
        var emotion:Emotion!
        
        let someLabel = UIButton()
        let deleteButton = UIButton()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(someLabel)
            addSubview(deleteButton)
            deleteButton.frame.size = CGSize(width: 30, height: 30)
            deleteButton.contentEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8)
            deleteButton.setImage(#imageLiteral(resourceName: "exitIcon"), for: .normal)
            deleteButton.changeToColor(UIColor.black)
            deleteButton.backgroundColor = UIColor.white
            deleteButton.layer.cornerRadius = deleteButton.frame.height/2
            deleteButton.clipsToBounds = true
            deleteButton.layer.borderWidth = 2
            deleteButton.layer.borderColor = UIColor.black.cgColor
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        //set up the cell based on the inputted emotion and size.
        func setUp(_ emotion:Emotion,size:CGSize){
            self.emotion = emotion
            backgroundColor = emotion.color
            someLabel.setTitle(emotion.name, for: .normal)
            someLabel.frame.size = size
            someLabel.clipsToBounds = true
            someLabel.layer.cornerRadius = 7
            someLabel.titleLabel?.font = emotion.font
            someLabel.titleLabel?.adjustsFontSizeToFitWidth = true
            
            someLabel.setTitleColor(UIColor.white, for: .normal)
            someLabel.center.x = size.width/2
            someLabel.center.y = size.height/2
            deleteButton.frame.origin.x = size.width - deleteButton.frame.width + 5
            deleteButton.frame.origin.y = -5
            someLabel.isUserInteractionEnabled = false
            if emotion.custom{deleteButton.isHidden = false}
            else{deleteButton.isHidden = true}
            clipsToBounds = false
            layer.cornerRadius = 7
        }
    }
    
    class PlusCell:UICollectionViewCell{
        let plusButton = UIButton()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(plusButton)
            plusButton.frame.size = CGSize(width: 50, height: 50)
            plusButton.contentEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8)
            plusButton.setImage(#imageLiteral(resourceName: "plusbutton2.png"), for: .normal)
            plusButton.changeToColor(UIColor.black)
            plusButton.backgroundColor = UIColor.white
            plusButton.layer.cornerRadius = plusButton.frame.height/2
            plusButton.clipsToBounds = true
            plusButton.layer.borderWidth = 3
            plusButton.layer.borderColor = UIColor.black.cgColor
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        //set up the cell based on the inputted emotion and size.
        func setUp(size:CGSize){
            backgroundColor = UIColor.white
            plusButton.center.x = size.width/2
            plusButton.center.y = size.height/2
            layer.cornerRadius = 7
            //layer.borderWidth = 3
            backgroundColor = globalLightGrey
            

            
        }

        
    }
    
}
