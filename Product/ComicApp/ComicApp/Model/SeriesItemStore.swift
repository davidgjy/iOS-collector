//
//  SeriesItemStore.swift
//  ComicApp
//
//  Created by GuJinYi on 16/8/30.
//  Copyright © 2016年 Genesis. All rights reserved.
//

import UIKit

class SeriesItemStore {
    var allItems = [SeriesItem]()
    
    init() {
        //requestSeriesListFromNetwork()
        //createRandomItems()
    }
    
    func createRandomItems() {
        for _ in 0..<5 {
            let seriesId = 1
            let name = "Test"
            let category = ""
            let sourceWeb = ""
            let brief = "This is a test"
            let folder = ""
            let cover = ""
            
            let seriesItem = SeriesItem(id: seriesId, name: name, category: category, sourceWeb: sourceWeb, brief: brief, folder: folder, cover: cover)
            
            self.allItems.append(seriesItem)
        }

    }
    
    
}



