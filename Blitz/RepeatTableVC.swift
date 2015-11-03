//
//  RepeatTableVC.swift
//  Blitz
//
//  Created by Tianyang Yu on 11/2/15.
//  Copyright © 2015 cs490. All rights reserved.
//

import UIKit

class RepeatTableVC: UITableViewController {

    // MARK: - Constant
    let repeatCellIdentifier = "RepeatCell"
    let titles = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    let DayToIndexMap = ["Mon": 1, "Tue": 2, "Wed": 3, "Thu": 4, "Fri": 5, "Sat": 6, "Sun": 0]
    
    // MARK: - Variable
    var carpoolController: CarpoolPostVC!
    var passingMessage: String! = "No Message"
    var checked = [Bool](count: 7, repeatedValue: false)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("@RepeatTableVC.swift - viewDidLoad(): Passing Message = " + passingMessage)
        constructCheckedArray(passingMessage)
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titles.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(repeatCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        cell.textLabel!.text = "Every "+titles[indexPath.row]
        cell.selected = checked[indexPath.row]
        if cell.selected
        {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            let rowToSelect:NSIndexPath = NSIndexPath(forRow: indexPath.row, inSection: 0);  //slecting 0th row with 0th section
            self.tableView.selectRowAtIndexPath(rowToSelect, animated: true, scrollPosition: UITableViewScrollPosition.None);
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        checked[indexPath.row] = true
        cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        checked[indexPath.row] = false
        cell!.accessoryType = UITableViewCellAccessoryType.None
    }
    

    @IBAction func backButtonTapped(sender: UIBarButtonItem) {
        let repeatString: String! = formDescriptiveRepeatString()
        NSLog("@RepeatTableVC.swift - backButtonTapped(): repeatString = " + repeatString)
        carpoolController.repeatTextField.text = repeatString
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Helper Function
    func formDescriptiveRepeatString() -> String {
        var returnString = ""
        for index in 1...6 {
            if checked[index] {
                returnString += getShortStyleDayString(titles[index]) + " "
            }
        }
        if checked[0] {
            returnString += "Sun"
        }
        if returnString == "" {
            returnString = "None"
        }
        return returnString
    }
    
    func constructCheckedArray(repeatString: String){
        if repeatString == "None" {
            return
        }
        let repeatDays = repeatString.characters.split{$0 == " "}.map(String.init)
        for repeatDay in repeatDays {
            checked[DayToIndexMap[repeatDay]!] = true
        }
        NSLog(String(checked))
    }
    
    func getShortStyleDayString(dayString: String) -> String {
        var s = dayString
        let range = dayString.startIndex.advancedBy(3)..<dayString.endIndex
        s.removeRange(range)
        return s
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
