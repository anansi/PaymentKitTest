//
//  IAPurchaceViewController.swift
//  PaymentKitTest
//
//  Created by Julian Hulme on 2016/07/19.
//  Copyright © 2016 Julian Hulme. All rights reserved.
//

import UIKit

import StoreKit //TODO note that the StoreKit has already been imported for this activity

class IAPurchaceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,SKProductsRequestDelegate, SKPaymentTransactionObserver {

    
    //TODO you will need to use the variable, productIdentifiers to fetch the IAP products from the app store
    var productIdentifiers:Set<String>  {
        var resultSet = Set<String>()
        resultSet.insert("waykn.twin.cannon")
        resultSet.insert("waykn.ammo")
        return resultSet
    }
    //Note. this is the array to store fetched products in
    var productsArray:Array<SKProduct!>  = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViewControllerDisplay()
        
        //TODO Starting point: fill in the code to fetch the products sold in this app
        self.requestProductInfo()
        
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
    }
    
    
    func requestProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            print("In requestProductInfo() - canMakePayments() = true")
            //TODO 
            //1 - Create a Set of strings representing IAP products as defined in iTunes Connect
            

            //TODO
            //2 - Create an SKProductRequest object
            //    set the product identifiers to be fetched
            //    set the delegate of the SKProductRequest object to this ViewController and implement the protocol. It will allow you to handle receipt of the products
            //    finally, make the product request fetch the products from the App Store
            let productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
            
            productsRequest.delegate = self
            productsRequest.start()

            
            //TODO remove these 2 lines of code, they are here to indicate that you need to fetch the products from iTunes Connect
//            self.hasFetchedResults = true
//            tableView.reloadData()
        } else {
            print("In requestProductInfo() - Cannot perform In App Purchases.")
        }
    }
    
    //TODO
    //3 - Implement the protocol (delegate) functions required for the SKProductRequest
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
    

    
    func purchaseProduct(product:SKProduct) {
        //TODO complete this in activity 2
        print ("when 'buy' is tapped, this function is called of the relivant product")
        let payment = SKPayment(product:product as SKProduct)
        SKPaymentQueue.defaultQueue().addPayment(payment)
        self.transactionInProgress = true
    }
    
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions as! [SKPaymentTransaction] {
            switch transaction.transactionState {
            case SKPaymentTransactionState.Purchased:
                print("Transaction completed successfully.")
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                transactionInProgress = false
                //delegate.didBuyColorsCollection(selectedProductIndex)
                
                
            case SKPaymentTransactionState.Failed:
                print("Transaction Failed");
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                transactionInProgress = false
                
            default:
                print(transaction.transactionState.rawValue)
            }
        }
    }

    

//You can view the code below this line if you like, but you do not need to modify it in anyway for this activity
//Hint: focus on the TODO items in this file
//------------------------------------------------------------------------------------------------------------------------------

    @IBOutlet weak var tableView: UITableView!
    var transactionInProgress:Bool = false
    var hasFetchedResults:Bool = false
    
    
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
            self.purchaseProduct(product)
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

