//
//  FacebookViewController.swift
//  ezSocial
//
//  Created by YehYungCheng on 2016/4/23.
//  Copyright © 2016年 YehYungCheng. All rights reserved.
//

import UIKit
import Accounts

class FacebookViewController: SocialViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.accountTypeIdentifier = ACAccountTypeIdentifierFacebook
        self.loginParameters = [
            ACFacebookAppIdKey: "550981634930132",
            ACFacebookPermissionsKey: [],
            //ACFacebookAudienceKey: ACFacebookAudienceFriends
        ]
        self.login()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Social view
    
    override func loginSuccess(account: ACAccount) {
        
        
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("facebookCell", forIndexPath: indexPath)
        
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let text = self.datas[indexPath.row] as? String{
            if text == "load" {
                return 0
            }
        }
        return 44
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
}

