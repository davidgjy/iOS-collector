//
//  SeriesListViewController.swift
//  ComicApp
//
//  Created by GuJinYi on 16/8/26.
//  Copyright © 2016年 Genesis. All rights reserved.
//

import UIKit

class SeriesListViewController: UITableViewController {
    let SPIN_SIZE: CGFloat = 30.0
    
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    var allItems: [SeriesItem] = []
    
    var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        print("-- viewDidLoad --")
        super.viewDidLoad()
        
        spinner = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        spinner.color = UIColor.blueColor()
        spinner.frame = CGRectMake(UIScreen.mainScreen().bounds.size.width / 2 - SPIN_SIZE / 2,
                                   UIScreen.mainScreen().bounds.size.height / 2 - SPIN_SIZE * 2,
                                   SPIN_SIZE,
                                   SPIN_SIZE)
        spinner.center = self.tableView.center
        self.tableView.addSubview(spinner)
        
        requestSeriesListFromNetwork()
        
        // Get the height of the status bar
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        self.tableView.contentInset = insets
        self.tableView.scrollIndicatorInsets = insets
        
        self.tableView.rowHeight = 70
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //self.tableView.reloadData()
        
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
    }
    
    override func tableView(tableView: UITableView,
                            cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Create an instance of UITableViewCell, with default appearance
        let cell = tableView.dequeueReusableCellWithIdentifier("SeriesItemCell", forIndexPath: indexPath) as! SeriesItemCell
        
        // Set the text on the cell with the description of the item
        // that is at the nth index of items, where n = row this cell
        // will appear in on the tableview
        let item = allItems[indexPath.row]
        
        cell.nameLabel.text = item.name
        cell.categoryLabel.text = item.category
        cell.thumbnaiView.image = item.thumbnail
        
        return cell
    }
    
    func requestSeriesListFromNetwork() {
        self.spinner.startAnimating()
        
        let httpMethod = "GET"
        
        /* We have a 15 seconds timeout for our connection */
        let timeout = 15.0
        
        /* You can choose your own URL here */
        let urlAsString = "http://comic.coolbaba.net/api/series/"
        
        //    urlAsString += "?param1=First"
        //    urlAsString += "&param2=Second"
        
        let url = NSURL(string: urlAsString)
        
        /* Set the timeout on our request here */
        let urlRequest = NSMutableURLRequest(URL: url!,
                                             cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData,
                                             timeoutInterval: timeout)
        
        urlRequest.HTTPMethod = httpMethod
        
        let task = session.dataTaskWithRequest(urlRequest) { (data, response, error) in
            guard let data = data where data.length > 0 else{
                print("Error happened")
                return
            }
            
            //let html = NSString(data: data, encoding: NSUTF8StringEncoding)
            //print("html = \(html)")
            
            let jsonData = JsonUtil.retrieveJsonFromData(data)
            let dataArray = jsonData["data"] as! NSArray
            for i in 0..<dataArray.count {
                let seriesId = dataArray[i]["id"] as! Int
                let name = dataArray[i]["name"] as! String
                let category = dataArray[i]["category"] as! String
                let sourceWeb = dataArray[i]["sourceWeb"] as! String
                let brief = dataArray[i]["brief"] as! String
                let folder = dataArray[i]["folder"] as! String
                let cover = dataArray[i]["cover"] as! String
                
                let seriesItem = SeriesItem(id: seriesId, name: name, category: category, sourceWeb: sourceWeb, brief: brief, folder: folder, cover: cover)
                print("Series\(i) = \(seriesItem.id), \(seriesItem.name), \(seriesItem.cover)")
                
                self.allItems.append(seriesItem)
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                self.spinner.stopAnimating()
                self.spinner.hidden = true
            })
        }
        
        task.resume()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowSeriesItem" {
            // Figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                // Get the item associated with the row and pass it along
                let item = self.allItems[row]
                let detailViewController = segue.destinationViewController as! SeriesDetailViewController
                detailViewController.item = item
            }
        }
    }
}





