//
//  AddMovieController.swift
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

class AddMovieController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var titleTF: UITextField!
    
    @IBOutlet weak var yearTF: UITextField!
    @IBOutlet weak var releasedTF: UITextField!
    @IBOutlet weak var runTF: UITextField!
    @IBOutlet weak var ratingTF: UITextField!
    @IBOutlet weak var genreTF: UITextField!
    @IBOutlet weak var actorTF: UITextField!
    @IBOutlet var genrePicker: UIPickerView!
    @IBOutlet weak var plotTF: UITextView!
    
    var mTitle:String = ""
    var mYear:String = ""
    var mRating:String = ""
    var mReleased:String = ""
    var mActors:String = ""
    var mGenre:String = ""
    var mPlot:String = ""
    var mRuntime:String = ""
    var search = false;
    var genres: [String] = [String]()
    
    var movieTable: MovieTableController?
    var movies:[String : MovieDescription] = [String:MovieDescription]()
    var genreArray : [String] = ["Action","Drama","Adventure","Thriller","Comedy","Biography"]
    var urlString:String = "http://localhost:8080"
    
    var allMovies:[NSManagedObject] = [NSManagedObject]()
    var appDel:AppDelegate?
    var mContext:NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
        mContext = appDel!.managedObjectContext
        
        self.genrePicker = UIPickerView()
        self.genrePicker.delegate = self
        self.genrePicker.dataSource = self
        self.genreTF.inputView = self.genrePicker
        self.title = "Add Movie"
        
        if search{
            self.titleTF.text = self.mTitle
            self.releasedTF.text = self.mReleased
            self.yearTF.text = self.mYear
            self.ratingTF.text = self.mRating
            self.runTF.text = self.mRuntime
            self.plotTF.text = self.mPlot
            self.actorTF.text = self.mActors
            self.genreTF.text = self.mGenre
            self.ratingTF.text = self.mRating
            //self.search = !self.search
        } else {
            self.titleTF.text = ""
            self.releasedTF.text = ""
            self.yearTF.text = ""
            self.ratingTF.text = ""
            self.runTF.text = ""
            self.plotTF.text = ""
            self.actorTF.text = ""
            self.genreTF.text = ""
            self.ratingTF.text = ""
            //self.search = !self.search
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.titleTF.resignFirstResponder()
        self.releasedTF.resignFirstResponder()
        self.yearTF.resignFirstResponder()
        self.ratingTF.resignFirstResponder()
        self.runTF.resignFirstResponder()
        self.plotTF.resignFirstResponder()
        self.actorTF.resignFirstResponder()
        self.genreTF.resignFirstResponder()
        self.ratingTF.resignFirstResponder()
    }
    
    
    

    @IBAction func buttonClicked(sender: AnyObject) {
        let title = self.titleTF.text! as String
        let year = self.yearTF.text! as String
        let runTime = self.runTF.text! as String
        let released = self.releasedTF.text! as String
        let actors = self.actorTF.text! as String
        let plot = self.plotTF.text! as String
        var genre = self.genreTF.text! as String
        let rated = self.ratingTF.text! as String
        
        let entity = NSEntityDescription.entityForName("Movie", inManagedObjectContext: mContext!)
        let movie = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: mContext)
        movie.setValue(title, forKey:"title")
        movie.setValue(year, forKey:"year")
        movie.setValue(runTime, forKey:"runtime")
        movie.setValue(released, forKey:"released")
        movie.setValue(actors, forKey:"actors")
        movie.setValue(plot, forKey:"plot")
        //movie.setValue(genre, forKey:"genre")
        movie.setValue(rated, forKey:"rating")
        do{
            try mContext!.save()
            allMovies.append(movie)
        } catch let error as NSError{
            NSLog("Error adding movie \(title). Error: \(error)")
        }

        let selectRequest = NSFetchRequest(entityName: "Genre")
        selectRequest.predicate = NSPredicate(format: "genre == %@",genre)
        var genreObj:NSManagedObject?
        do{
            var results = try mContext!.executeFetchRequest(selectRequest)
            if results.count <= 0 {
                // aCourse is not already saved, so save it
                let entity = NSEntityDescription.entityForName("Genre", inManagedObjectContext: mContext!)
                genreObj = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: mContext)
                genreObj!.setValue(genre, forKey:"genre")
                do{
                    try mContext!.save()
                } catch let error as NSError{
                    NSLog("Error adding entity for new course \(genre). Error: \(error)")
                }
            }else{
                genreObj = results[0] as? NSManagedObject
            }
            genres.append(genre)
            // add the course to the one to many takes relationship of selected student
            let movie = NSFetchRequest(entityName: "Movie")
            movie.predicate = NSPredicate(format: "title == %@",title)
            do{
                let resultMovie = try mContext!.executeFetchRequest(movie)
                if resultMovie.count > 0 {
                    // add the course managed object to the takes relationship set
                    resultMovie[0].setValue(genreObj, forKey: "has")
                    try mContext!.save()
                }
            }catch let error as NSError{
                NSLog("Error adding genre \(genre) to movie \(title). Error is \(error)")
            }
        } catch let error as NSError{
            NSLog("Error getting genre \(genre) for movie \(title). Error is \(error)")
        }
        
        
       // self.movies[md.title] = md
        //self.movieTable?.movies = self.movies
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    // functions for the picker view delegate and datasource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genreArray.count
        
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genreArray[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.genreTF.text = genreArray[row]
        self.genreTF.resignFirstResponder()
        
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
