//
//  NewsViewModel.swift
//  NewsMVVM Final
//
//  Created by Muhammad Hanif on 20/01/23.
//

import Foundation
import RxSwift
import RxCocoa

struct NewsViewModel {
    let articles: News
    
    init(_ articles: News) {
        self.articles = articles
    }
    
    var title: Observable<String> {
        return Observable<String>.just(articles.title)
    }
    
    var description: Observable<String> {
        return Observable<String>.just(articles.desc ?? "")
    }
}
