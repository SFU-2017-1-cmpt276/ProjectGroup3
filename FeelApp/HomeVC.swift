
//FeelApp
//This is the Home view controller. For the user to select an emotion. It also provides noavigation to other pages.
///Programmers: Deepak and Carson
//Version 1: Created UI with no actions
//Version 2: Added action for each emotion (connects to SubmitEmotionVC). Also added action for the button leading to HistoryVC
//Version 3: Improved UI. Set fonts and colors for each emotion. Set title bar color.

//Coding standard:
//all view controller files have a descriptor followed by "VC."
//all view files have a descriptor folled by "view"

import UIKit

class HomeVC: UIViewController,SelectFeelingDelegate {

    
    var topView = UIView()
    var titleLabel = UILabel()
    
    var historyButton = UIButton()
    var linkButton = UIButton()
    var feedButton = UIButton()
    var feedButtonHeight:CGFloat = 50
    var feedButtonOffset:CGFloat = 10
    
    var selectFeelingView:SelectFeelingView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpTopView()
        setUpSelectFeelingView()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func setUpView(){
        view.backgroundColor = UIColor.white
        feedButton.frame.size = CGSize(width: view.frame.width - 2*feedButtonOffset, height: feedButtonHeight)
        feedButton.frame.origin.y = view.frame.height - feedButton.frame.height - feedButtonOffset
        feedButton.center.x = view.frame.width/2
        topView.addSubview(feedButton)
        feedButton.setTitle("Newsfeed", for: .normal)
        feedButton.setTitleColor(UIColor.white, for: .normal)
        feedButton.backgroundColor = nowColor
        feedButton.titleLabel?.font = Font.PageHeaderSmall()
        feedButton.addTarget(self, action: #selector(HomeVC.toFeed), for: .touchUpInside)
        feedButton.layer.cornerRadius = feedButtonHeight/2
        
    }

    func setUpTopView(){
        let size = CGSize(width: 50, height: 50)
        let inset = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
        
        topView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: view.frame.width, height: 70))
        view.addSubview(topView)
        topView.backgroundColor = nowColor
        
        historyButton.frame.size = size
        historyButton.setImage(#imageLiteral(resourceName: "calendarIcon"), for: .normal)
        historyButton.contentEdgeInsets = inset
        topView.addSubview(historyButton)
        historyButton.changeToColor(UIColor.white)
        historyButton.frame.origin.y = topView.frame.height - historyButton.frame.height
        historyButton.frame.origin.x = topView.frame.width - historyButton.frame.width
        historyButton.addTarget(self, action: #selector(HomeVC.toHistory), for: .touchUpInside)
        
        linkButton.frame.size = size
        linkButton.setImage(#imageLiteral(resourceName: "linksIcon.png"), for: .normal)
        linkButton.contentEdgeInsets = inset
        topView.addSubview(linkButton)
        linkButton.changeToColor(UIColor.white)
        linkButton.frame.origin.y = topView.frame.height - historyButton.frame.height
        linkButton.frame.origin.x = 0
        linkButton.addTarget(self, action: #selector(HomeVC.toLinks), for: .touchUpInside)
        

        titleLabel.font = Font.PageHeaderSmall()
        titleLabel.text = "FeelApp"
        titleLabel.textColor = UIColor.white
        titleLabel.sizeToFit()
        titleLabel.center.x = topView.frame.width/2
        titleLabel.center.y = linkButton.center.y
        topView.addSubview(titleLabel)

    }
    
    func toFeed(){
        let vc = FeedVC()
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    func toLinks(){
        let vc = LinksVC()
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    func toHistory(){
        
        let vc = HistoryVC()
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    func setUpSelectFeelingView(){
        selectFeelingView = SelectFeelingView(size: CGSize(width:view.frame.width,height:view.frame.height - topView.frame.height - feedButtonHeight - 2*feedButtonOffset - 6))
        selectFeelingView.someDelegate = self
        view.addSubview(selectFeelingView)
        selectFeelingView.frame.origin.y = topView.frame.height
    }
    
    func emotionSelected(_ emotion: Emotion) {
        let vc = SubmitEmotionVC()
        vc.modalTransitionStyle = .crossDissolve
        vc.emotion = emotion
        present(vc, animated: true, completion: nil)
    }


}

