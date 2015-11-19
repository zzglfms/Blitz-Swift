//
//  MenuViewController.swift
//  Blitz
//
//  Created by Tianyang Yu on 10/8/15.
//  Copyright © 2015 cs490. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
 
    // MARK: - Constants
    var tableEntries = ["Carpool", "FoodDiscover", "House Rental", "Other"]
    
    // MARK: - Variables
    var lastSelectedRow: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewDidAppear(animated: Bool) {
        if let row = lastSelectedRow {
            let rowToSelect:NSIndexPath = NSIndexPath(forRow: row, inSection: 0)
            self.tableView.selectRowAtIndexPath(rowToSelect, animated: true, scrollPosition: UITableViewScrollPosition.None);
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.revealViewController() != nil {
            let navController = self.revealViewController().frontViewController as! UINavigationController
            let mainViewController = navController.viewControllers[0] as! MainViewController
            self.revealViewController().revealToggle(self)
            
            if indexPath.section == 0 {
                if let _ = lastSelectedRow {
                    if lastSelectedRow == indexPath.row {
                        // Deselect
                        mainViewController.category = ""
                        lastSelectedRow = nil
                        mainViewController.reloadTableView()
                    }
                    else {
                        mainViewController.category = tableEntries[indexPath.row]
                        lastSelectedRow = indexPath.row
                        mainViewController.reloadTableView()
                    }
                }
                else{
                    mainViewController.category = tableEntries[indexPath.row]
                    lastSelectedRow = indexPath.row
                    mainViewController.reloadTableView()
                }
            }
            else {
                print(String(indexPath))
            }
        }
        else{
            NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): Nil revealController")
        }
    }
    

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
