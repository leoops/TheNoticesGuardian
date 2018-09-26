//
//  SearchNotice.swift
//  TheNoticesGuardian
//
//  Created by Stefanini on 24/09/18.
//  Copyright © 2018 Stefanini. All rights reserved.
//

import Foundation
import SwiftyJSON

class SearchNotice {
    
    private struct SerializationKeys {
        static let response = "response"
        static let results = "results"
        static let pages = "pages"
        static let currentPage = "currentPage"
    }
    
    var currentPage: Int?
    var pages: Int?
    var results = [SearchResults]()
    
    public convenience init(object: Any){
        self.init(json: JSON(object))
    }
    
    public required init(json: JSON){
        let response = json[SerializationKeys.response]
        
        self.pages = response[SerializationKeys.pages].int
        self.currentPage = response[SerializationKeys.currentPage].int
        if let results = response[SerializationKeys.results].array {
            self.results = results.map { SearchResults(json: $0)}
        }
    }
}
