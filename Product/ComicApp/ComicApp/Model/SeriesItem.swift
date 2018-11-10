//
//  SeriesItem.swift
//  ComicApp
//
//  Created by GuJinYi on 16/8/30.
//  Copyright © 2016年 Genesis. All rights reserved.
//

import UIKit

class SeriesItem {
    var id: Int
    var name: String?
    var category: String?
    var sourceWeb: String?
    var brief: String?
    var folder: String?
    var cover: String?
    
    var imageKey: String?
    var fullCover: UIImage?
    var thumbnail: UIImage?

    init(id: Int, name: String?, category: String?, sourceWeb: String?,
         brief: String?, folder: String?, cover: String?) {
        self.id = id
        self.name = name
        self.category = category
        self.sourceWeb = sourceWeb
        self.brief = brief
        self.folder = folder
        self.cover = cover
        
        self.imageKey = ""
        
        let imageUrl = NSURL(string: cover!)
        let imageData = NSData(contentsOfURL:imageUrl!)
        let mImage = UIImage(data:imageData!)!
        self.fullCover = mImage
        setThumbnailFromImage(mImage)
        
        //super.init()
    }
    
    func setThumbnailFromImage(image: UIImage) {
        let origImageSize: CGSize = image.size
        
        // The rectangle of the thumbnail
        let newRect: CGRect = CGRectMake(0, 0, 40, 40)
        
        // Figure out a scaling ratio to make sure we maintain the same aspect ratio
        let ratio = max(newRect.size.width / origImageSize.width,
                          newRect.size.height / origImageSize.height)
        
        // Create a transparent bitmap context with a scaling factor
        // equal to that of the screen
        UIGraphicsBeginImageContextWithOptions(newRect.size, false, 0.0);
        
        // Create a path that is a rounded rectangle
        let path = UIBezierPath(roundedRect: newRect, cornerRadius:5.0);
        
        // Make all subsequent drawing clip to this rounded rectangle
        path.addClip()
        
        // Center the image in the thumbnail rectangle
        var projectRect = CGRect()
        projectRect.size.width = ratio * origImageSize.width;
        projectRect.size.height = ratio * origImageSize.height;
        projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
        projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
        
        // Draw the image on it
        image.drawInRect(projectRect)
        
        // Get the image from the image context; keep it as our thumbnail
        let smallImage = UIGraphicsGetImageFromCurrentImageContext();
        self.thumbnail = smallImage;
        
        // Cleanup image context resources; we're done
        UIGraphicsEndImageContext();
    }
}




