//
//  NetworkManager.swift
//  NetzmeFindBook
//
//  Created by Mario Muhammad on 30.09.19.
//  Copyright © 2019 Mario Muhammad. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class NetworkManager {
    
    @discardableResult
    private static func performRequest<T:Decodable>(route:APIRouter, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (Result<T, AFError>)->Void) -> DataRequest {
        return AF.request(route).responseDecodable (decoder: decoder){ (response: DataResponse<T, AFError>) in
            completion(response.result)
        }
    }
    
    static func getBook(keyword: String, completion:@escaping (Result<BukuModel, AFError>) -> Void) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.bookDateFormatter)
        performRequest(route: APIRouter.cariBuku(keyword: ["q": keyword]), decoder: jsonDecoder, completion: completion)
    }
}

extension DateFormatter {
    static var bookDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterYear = DateFormatter()
        dateFormatterYear.dateFormat = "yyyy"
        return dateFormatterYear
    }
}
