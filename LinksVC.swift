//FeelApp
//This is the Links view controller. For the user to view links to different SFU areas (counselling services, counselling homepage, etc.). Also includes phone numbers for the clinic for each SFU campus.

///Programmers: Deepak and Carson
//Version 1: Created tableview containing the links and phone numebrs.
//Version 2: COnnected each cell to the action. So, clicking on a cell will actually take you to the appropriate webpage or dial the number
//Version 3: Improved UI. Set fonts and colors for each table cell. Created title bar.

//Coding standard:
//all view controller files have a descriptor followed by "VC."
//all view files have a descriptor folled by "view"




import UIKit
import FirebaseAuth

class LinksVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var backButton = UIButton()
    var topView = UIView()
    var titleLabel = UILabel()
    
    var tableView = UITableView()
    
    //titles of each item in the table
    var linkTitles = ["SFU Health & Conselling Center Homepage","SFU Health & Conselling services","SFU Health & Counselling Contacting Guide","SFU Health & Conselling Resources","SFU Healthy Campus Community","SFU Events & Programs Calendar","SFU Health & Conselling Volunteer","SFU Media Library"]
    var phoneTitles = ["Burnaby Campus","Vancouver Campus","Surrey Campus"]
    
    override var preferredStatusBarStyle: UIStatusBarStyle{return UIStatusBarStyle.lightContent}
    
    var headerHeight:CGFloat = 45
    
    // set up table view and top bar and general view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTopView()
        setUpView()
        setUpTableView()
        // Do any additional setup after loading the view.
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
        backButton.addTarget(self, action: #selector(LinksVC.backAction), for: .touchUpInside)
        
        topView.addSubview(backButton)
        backButton.changeToColor(UIColor.white)
        backButton.frame.origin.y = topView.frame.height - backButton.frame.height
        backButton.frame.origin.x = 0
        titleLabel.font = Font.PageHeaderSmall()
        titleLabel.text = "Links and Settings"
        titleLabel.textColor = UIColor.white
        titleLabel.sizeToFit()
        titleLabel.center.x = topView.frame.width/2
        titleLabel.center.y = backButton.center.y
        topView.addSubview(titleLabel)
        
    }
    
    //action called by back button. dismiss view controller
    func backAction(){
        dismiss(animated: true, completion: nil)
    }
    
    func setUpView(){
        view.backgroundColor = UIColor.white
    }
    
    ///create the table view. Set the delegate and the cell it will use. set its frame. format it.
    func setUpTableView(){
        let originY = topView.frame.maxY
        tableView.frame = CGRect(x: 0, y: originY, width: view.frame.size.width, height: view.frame.size.height - originY)
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        tableView.rowHeight = 70
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = globalLightGrey
        
        tableView.bounces = true
        tableView.alwaysBounceVertical = true
        tableView.showsVerticalScrollIndicator = false
    }
    
    //tableview data source method for number of sections. we will have 2: for links and for phone numbers.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    //tableview data source method for number of rows in section. Return the counts of the link titles and phone titles arrays initialized earlier.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return linkTitles.count
        }
        else if section == 1{
            return phoneTitles.count
        }
        else{return 1}
    }
    
    //tableivew data source method for formatting cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        //set the title of the cell, based on the section (differnet array) and row
        if indexPath.section == 0{
            //cell.textLabel?.textColor = UIColor.white
            cell.textLabel?.text = linkTitles[indexPath.item]
        }
        else if indexPath.section == 1{
            //cell.textLabel?.textColor = UIColor.white
            cell.textLabel?.text = phoneTitles[indexPath.item]
        }
        else{
            cell.textLabel?.text = "Logout"
        }
        
        
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        
        cell.textLabel?.font = Font.PageBody()

        
        //set the button the appears on the right on the cell. if its a link, the button is the right arrow. otherwise, its the phone icon
        let imageView = UIImageView()
        if indexPath.section == 0{
            imageView.image = #imageLiteral(resourceName: "rightArrowIcon")
        }
        else if indexPath.section == 1{
            imageView.image = #imageLiteral(resourceName: "phone.png")
        }
        else{
            imageView.image = #imageLiteral(resourceName: "rightArrowIcon")
        }
        
        imageView.changeToColor(globalGreyColor)
        cell.accessoryView = imageView
        cell.accessoryView?.frame = CGRect(x:0, y:0, width:20, height:20)

        return cell
        
    }
    
    //tableview delegate method for header height.
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return headerHeight

    }
    //tableview delegate method for the actual header view. Create a view with height of headerHeight. put a label in it with approriate text. format and position the label.
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x:0, y:0, width:view.frame.width, height:headerHeight))
        returnedView.backgroundColor = UIColor.white
        let label = UILabel()
        if section == 0{label.text = "Information"}
        else if section == 1{label.text = "Call SFU Clinic"}
        else{label.text = "Settings"}
        
        let smallFont = Font.PageBodyBold()
        label.font = smallFont
        label.sizeToFit()
        label.textColor = UIColor.black
        label.center.y = returnedView.frame.height/2
        label.frame.origin.x = 10
        returnedView.addSubview(label)
        return returnedView
    }
    
    
    //tableview delegate method for when you click on the cell. Use switch case to set the action for each cell.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0{
            switch indexPath.item{
                
            case 0:toWebsite(url:"http://www.sfu.ca/students/health/")
            case 1:toWebsite(url:"http://www.sfu.ca/students/health/services.html")
            case 2:toWebsite(url:"http://www.sfu.ca/students/health/contact-us.html")
            case 3: toWebsite(url:"http://www.sfu.ca/students/health/resources.html")
            case 4:toWebsite(url:"http://www.sfu.ca/healthycampuscommunity.html")
            case 5:toWebsite(url:"http://www.sfu.ca/students/health/events/Events-Calendar.html")
            case 6:toWebsite(url:"http://www.sfu.ca/students/health/volunteer.html")
            case 7: toWebsite(url:"http://www.sfu.ca/students/health/resources/media/your-health--audio-video.html")
            default:break
            }
        }
        else if indexPath.section == 1{
            switch indexPath.item{
            case 0:makeCall(phoneNumber: "778-782-4615")
            case 1:makeCall(phoneNumber: "778-782-5200")
            case 2:makeCall(phoneNumber: "778-782-5200")
            default:break
            }
            
        }
        else{
            logout()
        }
    }
    
    func logout(){
        try! FIRAuth.auth()?.signOut()
        let vc = LoginVC()
        present(vc, animated: true, completion: nil)
    }
    
    //input is a url. Open up the website in Safari corresponding to the url
    func toWebsite(url:String){
        UIApplication.shared.openURL(URL(string: url)!)
    }
    
    //input is a phone number. Call the phone number. Only works on real device, not simulator.
    func makeCall(phoneNumber:String) {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
}
