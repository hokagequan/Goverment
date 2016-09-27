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
    
    fileprivate var captureSession: AVCaptureSession? = AVCaptureSession()
    fileprivate var captureMetadataOutput: AVCaptureMetadataOutput? = AVCaptureMetadataOutput()
    fileprivate var captureDeviceInput: AVCaptureDeviceInput? = nil
    fileprivate var videoPreviewLayer: AVCaptureVideoPreviewLayer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        PCSCustomUtil.customNavigationController(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if status == AVAuthorizationStatus.denied {
            self.showAlert("无相机访问权限")
            return
        }
        
        self.initializeScan()
        self.startScan()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
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
    
    func handleCode(_ code: String) {
        let activityID = activity?.identifier ?? 0
        PCSDataManager.defaultManager().content.actionDelegate?.checkIn(code, identifier: "\(activityID)", completion: { (success) in
            self.perform(#selector(QRCodeScanViewController.startScan), with: nil, afterDelay: 1.0)
        })
    }
    
    func initializeScan() {
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
//            captureSession.sessionPreset = AVCaptureSessionPreset1920x1080;
            captureSession?.addInput(captureDeviceInput)
            captureSession?.addOutput(captureMetadataOutput)
            
            let dispatchQueue = DispatchQueue(label: "ScanCodeQueue", attributes: [])
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
            captureMetadataOutput?.rectOfInterest = CGRect(x: 64.0 / size.height, y: ((size.width - 220) / 2.0) / size.width, width: 220.0 / size.height, height: 220.0 / size.width);
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer!.frame = containerView.bounds
            containerView.layer.addSublayer(videoPreviewLayer!)
            
            let boxView = UIView(frame: CGRect(x: (size.width - 220) / 2.0, y: 64.0, width: 220.0, height: 220.0))
            boxView.layer.borderColor = UIColor.gray.cgColor
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
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        if captureSession?.isRunning == false {
            return
        }
        
        if metadataObjects.count > 0 {
            captureSession?.stopRunning()
            
            for metadataObject in metadataObjects {
                self.handleCode((metadataObject as AnyObject).stringValue)
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
