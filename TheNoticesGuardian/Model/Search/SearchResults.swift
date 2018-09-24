//
//  SearchResults.swift
//  TheNoticesGuardian
//
//  Created by Stefanini on 24/09/18.
//  Copyright © 2018 Stefanini. All rights reserved.
//

import Foundation
import SwiftyJSON

class SearchResults {
    
    private struct SerializationKeys {
        static let id = "id"
        static let webTitle = "webTitle"
        static let webPublicationDate = "webPublicationDate"
        static let sectionName = "sectionName"
    }
    
    let id: String?
    let webTitle: String?
    let webPublicationDate: String?
    let sectionName: String?
    
    public convenience init(object: Any){
        self.init(json: JSON(object))
    }
    
    public required init(json: JSON){
        self.id = json[SerializationKeys.id].string
        self.webTitle = json[SerializationKeys.webTitle].string
        self.webPublicationDate = json[SerializationKeys.webPublicationDate].string
        self.sectionName = json[SerializationKeys.sectionName].string
    }
}
