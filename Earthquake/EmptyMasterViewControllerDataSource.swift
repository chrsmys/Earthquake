//
//  EmptyMasterViewControllerDataSource.swift
//  Earthquake
//
//  Created by Chris Mays on 2/23/15.
//  Copyright (c) 2015 Chris Mays. All rights reserved.
//

import UIKit
@objc class EmptyMasterViewControllerDataSource : NSObject, UITableViewDataSource {
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("emptyCell") as? UITableViewCell;
        return cell!
    
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
}
