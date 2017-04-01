
//FeelApp
//This is the Home view controller. For the user to select an emotion. It also provides noavigation to other pages.
///Programmers: Deepak and Carson
//Version 1: Created UI with no actions
//Version 2: Added action for each emotion (connects to SubmitEmotionVC). Also added action for the button leading to HistoryVC
//Version 3: Improved UI. Set fonts and colors for each emotion. Set title bar color.
//Version 4: Added newfeed button on the bottom, links button on top right.

//Coding standard:
//all view controller files have a descriptor followed by "VC."
//all view files have a descriptor folled by "view"

import UIKit


class HomeVC: UIViewController,SelectFeelingDelegate,UIScrollViewDelegate {

    var scrollView = UIScrollView()
    var pageControl = UIPageControl()
    var topView = UIView()
    var titleLabel = UILabel()
    
    var historyButton = UIButton()
    var linkButton = UIButton()
    var feedButton = UIButton()
    var feedButtonHeight:CGFloat = 50
    var feedButtonOffset:CGFloat = 20
    
    var selectFeelingView:SelectFeelingView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    // set up table view and top bar and general view.
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpTopView()
        setUpSelectFeelingView()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let pageNumber = round(scrollView.contentOffset.x/scrollView.frame.width)
        pageControl.currentPage = Int(pageNumber)

    }
    
    //set up the general view. In this case its just the feed button that apepasr on the bottom
    func setUpView(){
        view.backgroundColor = UIColor.white
        
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = 2
        view.addSubview(pageControl)
        pageControl.frame.size = CGSize(width: 100, height: 20)
        pageControl.frame.origin.y = view.frame.height - pageControl.frame.height - 10
        pageControl.center.x = view.frame.width/2
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.pageIndicatorTintColor = globalGreyColor
        
        scrollView.frame.size.width = view.frame.width
        scrollView.frame.size.height = pageControl.frame.origin.y - topView.frame.height
        view.addSubview(scrollView)
        scrollView.frame.origin.y = topView.frame.height
        scrollView.contentSize.width = view.frame.width*2
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        
        feedButton.frame.size = CGSize(width: view.frame.width - 2*feedButtonOffset, height: feedButtonHeight)
        feedButton.frame.origin.y = scrollView.frame.height - feedButton.frame.height - 10
        feedButton.center.x = view.frame.width/2
        scrollView.addSubview(feedButton)
        feedButton.setTitle("Newsfeed", for: .normal)
        feedButton.setTitleColor(UIColor.white, for: .normal)
        feedButton.backgroundColor = nowColor
        feedButton.titleLabel?.font = Font.PageHeaderSmall()
        feedButton.addTarget(self, action: #selector(HomeVC.toFeed), for: .touchUpInside)
        feedButton.layer.cornerRadius = feedButtonHeight/2
        
        setUpChildViewController(vc: ChartVC())
    }
    
    func setUpChildViewController(vc:UIViewController){
        addChildViewController(vc)
        scrollView.addSubview(vc.view)
        vc.view.frame.size = view.frame.size
        vc.view.frame.origin.y = 0
        vc.view.frame.origin.x = view.frame.width
    }

    //Set up the top bar. The view, title label, and the history/link button on the top right/left.
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
    
    //action called by the feed button. open the feedVC
    func toFeed(){
        let vc = FeedVC()
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    //action called by the links button. open the linksVC
    func toLinks(){
        let vc = LinksVC()
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    //action called by the history button. open the historyVC
    func toHistory(){
        
        let vc = HistoryVC()
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    //set up the SelectFeelingView. set its size and position.
    func setUpSelectFeelingView(){
        selectFeelingView = SelectFeelingView(size: CGSize(width:view.frame.width,height: feedButton.frame.origin.y - feedButtonOffset - topView.frame.height))
        selectFeelingView.isScrollEnabled = false
        selectFeelingView.someDelegate = self
        scrollView.addSubview(selectFeelingView)
        selectFeelingView.frame.origin.y = topView.frame.height
    }
    
    //action called when an emotion is clicked. function from the selectFeelingDelegate. Open the submitEmotionVC and pass the emotion that was clicked. 
    func emotionSelected(_ emotion: Emotion) {
        let vc = SubmitEmotionVC()
        vc.emotion = emotion
        present(vc, animated: true, completion: nil)
    }


}

