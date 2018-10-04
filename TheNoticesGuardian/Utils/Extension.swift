//
//  Extensions.swift
//  TheNoticesGuardian
//
//  Created by Stefanini on 26/09/18.
//  Copyright © 2018 Stefanini. All rights reserved.
//

import Foundation
import SwifterSwift
import Lottie
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

extension LOTAnimationView {
    func repositionAnimationOnScreen(positionX: CGFloat, positionY: CGFloat) {
        self.frame.origin = CGPoint(x: positionX - self.width/2, y: positionY - self.height/2)
    }
    func stopAndHidenAnimation() {
        if !self.isHidden {
            self.stop()
            self.isHidden = true
        }
    }
    
    func playAnimation() {
        if self.isHidden { self.isHidden = false }
        self.play()
    }
}
