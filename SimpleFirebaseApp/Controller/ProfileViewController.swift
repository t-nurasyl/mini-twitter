//
//  ProfileViewController.swift
//  SimpleFirebaseApp
//
//  Created by Darkhan on 02.04.18.
//  Copyright © 2018 SDU. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
class ProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    private var tweets: [Tweet] = []
    private var dbRef: FIRDatabaseReference?
    var current_user_email = {
        return FIRAuth.auth()?.currentUser?.email
    }
    let searchController = UISearchController(searchResultsController: nil)
    private var filteredTweets = [Tweet]()
//    Datetime date = alertController.textFields![0].text!.Creationtime
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Find twit"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        //navigationItem.title = current_user_email()
        dbRef = FIRDatabase.database().reference()
        dbRef = dbRef?.child("tweets")
        // Do any additional setup after loading the view.
        
        dbRef?.observe(.value, with: { snapshot in
            print(snapshot.childrenCount)
            self.tweets.removeAll()
            for snap in snapshot.children{
                let tweet = Tweet.init(snapshot: snap as! FIRDataSnapshot)
                self.tweets.append(tweet)
            }
            
            self.tweets.reverse()
            self.tableView.reloadData()
        })
    }
    
    @IBAction func composeButtonPressed(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add new Tweet", message: "What's up?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter here"
        }
        let postAction = UIAlertAction(title: "Post", style: .default) { (_ ) in
            let tweet = Tweet.init(alertController.textFields![0].text!, self.current_user_email()!);
        self.dbRef?.childByAutoId().setValue(tweet.toJSONFormat())
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        
        alertController.addAction(postAction)
        alertController.addAction(cancelAction)
        
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredTweets.count
        }
        return tweets.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let tweet : Tweet
        if isFiltering() {
            tweet = filteredTweets[indexPath.row]
        } else {
            tweet = tweets[indexPath.row]
        }
        
        cell.textLabel?.text = tweet.Content
        cell.detailTextLabel?.text = tweet.User_email
        if current_user_email() == tweets[indexPath.row].User_email{
            cell.backgroundColor = UIColor.yellow

        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let item = tweets[indexPath.row]
//            item.dbRef?.removeValue()
//        }
//    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {

            let user: Tweet = tweets[indexPath.row]
            let uk = user.Content
            print("Userkey: \(uk)")
            dbRef?.child(uk!).removeValue()
        }
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredTweets = tweets.filter({( tweet : Tweet) -> Bool in
            return (tweet.Content?.lowercased().contains(searchText.lowercased()))!
        })
        
        tableView.reloadData()
    }
//    func getDate(){
//        NSFileManager * fm = [NSFileManager defaultManager];
//        NSDictionary* attrs = [fm attributesOfItemAtPath:path error:nil];
//
//        if (attrs != nil) {
//            NSDate *date = (NSDate*)[attrs objectForKey: NSFileCreationDate];
//            NSLog(@"Date Created: %@", [date description]);
//        }
//        else {
//            NSLog(@"Not found");
//        }
//    }
    

}


extension ProfileViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
