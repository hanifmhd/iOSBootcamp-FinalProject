//
//  ListNewsViewModel.swift
//  NewsMVVM Final
//
//  Created by Muhammad Hanif on 20/01/23.
//

struct ListNewsViewModel {
    var newsViewModel: [NewsViewModel]
    
    init(_ news: [News]) {
        self.newsViewModel = news.compactMap(NewsViewModel.init)
    }
    
    func newsAt(_ index: Int) -> NewsViewModel {
        return self.newsViewModel[index]
    }
}
