//
//  Extensions.swift
//  TheNoticesGuardian
//
//  Created by Stefanini on 26/09/18.
//  Copyright © 2018 Stefanini. All rights reserved.
//

import Foundation
import SwifterSwift

protocol Alert {}

extension String{
    
    /// Metodo de converte de caracteres especiais de uma string em alfanumerico
    ///
    /// - Returns: string convertida
    func addingPercentEncoding() -> String {
        if let link = self.addingPercentEncoding(withAllowedCharacters: NSMutableCharacterSet.alphanumeric() as CharacterSet){
            return link
        }
        return self
    }
    
    func formatToStringDate(oldFormat: String, newFormat: String) -> String {
        if let date = self.date(withFormat: oldFormat) {
            return date.string(withFormat: "dd/MM/yyyy HH:mm")
        }
        return ""
    }
}

extension Date {

}
