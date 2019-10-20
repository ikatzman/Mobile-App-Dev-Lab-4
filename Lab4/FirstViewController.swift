//
//  FirstViewController.swift
//  Lab4
//
//  Created by Ian Katzman on 10/19/19.
//  Copyright © 2019 Ian Katzman. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var movieCollection: UICollectionView!
    
    var results:APIResults?
    var movieList: [Movie] = []
    var images: [UIImage] = []
    var myArray: [String] = []
    var apiKey = "e4d950c0efa6914112a12ef7d681091f"
    var base = "https://api.themoviedb.org/3/configuration?api_key=e4d950c0efa6914112a12ef7d681091f"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        movieCollection.dataSource = self
        let someString = UserDefaults.standard.string(forKey: "MyKey")
        print("the key is \(String(describing: someString))")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        grabData(title: searchBar.text ?? "")
    }
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        print("pnis")
//        grabData(title: searchBar.text ?? "")
//    }
    
    func grabData(title: String){
        var query = ""
        for char in title{
            if char == " "{
                query = "\(query)+"
            }
            else{
                query = "\(query)\(char)"
            }
        }
        print(query)
        
        let url = "\(base)&query=\(query)"
        
        print(url)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath)
        
        if(indexPath.section % 2 == 1){
            cell.backgroundColor = UIColor.purple
        }
        else{
            cell.backgroundColor = UIColor.blue
        }
        
        return cell
    }
    var count: Int = 0
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        UserDefaults.standard.set("This jaunt displayed", forKey: "MyKey")
        print("going to this vc \(segue.destination) from \(segue.source)")
        let ianVC = segue.destination as? IanViewController
        ianVC?.myLabelData = "\(count)"
        count = count + 1
    }
    
    


}

