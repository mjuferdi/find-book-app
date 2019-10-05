//
//  HomeViewController.swift
//  NetzmeFindBook
//
//  Created by Mario Muhammad on 30.09.19.
//  Copyright © 2019 Mario Muhammad. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {

    @IBOutlet weak var keywordTextField: UITextField!
    
    private var booksInfo: [BukuInfo] = [BukuInfo]()
    var keyword: String?
    
    // Delegate Protocol
    var delegate: bookProtocol?        
    override func viewDidLoad() {
        super.viewDidLoad()
        keywordTextField.delegate = self
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedarround()

    }
    
    // Funktionalität
    // Activity Indication
    // Fetch query with parameter from user input using http method GET
    func getBookByKeyword(keyword: String) {
        NetworkManager.getBook(keyword: keyword) { (result) in
            switch result {
            case .success(let book):
                self.booksInfo.removeAll()
                book.items?.forEach({ (book) in
                    let title = book.volumeInfo?.title ?? DefaultValue.TITLE
                    let authors = book.volumeInfo?.authors ?? DefaultValue.AUTHOR
                    let thumbnail = book.volumeInfo?.imageLinks?.thumbnail ?? DefaultValue.THUMBNAIL
                    let averageRat = book.volumeInfo?.averageRating ?? DefaultValue.AVG_RATING
                    let ratingsCount = book.volumeInfo?.ratingsCount ?? DefaultValue.RATING
                    let date = book.volumeInfo?.publishedDate ?? DefaultValue.YEAR
                    let language = book.volumeInfo?.language ?? DefaultValue.LANGUAGE
                    //let price = book.saleInfo?.listPrice?.amount ?? DefaultValue.PRICE
                    print("Rating: \(Decimal(averageRat))")
                    self.booksInfo.append(BukuInfo(title: title, authors: authors, imageLinks: thumbnail, averageRating: averageRat, ratingsCount: ratingsCount, publishedYear: self.dateOnlyYearFormatter(date: date), language: language))
                })
                self.delegate?.setBookInfo(bukuInfo: self.booksInfo)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // Format published date
    func dateOnlyYearFormatter(date: String) -> String {
        let inputFormatter = DateFormatter()
        let inputFormatterWihtMonth = DateFormatter()
        var resultString: String = ""
        
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatterWihtMonth.dateFormat = "yyyy-MM"
        
        // Check if date wth different format
        if inputFormatter.date(from: date) != nil {
            if let showDate = inputFormatter.date(from: date) {
                inputFormatter.dateFormat = "yyyy"
                resultString = inputFormatter.string(from: showDate)
            }
        } else if inputFormatterWihtMonth.date(from: date) != nil {
            if let showDate = inputFormatterWihtMonth.date(from: date) {
                inputFormatter.dateFormat = "yyyy"
                resultString = inputFormatter.string(from: showDate)
            }
        } else  {
            resultString = date
        }
        return resultString
    }

    // MARK: - IBAction
    // Error handling kalau input tidak ada 
    @IBAction func cariButtonTapped(_ sender: Any) {
        guard let inputText = keywordTextField.text else {fatalError("Sumting error")}
        if inputText == "" {
            keyword = "{}"
        } else {
            keyword = inputText
        }
        keywordTextField.text = ""
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ListCollectionViewController {
            let listColVC = segue.destination as? ListCollectionViewController
            guard let givenKeyword = keyword else {fatalError("Sumting error")}
            listColVC?.keyword = givenKeyword
        }
    }

}

extension HomeViewController: UITextFieldDelegate {
    // Hide keyboard when done button tapped
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        keywordTextField.resignFirstResponder()
        return true
    }
}

// Hide keyboard when touched anywhere
extension UIViewController {
    func hideKeyboardWhenTappedarround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
