//
//  Sessao.swift
//  TheNoticesGuardian
//
//  Created by Stefanini on 18/09/18.
//  Copyright © 2018 Stefanini. All rights reserved.
//

import Foundation
import SwiftyJSON


class Session {
    
    private struct SerializationKeys {
        static let response = "response"
        static let results = "results"
    }
    
    var total: Int?
    var results = [SessionResults]()
    
    public convenience init(object: Any) {
        self.init(json: JSON(object))
    }
    
    public required init(json: JSON) {
        let json = json[SerializationKeys.response]
        if let results = json[SerializationKeys.results].array {self.results = results.map { SessionResults(json: $0)}}
    }
}
