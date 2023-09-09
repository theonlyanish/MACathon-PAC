//
//  JobViewController.swift
//  PACReceipts
//
//  Created by Anish Kapse on 9/9/2023.
//

import Foundation
import UIKit
import Pastel

class JobViewController: UIViewController{
    
    // Outler for user menu preference
    override func viewDidLoad() {
        super.viewDidLoad()
        let pastelView = PastelView(frame: view.bounds)

         // Custom Direction
         pastelView.startPastelPoint = .bottomLeft
         pastelView.endPastelPoint = .topRight

         // Custom Duration
         pastelView.animationDuration = 3.0

         // Custom Color
         pastelView.setColors([
            UIColor(red: 12/255, green: 123/255, blue: 179/255, alpha: 1.0),

//                                UIColor(red: 7/255, green: 163/255, blue: 178/255, alpha: 1.0),
//                                UIColor(red: 217/255, green: 236/255, blue: 199/255, alpha: 1.0)])

//            UIColor(red: 14/255, green: 15/255, blue: 172/255, alpha: 1.0),
//            UIColor(red: 75/255, green: 8/255, blue: 109/255, alpha: 1.0)])

               UIColor(red: 242/255, green: 186/255, blue: 232/255, alpha: 1.0)])

         pastelView.startAnimation()
         view.insertSubview(pastelView, at: 0)
        
    }
    

@IBAction func nextBtnClicked(_ sender: UIButton)
{
    
    let controller = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
    controller.modalPresentationStyle = .fullScreen
    controller.modalTransitionStyle = .flipHorizontal
    UserDefaults.standard.hasOnboarded = true
    present(controller, animated: true, completion: nil)
}
}


