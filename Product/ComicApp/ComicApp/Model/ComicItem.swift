//
//  ComicItem.swift
//  ComicApp
//
//  Created by GuJinYi on 16/9/6.
//  Copyright © 2016年 Genesis. All rights reserved.
//

import UIKit

class ComicItem {
    var id: Int
    var picture: String?
    var subFolder: String?
    var sourceFolder: String?
    var sourceName: String?
    var pageNo: Int
    
    var fullComic: UIImage?
    
    init(id: Int, picture: String?, subFolder: String?, sourceFolder: String?,
         sourceName: String?, pageNo: Int) {
        self.id = id
        self.picture = picture
        self.subFolder = subFolder
        self.sourceFolder = sourceFolder
        self.sourceName = sourceName
        self.pageNo = pageNo
        
        let imageUrl = NSURL(string: picture!)
        let imageData = NSData(contentsOfURL:imageUrl!)
        let mImage = UIImage(data:imageData!)!
        self.fullComic = mImage
    }
}