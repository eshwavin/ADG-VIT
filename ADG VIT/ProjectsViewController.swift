//
//  ProjectsViewController.swift
//  ADG VIT
//
//  Created by Srivinayak Chaitanya Eshwa on 30/01/17.
//  Copyright © 2017 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class ProjectsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: Menu Variables

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    // MARK: Collection View Variables
    
    @IBOutlet weak var ongoingProjectsButton: UIButton!
    @IBOutlet weak var pastProjectsButton: UIButton!
    @IBOutlet weak var collectionViewIndicatorLineView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var flag = true
    
    // MARK: Projects Variables
    
    var ongoingCollectionView: UICollectionView!
    var pastCollectionView: UICollectionView!
    
    // MARK: CollectionViewDataSourceDelegate
    
    let collectionViewDataSourceDelegate = ProjectsCollectionViewDataSourceDelegate()
    
    var selectedProject: [String: String] = [:]
    
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
        self.title = "Projects"
        
        // get data
        self.getData()
        
        // set collectionviewdatasourcedelegate navigation function
        
        self.collectionViewDataSourceDelegate.navigationFunction = self.segue
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.flag {
            self.collectionViewIndicatorLineView.center.x = self.ongoingProjectsButton.center.x
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ReachStatusChanged"), object: nil)
    }
    
    // MARK: - Collection View Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "outerCollectionViewCell", for: indexPath) as! ProjectsOuterCollectionViewCell
        
        cell.innerCollectionView.tag = indexPath.item + 100
        
        if indexPath.item == 0 {
            self.ongoingCollectionView = cell.innerCollectionView
        }
        else {
            self.pastCollectionView = cell.innerCollectionView
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

    @IBAction func projectsButtonTapped(_ sender: UIButton) {
        
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
        
        let ongoingCenter = self.ongoingProjectsButton.center.x
        let pastCenter = self.pastProjectsButton.center.x
        
        let lineViewRange = pastCenter - ongoingCenter
        
        let maximumOffset = self.collectionView.frame.width
        
        let calculatedCenter = ongoingCenter + (lineViewRange / (maximumOffset) * offset)
        
        self.collectionViewIndicatorLineView.center.x = calculatedCenter
        
        if abs(calculatedCenter - ongoingCenter) < abs(calculatedCenter - pastCenter) {
            self.ongoingProjectsButton.setTitleColor(UIColor.white, for: .normal)
            self.pastProjectsButton.setTitleColor(newsInactiveColor, for: .normal)
        }
        else {
            self.pastProjectsButton.setTitleColor(UIColor.white, for: .normal)
            self.ongoingProjectsButton.setTitleColor(newsInactiveColor, for: .normal)
        }
        
    }

    
    // MARK: - Reachability
    
    func reachabilityChanged() {
        if reachabilityStatus == NOACCESS {
            DispatchQueue.main.async {
                self.present(noInternetAccessAlert(), animated: true, completion: nil)
            }
        }
        self.getData()
    }
    
    
    // MARK: - Projects
    
    func didLoadOngoingData(result: [[String: String]]) {
        
        self.collectionViewDataSourceDelegate.ongoingProjects = result
        
        if self.ongoingCollectionView != nil {
            self.ongoingCollectionView.reloadData()
        }
        else {
            self.collectionView.reloadData()
        }
        
    }
    
    func didLoadPastData(result: [[String: String]]) {
        
        self.collectionViewDataSourceDelegate.pastProjects = result
        
        if self.pastCollectionView != nil {
            self.pastCollectionView.reloadData()
        }
        else {
            self.collectionView.reloadData()
        }
    }
    
    
    // MARK: - APIs
    
    func getData() {
        // get projects data
        
        if self.collectionViewDataSourceDelegate.ongoingProjects.count == 0 {
            DataManager().getProjects(child: "ongoing", completion: didLoadOngoingData) {
                if reachabilityStatus != NOACCESS {
                    self.present(showAlert("Could not fetch Ongoing Projects!", message: "Try again later"), animated: true, completion: nil)
                }
            }
        }
        
        if self.collectionViewDataSourceDelegate.pastProjects.count == 0 {
            DataManager().getProjects(child: "past", completion: didLoadPastData) {
                if reachabilityStatus != NOACCESS {
                    self.present(showAlert("Could not fetch Past Projects!", message: "Try again later"), animated: true, completion: nil)
                }
            }
        }        
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    func segue(item: [String: String]) {
        self.selectedProject = item
        self.performSegue(withIdentifier: "showProjects", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showProjects" {
            // send the selected project to the destination
            let destinationViewController = segue.destination as! ProjectDetailsViewController
            destinationViewController.project = self.selectedProject
            
        }
        
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
    
    }
    

}
