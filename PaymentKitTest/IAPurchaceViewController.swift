//
//  IAPurchaceViewController.swift
//  PaymentKitTest
//
//  Created by Julian Hulme on 2016/07/19.
//  Copyright © 2016 Julian Hulme. All rights reserved.
//

import UIKit

import StoreKit

class IAPurchaceViewController: UIViewController, UITableViewDataSource, SKProductsRequestDelegate, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var hasFetchedResults = false
    let productIdentifiers: Set = Set<String>()
    var productIDs: Array<String!> = ["waykn_subscription_product"]
    var productsArray: Array<SKProduct!> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //initial the tableview
        tableView.dataSource = self
        //set view controller title 
        self.title = "In App Purchases"
        //show the navigation bar again 
        self.navigationController?.navigationBarHidden = false
        
        // Do any additional setup after loading the view.
        self.requestProductInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func requestProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            var productIdentifiers = Set<String>()
            productIdentifiers.insert("waykn_subscription_product")
            productIdentifiers.insert("waykn.twin.cannon")
            
            let productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
            
            productsRequest.delegate = self
            productsRequest.start()

         
        }
        else {
            print("Cannot perform In App Purchases.")
        }
    }
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse)   {
        
        self.hasFetchedResults = true
        if response.products.count != 0 {
            for product in response.products {
                print(product.localizedTitle)
                print(product.localizedDescription)
                productsArray.append(product)
            }
            
            
            self.tableView.reloadData()
        }   else {
            print("There are no products.")
        }
    }
    
    //MARK: UITableViewDelegate functions
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let product = self.productsArray[indexPath.row]
        
    }
    
    //MARK: UITableViewDataSource functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (self.productsArray.count != 0)   {
            return self.productsArray.count
        }   else    {
            return 1
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (self.productsArray.count != 0) {
            
            let product = self.productsArray[indexPath.row]
            
            let cell = UITableViewCell()
            
            let headingLabel = UILabel(frame:CGRectMake(0,0, cell.frame.width, cell.frame.height * 0.5))
            headingLabel.text = product.localizedTitle
            
            let subheadingLabel = UILabel(frame:CGRectMake(0,10, cell.frame.width, cell.frame.height))
            
            subheadingLabel.font = UIFont.systemFontOfSize(CGFloat(12))
            subheadingLabel.text = product.localizedDescription
            
            cell.addSubview(headingLabel)
            cell.addSubview(subheadingLabel)
            
            return cell

        }   else    {
            
            let cell = UITableViewCell()
            
            let headingLabel = UILabel(frame:CGRectMake(0,0, cell.frame.width, cell.frame.height * 0.5))
            
            if(hasFetchedResults)    {
                headingLabel.text = "No in app purchase items found :("
            }   else    {
                headingLabel.text = "Fetching in app purchases..."
            }
            
            
            let subheadingLabel = UILabel(frame:CGRectMake(0,10, cell.frame.width, cell.frame.height))
            
            
            
            cell.addSubview(headingLabel)
            
            
            return cell
        }
        
    }
    
}

