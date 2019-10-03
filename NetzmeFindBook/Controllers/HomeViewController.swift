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
    
    private var booksInfo: [Any] = []
    var keyword: String?
    
    // Delegate Protocol
    var delegate: bookProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keywordTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func getBookByKeyword(keyword: String) {
        NetworkManager.getBook(keyword: keyword) { (result) in
            switch result {
            case .success(let book):
                book.items?.forEach({ (book) in
                    if let books = book.volumeInfo {
                        self.booksInfo.append(books)
                    }
                })
                print("\(self.booksInfo)")
                self.delegate?.setBookInfo(volumeInfo: self.booksInfo)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func dateOnlyYearFormatter(date: String) {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyy-MM-dd"
        if let showDate = inputFormatter.date(from: date) {
            inputFormatter.dateFormat = "yyy"
            let resultString = inputFormatter.string(from: showDate)
        }
    }

    // MARK: - IBAction
    // Error handling kalau input tidak ada 
    @IBAction func cariButtonTapped(_ sender: Any) {
        guard let inputText = keywordTextField.text else {fatalError("Sumting error")}
        if inputText == "" {
            keyword = "{}"
            print("Keyword: \(keyword)")
        } else {
            keyword = inputText
            print("Keyword: \(keyword)")
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

