//
//  Api.swift
//  TheNoticesGuardian
//
//  Created by Stefanini on 19/09/18.
//  Copyright © 2018 Stefanini. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ApiService {
    typealias JsonSessionHandler = (( [Results]?) -> ())
    
    static func requestAllSessions(showElements: String, handler: JsonSessionHandler?){
        guard let url = URL(string:LinkManager.listOsSessions(showElements: showElements)) else {
            return
        }
        Alamofire.request(url).validate().responseJSON { (dataResponse) in
            switch dataResponse.result {
                case .success(let value):
                    let dataSessions = Session(object: value)
                    print(dataSessions)
                    
                    if let handlerUnwrapped = handler {
                        handlerUnwrapped(dataSessions.results)
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    //static func requestNotices(with)
}
