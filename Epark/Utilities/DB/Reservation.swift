//
//  Reservation.swift
//  Epark
//
//  Created by iheb mbarki on 10/11/2022.
//

import Foundation
import FirebaseFirestoreSwift

 struct Reservation: Identifiable, Codable {
     @DocumentID var id: String? = UUID().uuidString
     var firstName: String
     var lastName: String
     var registrationPlate: String
     var date: Date
     var duration: Int
    
    enum CodingKeys: String, CodingKey {
        case firstName
        case lastName
        case registrationPlate = "plates"
        case date
        case duration
    }
}
