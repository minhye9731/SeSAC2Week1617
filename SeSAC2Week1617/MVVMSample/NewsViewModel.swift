//
//  NewsViewModel.swift
//  SeSAC2Week1617
//
//  Created by 강민혜 on 10/20/22.
//

import Foundation

class NewsViewModel {
    
    var pageNumber: CObservable<String> = CObservable("3000")
    
    var sample: CObservable<[News.NewsItem]> = CObservable(News.items)
    
    func changePageNumberFormat(text: String) {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let text = text.replacingOccurrences(of: ",", with: "")
        guard let number = Int(text) else { return }
        let result = numberFormatter.string(for: number)! // from이면 ns~~로 써야해서, 바로 int로 쓰려고 for로 변경함.
        
        pageNumber.value = result
    }
    
    func resetSample() {
        sample.value = []
    }
    
    func loadSample() {
        sample.value = News.items
    }
    
}
