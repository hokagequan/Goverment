//
//  QRCodeScanViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/7.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit
import AVFoundation
import EZLoadingActivity

class QRCodeScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var containerView: UIView!
    
    var activity: Activity? = nil
    
    private var captureSession: AVCaptureSession? = AVCaptureSession()
    private var captureMetadataOutput: AVCaptureMetadataOutput? = AVCaptureMetadataOutput()
    private var captureDeviceInput: AVCaptureDeviceInput? = nil
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        PCSCustomUtil.customNavigationController(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let status = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        if status == AVAuthorizationStatus.Denied {
            self.showAlert("无相机访问权限")
            return
        }
        
        self.initializeScan()
        self.startScan()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.stopScan()
        captureSession?.removeInput(captureDeviceInput)
        captureSession?.removeOutput(captureMetadataOutput)
        videoPreviewLayer?.removeFromSuperlayer()
        videoPreviewLayer = nil
        
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleCode(code: String) {
        let range = code.rangeOfString(":")!
        let personID = code.substringToIndex(range.startIndex)
        let req = CheckInReq()
        req.activityID = "\(activity!.identifier)"
        req.qrCodes = [personID]
        EZLoadingActivity.show("", disableUI: true)
        EZLoadingActivity.Settings.SuccessText = "签到成功"
        EZLoadingActivity.Settings.FailText = "签到失败"
        req.requestCompletion { (response) -> Void in
            let result = response?.result
            var success: Bool = false
            var errorCode: String? = nil
            
            defer {
                if success == true {
                    EZLoadingActivity.hide(success: true, animated: false)
                }
                else {
                    if errorCode != "-1" {
                        EZLoadingActivity.hide(success: false, animated: false)
                    }
                    else {
                        ResponseErrorManger.defaultManager().handleError(errorCode, message: nil)
                    }
                }
                
                self.performSelector(#selector(QRCodeScanViewController.startScan), withObject: nil, afterDelay: 1.0)
            }
            
            if result?.isSuccess == true {
                guard let value = result?.value else {
                    success = false
                    
                    return
                }
                
                guard let responseString = HttpBaseReq.parseResponse(value) as? String else {
                    return
                }
                
                if ((responseString as NSString).intValue >= 1) {
                    success = true
                }
                else {
                    errorCode = responseString
                    success = false
                }
            }
            else {
                success = false
            }
        }
    }
    
    func initializeScan() {
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do {
            captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
//            captureSession.sessionPreset = AVCaptureSessionPreset1920x1080;
            captureSession?.addInput(captureDeviceInput)
            captureSession?.addOutput(captureMetadataOutput)
            
            let dispatchQueue = dispatch_queue_create("ScanCodeQueue", nil)
            captureMetadataOutput?.setMetadataObjectsDelegate(self, queue: dispatchQueue)
            captureMetadataOutput?.metadataObjectTypes = [AVMetadataObjectTypeQRCode,
                AVMetadataObjectTypeUPCECode,
                AVMetadataObjectTypeCode39Code,
                AVMetadataObjectTypeCode39Mod43Code,
                AVMetadataObjectTypeEAN13Code,
                AVMetadataObjectTypeEAN8Code,
                AVMetadataObjectTypeCode93Code,
                AVMetadataObjectTypeCode128Code,
                AVMetadataObjectTypePDF417Code,
                AVMetadataObjectTypeAztecCode]
            
            let size = containerView.bounds.size
            captureMetadataOutput?.rectOfInterest = CGRectMake(64.0 / size.height, ((size.width - 220) / 2.0) / size.width, 220.0 / size.height, 220.0 / size.width);
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer!.frame = containerView.bounds
            containerView.layer.addSublayer(videoPreviewLayer!)
            
            let boxView = UIView(frame: CGRectMake((size.width - 220) / 2.0, 64.0, 220.0, 220.0))
            boxView.layer.borderColor = UIColor.grayColor().CGColor
            boxView.layer.borderWidth = 2.0
            containerView.addSubview(boxView)
        }
        catch {
            return
        }
    }
    
    func startScan() {
        captureSession?.startRunning()
    }
    
    func stopScan() {
        captureSession?.stopRunning()
    }
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        if captureSession?.running == false {
            return
        }
        
        if metadataObjects.count > 0 {
            captureSession?.stopRunning()
            
            for metadataObject in metadataObjects {
                self.handleCode(metadataObject.stringValue)
                break
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
