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
    }
    
    //collection view data source method. Set the number of items to be the count of the emotions array
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emotions.count
    }
    
    //collection view data source method. Set up the cell.
    //add a gesture recognizer to the label
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EmotionCell
        cell.someLabel.addTarget(self, action: #selector(SelectFeelingView.buttonClicked(_:)), for: .touchUpInside)
        cell.setUp(emotions[indexPath.item], size: cellSize)
        return cell
    }
    
    //function called when a cell label is clicked. Figure out the cell that the label was in, get the emotion from that, and pass that emotion to the delegate
    func buttonClicked(_ sender:UIButton){
        
        var someView = sender.superview!
        while !(someView is EmotionCell){
            someView = someView.superview!
        }
        let cell = (someView as! EmotionCell)
        
        if let index = indexPath(for: cell){
            someDelegate?.emotionSelected(emotions[index.item])
        }
        
    }
    
    //collection view delegate method. for the insets.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: gap, left: gap, bottom: 0, right: gap)
    }
    
    

    //cell that will be used by this class
    class EmotionCell:UICollectionViewCell{
        
        let someLabel = UIButton()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(someLabel)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        //set up the cell based on the inputted emotion and size.
        func setUp(_ emotion:Emotion,size:CGSize){
            
            backgroundColor = emotion.color
            someLabel.setTitle(emotion.name, for: .normal)
            someLabel.frame.size = size
            someLabel.titleLabel?.font = emotion.font
            
            someLabel.setTitleColor(UIColor.white, for: .normal)
            someLabel.center.x = size.width/2
            someLabel.center.y = size.height/2
            
            clipsToBounds = true
            layer.cornerRadius = 7
            /*layer.masksToBounds = false
             layer.shadowColor = UIColor.black.cgColor
             layer.shadowOpacity = 0.2
             layer.shadowRadius = 1.75
             layer.shadowOffset = CGSize(width: 0, height: 0)
             */
        }
    }
    
}
