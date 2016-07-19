//
//  IAPurchaceViewController.swift
//  PaymentKitTest
//
//  Created by Julian Hulme on 2016/07/19.
//  Copyright © 2016 Julian Hulme. All rights reserved.
//

import UIKit

import StoreKit

class IAPurchaceViewController: UIViewController, SKProductsRequestDelegate {

    let productIdentifiers: Set = Set<String>()
    var productIDs: Array<String!> = ["waykn_subscription_product"]
    var productsArray: Array<SKProduct!> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        if response.products.count != 0 {
            for product in response.products {
                print(product.localizedTitle)
                print(product.localizedDescription)
                productsArray.append(product)
            }
        }   else {
            print("There are no products.")
        }
    }
    
}

