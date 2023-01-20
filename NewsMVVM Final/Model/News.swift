//
//  News.swift
//  NewsMVVM Final
//
//  Created by Muhammad Hanif on 20/01/23.
//

import Foundation
import RealmSwift

struct NewsResponse: Decodable {
    let articles: [News]
}

class News: Object, Decodable {
    @Persisted(primaryKey: true) var title: String = ""
    @Persisted var desc: String?
    @Persisted var urlImage: String?
    
    enum CodingKeys: String, CodingKey {
        case title, desc, urlImage
    }
}
