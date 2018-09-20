//
//  Sessao.swift
//  TheNoticesGuardian
//
//  Created by Stefanini on 18/09/18.
//  Copyright © 2018 Stefanini. All rights reserved.
//

import Foundation
import SwiftyJSON

private struct SerializationKeys {
    static let response = "response"
    static let results = "results"
}
class Session {
    
    var results = [Results]()
    
    public required init(json: JSON) {
        let json = json[SerializationKeys.response]
        if let results = json[SerializationKeys.results].array {self.results = results.map { Results(json: $0)}}
    }
    
    public convenience init(object: Any) {
        self.init(json: JSON(object))
    }
}
