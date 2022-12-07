//
//  Lifesaver Singleton.swift
//  Lifesaver
//
//  Created by Muharrem Köroğlu on 6.12.2022.
//

import Foundation
import UIKit

class Lifesaver {
    
    static let sharedInstance = Lifesaver()
    
    var dogGender = ""
    var dogType = ""
    var dogProblem = ""
    var dogImage = UIImage()
    var dogLatitude = ""
    var dogLongitude = ""

    private init () {}
}
