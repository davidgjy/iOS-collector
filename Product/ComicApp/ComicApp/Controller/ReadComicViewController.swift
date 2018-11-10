//
//  ReadComicViewController.swift
//  ComicApp
//
//  Created by GuJinYi on 16/9/6.
//  Copyright © 2016年 Genesis. All rights reserved.
//

import UIKit

class ReadComicViewController: UIViewController {
    let SPIN_SIZE: CGFloat = 30.0
//    var session: NSURLSession = {
//        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
//        return NSURLSession(configuration: config)
//    }()
    var stopDownload: Bool! = false
    var showToolbar: Bool! = false {
        didSet {
            if (self.showToolbar == true) {
                //print("show toolbar")
                self.toolBar.hidden = false
            } else {
                //print("hide toolbar")
                self.toolBar.hidden = true
            }
        }
    }
    
    var seriesId: Int = 0
    var volumeId: Int = 1
    var currentPage = 0
    var allItems: [ComicItem] = []
    var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var comicView: UIImageView!
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    
    var leftSwipeRecognizer: UISwipeGestureRecognizer!
    var rightSwipeRecognizer: UISwipeGestureRecognizer!
    var tapRecognizer: UITapGestureRecognizer!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        leftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ReadComicViewController.handleLeftSwipe(_:)))
        rightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ReadComicViewController.handleRightSwipe(_:)))
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ReadComicViewController.handleTaps(_:)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Series Id: \(seriesId)")
        
        self.comicView.contentMode = .ScaleAspectFit;
        
        self.toolBar.hidden = true
        
        initSpinner()
        requestComicFromNetwork()
        
        leftSwipeRecognizer.direction = .Left
        rightSwipeRecognizer.direction = .Right
        leftSwipeRecognizer.numberOfTouchesRequired = 1
        rightSwipeRecognizer.numberOfTouchesRequired = 1
        view.addGestureRecognizer(leftSwipeRecognizer)
        view.addGestureRecognizer(rightSwipeRecognizer)
        view.addGestureRecognizer(tapRecognizer)
        
        addRefreshNotification()
    }
    
    func initSpinner() {
        spinner = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        spinner.color = UIColor.greenColor()
        spinner.frame = CGRectMake(UIScreen.mainScreen().bounds.size.width / 2 - SPIN_SIZE / 2,
                                   UIScreen.mainScreen().bounds.size.height / 2 - SPIN_SIZE * 2,
                                   SPIN_SIZE,
                                   SPIN_SIZE)
        spinner.center = self.view.center
        self.view.addSubview(spinner)
    }
    
    func requestComicFromNetwork() {
        self.spinner.startAnimating()
        
        let httpMethod = "POST"
        
        /* We have a 15 seconds timeout for our connection */
        let timeout = 15.0
        
        /* You can choose your own URL here */
        let urlAsString = "http://comic.coolbaba.net/api/comic/"
        
        //    urlAsString += "?param1=First"
        //    urlAsString += "&param2=Second"
        
        let url = NSURL(string: urlAsString)
        
        /* Set the timeout on our request here */
        let urlRequest = NSMutableURLRequest(URL: url!,
                                             cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData,
                                             timeoutInterval: timeout)
        
        urlRequest.HTTPMethod = httpMethod
        
        let body = "seriesId=\(seriesId)&volumeId=\(volumeId)".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        urlRequest.HTTPBody = body
        
        let session: NSURLSession = {
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            return NSURLSession(configuration: config)
        }()

        let task = session.dataTaskWithRequest(urlRequest) { (data, response, error) in
            guard let data = data where data.length > 0 else{
                print("Error happened")
                return
            }
            
            //            let html = NSString(data: data, encoding: NSUTF8StringEncoding)
            //            print("html = \(html)")
            
            let jsonData = JsonUtil.retrieveJsonFromData(data)
            let dataDict = jsonData["data"] as! NSDictionary
            let comicArray = dataDict["comics"] as! NSArray
            let loadNum = comicArray.count / 10
            for i in 0..<comicArray.count {
                if (self.stopDownload == true) {
                    return
                }
                
                let comicId = comicArray[i]["id"] as! Int
                let picture = comicArray[i]["picture"] as! String
                let subFolder = comicArray[i]["subFolder"] as! String
                let sourceFolder = comicArray[i]["sourceFolder"] as! String
                let sourceName = comicArray[i]["sourceName"] as! String
                let pageNo = comicArray[i]["pageNo"] as! Int
                
                let comicItem = ComicItem(id: comicId, picture: picture, subFolder: subFolder, sourceFolder: sourceFolder, sourceName: sourceName, pageNo: pageNo)
                print("Comic\(i) = \(comicItem.id), \(comicItem.picture), \(comicItem.pageNo)")
                
                self.allItems.append(comicItem)
                
                if i == loadNum {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.spinner.stopAnimating()
                        self.spinner.hidden = true
                        self.comicView.image = self.allItems[0].fullComic
                    })
                }
            }
            
//            dispatch_async(dispatch_get_main_queue(), {
//                self.comicView.image = self.allItems[0].fullComic
//                self.spinner.stopAnimating()
//                self.spinner.hidden = true
//            })

        }
        
        task.resume()
    }
    
    func handleLeftSwipe(sender: UISwipeGestureRecognizer) {
        if sender.direction == .Left {
            print("Swipe Left")
            
            currentPage += 1
            if currentPage >= self.allItems.count {
                currentPage = self.allItems.count - 1
            }
            self.comicView.image = self.allItems[currentPage].fullComic
        }
    }
    
    func handleRightSwipe(sender: UISwipeGestureRecognizer) {
        if sender.direction == .Right {
            print("Swipe Right")
            
            currentPage -= 1
            if currentPage < 0 {
                currentPage = 0
            }
            self.comicView.image = self.allItems[currentPage].fullComic
        }
    }

    func handleTaps(sender: UITapGestureRecognizer) {
        self.showToolbar = !self.showToolbar
    }
    
    @IBAction func backToDetailView(sender: UIBarButtonItem) {
        //print("back to detail view")
        self.stopDownload = true
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SelectCatalog" {
            self.showToolbar = false
            self.stopDownload = true
        }
    }
    
    func addRefreshNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ReadComicViewController.refreshComicByCatalog(_:)), name: "RefreshByCatalog", object: nil)
    }
    
    func refreshComicByCatalog(notification: NSNotification) {
        print("Refresh comic by catalog: \(notification.object)")
        if let catalogId = notification.object {
            seriesId = 2
            volumeId = catalogId as! Int
            stopDownload = false
            self.allItems = []
            requestComicFromNetwork()
        }
    }
}



