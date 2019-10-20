//
//  IanViewController.swift
//  Lab4
//
//  Created by Ian Katzman on 10/19/19.
//  Copyright © 2019 Ian Katzman. All rights reserved.
//

import UIKit

class IanViewController: UIViewController {

    var myLabelData: String = "nothing"
    @IBOutlet weak var theLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("calling init for ian vc")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        theLabel.text = myLabelData
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
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        print("going to this vc \(segue.destination) from \(segue.source)")
    }
    

}
