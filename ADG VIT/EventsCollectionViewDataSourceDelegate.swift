//
//  EventsCollectionViewDataSourceDelegate.swift
//  ADG VIT
//
//  Created by Srivinayak Chaitanya Eshwa on 02/02/17.
//  Copyright © 2017 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import Foundation

class EventsCollectionViewDataSourceDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var upcomingEvents: [[String: AnyObject]] = []
    var pastEvents: [[String: AnyObject]] = []
    
    var navigationFunction: (([String: AnyObject])-> Void)?
    
    // MARK: - Collection View Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 100 {
//            print("U:", self.upcomingEvents.count)
            return self.upcomingEvents.count
            
        }
        else {
//            print("P:", self.pastEvents.count)
            return self.pastEvents.count
            
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "innerCollectionViewCell", for: indexPath) as! EventsInnerCollectionViewCell
        
        if collectionView.tag == 100 {
            cell.event = self.upcomingEvents[indexPath.item]
        }
        else {
            cell.event = self.pastEvents[indexPath.item]
        }
        
        cell.backgroundColor = eventColors[indexPath.item % eventColors.count]
        
        cell.layer.cornerRadius = 8.0
        cell.clipsToBounds = true
        
        return cell
    }
    
    // MARK: Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        if collectionView.tag == 100 {
            
            var item = self.upcomingEvents[indexPath.item]
            
            item["category"] = "upcoming" as AnyObject
            
            self.navigationFunction?(item)
        }
        else {
            
            var item = self.pastEvents[indexPath.item]
            
            item["category"] = "past" as AnyObject
            
            self.navigationFunction?(item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: - Collection View Delegate Flow Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.5, height: collectionView.frame.height - 15.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 7.5, left: 20.0, bottom: 7.5, right: 20.0)
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    //        return 2.5
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
}
