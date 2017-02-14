//
//  ViewController.swift
//  ADG VIT
//
//  Created by Srivinayak Chaitanya Eshwa on 25/01/17.
//  Copyright © 2017 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate {
    
    // MARK: Menu Variables
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    // MARK: Weather Variables
    
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    
    // MARK: News Variables
    
    @IBOutlet weak var VITNewsButton: UIButton!
    @IBOutlet weak var ADGNewsButton: UIButton!

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewIndicatorLineView: UIView!
    
    var flag = true
    
    // MARK: Other Variables
    
    var tableViewDelegateDataSource = HomeTableViewDataDelegate()
    
    // MARK: Table View Variables
    
    var VITTableView: UITableView!
    var ADGTableView: UITableView!
    
    // MARK: Core Location
    
    let locationManager = CLLocationManager()
    
    // MARK: - View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // notification center
        
            // 1. application did become active
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.manageLocation), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
            // 2. reachability
        
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
        self.title = "Home"
        
        // getting news
        
        self.getData()
        
        // location manager
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
//            // 1. ask for authorization
//        if CLLocationManager.authorizationStatus() == .notDetermined {
//            self.locationManager.requestWhenInUseAuthorization()
//            self.updateLocation()
//            
//        }
//            // 2. authorization were denied
//        else if CLLocationManager.authorizationStatus() == .denied {
//            self.weatherLabel.text = "Location Services Denied!"
//            
//            self.present(showAlert("Cannot access location", message: "Location services were previously denied. Please enable location services for this app in Settings."), animated: true, completion: nil)
//        }
//            // 3. we do have authorization
//        else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
//            
//            self.updateLocation()
//            
//        }
        
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        if self.flag {
            self.collectionViewIndicatorLineView.center.x = self.VITNewsButton.center.x
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.weatherLabel.text == "Location Services Denied!" && CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            self.updateLocation()
            
        }
        
    }

    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsCell", for: indexPath) as! NewsCollectionViewCell
        
        cell.tableView.layer.cornerRadius = 8.0
        cell.tableView.clipsToBounds = true
        
        cell.tableView.layoutMargins = UIEdgeInsets.zero
        cell.tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        cell.tableView.tag = indexPath.item + 100
        cell.tableView.reloadData()
        
        if indexPath.item == 0 {
            self.VITTableView = cell.tableView
        }
        else {
            self.ADGTableView = cell.tableView
        }
        
        cell.tableView.rowHeight = 60.0
        if cell.tableView.dataSource == nil {
            cell.tableView.dataSource = self.tableViewDelegateDataSource
        }
        
        if cell.tableView.delegate == nil {
            cell.tableView.delegate = self.tableViewDelegateDataSource
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
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        return CGSize.zero
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize.zero
//    }
    
    // MARK: - News Button Functions
    
    @IBAction func newsButtonTapped(_ sender: UIButton) {
        
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
        
        let VITCenter = self.VITNewsButton.center.x
        let ADGCenter = self.ADGNewsButton.center.x
        
        let lineViewRange = ADGCenter - VITCenter
        
        let maximumOffset = self.collectionView.frame.width
        
        let calculatedCenter = VITCenter + (lineViewRange / (maximumOffset) * offset)
        
        self.collectionViewIndicatorLineView.center.x = calculatedCenter
        
        if abs(calculatedCenter - VITCenter) < abs(calculatedCenter - ADGCenter) {
            self.VITNewsButton.setTitleColor(UIColor.white, for: .normal)
            self.ADGNewsButton.setTitleColor(newsInactiveColor, for: .normal)
        }
        else {
            self.ADGNewsButton.setTitleColor(UIColor.white, for: .normal)
            self.VITNewsButton.setTitleColor(newsInactiveColor, for: .normal)
        }
        
    }
    
    
    // MARK: - APIs
    
    // MARK: News
    
    func getData() {
        
        if self.tableViewDelegateDataSource.VITNews.count == 0 {
            DataManager().getNews(child: "VIT", completion: didLoadVITData) {
                if reachabilityStatus != NOACCESS {
                    self.present(showAlert("Could not fetch VIT News!", message: "Try again later"), animated: true, completion: nil)
                }
            }
        }
        
        if self.tableViewDelegateDataSource.ADGNews.count == 0 {
            DataManager().getNews(child: "ADG", completion: didLoadADGData) {
                if reachabilityStatus != NOACCESS {
                    self.present(showAlert("Could not fetch ADG News!", message: "Try again later"), animated: true, completion: nil)
                }
            }
        }
    }
    
    func didLoadVITData(result: [String]) {
        
        self.tableViewDelegateDataSource.VITNews = result
        //        self.collectionView.reloadData()
        if self.VITTableView != nil {
            self.VITTableView.reloadData()
        }
        else {
            self.collectionView.reloadData()
        }
    }
    
    func didLoadADGData(result: [String]) {
        
        self.tableViewDelegateDataSource.ADGNews = result
        //        self.collectionView.reloadData()
        
        if self.ADGTableView != nil {
            self.ADGTableView.reloadData()
        }
        else {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: Weather

    
    func runWeatherAPI(_ location: CLLocation) {
        
        let url = "http://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&units=metric&appid=" + openWeatherAPIKey
        
        let dataManager = DataManager()
        dataManager.weatherAPI(url, completion: didLoadWeatherData) {
            if reachabilityStatus != NOACCESS {
                self.present(showAlert("Could not load the weather", message: "Try again later"), animated: true, completion: nil)
            }
        }
        
    }

    func didLoadWeatherData(_ result: [String: AnyObject]) {
        
        // set label text
        self.weatherLabel.text = "\(result["temp"]!)°C\n" + ("\(result["description"]!)".capitalized)
        
        // get image

        self.weatherIconImageView.image = UIImage(named: "\(result["icon"]!)")
        
//        let iconUrl = "http://openweathermap.org/img/w/\(result["icon"]!).png"
//        
//        let dataManager = DataManager()
//        dataManager.getVideoImage(iconUrl, imageView: self.weatherIconImageView) {
//            if reachabilityStatus != NOACCESS {
//                self.present(showAlert("Could not load weather image", message: nil), animated: true, completion: nil)
//            }
//        }
        
    }
    
    // MARK: - Location Manager
    
    func manageLocation() {
        
        
        // 1. ask for authorization
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
            self.updateLocation()
            
        }
            // 2. authorization were denied
        else if CLLocationManager.authorizationStatus() == .denied {
            self.weatherLabel.text = "Location Services Denied!"
            
            self.present(showAlert("Cannot access location", message: "Location services were previously denied. Please enable location services for this app in Settings."), animated: true, completion: nil)
        }
            // 3. we do have authorization
        else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            self.updateLocation()
            
        }
    }
    
    func updateLocation() {
        
        self.locationManager.startUpdatingLocation()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first!
        self.runWeatherAPI(location)
    }
    

    // MARK: - Reachability
    
    func reachabilityChanged() {
        if reachabilityStatus == NOACCESS {
            self.present(noInternetAccessAlert(), animated: true, completion: nil)
        }
        else {
            self.manageLocation()
            self.getData()
        }
    }
    
}

