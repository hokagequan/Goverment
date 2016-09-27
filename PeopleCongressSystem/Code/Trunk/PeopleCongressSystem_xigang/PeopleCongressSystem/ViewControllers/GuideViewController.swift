//
//  GuideViewController.swift
//  SuperGome
//
//  Created by Q on 15/12/17.
//  Copyright © 2015年 EADING. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var guideOne: UIImageView!
    @IBOutlet weak var guideTwo: UIImageView!
    @IBOutlet weak var guideThree: UIImageView!
    @IBOutlet weak var guideFour: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        guideOne.image = UIImage(named: "guide_one")
        guideTwo.image = UIImage(named: "guide_two")
//        [CustomObjectUtil .customObject([startButton], backgroundColor: UIColor(white: 1.0, alpha: 0.5), borderWith: 1.0, borderColor: UIColor.whiteColor(), corner: 25.0)]
//        
//        let screenSizeHeight = UIScreen.mainScreen().bounds.size.height
//        
//        if screenSizeHeight == 568 {
//            self.guideOne.image = UIImage(named: "guide_one_568")
//            self.guideTwo.image = UIImage(named: "guide_two_568")
//            self.guideThree.image = UIImage(named: "guide_three_568")
//            self.guideFour.image = UIImage(named: "guide_four_568")
//        }
//        else if screenSizeHeight == 667 {
//            self.guideOne.image = UIImage(named: "guide_one_667")
//            self.guideTwo.image = UIImage(named: "guide_two_667")
//            self.guideThree.image = UIImage(named: "guide_three_667")
//            self.guideFour.image = UIImage(named: "guide_four_667")
//        }
//        else if screenSizeHeight == 736 {
//            self.guideOne.image = UIImage(named: "guide_one_736")
//            self.guideTwo.image = UIImage(named: "guide_two_736")
//            self.guideThree.image = UIImage(named: "guide_three_736")
//            self.guideFour.image = UIImage(named: "guide_four_736")
//        }
//        else {
//            self.guideOne.image = UIImage(named: "guide_one")
//            self.guideTwo.image = UIImage(named: "guide_two")
//            self.guideThree.image = UIImage(named: "guide_three")
//            self.guideFour.image = UIImage(named: "guide_four")
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
        pageControl.currentPage = index
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
