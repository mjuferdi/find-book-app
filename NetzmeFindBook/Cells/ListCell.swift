//
//  ListCell.swift
//  NetzmeFindBook
//
//  Created by Mario Muhammad on 01.10.19.
//  Copyright © 2019 Mario Muhammad. All rights reserved.
//

import UIKit
import Kingfisher
import Cosmos

class ListCell: UICollectionViewCell {
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Set cell attribute based on data model Design
    var buku: BukuInfo! {
        didSet {
            if let bukuTitle = buku.title, let bukuAuthor = buku.authors, let imageLink = buku.imageLinks, let bukuAverageRat = buku.averageRating, let bukuRating = buku.ratingsCount, let bukuPublished = buku.publishedYear, let bahasa = buku.language {
                
                // Set buku title
                titleLabel.text = bukuTitle
                // Set buku authors
                bukuAuthor.forEach { (author) in
                    authorLabel.text = author
                }
                // Set buku year
                yearLabel.text = bukuPublished
                // Set buku language
                switch bahasa {
                case "en":
                    languageLabel.text = "English"
                case "id":
                    languageLabel.text = "Indonesia"
                default:
                    return
                }
                // Download buku image from URL to set in imageview
                let urlString = imageLink
                let url = URL(string: urlString)
                bookImageView.kf.setImage(with: url, placeholder: UIImage(named: "no-image"), options: nil, progressBlock: nil) { (result) in
                    return
                }
                bookImageView.contentMode = UIView.ContentMode.scaleAspectFill
                // Set buku rating
                cosmosView.rating = Double(bukuAverageRat)
                cosmosView.settings.fillMode = .half
                cosmosView.settings.updateOnTouch = false
            }
        }
    }
}
