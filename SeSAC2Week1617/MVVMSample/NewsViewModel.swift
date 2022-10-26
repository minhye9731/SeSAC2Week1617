//
//  NewsViewModel.swift
//  SeSAC2Week1617
//
//  Created by 강민혜 on 10/20/22.
//

import Foundation
import RxSwift
import RxCocoa

class NewsViewModel {
    
//    var pageNumber: CObservable<String> = CObservable("3000")
    var pageNumber = BehaviorSubject<String>(value: "3,000")
    
//    var sample: CObservable<[News.NewsItem]> = CObservable(News.items)
//    var sample = BehaviorSubject(value: News.items)
    var sample = BehaviorRelay(value: News.items)
    
    func changePageNumberFormat(text: String) {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let text = text.replacingOccurrences(of: ",", with: "")
        guard let number = Int(text) else { return }
        let result = numberFormatter.string(for: number)! // from이면 ns~~로 써야해서, 바로 int로 쓰려고 for로 변경함.
        
//        pageNumber.value = result
        pageNumber.onNext(result) // 이벤트 전달
        // on, onnext 차이? onnext를 더 많이 쓴다. on은 에러도 다 보낼 수 있으니까 아예 한번에 이벤트만 전달해버리기 위해 onnext를 씀.
    }
    
    func resetSample() {
//        sample.value = [] // MVVM 적용
//        sample.onNext([]) // RX 적용
        sample.accept([]) // RX 적용 - relay 적용
    }
    
    func loadSample() {
//        sample.value = News.items
//        sample.onNext(News.items)
        sample.accept(News.items)
    }
    
}
