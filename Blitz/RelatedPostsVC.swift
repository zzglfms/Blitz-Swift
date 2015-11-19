//
//  RelatedPostsVC.swift
//  Blitz
//
//  Created by Tianyang Yu on 11/17/15.
//  Copyright © 2015 cs490. All rights reserved.
//

import UIKit

let cellName = "post cell"

class RelatedPostsVC: UITableViewController {

    //Mark variables
    var activeList: [[String: AnyObject]]! = []
    var completeList: [[String: AnyObject]]! = []


    //Mark Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadTableView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return activeList.count
        }
        else {
            return completeList.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellName, forIndexPath: indexPath) as UITableViewCell
        
        var postList: [[String: AnyObject]]!
        if indexPath.section == 0 {
                postList = activeList
        }
        else {
            postList = completeList
        }
        
        // Set title
        cell.textLabel!.text = postList[indexPath.row]["title"] as? String
        
        // Set postTime
        let date_iso8601 = NSDate.date(fromString: postList[indexPath.row]["postTime"]! as! String, format: DateFormat.ISO8601)
        let date_String = date_iso8601?.toString(format: DateFormat.Custom("yyyy-MM-dd HH:mm"))
        cell.detailTextLabel!.text = date_String
        
        return cell
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "In-Progress"
        }
        else {
            return "Completed"
        }
    }
    
    
    //Mark: -Do action when this cell is tapped
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //self.performSegueWithIdentifier("yourIdentifier", sender: self)
        let showPost = self.storyboard?.instantiateViewControllerWithIdentifier("ShowPostVC") as! ShowPostVC
        
        var postList: [[String: AnyObject]]!

        if indexPath.section == 0 {
            postList = activeList
        }
        else {
            postList = completeList
        }
        
        let postID = postList[indexPath.row]["_id"] as? String
        
        showPost.postID = postID!
        
        self.navigationController?.pushViewController(showPost, animated: true)
    }
    

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
    
    func reloadTableView() {
        //
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if let username = prefs.stringForKey("USERNAME"){
            let queryJSON: [String: AnyObject] = [
                "operation": "Query",
                "username": username
            ]
            
            let results = getResultFromServerAsJSONArray(queryJSON)
            NSLog("%@", results)
            
            for result in results {
                if result["TranscationCompleted"] as! Bool {
                    completeList.append(result)
                }
                else {
                    activeList.append(result)
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
