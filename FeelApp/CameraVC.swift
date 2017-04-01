//
//  CameraVC.swift
//  KnockKnock
//
//  Created by Deepak Venkatesh on 2016-07-21.
//  Copyright © 2016 ThirtyFour. All rights reserved.
//

import UIKit
import AVFoundation
//import FirebaseStorage

protocol CameraVCDelegate{
    func photoAccepted(photo:UIImage)->Void
}
class CameraVC: UIViewController {
    
    //data
    var delegate:CameraVCDelegate?
    var frontCameraInput:AVCaptureDeviceInput!
    var backCameraInput:AVCaptureDeviceInput!
    var torchOn = false
    var frontCameraActive = false
    var possiblePhoto = UIImage()
    
    //so that you dont take multiple pictures quickly and screw things up
    var capturingPhoto = false
    
    //view
    //top area
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var toggleCameraButton: UIButton!
    @IBOutlet weak var acceptPhotoButton: UIButton!
    @IBOutlet var takePhotoButton: UIButton!
    @IBOutlet weak var tapMessageLabel: UIButton!
    //camera
    let captureSession = AVCaptureSession()
    let stillImageOutput = AVCaptureStillImageOutput()
    @IBOutlet weak var cameraPreview: UIView!
    var acceptPhotoPreview = UIImageView()
    var previewLayer:AVCaptureVideoPreviewLayer!
    
    //other
    @IBOutlet weak var backButton: UIButton!
    var focusBoxLayer: CAShapeLayer!
    
    @IBOutlet var acceptPhotoHeight: NSLayoutConstraint!
    @IBOutlet var acceptPhotoWidth: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUpView()
        setUpFocusBox()
        
        
        //set up camera stuff, then check if inputs are there. if they arent then show error label.
        setUpInputs()
        setUpCaptureSession()
        if frontCameraInput == nil || backCameraInput == nil{
            flashButton.isHidden = true
            toggleCameraButton.isHidden = true
            cameraPreview.isHidden = true
            return
        }
        
        setCamera()
        setFlash()
        showTakePhotoScreen()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.bounds = cameraPreview.bounds
        previewLayer.position = CGPoint(x: cameraPreview.bounds.midX, y: cameraPreview.bounds.midY)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //animate the tap message label
        UIView.animate(withDuration: 1, delay: 0.75, options: .curveEaseIn, animations: {
            
            self.tapMessageLabel.alpha = 0
        }, completion: {_ in
            self.tapMessageLabel.isHidden = true
        })
    }
    
    
    
    
    func setUpView(){
        
        takePhotoButton.addTarget(self, action: #selector(CameraVC.takePicture(_:)), for: .touchUpInside)
        
        //set up view in general
        view.backgroundColor = UIColor.black
        
        //set up top buttons
        
        //set up accept photo preview
        view.addSubview(acceptPhotoPreview)
        acceptPhotoPreview.frame = view.frame
        view.sendSubview(toBack: acceptPhotoPreview)
        acceptPhotoPreview.isHidden = true
        
        //set up camera preview
        view.sendSubview(toBack: cameraPreview)
        let rec = UITapGestureRecognizer(target: self, action: #selector(CameraVC.focus(_:)))
        cameraPreview.addGestureRecognizer(rec)
        /*let rec2 = UILongPressGestureRecognizer(target: self, action: #selector(CameraVC.(_:)))
        rec2.minimumPressDuration = 0.5
        cameraPreview.addGestureRecognizer(rec2)*/
        
        
        takePhotoButton.backgroundColor = UIColor.clear
        takePhotoButton.clipsToBounds = true
        takePhotoButton.layer.cornerRadius = 35
        takePhotoButton.layer.borderWidth = 4
        takePhotoButton.layer.borderColor = UIColor.white.cgColor
        takePhotoButton.setImage(nil, for: .normal)
        
        for button in [backButton,toggleCameraButton,flashButton,takePhotoButton] as [UIButton]{
             button.layer.shadowColor = UIColor.black.cgColor
             button.layer.shadowOpacity = 0.4
             button.layer.shadowOffset = CGSize.zero
             button.layer.shadowRadius = 2.25
        }
        
        acceptPhotoButton.backgroundColor = UIColor.orange
        acceptPhotoButton.layer.cornerRadius = 25
        acceptPhotoButton.clipsToBounds = true
        acceptPhotoButton.changeToColor(UIColor.white)
        
        acceptPhotoButton.layer.masksToBounds = false
        acceptPhotoButton.layer.shadowColor = UIColor.black.cgColor
        acceptPhotoButton.layer.shadowOpacity = 0.4
        acceptPhotoButton.layer.shadowRadius = 1.75
        acceptPhotoButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        backButton.changeToColor(UIColor.white)
        toggleCameraButton.changeToColor(UIColor.white)
        flashButton.changeToColor(UIColor.white)
        
        //set up tap message label
        tapMessageLabel.backgroundColor = UIColor(white: 0, alpha: 0.1)
        let string1 = NSMutableAttributedString(string: "Tap anywhere ", attributes: [NSFontAttributeName:Font.PageBodyBold(),NSForegroundColorAttributeName:UIColor.orange])
        let string2 = NSMutableAttributedString(string: "to take a photo!", attributes: [NSFontAttributeName:Font.PageBody(),NSForegroundColorAttributeName:UIColor.white])
        string1.append(string2)
        tapMessageLabel.setAttributedTitle(string1, for: .normal)
        tapMessageLabel.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        tapMessageLabel.titleLabel?.numberOfLines = 0
        tapMessageLabel.isHidden = true
    }
    
    //set up the front and back camera inputs and assign them to variables so that the camera can be switched
    func setUpInputs(){
        
        let frontDevices = AVCaptureDevice.devices().filter{ ($0 as AnyObject).hasMediaType(AVMediaTypeVideo) && ($0 as AnyObject).position == AVCaptureDevicePosition.front }
        let backDevices = AVCaptureDevice.devices().filter{ ($0 as AnyObject).hasMediaType(AVMediaTypeVideo) && ($0 as AnyObject).position == AVCaptureDevicePosition.back }
        
        
        if frontDevices.first != nil{
            if frontDevices.first is AVCaptureDevice{
                let camera = frontDevices.first as! AVCaptureDevice
                
                let err : NSError? = nil
                do {
                    frontCameraInput = try AVCaptureDeviceInput(device: camera)
                    
                } catch _ {
                    print("error: \(err?.localizedDescription)")
                }
            }
        }
        
        if backDevices.first != nil{
            if backDevices.first is AVCaptureDevice{
                let camera = backDevices.first as! AVCaptureDevice
                let err : NSError? = nil
                do {
                    backCameraInput = try AVCaptureDeviceInput(device: camera)
                    
                } catch _ {
                    print("error: \(err?.localizedDescription)")
                }
            }
        }
        
    }
    
    func showAcceptPhotoScreen(){
        acceptPhotoPreview.image = possiblePhoto
        acceptPhotoPreview.isHidden = false
        acceptPhotoButton.isHidden = false
        flashButton.isHidden = true
        toggleCameraButton.isHidden = true
        takePhotoButton.isHidden = true
        backButton.setImage(#imageLiteral(resourceName: "exitIcon"), for: .normal)
        backButton.changeToColor(UIColor.white)
        backButton.contentEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)
        
        captureSession.stopRunning()
        
        self.acceptPhotoWidth.constant = 0
        self.acceptPhotoHeight.constant = 0
        self.acceptPhotoButton.setImage(nil, for: .normal)
        self.acceptPhotoButton.alpha = 0
        self.acceptPhotoButton.layer.cornerRadius = 0
        
        self.view.layoutIfNeeded()
        
        
        
        self.acceptPhotoButton.addCornerRadiusAnimation(from: 0, to: 25, duration: 0.45)
        UIView.animate(withDuration: 0.5, animations: {
            self.acceptPhotoWidth.constant = 50
            self.acceptPhotoHeight.constant = 50
            self.acceptPhotoButton.alpha = 1
            self.view.layoutIfNeeded()
        }, completion:{finished in
            self.acceptPhotoButton.setImage(#imageLiteral(resourceName: "checkMarkIcon"), for: .normal)
            self.acceptPhotoButton.changeToColor(UIColor.white)
        })
        
    }
    
    @IBAction func showTakePhotoScreen() {
        if !captureSession.isRunning{
            self.captureSession.startRunning()
        }
        setFlash()
        acceptPhotoPreview.isHidden = true
        acceptPhotoButton.isHidden = true
        flashButton.isHidden = false
        toggleCameraButton.isHidden = false
        takePhotoButton.isHidden = false
        backButton.setImage(#imageLiteral(resourceName: "leftArrowIcon"), for: .normal)
        backButton.changeToColor(UIColor.white)
        backButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        
        
    }
    //set up the basic capture session properties that wont change
    func setUpCaptureSession(){
        
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
        if captureSession.canAddOutput(stillImageOutput) {
            captureSession.addOutput(stillImageOutput)
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravityResize
        cameraPreview.layer.addSublayer(previewLayer)
    }
    
    
    //set up the basic circle properties that wont change
    func setUpFocusBox(){
        
        // Setup the CAShapeLayer with the path, colors, and line width
        focusBoxLayer = CAShapeLayer()
        
        focusBoxLayer.fillColor = UIColor.clear.cgColor
        focusBoxLayer.strokeColor = globalGreyColor.cgColor
        focusBoxLayer.lineWidth = 2
        
        // Don't draw the circle initially
        focusBoxLayer.strokeEnd = 0.0
        // Add the focusBoxLayer to the view's layer's sublayers
        view.layer.addSublayer(focusBoxLayer)
        
    }
    
    func takePicture(_ sender:UITapGestureRecognizer) {
        
        if !captureSession.isRunning{return}
        if capturingPhoto{return}
        
        if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo) {
            capturingPhoto = true
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection) {
                (imageDataSampleBuffer, error) -> Void in
                
                if error == nil && imageDataSampleBuffer != nil{
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                    
                    
                    self.possiblePhoto = UIImage(data: imageData!)!
                    if self.frontCameraActive{
                        self.possiblePhoto = UIImage(cgImage: self.possiblePhoto.cgImage!, scale: self.possiblePhoto.scale, orientation: .leftMirrored)
                    }
                    self.showAcceptPhotoScreen()
                    self.capturingPhoto = false
                }
                
            }
        }
    }
    
    
    //animate the circle drawing around a center point
    func animateFocusBox(_ center:CGPoint,duration: TimeInterval) {
        
        let radius:CGFloat = 60
        let rect = CGRect(x: center.x - radius, y: center.y-radius, width: radius*2, height: radius*2)
        focusBoxLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: 4).cgPath
        focusBoxLayer.isHidden = false
        
        
        // We want to animate the strokeEnd property of the focusBoxLayer
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.focusBoxLayer.isHidden = true
        })
        
        let drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        // Set the animation duration appropriately
        drawAnimation.duration = duration
        
        // Animate from 0 (no circle) to 1 (full circle)
        drawAnimation.fromValue = 0
        drawAnimation.toValue = 1
        // Do a linear animation (i.e. the speed of the animation stays the same)
        drawAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        // Set the focusBoxLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        focusBoxLayer.strokeEnd = 1.0
        
        
        // Do the actual animation
        focusBoxLayer.add(drawAnimation, forKey: "animateCircle")
        
        CATransaction.commit()
    }
    
    
    
    
    //focus the camera and draw a box around that point
    func focus(_ sender:UILongPressGestureRecognizer){
        
        if sender.state == .began{
            animateFocusBox(sender.location(in: view),duration:0.25)
            var touchPoint = sender.location(in: view)
            var screenSize = cameraPreview.bounds.size
            var focusPoint = CGPoint(x: touchPoint.y / screenSize.height, y: 1.0 - touchPoint.x / screenSize.width)
            
            let currentDevice = (captureSession.inputs.first as! AVCaptureDeviceInput).device
            
            
            do{
                captureSession.beginConfiguration()
                try currentDevice?.lockForConfiguration()
                defer {
                    captureSession.commitConfiguration()
                    currentDevice?.unlockForConfiguration()
                }
                
                if (currentDevice?.isFocusPointOfInterestSupported)! {
                    currentDevice?.focusPointOfInterest = focusPoint
                    currentDevice?.focusMode = AVCaptureFocusMode.autoFocus
                }
                if (currentDevice?.isExposurePointOfInterestSupported)! {
                    currentDevice?.exposurePointOfInterest = focusPoint
                    currentDevice?.exposureMode = AVCaptureExposureMode.autoExpose
                }
            }
            catch let error {
                print("Failed to set up torch level with error \(error)")
                
            }
        }
    }
    
    
    //set the camera to either fron or back, depending on the front camera active varaible
    func setCamera(){
        
        captureSession.beginConfiguration()
        
        if frontCameraActive{
            captureSession.removeInput(backCameraInput)
            captureSession.addInput(frontCameraInput)
        }
        else{
            captureSession.removeInput(frontCameraInput)
            captureSession.addInput(backCameraInput)
        }
        
        //you are NOT setting the flash on/off here. but if the device doesnt have flash, you hide the button
        if (captureSession.inputs[0] as! AVCaptureDeviceInput).device.hasFlash{
            flashButton.isHidden = false
        }
            
        else{flashButton.isHidden = true}
        
        captureSession.commitConfiguration()
    }
    
    func setFlash(){
        
        if captureSession.inputs.first == nil{
            return}
        if !(captureSession.inputs.first is AVCaptureDeviceInput){
            return}
        
        
        let currentDevice = (captureSession.inputs.first as! AVCaptureDeviceInput).device
        
        if !(currentDevice?.isFlashModeSupported(AVCaptureFlashMode.on))! || !(currentDevice?.isFlashModeSupported(AVCaptureFlashMode.off))! {
            flashButton.isHidden = true
            return
        }
        
        flashButton.isHidden = false
        do{
            captureSession.beginConfiguration()
            try currentDevice?.lockForConfiguration()
            defer {
                captureSession.commitConfiguration()
                currentDevice?.unlockForConfiguration()
            }
            
            if torchOn{
                currentDevice?.flashMode = AVCaptureFlashMode.on
                flashButton.setImage(UIImage(named: "flashOn2")!, for: UIControlState())
            }
            else{
                currentDevice?.flashMode = AVCaptureFlashMode.off
                flashButton.setImage(UIImage(named: "flashOff2")!, for: UIControlState())
            }
            flashButton.changeToColor(UIColor.white)
            
        }
        catch let error {
            print("Failed to set up torch level with error \(error)")
            
        }
        
    }
    
    //toggle the flash
    @IBAction func flashButtonAction(_ sender: UIButton) {
        if torchOn{torchOn = false}
        else{torchOn = true}
        
        setFlash()
    }
    
    //toggle the camera
    @IBAction func toggleCameraButtonAction(_ sender: UIButton) {
        
        if frontCameraActive{frontCameraActive = false}
        else{frontCameraActive = true}
        
        setCamera()
        setFlash()
    }
    
    
    //the check mark button. go to new update VC and pass the photo along
    @IBAction func acceptPhotoAction(_ sender: AnyObject) {
        
        captureSession.stopRunning()
        
        for button in [flashButton,toggleCameraButton,acceptPhotoButton,backButton]{
            button?.isHidden = true
        }
        
        self.dismiss(animated: true, completion: {_ in self.delegate?.photoAccepted(photo:self.possiblePhoto)})
        
    }
    
    //go back to update feed VC
    @IBAction func backButtonAction(_ sender: UIButton) {
        
        if !acceptPhotoButton.isHidden{
            showTakePhotoScreen()
        }
        else{
            captureSession.stopRunning()
            //delegate.backToActivityFeed()
            dismiss(animated: true, completion: nil)
        }
    }
    
}

