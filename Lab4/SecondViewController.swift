//
//  SecondViewController.swift
//  Lab4
//
//  Created by Ian Katzman on 10/19/19.
//  Copyright © 2019 Ian Katzman. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource {
    
    
    @IBOutlet weak var table: UITableView!
    
    var myArray: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        table.dataSource = self
        
        loadDatabase()
    }
    
    func loadDatabase(){
        let dbPath = Bundle.main.path(forResource: "favoriteMovies", ofType: "db")
        let contactDB = FMDatabase(path: dbPath)
        
        if !(contactDB.open()){
            print("Unable to open DB")
            return
        } else {
            do {
                let results = try contactDB.executeQuery("SELECT * FROM moviess", values: nil)
                while(results.next()){
                    let id = results.int(forColumn: "id")
                    let poster_path = results.string(forColumn: "poster_path")
                    let title = results.string(forColumn: "title")
                    let release_date = results.string(forColumn: "release_date")
                    let vote_average = results.double(forColumn: "vote_average")
                    let overview = results.string(forColumn: "overview")
                    let vote_count = results.int(forColumn: "vote_count")

                    let jsonString = """
                        {
                        "id": \(id),
                        "poster_path": "\(poster_path ?? "")",
                        "title": "\(title ?? "")",
                        "release_date": "\(release_date ?? "")",
                        "vote_average": \(vote_average),
                        "overview": "\(overview ?? "")",
                        "vote_count": \(vote_count)
                        }
                        """.data(using: .utf8)!
                    
                    print(jsonString)
                    let movie = try JSONDecoder().decode(Movie.self, from: jsonString)
                    print(movie)
                    myArray.append(movie)
                    print(myArray)
                }
            } catch let error as NSError {
                    print("failed \(error)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        cell.textLabel!.text = myArray[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            myArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
}

