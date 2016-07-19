//
//  LandingViewController.swift
//  PaymentKitTest
//
//  Created by Julian Hulme on 2016/07/19.
//  Copyright © 2016 Julian Hulme. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //set view controller title
        self.title = "Home"
        
        
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Organize, target: self, action: "storeButtonTapped"), animated: true)
        //var storeButton = UIBarButtonItem("Store",target: self,action: "storeButtonTapped")
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func storeButtonTapped() {
        
        let storeViewControler = IAPurchaceViewController(nibName: "IAPurchaceViewController", bundle: nil)
        self.navigationController?.pushViewController(storeViewControler, animated: true)
    }

}
