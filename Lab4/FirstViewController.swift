//
//  FirstViewController.swift
//  Lab4
//
//  Created by Ian Katzman on 10/19/19.
//  Copyright © 2019 Ian Katzman. All rights reserved.
//

import UIKit

let base = Base()

class FirstViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UICollectionViewDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var movieCollection: UICollectionView!
    @IBOutlet weak var searchField: UISearchBar!
    
    var results:APIResults?
    var movieList: [Movie] = []
    var images: [UIImage] = []
    var myArray: [String] = []
    var apiKey = "e4d950c0efa6914112a12ef7d681091f"
    var configBase = "https://api.themoviedb.org/3/configuration?api_key=e4d950c0efa6914112a12ef7d681091f"
    var searchBase = "https://api.themoviedb.org/3/search/movie?api_key=e4d950c0efa6914112a12ef7d681091f&query="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        movieCollection.dataSource = self
        searchField.delegate = self
        getData(title: "Night")
        cacheImages()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getData(title: searchBar.text ?? "")
    }
    
    func getData(title: String){
        var query = ""
        for char in title{
            if char == " "{
                query = "\(query)+"
            }
            else{
                query = "\(query)\(char)"
            }
        }
        let url = "\(searchBase)\(query)"
        let usable = URL(string: url)
        
        let data = try! Data(contentsOf: usable!)
        let result = try! JSONDecoder().decode(APIResults.self, from: data)

        var length = 0
        var list = result.results
        
        if list.count > 20{
            length = 20
        } else {
            length = list.count
        }
        
        movieList = []
        
        for i in 0 ..< length{
            movieList.append(list[i])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! movieCell
            cell.movieLabel.text = movieList[indexPath.row].title
            cell.movieImage.image = images[indexPath.row]
            return cell
    }
    
    func cacheImages(){
        for movie in movieList{
            let url = URL(string: "http://image.tmdb.org/t/p/w185\(movie.poster_path ?? "")")
            let data = try? Data.init(contentsOf: url!)
            if(data != nil){
                let image = UIImage(data: data!)
                if(!images.contains(image!)){
                    images.append(image!)
                }
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
//        UserDefaults.standard.set("This jaunt displayed", forKey: "MyKey")
//        print("going to this vc \(segue.destination) from \(segue.source)")
//        let ianVC = segue.destination as? IanViewController
//        ianVC?.myLabelData = "\(movieList[9].title)"
//        if(segue.identifier == "myCell"){
//            let destination = segue.destination as? IanViewController
//
//            if let cell = sender as? movieCell != nil
//            {
//                destination?.myLabelData = cell.movieLabel
//            }
//            destination?.myLabelData = "hhh"
//        }
//        if segue.identifier == "myCell" {
            print("im here")
            if let collectionCell: movieCell = sender as? movieCell {
                if let collectionView: UICollectionView = collectionCell.superview as? UICollectionView {
                    if let destination = segue.destination as? IanViewController {
                        print(collectionCell.tag)
                        print(collectionView.tag)
                        print(movieList[collectionCell.tag].title)
                        destination.myLabelData = movieList[collectionView.tag].title
                    }
                }
            }
//        }
    }
    
    


}

