//
//  MovieTableController.swift
//  MovieDescriptionNavigation
//  Copyright 2016 Dhawal Soni
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//  Created by dssoni on 2/22/16.
//  Copyright © 2016 dssoni. All rights reserved.
//

import UIKit
import CoreData

class MovieTableController: UITableViewController,UISearchBarDelegate{
    
    @IBOutlet var movieTable: UITableView!
    var appDel:AppDelegate?
    var mContext:NSManagedObjectContext?
    var movies:[String : MovieDescription] = [String:MovieDescription]()
    var selectedMovie : String = ""
    var allMovies:[NSManagedObject] = [NSManagedObject]()
    var searchController:UISearchController!
    var mTitle:String = ""
    var mYear:String = ""
    var mRating:String = ""
    var mReleased:String = ""
    var mActors:String = ""
    var mGenre:String = ""
    var mPlot:String = ""
    var mRuntime:String = ""
    var search = false
    
    override func viewDidLoad() {
     super.viewDidLoad()
        self.searchController = UISearchController(searchResultsController:  nil)
        self.searchController.searchBar.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        self.navigationItem.titleView = searchController.searchBar
        appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
        mContext = appDel!.managedObjectContext
        //movieLibrary = MovieLibrary.init()
        //self.movies = (movieLibrary?.movies)!
        //let movieConnect:MovieCollectionStub = MovieCollectionStub(urlString: urlString)
        
        let selectRequest = NSFetchRequest(entityName: "Movie")
        do{
            let results = try mContext!.executeFetchRequest(selectRequest)
            for res in results {
                if(!allMovies.contains(res as! NSManagedObject)){
                    allMovies.append(res as! NSManagedObject)
                }
            }
        } catch let error as NSError{
            NSLog("Error selecting movie \(title). Error: \(error)")
        }
        
        self.navigationItem.leftBarButtonItem = editButtonItem()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        viewDidLoad()
        self.movieTable.reloadData()
    }
    
    // UISearchBarDelegate functions
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        //NSLog("updateSearchResultsForSearchController called")
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        NSLog("searchBarTextDidEndEditing \(searchBar.text!)")
        searchBar.resignFirstResponder()
        let m = searchBar.text!.stringByReplacingOccurrencesOfString(" ", withString: "+")
        print(m)
        let urlString = "http://www.omdbapi.com/?t="+m+"&y=&plot=short&r=json"
        
        
        let movieConnect:MovieCollectionStub = MovieCollectionStub(urlString: urlString)
        movieConnect.asyncHttpPostJSON(urlString, callback: { (res: String, err: String?) -> Void in
            if err != nil {
                NSLog(err!)
            }else{
                NSLog(res)
                if let data: NSData = res.dataUsingEncoding(NSUTF8StringEncoding){
                    do{
                        
                        let dict = try NSJSONSerialization.JSONObjectWithData(data,options:.MutableContainers) as?[String:AnyObject]
                        if dict?.count > 0 && !(dict!.keys.contains("Error")) {
                            self.mTitle = dict!["Title"] as! String
                            self.mYear = dict!["Year"] as! String
                            self.mRating = dict!["Rated"] as! String
                            self.mRuntime = dict!["Released"] as! String
                            self.mReleased = dict!["Runtime"] as! String
                            self.mActors = dict!["Actors"] as! String
                            self.mGenre = dict!["Genre"] as! String
                            self.mPlot = dict!["Plot"] as! String
                            self.search = true
                            self.performSegueWithIdentifier("addMovie", sender: self)
                        }
                        
                    } catch {
                        NSLog("unable to convert to dictionary")
                    }
                }
            }
            
        })
        
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
        return self.allMovies.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        var cell : UITableViewCell = UITableViewCell()
        cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "tableCell")
        
        //cell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell.textLabel?.numberOfLines = 0
        let movie = self.allMovies[indexPath.row]
        cell.textLabel?.text = movie.valueForKey("title") as? String
        //cell.detailTextLabel?.text = self.allMovies[indexPath.row]
        // Configure the cell...

        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.selectedMovie = (self.allMovies[indexPath.row].valueForKey("title") as? String)!
        performSegueWithIdentifier("movieDetail", sender: self)
        self.movieTable.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    @IBAction func addClicked(sender: AnyObject) {
        self.search = false
        performSegueWithIdentifier("addMovie", sender: self)
    }
    
    @IBAction func refreshClicked(sender: AnyObject) {
        viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "movieDetail"){
            let destinationViewController =  segue.destinationViewController as! ViewController
            destinationViewController.selectedMovie = self.selectedMovie
            destinationViewController.movies = self.movies
        } else if(segue.identifier == "addMovie") {
            let destinationViewController =  segue.destinationViewController as! AddMovieController
            destinationViewController.movies = self.movies
            destinationViewController.movieTable = self
            destinationViewController.mTitle = self.mTitle
            destinationViewController.mYear = self.mYear
            destinationViewController.mRating = self.mRating
            destinationViewController.mReleased = self.mReleased
            destinationViewController.mRuntime = self.mRuntime
            destinationViewController.mActors = self.mActors
            destinationViewController.mGenre = self.mGenre
            destinationViewController.mPlot = self.mPlot
            destinationViewController.search = self.search
        }
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            //var name : String = self.studSelectTF.text!
            let movieName = self.allMovies[indexPath.row].valueForKey("title") as? String
            print(movieName)
            let selectRequest = NSFetchRequest(entityName: "Movie")
            selectRequest.predicate = NSPredicate(format: "title == %@",movieName!)
            do{
                let results = try mContext!.executeFetchRequest(selectRequest)
                if results.count > 0 {
                    mContext!.deleteObject(results[0] as! NSManagedObject)
                    try mContext?.save()
                }
            } catch let error as NSError{
                NSLog("error selecting all students \(error)")
            }
            self.allMovies.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

}