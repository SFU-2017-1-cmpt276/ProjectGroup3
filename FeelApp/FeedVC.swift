//FeelApp
//This is the Feed view controller. For the user to view posts from other users in a newsfeed format. Anyonmous posts, identified only by the user's alias.
///Programmers: Deepak and Carson
//Version 1: Created tableview with PostCell and test data.
//Version 2: Connected to database.
//Version 3: Improved UI. Set fonts and colors for each story. Created title bar.
//Version 4: Fixed bug where long text was overflowing to the right, instead of increasing the height of the cell.

//Coding standard:
//all view controller files have a descriptor followed by "VC."
//all view files have a descriptor folled by "view"


import UIKit
import FirebaseDatabase

class FeedVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var tableView = UITableView()
    var backButton = UIButton()
    var topView = UIView()
    var titleLabel = UILabel()
    var posts:[Post] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle{return UIStatusBarStyle.lightContent}
    
    // set up table view and top bar. Get data from firebase.
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTopView()
        setUpTableView()
        getPosts()
    }
    
    //create the table view. Set the delegate and the cell it will use. set its frame. format it.
    func setUpTableView(){
        let originY = topView.frame.maxY
        tableView.frame = CGRect(x: 0, y: originY, width: view.frame.size.width, height: view.frame.size.height - originY)
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName:"PostCell",bundle:nil), forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.separatorColor = globalLightGrey
        
        tableView.bounces = true
        tableView.alwaysBounceVertical = true
        tableView.showsVerticalScrollIndicator = false
    }
    
    //Set up the top bar. The view, back button, and title label.
    func setUpTopView(){
        let size = CGSize(width: 50, height: 50)
        let inset = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
        
        topView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: view.frame.width, height: 70))
        view.addSubview(topView)
        topView.backgroundColor = nowColor
        
        backButton.frame.size = size
        backButton.setImage(#imageLiteral(resourceName: "leftArrowIcon"), for: .normal)
        backButton.contentEdgeInsets = inset
        backButton.addTarget(self, action: #selector(FeedVC.backAction), for: .touchUpInside)
        
        topView.addSubview(backButton)
        backButton.changeToColor(UIColor.white)
        backButton.frame.origin.y = topView.frame.height - backButton.frame.height
        backButton.frame.origin.x = 0
        
        titleLabel.font = Font.PageHeaderSmall()
        titleLabel.text = "Feed"
        titleLabel.textColor = UIColor.white
        titleLabel.sizeToFit()
        titleLabel.center.x = topView.frame.width/2
        titleLabel.center.y = backButton.center.y
        topView.addSubview(titleLabel)
    }
    
    //function called by the back button. Dismiss the view controller
    func backAction(){
        dismiss(animated: true, completion: nil)
    }
    
    //Get the data from firebase. Add it to the posts array. then reload the tableview
    func getPosts(){
        
        FIRDatabase.database().reference().child("Posts").observeSingleEvent(of: .value, with: {allSnap in
            let hello = userUID
            let dict = allSnap.value as? [String:AnyObject] ?? [:]
            
            for (id,postDict) in dict{
                
                let post = Post()
                
                let emotionDict = postDict["Emotion"] as? [String:AnyObject] ?? [:]
                let type = emotionDict["Type"] as? String ?? ""
                post.emotion = Emotion.fromString(type)
                post.emotion.text = emotionDict["Text"] as? String ?? ""
                post.emotion.time = emotionDict["Time"] as? TimeInterval ?? TimeInterval()
                
                post.sender.id = postDict["Sender ID"] as? String ?? ""
                post.sender.alias = postDict["Sender Alias"] as? String ?? ""
                
                self.posts.append(post)


                
            }
            self.posts.sort(by: {$0.emotion.time > $1.emotion.time})
            self.tableView.reloadData()
        })
    }
    
    
    //tableview data source method. say the number of rows that will appear
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    //tableview data source method. set and format the cell. 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! PostCell
        cell.setUp(post: posts[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }

}
