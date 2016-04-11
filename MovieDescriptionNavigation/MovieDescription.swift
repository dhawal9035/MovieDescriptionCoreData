//
//  MovieDescription.swift
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

import Foundation

public class MovieDescription{
    var title: String
    var year: String
    var rated: String
    var released:String
    var runTime:String
    var genre:String
    var actors:String
    var plot:String
    init (jsonStr: String){
        self.title = ""
        self.year=""
        self.released=""
        self.actors=""
        self.genre=""
        self.runTime=""
        self.rated=""
        self.plot=""
        if let data: NSData = jsonStr.dataUsingEncoding(NSUTF8StringEncoding){
            do{
                let dict = try NSJSONSerialization.JSONObjectWithData(data,options:.MutableContainers) as?[String:AnyObject]
                self.title = (dict!["Title"] as? String)!
                self.year = (dict!["Year"] as? String)!
                self.released = (dict!["Released"] as? String)!
                self.actors = (dict!["Actors"] as? String)!
                self.genre = (dict!["Genre"] as? String)!
                self.runTime = (dict!["Runtime"] as? String)!
                self.rated = (dict!["Rated"] as? String)!
                self.plot = (dict!["Plot"] as? String)!
            } catch {
                print("unable to convert to dictionary")
                
            }
        }
    }

    init(dict: [String:AnyObject]){
        self.title = dict["Title"] as! String
        self.year = dict["Year"] as! String
        self.released = dict["Released"] as! String
        self.runTime = dict["Runtime"] as! String
        self.actors = dict["Actors"] as! String
        self.genre = dict["Genre"] as! String
        self.rated = dict["Rated"] as! String
        self.plot = dict["Plot"] as! String
    }
    
    init( title: String, year: String,released: String, runtime: String, rated: String, genre: String, actors: String, plot:String){
        self.title = title
        self.year = year
        self.released = released
        self.rated = rated
        self.runTime = runtime
        self.actors = actors
        self.genre = genre
        self.plot = plot
        
    }
    
    func toJsonString() -> String {
        var jsonStr = "";
        let dict = ["Title" : title, "Year":year, "Released":released,"Runtime":runTime,"Rated":rated,"Genre":genre,"Actors":actors, "Plot":plot]
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.PrettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            jsonStr = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
        } catch let error as NSError {
            print(error)
        }
        return jsonStr
    }

}
