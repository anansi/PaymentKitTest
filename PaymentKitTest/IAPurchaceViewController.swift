//
//  IAPurchaceViewController.swift
//  PaymentKitTest
//
//  Created by Julian Hulme on 2016/07/19.
//  Copyright © 2016 Julian Hulme. All rights reserved.
//

import UIKit

import StoreKit

class IAPurchaceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var transactionInProgress:Bool = false
    var hasFetchedResults = false
    let productIdentifiers: Set = Set<String>()
    var productIDs: Array<String!> = []
    var productsArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViewControllerDisplay()
        
        //TODO Starting point: fill in the code to fetch the products sold in this app
        self.requestProductInfo()
    }
    
    //Your First function to implement
    func requestProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            print("In requestProductInfo() - canMakePayments() = true")
            
            self.hasFetchedResults = true
            tableView.reloadData()
        } else {
            print("In requestProductInfo() - Cannot perform In App Purchases.")
        }
    }
    

//You can view the code below this line if you like, but you do not need to modify it in anyway for this activity
//Hint: focus on the TODO items in this file
//------------------------------------------------------------------------------------------------------------------------------

    
    func initViewControllerDisplay()    {
        //initial the tableview
        tableView.dataSource = self
        tableView.delegate = self
        //set view controller title
        self.title = "In App Purchases"
    }

    func showActions(product:SKProduct) {
        if transactionInProgress {
            return
        }
        
        let actionSheetController = UIAlertController(title: "Do you want to process with purchase of:", message: "\(product.localizedTitle)?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let buyAction = UIAlertAction(title: "Buy", style: UIAlertActionStyle.Default) { (action) -> Void in
            let payment = SKPayment(product:product as SKProduct)
            SKPaymentQueue.defaultQueue().addPayment(payment)
            self.transactionInProgress = true
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            
        }
        
        actionSheetController.addAction(buyAction)
        actionSheetController.addAction(cancelAction)
        
        presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    //MARK: UITableViewDelegate functions
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let product = self.productsArray[indexPath.row]
        
        showActions(product as! SKProduct)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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

