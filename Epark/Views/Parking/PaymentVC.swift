//
//  PaymentVC.swift
//  Epark
//
//  Created by iheb mbarki on 10/11/2022.
//

import UIKit
import Braintree

class PaymentVC: UIViewController {

    var braintreeClient: BTAPIClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        braintreeClient = BTAPIClient(authorization: "sandbox_hcw9bttw_f9twjfrdc6dnwx78")!
        
        let payPalDriver = BTPayPalDriver(apiClient: braintreeClient)
            payPalDriver.viewControllerPresentingDelegate = self
            payPalDriver.appSwitchDelegate = self // Optional
    }
    

}

extension PaymentVC: BTviewControllerPresentingDelegate {
    
}

extension PaymentVC: BTappSwitchDelegate {
    
}
