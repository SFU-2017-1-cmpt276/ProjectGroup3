//
//  LinksVC.swift
//  FeelApp
//
//  Created by Deepak Venkatesh on 2017-03-15.
//  Copyright © 2017 CMPT276. All rights reserved.
//

import UIKit

class LinksVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var backButton = UIButton()
    var topView = UIView()
    var titleLabel = UILabel()
    
    var tableView = UITableView()
    
    var linkTitles = ["SFU Health & Conselling Center Homepage","SFU Health & Conselling services","SFU health & conselling contacting guide","SFU health & conselling resources","SFU healthy campus community","SFU events & programs calendar","SFU health & conselling volunteer","SFU media library"]
    var phoneTitles = ["Burnaby Campus","Vancouver Campus","Surrey Campus"]
    
    override var preferredStatusBarStyle: UIStatusBarStyle{return UIStatusBarStyle.lightContent}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTopView()
        setUpView()
        setUpTableView()
        // Do any additional setup after loading the view.
    }
    
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
        titleLabel.text = "Links"
        titleLabel.textColor = UIColor.white
        titleLabel.sizeToFit()
        titleLabel.center.x = topView.frame.width/2
        titleLabel.center.y = backButton.center.y
        topView.addSubview(titleLabel)
    }
    
    func backAction(){
        dismiss(animated: true, completion: nil)
    }
    
    func setUpView(){
        view.backgroundColor = UIColor.white
    }
    
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
        return linkTitles.count
        }
        else{
            return phoneTitles.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        if indexPath.section == 0{
            cell.textLabel?.text = linkTitles[indexPath.item]
        }
        else{
            cell.textLabel?.text = phoneTitles[indexPath.item]
        }
        
        
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        
        cell.textLabel?.font = Font.PageBody()
        
        let imageView = UIImageView()
        if indexPath.section == 0{
        imageView.image = #imageLiteral(resourceName: "rightArrowIcon")
        }
        else{
            imageView.image = #imageLiteral(resourceName: "phone.png")
        }
        
        imageView.changeToColor(globalGreyColor)
        cell.accessoryView = imageView
        cell.accessoryView?.frame = CGRect(x:0, y:0, width:20, height:20)
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x:0, y:0, width:view.frame.width, height:45))
        //set these values as necessary
        returnedView.backgroundColor = UIColor.white
        let label = UILabel()
        if section == 0{label.text = "Links"}
        else{label.text = "Call SFU Clinic"}
        
        let smallFont = Font.PageBodyBold()//UIFont(name: Font.PageBodyBold().fontName, size: Font.PageSmallBold().pointSize - 2)
        label.font = smallFont
        label.sizeToFit()
        label.textColor = UIColor.black
        label.center.y = returnedView.frame.height/2
        label.frame.origin.x = 10
        returnedView.addSubview(label)
        return returnedView
    }
    
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
        else{
            switch indexPath.item{
            case 0:makeCall(number: "778-782-4615")
            case 1:makeCall(number: "778-782-5200")
            case 2:makeCall(number: " 778-782-5200")
                default:break
            }

        }
    }
    
    func toWebsite(url:String){
        UIApplication.shared.openURL(URL(string: url)!)
    }
    
    func makeCall(number:String){
        var url = NSURL(string: "tell://\(number)")
        UIApplication.shared.openURL(url as! URL)
    }
    

}
