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
    
    let content = PCSDataManager.defaultManager().content
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UICollectionView
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return (self.view.bounds.size.width - 3 * 70.0 * GlobalUtil.rateForWidth()) / 3.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let distance = (self.view.bounds.size.width - 3 * 70.0 * GlobalUtil.rateForWidth()) / 6.0
        return UIEdgeInsetsMake(20, distance, 20, distance)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(70.0 * GlobalUtil.rateForWidth(), 70 * GlobalUtil.rateForWidth() + 30)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return content.homeElementCount()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("NormalImageCell", forIndexPath: indexPath) as! NormalImageCell
        
        cell.titleLabel.text = content.homeElementTitle(indexPath.row)
        cell.iconImageView.image = UIImage(named: content.homeElementIcon(indexPath.row))
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // TODO: 人民代表的点击处理
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        if content is WorderContentInfo {
            let actionDelegate = WorkerHomeActionDelegate()
            
            actionDelegate.didClickIndexPath(self, indexPath: indexPath)
        }
        else if content is CongressContentInfo {
            let actionDelegate = CongressHomeActionDelegate()
            
            actionDelegate.didClickIndexPath(self, indexPath: indexPath)
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
