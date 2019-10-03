//
//  ListCell.swift
//  NetzmeFindBook
//
//  Created by Mario Muhammad on 01.10.19.
//  Copyright © 2019 Mario Muhammad. All rights reserved.
//

import UIKit
import Kingfisher

class ListCell: UICollectionViewCell {
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var rateImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Set cell attribute based on data model Design
    var buku: BukuInfo! {
        didSet {
            if let bukuTitle = buku.title, let bukuAuthor = buku.authors, let imageLink = buku.imageLinks, let bukuAverageRat = buku.averageRating, let bukuRating = buku.ratingsCount, let bukuPublished = buku.publishedYear {
                
                titleLabel.text = bukuTitle
                bukuAuthor.forEach { (author) in
                    authorLabel.text = author
                }
                
                // Download image from URL to set in imageview
                let urlString = imageLink
                let url = URL(string: urlString)
                bookImageView.kf.setImage(with: url, placeholder: UIImage(named: "no-image"), options: nil, progressBlock: nil) { (result) in
                    return
                }
                bookImageView.contentMode = UIView.ContentMode.scaleAspectFill
                
            }
        }
    }
}
