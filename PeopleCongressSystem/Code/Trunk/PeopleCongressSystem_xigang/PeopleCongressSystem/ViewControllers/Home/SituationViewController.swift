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
        case news = 0
        case congressMeeting
        case notice
        case standingMeeting
        case congressInfo
        case others
        case max
        
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
        collectionView.register(UINib(nibName: "NormalImageCell", bundle: nil), forCellWithReuseIdentifier: "NormalImageCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return (self.view.bounds.size.width - 3 * 70.0 * GlobalUtil.rateForWidth()) / 3.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let distance = (self.view.bounds.size.width - 3 * 70.0 * GlobalUtil.rateForWidth()) / 6.0
        return UIEdgeInsetsMake(20, distance, 20, distance)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70.0 * GlobalUtil.rateForWidth(), height: 70 * GlobalUtil.rateForWidth() + 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Items.max.rawValue
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NormalImageCell", for: indexPath) as! NormalImageCell
        
        let item = Items(rawValue: (indexPath as NSIndexPath).row)!
        cell.titleLabel.text = item.title()
        cell.iconImageView.image = UIImage(named: item.icon())
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = Items(rawValue: (indexPath as NSIndexPath).row)!
        
        var page = ""
        switch item {
        case .news:
            page = "newstype=010401"
            break
        case .congressMeeting:
            page = "newstype=010402"
            break
        case .notice:
            page = "newstype=010404"
            break
        case .standingMeeting:
            page = "newstype=010403"
            break
        case .congressInfo:
            page = "newstype=010405"
            break
        case .others:
            page = "newstype=010406"
            break
        default:
            break
        }
        
        let headerPage = PCSDataManager.defaultManager().htmlURL(header)
        let range = headerPage.range(of: "?")
        let partOne = headerPage.substring(to: range!.upperBound)
        let partTwo = headerPage.substring(from: range!.upperBound)
        let totalPage = "\(partOne)\(page)&\(partTwo)"
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CommonHTMLViewController") as! CommonHTMLViewController
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
