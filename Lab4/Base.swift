//
//  Base.swift
//  Lab4
//
//  Created by Ian Katzman on 10/20/19.
//  Copyright © 2019 Ian Katzman. All rights reserved.
//

import Foundation


class Base {
    var apiResults: APIResults?
    
    init() {
        apiResults = nil
    }
    
    func getSearchResults(searchText: String) {
        
        if(searchText != ""){
            let searchString = formatSearchString(searchText: searchText)
            let apiKey = "e4d950c0efa6914112a12ef7d681091f"
            let jsonRequest = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(searchString)"
            apiCall(urlRequest: jsonRequest)
        }
        return
        
    }
    
    func apiCall(urlRequest: String) {
        guard let url = URL(string: urlRequest) else {
            print("Error in creating URL")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
            guard error == nil else {
                print(error!)
                return
            }
            guard let movieJson = data else {
                print("Error getting data")
                return
            }
            
            guard let movieData = try?
                JSONDecoder().decode(APIResults?.self, from: Data(movieJson))
                else {
                    print("Error decoding json data")
                    return
            }
            
            self.apiResults = movieData
        }
        task.resume()
    }
    
    func formatSearchString(searchText: String) -> String {
        let reformattedText = searchText.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        return reformattedText
    }
    
    func getImagePath(path: String) -> String {
        return "https://image.tmdb.org/t/p/w200/\(path)"
    }
    
}
