//
//  EventDetailsViewController.swift
//  ADG VIT
//
//  Created by Srivinayak Chaitanya Eshwa on 03/02/17.
//  Copyright © 2017 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var event: [String: AnyObject]!
    
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventTitleHead: UIView!
    @IBOutlet weak var eventTitleHeadLabel: UILabel!
    @IBOutlet weak var eventTextView: UITextView!
    @IBOutlet weak var eventDateLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var eventCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHideRevealButton: UIButton!
    
    @IBOutlet weak var scrollRightButton: UIButton!
    @IBOutlet weak var scrollLeftButton: UIButton!
    
    var eventImages: [UIImage] = []
    
    var collectionViewItemWidth: CGFloat = 0.0
    
    var flag = true
    
    var currentCollectionViewItem: IndexPath = IndexPath(item: 0, section: 0)
    
    // MARK: - View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // UI Changes
        
        self.eventTitleHeadLabel.text = (self.event!["name"] as! String)
        self.eventTitle.text = (self.event!["name"] as! String)
        self.eventTextView.text = (self.event!["description"] as! String)
        
        self.eventDateLabel.text = (self.event!["date"] as! String)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.001) {
            self.eventTextView.setContentOffset(CGPoint.zero, animated: false)
        }
        
        // get images
        
//        self.getImages()
        
        if self.eventImages.count == 0 {
            self.scrollLeftButton.isHidden = true
            self.scrollRightButton.isHidden = true
        }
        
        // reachability
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.reachabilityChanged), name: NSNotification.Name(rawValue: "ReachStatusChanged"), object: nil)
        
        self.reachabilityChanged()
        
        // hide left button
        self.scrollLeftButton.alpha = 0.0
        self.scrollLeftButton.isHidden = true
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.exitButton.layer.cornerRadius = self.exitButton.frame.height / 2.0
        
        self.scrollLeftButton.layer.cornerRadius = self.scrollLeftButton.frame.height / 2.0
        self.scrollRightButton.layer.cornerRadius = self.scrollRightButton.frame.height / 2.0
        
        self.imageHideRevealButton.layer.cornerRadius = self.imageHideRevealButton.frame.height / 2.0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Collection View Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.eventImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventsImageCollectionViewCell", for: indexPath) as! EventsImageCollectionViewCell
        
        cell.imageView.image = self.eventImages[indexPath.item]
        cell.imageView.alignTop = true
        
        return cell
    }
    
    // MARK: - Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // MARK: - Collection View Flow Delegate Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        self.collectionViewItemWidth = self.collectionView.frame.width
        return CGSize(width: self.collectionViewItemWidth, height: self.collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    // MARK: - Get images
    
    func getImages() {
        
        if self.eventImages.count != 0 {
            return
        }
        
        else {
            
            let images = self.event["images"] as! [String: String]
            
            for image in images {
                
                DataManager().getEventsImage(url: "\(image.value).png", completion: { (returnedImage) in
                    if returnedImage != nil {
                        self.eventImages.append(returnedImage!)
                        
                        if self.eventImages.count >= 2 {
                            self.scrollRightButton.isHidden = false
                            self.scrollRightButton.alpha = 1.0
                        }
                        
                        
                        self.collectionView.reloadData()
                    }
                    
                })
            }
        }
        
    }
    
    // MARK: - Support Functions
    
    @IBAction func changeHeight(_ sender: UIButton) {
        
        if self.eventCollectionViewHeightConstraint.constant == 0 {
            self.eventCollectionViewHeightConstraint.constant = (self.view.frame.height) * 0.6
        }
        else {
            self.eventCollectionViewHeightConstraint.constant = 0
            
        }
        
        
        UIView.animate(withDuration: 1.0) {
            
            if self.eventTitleHead.alpha == 0 {
                self.eventTitleHead.alpha = 1
            }
            else {
                self.eventTitleHead.alpha = 0
            }
            
            self.view.layoutIfNeeded()
            
        }
        self.collectionView.reloadData()
        self.collectionView.scrollToItem(at: self.currentCollectionViewItem, at: UICollectionViewScrollPosition.left, animated: false)
        
    }
    
    func reachabilityChanged() {
        if reachabilityStatus == NOACCESS {
            self.present(noInternetAccessAlert(), animated: true, completion: nil)
        }
        else if self.eventImages.count == 0 {
            self.getImages()
        }
        
    }
    
    // MARK: - Collection View Scrolling
    
    @IBAction func scrollEventImages(_ sender: UIButton) {
        
        if !self.flag {
            return
        }
        
        self.flag = false
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { 
            self.flag = true
        }
        
        if sender.tag == 1 {
            
            let indexPath = collectionView.indexPathsForVisibleItems.first! as IndexPath
            
            if indexPath.item <= 0 {
                return
            }
            
            let previousIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
            self.collectionView.scrollToItem(at: previousIndexPath, at: UICollectionViewScrollPosition.left, animated: true)
            
        }
        else if sender.tag == 2 {
            
            let indexPath = collectionView.indexPathsForVisibleItems.first! as IndexPath
            
            if indexPath.item >= self.eventImages.count {
                return
            }
            
            let nextIndexPath = IndexPath(item: indexPath.item + 1, section: indexPath.section)
            self.collectionView.scrollToItem(at: nextIndexPath, at: UICollectionViewScrollPosition.left, animated: true)
            
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        print(scrollView.contentOffset.x)
        
        if scrollView.contentOffset.x <= 0 {
            
            if !(self.scrollLeftButton.isHidden) {
                self.scrollLeftButton.fadeOut(0.3, delay: 0.0, completion: { (true) in
                    self.scrollLeftButton.isHidden = true
                })
            }
            
            
        }
        else if self.scrollLeftButton.isHidden {
            self.scrollLeftButton.fadeIn(0.3, delay: 0.0, completion: { (true) in
                self.scrollLeftButton.isHidden = false
            })
        }
        
        if scrollView.contentOffset.x >= self.collectionViewItemWidth * CGFloat(self.eventImages.count - 1) {
            
            if !(self.scrollRightButton.isHidden) {
                self.scrollRightButton.fadeOut(0.3, delay: 0.0, completion: { (true) in
                    self.scrollRightButton.isHidden = true
                })
            }
            
        }
        else if self.scrollRightButton.isHidden {
            self.scrollRightButton.fadeIn(0.3, delay: 0.0, completion: { (true) in
                self.scrollRightButton.isHidden = false
            })
        }
        
        self.currentCollectionViewItem = IndexPath(item: Int(scrollView.contentOffset.x / self.collectionViewItemWidth), section: 0)
        
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
