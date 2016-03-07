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
        // TODO: 处理二维码
        let req = CheckInReq()
        req.activityID = activity?.identifier
        req.qrCodes = [code]
        EZLoadingActivity.show("", disableUI: true)
        req.requestCompletion { (response) -> Void in
            EZLoadingActivity.hide()
            let result = response?.result
            var success: Bool = false
            
            defer {
                if success == true {
                    EZLoadingActivity.showWithDelay("签到成功", disableUI: true, seconds: 1)
                }
                else {
                    EZLoadingActivity.showWithDelay("签到失败", disableUI: true, seconds: 1)
                }
                
                self.startScan()
            }
            
            if result?.isSuccess == true {
                guard let value = result?.value else {
                    success = false
                    
                    return
                }
                
                if ((value as NSString).intValue >= 1) {
                    success = true
                }
                else {
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
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer!.frame = containerView.bounds
            containerView.layer.addSublayer(videoPreviewLayer!)
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
