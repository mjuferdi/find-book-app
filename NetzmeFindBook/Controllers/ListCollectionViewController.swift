//
//  ListCollectionViewController.swift
//  NetzmeFindBook
//
//  Created by Mario Muhammad on 01.10.19.
//  Copyright © 2019 Mario Muhammad. All rights reserved.
//

import UIKit

class ListCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let homeViewController = HomeViewController()
    var booksData: [BukuInfo] = [BukuInfo]()
    var keyword: String = ""
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Input dari serbang nih: \(keyword)")
        
        activityIndicatorSetup()
        activityIndicator.startAnimating()
        
        homeViewController.delegate = self
        homeViewController.getBookByKeyword(keyword: self.keyword)
    
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false


        // Do any additional setup after loading the view.
    }
    
    // MARK: - Functionalität
    func activityIndicatorSetup() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        let transfrom = CGAffineTransform.init(scaleX: 2.5, y: 2.5)
        activityIndicator.transform = transfrom
        self.view.addSubview(activityIndicator)
    }
    
    func bookNotFoundNotification() {
        let alert = UIAlertController(title: "Uuupss..", message: "Buku yang kamu cari gak ada :(", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return booksData.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as! ListCell
        let buku = self.booksData[indexPath.row]
        cell.buku = buku
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ListHeaderView", for: indexPath) as? SearchListHeaderView
                else {
                    fatalError("Invalid view type")
            }
            headerView.searchBar.placeholder = "Mau cari buku apa?"
            return headerView
        default:
            assert(false, "Invalid element type")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        return CGSize(width: (width - 30)/2, height: 350)
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension ListCollectionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if(!(searchBar.text?.isEmpty)!) {
            if let searchText = searchBar.text {
                activityIndicator.startAnimating()
                homeViewController.getBookByKeyword(keyword: searchText)
                self.collectionView.reloadData()
            }
            
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.isEmpty) {
            print("Searchbar empty")
            self.collectionView.reloadData()
        }
    }
}

extension ListCollectionViewController: bookProtocol  {

    func setBookInfo(bukuInfo: [BukuInfo]) {
        if bukuInfo.count == 0 {
            bookNotFoundNotification()
        } else {
            booksData = bukuInfo
        }
        booksData.forEach { (book) in
            print("\(book)")
        }
        activityIndicator.stopAnimating()
        collectionView.reloadData()
        print("Total buku: \(self.booksData.count)")
    }
}
