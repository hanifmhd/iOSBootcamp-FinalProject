//
//  Profile.swift
//  NewsMVVM Final
//
//  Created by Muhammad Hanif on 20/01/23.
//

import Foundation
import RealmSwift

class Profile: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var fullname: String = ""
    @Persisted var title: String = ""
    @Persisted var image: Data
}
