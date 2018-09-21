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
    typealias JsonSessionHandler = (([SessionResults]?) -> ())
    typealias JsonNoticesHandler = ((Notices?) -> ())
    typealias JsonNoticeHandler = ((Notice?) -> ())
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - showElements: tipo do conteudo da session a ser buscado
    ///   - handler: conjunto de noticias retornado ao final da requição
    static func requestAllSessions(showElements: String, handler: JsonSessionHandler?){
        guard let url = URL(string:LinkManager.listOsSessions(showElements: showElements)) else {
            return
        }
        Alamofire.request(url).validate().responseJSON { (dataResponse) in
            switch dataResponse.result {
            case .success(let value):
                let dataSessions = Session(object: value)
                if let handlerUnwrapped = handler {
                    handlerUnwrapped(dataSessions.results)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    static func requestNotices(inPage page: Int, withSession session: String, handler: JsonNoticesHandler?){
        guard let url = URL(string: LinkManager.listOfNotices(session: session, pageNumber: "\(page)")) else {
            return
        }
        Alamofire.request(url).validate().responseJSON { (dataResponse) in
            switch dataResponse.result {
            case .success(let value):
                let dataNotices = Notices(object: value)
                if let handlerUnwrapped = handler {
                    handlerUnwrapped(dataNotices)
                }
            case .failure(let error):
                print(error)
            
            }
        }
    }
//    https://content.guardianapis.com/books/2018/sep/15/sarah-perry-made-in-chelmsford?api-key=beea06ac-ec4d-4547-9118-db67727e4e7e&show-elements=all&show-fields=bodyText,thumbnail
    static func requestNotice(withId id: Int, handler: JsonNoticeHandler?) {
        guard let url = URL(string: LinkManager.itemNotice(id: "\(id)")) else {
            return
        }
    }
}
