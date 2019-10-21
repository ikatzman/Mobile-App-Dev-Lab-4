//
//  FirstViewController.swift
//  Lab4
//
//  Created by Ian Katzman on 10/19/19.
//  Copyright © 2019 Ian Katzman. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UICollectionViewDelegate, UITabBarDelegate {
    
    @IBOutlet weak var movieCollection: UICollectionView!
    @IBOutlet weak var searchField: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var id = ""
    var length = 0
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
//        activityIndicator.startAnimating()
        getData(title: "Night")
//        activityIndicator.stopAnimating()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        activityIndicator.startAnimating()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        activityIndicator.stopAnimating()
        updateData(title: searchBar.text ?? "")
        cacheImages()
        images = []
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
        cacheImages()
        images = []
    }
    
    func updateData(title: String){
//        activityIndicator.startAnimating()
        let prevCount = movieList.count
        getData(title: title)
        let newCount = movieList.count
        movieCollection.performBatchUpdates({
            if(prevCount > 0){
                let deleteIndexPaths = Array(0...prevCount-1).map({IndexPath(item: $0, section:
                    0)})
                movieCollection.deleteItems(at: deleteIndexPaths)
            }
            let updateIndexPaths = Array(0...newCount-1).map({IndexPath(item: $0, section:
                0)})
            movieCollection.insertItems(at: updateIndexPaths)
        }, completion: nil)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            self.activityIndicator.stopAnimating()
//        }

        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! movieCell
            cell.movieLabel.text = movieList[indexPath.row].title
            cacheImages()
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
        let collectionCell: movieCell = (sender as? movieCell)!
            if let destination = segue.destination as? IanViewController {
                destination.titleVal = collectionCell.movieLabel.text!
                var myMovie: Movie?
                for movie in movieList{
                    if movie.title == collectionCell.movieLabel.text{
                        myMovie = movie
                        break;
                    }
                }
                destination.releaseVal = "Released: \(myMovie!.release_date)"
                destination.ratingVal = "Rating: \(myMovie!.vote_average)"
                destination.scoreVal = "Votes: \(myMovie!.vote_count!)"
                
                let url = URL(string: "http://image.tmdb.org/t/p/w500\(myMovie!.poster_path ?? "")")
                let data = try? Data.init(contentsOf: url!)
                if(data != nil){
                    destination.bigImage = UIImage(data: data!)
                }
            }
        }
    }

