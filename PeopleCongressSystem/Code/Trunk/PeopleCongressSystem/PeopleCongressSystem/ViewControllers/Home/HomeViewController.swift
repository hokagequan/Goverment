//
//  HomeViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/1/19.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    enum HomeCellRow: Int {
        case ActivityManage = 0
        case VariableManage
        case Analyze
        case ShareSpace
        case CongressInfo
        case Notify
        case Situation
        case Max
        
        func title() -> String {
            let titles = ["活动管理", "履职管理", "履职统计", "共享空间", "代表信息", "通知通报", "知情知政"]
            
            return titles[self.rawValue]
        }
        
        func icon() -> String {
            let icons = ["lock_dot_nor", "lock_dot_nor", "lock_dot_nor", "lock_dot_nor", "lock_dot_nor", "lock_dot_nor", "lock_dot_nor"]
            
            return icons[self.rawValue]
        }
    }

    @IBOutlet weak var collectionView: UICollectionView!
    
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
        return (self.view.bounds.size.width - 3 * 80.0) / 3.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let distance = (self.view.bounds.size.width - 3 * 80.0) / 6.0
        return UIEdgeInsetsMake(20, distance, 20, distance)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HomeCellRow.Max.rawValue
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("NormalImageCell", forIndexPath: indexPath) as! NormalImageCell
        
        let row = HomeCellRow(rawValue: indexPath.row)
        cell.titleLabel.text = row!.title()
        cell.iconImageView.image = UIImage(named: row!.icon())
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // TODO:
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let row = HomeCellRow(rawValue: indexPath.row)!
        
        switch row {
        case .ActivityManage:
            break
        case .VariableManage:
            break
        case .Analyze:
            break
        case .ShareSpace:
            break
        case .CongressInfo:
            break
        case .Notify:
            break
        case .Situation:
            break
        default:
            break
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
