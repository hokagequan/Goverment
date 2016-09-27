//
//  HomeViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/1/19.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var specialButton: UIButton!
    
    let content = PCSDataManager.defaultManager().content
    let cellSize: CGFloat = 52.0
    
    var message: String? = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        PCSCustomUtil.customNavigationController(self)
        
        self.loadUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if content is CongressContentInfo {
            let req = GetActivityNotifyCountReq()
            req.requestSimpleCompletion({ (success, count, errorCode) -> Void in
                if success {
                    self.message = count
                    self.collectionView.reloadItems(at: [IndexPath(row: 0, section: 0)])
                }
                else {
                    ResponseErrorManger.defaultManager().handleError(errorCode, message: nil)
                }
            })
        }
    }
    
    func loadUI() {
        if content is WorderContentInfo {
            specialButton.setImage(UIImage(named: "home_checkin"), for: UIControlState())
        }
        else if content is CongressContentInfo {
            specialButton.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func clickSpecial(_ sender: AnyObject) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        content.actionDelegate?.didClickSpecial(self)
    }
    
    // MARK: - UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return (self.view.bounds.size.width - 3 * cellSize * GlobalUtil.rateForWidth()) / 3.0 - 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let distance = (self.view.bounds.size.width - 3 * cellSize * GlobalUtil.rateForWidth()) / 6.0
        return UIEdgeInsetsMake(40, distance, 20, distance)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellSize * GlobalUtil.rateForWidth(), height: cellSize * GlobalUtil.rateForWidth() + 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return content.homeElementCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NormalImageCell", for: indexPath) as! NormalImageCell
        
        cell.titleLabel.text = content.homeElementTitle((indexPath as NSIndexPath).row)
        cell.iconImageView.image = UIImage(named: content.homeElementIcon((indexPath as NSIndexPath).row))
        cell.markLabel.isHidden = true
        
        if content is CongressContentInfo && (indexPath as NSIndexPath).row == 0 && message != "0" {
            cell.markLabel.text = message
            cell.markLabel.isHidden = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        content.actionDelegate?.didClickIndexPath(self, indexPath: indexPath)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SituationSegue" {
            let vc = segue.destination as! SituationViewController
            vc.header = sender as! String
        }
    }

}
