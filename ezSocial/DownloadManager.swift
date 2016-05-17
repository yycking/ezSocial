//
//  DownloadManager.swift
//  ezSocial
//
//  Created by YehYungCheng on 2016/5/4.
//  Copyright © 2016年 YehYungCheng. All rights reserved.
//

import Foundation

class DownloadManager {
    var retry = 3
    let request: NSMutableURLRequest!
    let action: NSDictionary->()!
    var fail: (()->())?
    
    init(url: String, success: NSDictionary->()) {
        self.request = NSMutableURLRequest(URL: NSURL(string: url)!)
        self.action = success
    }
    
    @objc func connect() {
        autoreleasepool {
            let session = NSURLSession.sharedSession()
            let sessionURLTask = session.dataTaskWithRequest(request) { (data, response, error) in
                // success and error handling
                if let data = data {
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
                        self.action(json as! NSDictionary)
                    } catch let myJSONError {
                        print(myJSONError)
                    }
                } else if let error = error {
                    // check if error is transient or final and throw right error
                    if let delay = error.userInfo["ErrorRetryDelayKey"] as? Double {
                        // request failed and can be retry later
                        self.reconnect(delay)
                    } else {
                        // request failed for other reason
                        self.reconnect()
                    }
                } else {
                    // no data received scenario
                    self.reconnect()
                }
            }
            
            sessionURLTask.resume()
        }
    }
    
    func reconnect(delay: Double = 1) {
        if self.retry > 0 {
            NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: #selector(DownloadManager.connect), userInfo: nil, repeats: false)
            
            self.retry = self.retry-1
        }else if let next = fail {
            next()
        }
    }
}