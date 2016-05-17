//
//  SocialViewController.swift
//  ezSocial
//
//  Created by YehYungCheng on 2016/4/24.
//  Copyright © 2016年 YehYungCheng. All rights reserved.
//

import UIKit
import Accounts

class SocialViewController: UITableViewController {
    
    @IBOutlet weak var activyIndicator: UIActivityIndicatorView!
    @IBOutlet weak var failLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    var accountTypeIdentifier: String!
    var loginParameters: [NSObject: AnyObject]!
    var datas = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if nil == self.tableView.backgroundView {
            let bundle = NSBundle(forClass: self.dynamicType)
            let nib = UINib(nibName: "FailView", bundle: bundle)
            let views = nib.instantiateWithOwner(self, options: nil)
            self.tableView.backgroundView = views[0] as? UIView
            
            self.refreshButton.addTarget(self, action: #selector(SocialViewController.login), forControlEvents: .TouchUpInside)
        }
    }
    
    func login() {
        if let _ = self.tableView.backgroundView {
            activyIndicator.startAnimating()
            
            self.refreshButton.hidden = true
            
            self.failLabel.hidden = true
            let index = accountTypeIdentifier.startIndex.advancedBy(10)
            self.failLabel.text = "Please check \(accountTypeIdentifier.substringFromIndex(index)) on \"Setting\""
            
            self.tableView.separatorStyle = .None
            
            let store = ACAccountStore()
            let accountType = store.accountTypeWithAccountTypeIdentifier(accountTypeIdentifier)
            store.requestAccessToAccountsWithType(accountType, options: loginParameters) { granted, error in
                dispatch_async(dispatch_get_main_queue(), {
                    self.activyIndicator.stopAnimating()
                    
                    if granted {
                        let accounts = store.accountsWithAccountType(accountType)
                        if let account = accounts.last as? ACAccount {
                            self.tableView.separatorStyle = .SingleLine
                            self.tableView.backgroundView = nil
                            
                            self.loginSuccess(account)
                            return
                        }
                    }
                    
                    if (error != nil) {
                        print(error)
                    }
                    
                    self.refreshButton.hidden = false
                    self.failLabel.hidden = false
                })
            }
        }
    }
    
    func loginSuccess(account: ACAccount) {
        
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }

}
