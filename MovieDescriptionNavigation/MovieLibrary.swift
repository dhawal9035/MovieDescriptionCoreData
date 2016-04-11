//
//  MovieLibrary.swift
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

/*import Foundation

public class MovieLibrary{
    
    public var movies:[String : MovieDescription] = [String:MovieDescription]()
    
    init(){
        let bundle = NSBundle.mainBundle()
        let myFilePath = bundle.pathForResource("movies", ofType: "json")
        
        NSLog("myFilePath \(myFilePath!)")
        
        // Get all the data from Json file
        
        if let data = NSData(contentsOfFile: myFilePath!){
            do{
                // Create dictionary of type string and movie description
                
                let dict = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String:AnyObject]
                for(title) in dict!.keys {
                    NSLog("Processing \(title)")
                    let movieJson : NSDictionary = (dict![title] as? [String:String])!
                    let movie:MovieDescription = MovieDescription(jsonStr:movieJson)
                    movies[movie.title] = movie
                }
            } catch {
                NSLog("Not able to convert the json to dictionary")
            }
        }
    }
    
    func add(newMovie:MovieDescription)->[String : MovieDescription]{
        self.movies[newMovie.title] = newMovie
        return movies
    }
}*/