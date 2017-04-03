//
//  TestVC3.swift
//  Ourglass
//
//  Created by Deepak Venkatesh on 2017-02-28.
//  Copyright © 2017 ThirtyFour. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class PhotoViewerVC2: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var delegate:PhotoViewerVCDelegate?
    var backButton = UIButton()
    var pageControl = UIPageControl()
    var tableView:UICollectionView!
    let bottomView = UIView()
    var deleteButton = UIButton()
    let noPhotosLabel = UILabel()
    
    var photos:[UIImage] = []
    var emotion:Emotion!
    
    var currentPage = 0
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        deleteButton.isHidden = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        resetPageNumber()
    }
    
    func getPhotos(){
        
        if emotion.photoInfos.count == 0{
            resetPageNumber()
            return}
        var count = 0{
            willSet{
                if newValue == emotion.photoInfos.count{
                    tableView.reloadData()
                    resetPageNumber()
                }
            }
        }
        for thing in emotion.photoInfos{
            let storageRef = GlobalData.getPhotosStorageRef().child("/\(emotion.id)").child("/\(thing.0).jpg")
            storageRef.data(withMaxSize: 1024*1024, completion: {(data,error) in
                
                if error == nil{
                    self.photos.append(UIImage(data:data!)!)
                }
                count += 1
            })

        }
    
    }
    
    func setUpTableView(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        tableView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), collectionViewLayout: layout)
        view.addSubview(tableView)
        tableView.register(TutorialCell.self, forCellWithReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isPagingEnabled = true
        
        tableView.bounces = false
        tableView.backgroundColor = UIColor.clear
        tableView.showsHorizontalScrollIndicator = false
    }
    
    func resetPageNumber(){
        
        let pageNumber = Int(round(tableView.contentOffset.x/tableView.frame.width))
        pageControl.currentPage = pageNumber
        pageControl.numberOfPages = photos.count
        currentPage = pageNumber
        
        if photos.count == 0{
            noPhotosLabel.isHidden = false
            deleteButton.isHidden = true
        }
        else{
            noPhotosLabel.isHidden = true
            deleteButton.isHidden = true
        }
        if photos.count == 1{bottomView.isHidden = true}
        else{
            bottomView.isHidden = false
        }
    }
    func deleteButtonAction(){
        
        photos.remove(at: currentPage)
        tableView.reloadData()
        resetPageNumber()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        
        
        setUpTableView()
        
        let size = CGSize(width: 50, height: 50)
        let inset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        let inset2 = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        backButton.frame.size = size
        backButton.setImage(#imageLiteral(resourceName: "exitIcon"), for: .normal)
        backButton.contentEdgeInsets = inset
        
        view.addSubview(backButton)
        backButton.changeToColor(UIColor.white)
        backButton.frame.origin.y = 0
        backButton.frame.origin.x = 0
        backButton.addTarget(self, action: #selector(PhotoViewerVC2.backButtonAction), for: .touchUpInside)
        
        deleteButton.frame.size = size
        deleteButton.setImage(#imageLiteral(resourceName: "trashIcon.png"), for: .normal)
        deleteButton.contentEdgeInsets = inset2
        
        view.addSubview(deleteButton)
        deleteButton.changeToColor(UIColor.white)
        deleteButton.frame.origin.y = 0
        deleteButton.frame.origin.x = view.frame.width - deleteButton.frame.width
        deleteButton.addTarget(self, action: #selector(PhotoViewerVC2.deleteButtonAction), for: .touchUpInside)
        
        
        
        
        
        bottomView.frame.size = CGSize(width: view.frame.width, height: 30)
        bottomView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.addSubview(bottomView)
        bottomView.frame.origin.y = view.frame.height - bottomView.frame.height
        
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = photos.count
        bottomView.addSubview(pageControl)
        pageControl.frame.size = CGSize(width: 100, height: 20)
        pageControl.center.y = bottomView.frame.height/2
        pageControl.center.x = view.frame.width/2
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.4)
        
        
        noPhotosLabel.text = "No photos yet :("
        noPhotosLabel.isHidden = true
        noPhotosLabel.font = Font.PageHeaderSmall()
        noPhotosLabel.textColor = UIColor.white
        noPhotosLabel.sizeToFit()
        view.addSubview(noPhotosLabel)
        noPhotosLabel.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
        noPhotosLabel.isHidden = true
        view.bringSubview(toFront: noPhotosLabel)
        noPhotosLabel.layer.zPosition = 2
        getPhotos()
        
    }
    
    func backButtonAction(){
        delegate?.getCurrentPhotos(photos: photos)
        dismiss(animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = tableView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TutorialCell
        
        let size = (tableView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        cell.setUp(size: size,image:photos[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if bottomView.alpha == 0{
            UIView.animate(withDuration: 0.2, animations: {
                
                self.bottomView.alpha = 1
            })
        }
        else{
            UIView.animate(withDuration: 0.2, animations: {
                self.bottomView.alpha = 0
            })
        }
    }
    
    class TutorialCell:UICollectionViewCell{
        let mainImage = UIImageView()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = UIColor.clear
            setUpMainImage()
        }
        
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
        func setUpMainImage(){
            
            addSubview(mainImage)
             mainImage.contentMode = .scaleAspectFit
        }
        
        
        func setUp(size:CGSize,image:UIImage){
            
            
            mainImage.image = image
            
            mainImage.frame.size = CGSize(width: size.width-2, height: size.height-2)
            mainImage.center = CGPoint(x: frame.width/2, y: frame.height/2)
            backgroundColor = UIColor.black
           
        }
    }
    
    
}
