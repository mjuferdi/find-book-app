//
//  APIRouter.swift
//  NetzmeFindBook
//
//  Created by Mario Muhammad on 30.09.19.
//  Copyright © 2019 Mario Muhammad. All rights reserved.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
    case cariBuku(keyword: Parameters)

    // MARK: - HTTP Method
    private var method: HTTPMethod {
        switch self {
        case .cariBuku:
            return .get
        }
    }

    // MARK: - Path
    private var path: String {
        switch self {
        case .cariBuku:
            return "/books/v1/volumes"
        }
    }

    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .cariBuku(let keyword):
            return [K.APIParameterKey.keyword: keyword]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = try K.ProductionServer.baseuRL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))

        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)

        switch self {
        case .cariBuku(let keyword):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: keyword)
        }
        
        urlRequest.httpMethod = method.rawValue
        print("url: \(urlRequest)")
        return urlRequest
    }
}








