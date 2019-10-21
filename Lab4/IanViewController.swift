//
//  IanViewController.swift
//  Lab4
//
//  Created by Ian Katzman on 10/19/19.
//  Copyright © 2019 Ian Katzman. All rights reserved.
//

import UIKit

class IanViewController: UIViewController {
    
    var id = ""
    var titleVal: String = "nothing"
    var ratingVal: String = "nothing"
    var scoreVal: String = "nothing"
    var releaseVal: String = "nothing"
    var bigImage: UIImage? = nil

    @IBOutlet weak var theLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highResImg: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        theLabel.text = titleVal
        ratingLabel.text = ratingVal
        releaseLabel.text = releaseVal
        scoreLabel.text = scoreVal
        highResImg.image = bigImage
    }
    
    @IBAction func addToFavs(_ sender: Any) {
        let dbPath = Bundle.main.path(forResource: "favoriteMovies", ofType: "db")
        let contactDB = FMDatabase(path: dbPath)
        
        if !(contactDB.open()){
            print("Unable to open DB")
            return
        } else {
            do {
                print("I am here")
                try contactDB.executeUpdate("insert into moviess (title) values(?)", values: [theLabel.text ?? ""])
            } catch let error as NSError {
                print("failed \(error)")
            }
        }
        contactDB.close()
    }
}
