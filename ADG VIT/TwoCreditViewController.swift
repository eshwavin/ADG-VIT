//
//  TwoCreditViewController.swift
//  ADG VIT
//
//  Created by Srivinayak Chaitanya Eshwa on 10/02/17.
//  Copyright © 2017 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit
import FirebaseDatabase
import RealmSwift

class TwoCreditViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var attendanceView: AttendanceView!
    @IBOutlet weak var attendanceLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var events = [Events]()
    var totalHours: Float = 0.0
    var attendedHours: Float = 0.0
    
    let databaseReference = FIRDatabase.database().reference().child("twoCredit").child("users")
    
    // MARK: - View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // setting table view row height
        
        self.tableView.rowHeight = 68.0
        self.tableView.layoutMargins = UIEdgeInsets.zero
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
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
        
        
        // stored data
        
        let realm = try! Realm()
        
        var user = UserData()
        
        if let us = realm.objects(UserData.self).first {
            
            self.title = us.name
            
            for event in us.events {
                
                self.totalHours += event.hours
                if event.attended {
                    self.attendedHours += event.hours
                }
                self.events.append(event)
            }
            
            self.attendanceView.percentage = CGFloat(self.attendedHours / self.totalHours)
            self.attendanceLabel.text = "\(self.attendedHours)/\(self.totalHours)"
            
            user = us
            
            self.tableView.reloadData()

        }
        
        
        
        
        // getting the current data
        
        self.databaseReference.queryOrdered(byChild: "email").queryEqual(toValue: user.email).observe(FIRDataEventType.value, with: { (snapshot) in
            if !(snapshot.value is NSNull) {
                
                let userData = (snapshot.value! as! [String: AnyObject]).first!.value
                
                // removing previous events from database
                try! realm.write {
                    realm.delete(realm.objects(Events.self))
                }
                
                // populating user if blank
                
                if user.name == "" {
                    user.name = userData["name"] as! String
                    user.email = userData["email"] as! String
                }
                
                // setting events to blank
                
                user.events = List<Events>()
                self.events = []
                
                // setting hours to 0
                
                self.totalHours = 0
                self.attendedHours = 0
                
                // populating events
                
                let events = userData["events"] as! [String : AnyObject]
                
                    
                for event in events {
                        
                    let value = event.value as! [String: AnyObject]
                        
                    let realmEvent = Events()
                    realmEvent.name = value["name"] as! String
                    realmEvent.attended = value["attended"] as! String == "YES" ? true : false
                    realmEvent.date = value["date"] as! String
                    realmEvent.hours = Float((value["hours"] as! NSString).floatValue)
                    
                    self.totalHours += realmEvent.hours
                    if realmEvent.attended {
                        self.attendedHours += realmEvent.hours
                    }
                        
                    user.events.append(realmEvent)
                    self.events.append(realmEvent)
                        
                }
                
                // setting attendance view
                self.attendanceView.percentage = CGFloat(self.attendedHours / self.totalHours)
                self.attendanceLabel.text = "\(self.attendedHours)/\(self.totalHours)"
                
                // saving data
                
                try! realm.write {
                    realm.add(user)
                }
                
                // reloading table
                
                self.tableView.reloadData()
                
            }

            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView.layer.cornerRadius = 8.0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventsCell", for: indexPath) as! EventsTableViewCell
        
        cell.event = self.events[indexPath.row]
        
        return cell
    }
    
    // MARK: - Reachability
    
    func reachabilityChanged() {
        if reachabilityStatus == NOACCESS {
            self.present(noInternetAccessAlert(), animated: true, completion: nil)
        }
    }
    
    // MARK: - Support Functions
    
    @IBAction func actionButtonPressed(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        alertController.addAction(UIAlertAction(title: "Logout", style: UIAlertActionStyle.default, handler: { (action) in
            
            // logout
            UserDefaults.standard.set(false, forKey: "LoggedIn")
            
            // deleting all realm objects
            
            try! realm.write {
                realm.delete(realm.objects(Events.self))
                realm.delete(realm.objects(UserData.self))
            }
            
            self.navigationController!.popViewController(animated: true)
            
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
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
