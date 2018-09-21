//
//  Notice.swift
//  TheNoticesGuardian
//
//  Created by Stefanini on 21/09/18.
//  Copyright © 2018 Stefanini. All rights reserved.
//

import Foundation
import SwiftyJSON

class Notice {
    
    private struct SerializationKeys {
        static let content = "content"
        static let id = "id"
        static let webTitle = "webTitle"
        static let webPublicationDate = "webPublicationDate"
        static let thumbnail = "thumbnail"
        static let bodyText = "bodyText"
        static let sessionName = "sessionName"
    }

    let content: String?
    let webTitle: String?
    let webPublicationDate: String?
    let sessionName: String?
    let thumbnail: String?
    let bodyText: String?
    
    public convenience init(object: Any){
        self.init(json: object)
    }
    public required init(json: JSON){
        let content = json[SerializationKeys.content].array
        self.webTitle = content![SerializationKeys.webTitle].string
        self.webPublicationDate: String?
        self.sessionName: String?
        self.thumbnail: String?
        self.bodyText: String?
    }
//    let content: String?
//    let webTitle: String?
//    let webPublicationDate: String?
//    let sessionName: String?
//    let thumbnail: String?
//    let bodyText: String?
}
