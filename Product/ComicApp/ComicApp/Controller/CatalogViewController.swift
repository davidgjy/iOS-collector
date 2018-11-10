//
//  CatalogViewController.swift
//  ComicApp
//
//  Created by GuJinYi on 16/9/22.
//  Copyright © 2016年 Genesis. All rights reserved.
//

import UIKit

class CatalogViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backButton"), style: .Done, target: self, action: #selector(CatalogViewController.back))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func back() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func testNotification(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("RefreshByCatalog", object: 2)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
