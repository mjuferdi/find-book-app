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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keywordTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func getBookByKeyword(keyword: String) {
        //NetworkManager.getBook(keyword: keyword)
        NetworkManager.getBook(keyword: keyword) { (result) in
            switch result {
            case .success(let book):
                book.items?.forEach({ (book) in
                    if let title = book.volumeInfo?.title {
                        print("Judul Buku: \(title)")
                    }
                })
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // Error handling kalau input tidak ada 
    @IBAction func cariButtonTapped(_ sender: Any) {
        guard let inputText = keywordTextField.text else {fatalError("Sumthing error")}
        if inputText == "" {
            print("Keyword: \(inputText)")
            getBookByKeyword(keyword: "{}")
        } else {
            getBookByKeyword(keyword: inputText)
        }
        keywordTextField.text = ""
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeViewController: UITextFieldDelegate {
    // Hide keyboard when done button tapped
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        keywordTextField.resignFirstResponder()
        return true
    }
}
