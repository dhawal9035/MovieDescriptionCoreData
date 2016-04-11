//
//  ViewController.swift
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

class ViewController: UIViewController {

    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var releasedLbl: UILabel!
    @IBOutlet weak var runLbl: UILabel!
    @IBOutlet weak var ratedLbl: UILabel!
    @IBOutlet weak var genreLbl: UILabel!
    @IBOutlet weak var actorTV: UITextView!
    @IBOutlet weak var plotTV: UITextView!
    var appDel:AppDelegate?
    var mContext:NSManagedObjectContext?
    
    var urlString:String = ""
    var selectedMovie : String = ""
    var movies:[String : MovieDescription] = [String:MovieDescription]()
    //let urlString : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
        mContext = appDel!.managedObjectContext
        // Do any additional setup after loading the view, typically from a nib.
        let selectRequest = NSFetchRequest(entityName: "Movie")
        selectRequest.predicate = NSPredicate(format: "title == %@",selectedMovie)
        do{
            let results = try mContext!.executeFetchRequest(selectRequest)
            if results.count > 0 {
                self.title = selectedMovie
                self.yearLbl.text = results[0].valueForKey("year") as? String
                self.releasedLbl.text = results[0].valueForKey("released") as? String
                self.ratedLbl.text = results[0].valueForKey("rating") as? String
                self.runLbl.text = results[0].valueForKey("runtime") as? String
                self.actorTV.text = results[0].valueForKey("actors") as? String
                self.plotTV.text = results[0].valueForKey("plot") as? String
                //
            }
        } catch let error as NSError{
            NSLog("Error selecting student: Error: \(error)")
        }
        
        let genreRequest = NSFetchRequest(entityName: "Movie")
        genreRequest.predicate = NSPredicate(format: "title == %@",selectedMovie)
        do{
            let results = try mContext!.executeFetchRequest(selectRequest)
            if results.count > 0 {
                let studCourses = results[0].valueForKey("has")
                let crsName:String = (studCourses!.valueForKey("genre") as? String)!
                self.genreLbl.text = crsName
            }
        } catch let error as NSError{
            NSLog("Error selecting student: Error: \(error)")
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

