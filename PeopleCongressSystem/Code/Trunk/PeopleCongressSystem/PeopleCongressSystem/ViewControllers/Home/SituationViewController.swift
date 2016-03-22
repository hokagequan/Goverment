//
//  SituationViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/9.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class SituationViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    enum Items: Int {
        case News = 0
        case CongressMeeting
        case Notice
        case StandingMeeting
        case CongressInfo
        case Others
        case Max
        
        func title() -> String {
            let titles = ["人大要闻", "人民代表大会", "常委会公告", "常委会会议", "人大信息", "其它", ""]
            
            return titles[self.rawValue]
        }
        
        func icon() -> String {
            let icons = ["news", "congress_meeting", "notice", "standing_meeting", "congress_info", "others", ""]
            
            return icons[self.rawValue]
        }
    }

    @IBOutlet weak var collectionView: UICollectionView!
    
    var header: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        PCSCustomUtil.customNavigationController(self)
        collectionView.registerNib(UINib(nibName: "NormalImageCell", bundle: nil), forCellWithReuseIdentifier: "NormalImageCell")
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
        return Items.Max.rawValue
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("NormalImageCell", forIndexPath: indexPath) as! NormalImageCell
        
        let item = Items(rawValue: indexPath.row)!
        cell.titleLabel.text = item.title()
        cell.iconImageView.image = UIImage(named: item.icon())
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let item = Items(rawValue: indexPath.row)!
        
        var page = ""
        switch item {
        case .News:
            page = "newstype=010401"
            break
        case .CongressMeeting:
            page = "newstype=010402"
            break
        case .Notice:
            page = "newstype=010404"
            break
        case .StandingMeeting:
            page = "newstype=010403"
            break
        case .CongressInfo:
            page = "newstype=010405"
            break
        case .Others:
            page = "newstype=010406"
            break
        default:
            break
        }
        
        let headerPage = PCSDataManager.defaultManager().htmlURL(header)
        let range = headerPage.rangeOfString("?")
        let partOne = headerPage.substringToIndex(range!.endIndex)
        let partTwo = headerPage.substringFromIndex(range!.endIndex)
        let totalPage = "\(partOne)\(page)&\(partTwo)"
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("CommonHTMLViewController") as! CommonHTMLViewController
        vc.URL = totalPage
        vc.naviTitle = item.title()
        self.navigationController?.pushViewController(vc, animated: true)
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
