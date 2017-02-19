//
//  EventsViewController.swift
//  ADG VIT
//
//  Created by Srivinayak Chaitanya Eshwa on 02/02/17.
//  Copyright © 2017 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: Menu Variables
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    // MARK: Collection View Variables
    
    @IBOutlet weak var upcomingEventsButton: UIButton!
    @IBOutlet weak var pastEventsButton: UIButton!
    
    @IBOutlet weak var collectionViewIndicatorLineView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var flag = true
    
    // MARK: Events Variables
    
    var upcomingEvents: [String: AnyObject] = [:]
    var pastEvents: [String: AnyObject] = [:]
    
    var upcomingEventsCollectionView: UICollectionView!
    var pastEventsCollectionView: UICollectionView!
    
    // MARK: CollectionViewDataSourceDelegate
    
    let collectionViewDataSourceDelegate = EventsCollectionViewDataSourceDelegate()
    
    var selectedEvent: [String: AnyObject] = [:]
    
    // MARK: - View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // reachability
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.reachabilityChanged), name: NSNotification.Name(rawValue: "ReachStatusChanged"), object: nil)
        
        self.reachabilityChanged()
        
        // reveal view controller
        
        if revealViewController() != nil {
            self.menuButton.target = revealViewController()
            self.menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rightViewRevealWidth = SWRevealWidth
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // navigation controller
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.title = "Events"
        
        // getting data
        
        self.getData()
        
        // setting navigation of the collectionviewdatasourcedelegate
        self.collectionViewDataSourceDelegate.navigationFunction = self.segue
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.flag {
            self.collectionViewIndicatorLineView.center.x = self.upcomingEventsButton.center.x
        }
        
    }
    
    // MARK: - Collection View Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "outerCollectionViewCell", for: indexPath) as! EventsOuterCollectionViewCell
        
        cell.innerCollectionView.tag = indexPath.item + 100
        
        if indexPath.item == 0 {
            self.upcomingEventsCollectionView = cell.innerCollectionView
        }
        else {
            self.pastEventsCollectionView = cell.innerCollectionView
        }
        
        if cell.innerCollectionView.dataSource == nil {
            cell.innerCollectionView.dataSource = self.collectionViewDataSourceDelegate
        }
        
        if cell.innerCollectionView.delegate == nil {
            cell.innerCollectionView.delegate = self.collectionViewDataSourceDelegate
        }
        
        return cell
    }
    
    // MARK: - Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // MARK: - Collection View Delegate Flow Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    @IBAction func eventsButtonTapped(_ sender: UIButton) {
        
        if self.flag {
            self.flag = false
        }
        
        if sender.tag == 1 {
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionViewScrollPosition.left, animated: true)
        }
        else {
            self.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: UICollectionViewScrollPosition.left, animated: true)
        }
        
    }
    
    // MARK: - Collection View Scrolling Functions
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if self.flag {
            self.flag = false
        }
        
        let offset = scrollView.contentOffset.x
        
        let ongoingCenter = self.upcomingEventsButton.center.x
        let pastCenter = self.pastEventsButton.center.x
        
        let lineViewRange = pastCenter - ongoingCenter
        
        let maximumOffset = self.collectionView.frame.width
        
        let calculatedCenter = ongoingCenter + (lineViewRange / (maximumOffset) * offset)
        
        self.collectionViewIndicatorLineView.center.x = calculatedCenter
        
        if abs(calculatedCenter - ongoingCenter) < abs(calculatedCenter - pastCenter) {
            self.upcomingEventsButton.setTitleColor(UIColor.white, for: .normal)
            self.pastEventsButton.setTitleColor(newsInactiveColor, for: .normal)
        }
        else {
            self.pastEventsButton.setTitleColor(UIColor.white, for: .normal)
            self.upcomingEventsButton.setTitleColor(newsInactiveColor, for: .normal)
        }
        
    }

    
    // MARK: - Reachability
    
    func reachabilityChanged() {
        if reachabilityStatus == NOACCESS {
            DispatchQueue.main.async {
                self.present(noInternetAccessAlert(), animated: true, completion: nil)
            }
        }
        // else load data
        self.getData()
    }

    // MARK: - Events
    
    func didLoadUpcomingData(result: [[String: AnyObject]]) {
        self.collectionViewDataSourceDelegate.upcomingEvents = result
        
        if self.upcomingEventsCollectionView != nil {
            self.upcomingEventsCollectionView.reloadData()
        }
        else {
            self.collectionView.reloadData()
        }
        
    }
    
    func didLoadPastData(result: [[String: AnyObject]]) {
        self.collectionViewDataSourceDelegate.pastEvents = result
        
        if self.pastEventsCollectionView != nil {
            self.pastEventsCollectionView.reloadData()
        }
        else {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - APIs
    
    func getData() {
        // get projects data
        
        if self.collectionViewDataSourceDelegate.upcomingEvents.count == 0 {
            DataManager().getEvents(child: "upcoming", completion: didLoadUpcomingData) {
                if reachabilityStatus != NOACCESS {
                    self.present(showAlert("Could not fetch Ongoing Projects!", message: "Try again later"), animated: true, completion: nil)
                }
            }
        }
        
        if self.collectionViewDataSourceDelegate.pastEvents.count == 0 {
            DataManager().getEvents(child: "past", completion: didLoadPastData) {
                if reachabilityStatus != NOACCESS {
                    self.present(showAlert("Could not fetch Past Projects!", message: "Try again later"), animated: true, completion: nil)
                }
            }
        }
        
    }

    
    
    // MARK: - Navigation

    func segue(item: [String: AnyObject]) {
        self.selectedEvent = item
        
        if item["category"] as! String == "upcoming" {
            self.performSegue(withIdentifier: "showUpcoming", sender: self)
        }
        else {
            self.performSegue(withIdentifier: "showPast", sender: self)
        }
        
        
        
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showPast" {
            let destinationViewController = segue.destination as! EventDetailsViewController
            destinationViewController.event = self.selectedEvent
        }
        else if segue.identifier == "showUpcoming" {
            let destinationViewController = segue.destination as! UpcomingEventsViewController
            destinationViewController.event = self.selectedEvent
        }
        
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }


}
