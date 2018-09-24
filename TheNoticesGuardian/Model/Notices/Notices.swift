//
//  Noticia.swift
//  TheNoticesGuardian
//
//  Created by Stefanini on 18/09/18.
//  Copyright © 2018 Stefanini. All rights reserved.
//

import Foundation
import SwiftyJSON

class Notices {
    private struct SerializationKeys {
        static let response = "response"
        static let results = "results"
        static let pages = "pages"
    }
    
    var pages: Int?
    var results = [NoticesResults]()
    
    public convenience init(object: Any) {
        self.init(json: JSON(object))
    }
    public required init(json: JSON) {
        let json = json[SerializationKeys.response]
        pages = json[SerializationKeys.pages].int
        if let results = json[SerializationKeys.results].array {self.results = results.map { NoticesResults(json: $0)}}
    }
}
