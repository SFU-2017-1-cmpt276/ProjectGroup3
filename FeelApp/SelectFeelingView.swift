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

protocol SelectFeelingDelegate{
    func emotionSelected(_ emotion:Emotion)->Void
}
class SelectFeelingView: UICollectionView,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    var someDelegate:SelectFeelingDelegate?
    let gap:CGFloat = 20
    let height:CGFloat = 60
    var emotions = Emotion.getAll()
    
    var cellSize:CGSize
    
    init(size:CGSize){
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width:size.width/2 - gap*1.5,height:size.width/2 - gap*1.5)
        layout.minimumLineSpacing = gap
        cellSize = layout.itemSize
        
        super.init(frame: CGRect(origin:CGPoint.zero,size: CGSize(width:size.width,height:size.height)), collectionViewLayout: layout)
        
        setUp()
        
        let numberOfRows = CGFloat(ceil(Float(emotions.count)/2))
        
        let cellTotalHeight = numberOfRows * height
        let totalGaps = (numberOfRows-1)*gap
        let edgeGaps = gap*2
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(){
        delegate = self
        dataSource = self
        backgroundColor = UIColor(white: 1, alpha: 1)
        alwaysBounceVertical = false
        bounces = false
        showsVerticalScrollIndicator = false
        register(EmotionCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emotions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EmotionCell
        cell.someLabel.addTarget(self, action: #selector(SelectFeelingView.buttonClicked(_:)), for: .touchUpInside)
        cell.setUp(emotions[indexPath.item], size: cellSize)
        return cell
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: gap, left: gap, bottom: 0, right: gap)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        someDelegate?.emotionSelected(emotions[indexPath.item])
    }
    
    
    class EmotionCell:UICollectionViewCell{
        
        let someLabel = UIButton()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(someLabel)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func test(){
            
        }
        
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
