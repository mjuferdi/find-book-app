//
//  Constant.swift
//  NetzmeFindBook
//
//  Created by Mario Muhammad on 30.09.19.
//  Copyright © 2019 Mario Muhammad. All rights reserved.
//

import Foundation

struct K {
    struct ProductionServer {
        static let baseuRL = "https://www.googleapis.com"
    }
    
    struct APIParameterKey {
        static let keyword = ""
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}

class DefaultValue {
    static let TITLE = "Untitled"
    static let AUTHOR = ["Unknown"]
    static let THUMBNAIL = "No Image"
    static let AVG_RATING = 0
    static let RATING = 0
    static let YEAR = "-"
}


