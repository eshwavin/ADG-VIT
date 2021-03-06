//
//  MenuTableViewController.swift
//  ADG VIT
//
//  Created by Srivinayak Chaitanya Eshwa on 25/01/17.
//  Copyright © 2017 Srivinayak Chaitanya Eshwa. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    @IBOutlet var menuImageViews: [UIImageView]!
    
    var tapGestureRecognizer = UITapGestureRecognizer()
    
    var selectedPage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(image: UIImage(named: "Side menu bg"))
        imageView.contentMode = .scaleAspectFill
        
        self.tableView.backgroundView = imageView
        
        self.menuImageViews[self.selectedPage].image = UIImage(named: "Double Circle")
        
        if ThreeD {
            self.tableView(self.tableView, didSelectRowAt: IndexPath(row: 4, section: 0))
        }
        
    }
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        let frontViewController = self.revealViewController().frontViewController
//        
//        frontViewController?.view.isUserInteractionEnabled = false
//        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.revealViewController().rightRevealToggle(_:)))
//        
//        frontViewController?.view.addGestureRecognizer(self.tapGestureRecognizer)
//        
//        frontViewController?.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        let frontViewController = self.revealViewController().frontViewController
//        
//        frontViewController?.view.isUserInteractionEnabled = true
//        
//        for gestureRecognizer in (frontViewController?.view.gestureRecognizers)! {
//            if gestureRecognizer == self.tapGestureRecognizer || gestureRecognizer == self.revealViewController().panGestureRecognizer() {
//                
//                frontViewController?.view.removeGestureRecognizer(gestureRecognizer)
//                
//            }
//        }
//        
//    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            return
        }
        
        self.menuImageViews[self.selectedPage].image = UIImage(named: "Circle")
        self.selectedPage = indexPath.row - 1
        self.menuImageViews[self.selectedPage].image = UIImage(named: "Double Circle")
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
