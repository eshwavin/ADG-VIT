//
//  HomeTableViewDataDelegate.swift
//  ADG VIT
//
//  Created by Srivinayak Chaitanya Eshwa on 29/01/17.
//  Copyright © 2017 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class HomeTableViewDataDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var VITNews: [String] = []
    var ADGNews: [String] = []
    
    override init() {
        super.init()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 100 {
            return self.VITNews.count
        }
        else {
            return self.ADGNews.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsTableViewCell", for: indexPath) as! HomeTableViewCell
        
        if tableView.tag == 100 {
            cell.newsLabel.text = self.VITNews[indexPath.row]
        }
        else {
            cell.newsLabel.text = self.ADGNews[indexPath.row]
        }
        
        return cell
    }
    
    
    
    
}
