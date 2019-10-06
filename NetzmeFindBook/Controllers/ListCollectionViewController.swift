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
