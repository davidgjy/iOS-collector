//
//  SeriesDetailViewController.swift
//  ComicApp
//
//  Created by GuJinYi on 16/9/5.
//  Copyright © 2016年 Genesis. All rights reserved.
//

import UIKit

class SeriesDetailViewController: UIViewController {
    @IBOutlet weak var nameValue: UILabel!
    @IBOutlet weak var categoryValue: UILabel!
    @IBOutlet weak var briefValue: UILabel!
    @IBOutlet weak var coverView: UIImageView!
    
    var item: SeriesItem! {
        didSet {
            navigationItem.title = item.name
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        nameValue.text = item.name
        categoryValue.text = item.category
        briefValue.text = item.brief
        self.coverView.image = item.fullCover
    }
    
    override func viewDidLoad() {
        // brief label auto break line
        briefValue.lineBreakMode = NSLineBreakMode.ByWordWrapping
        briefValue.numberOfLines = 0
        
        self.tabBarController?.tabBar.hidden = true
        self.coverView.contentMode = .ScaleAspectFit;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ReadSeriesComic" {
            let rcViewController = segue.destinationViewController as! ReadComicViewController
            rcViewController.seriesId = item.id
        }
    }
}


