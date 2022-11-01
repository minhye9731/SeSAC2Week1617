//
//  SubscribeViewModel.swift
//  SeSAC2Week1617
//
//  Created by 강민혜 on 11/1/22.
//

import Foundation
import RxSwift
import RxCocoa

class SubscribeViewModel {

    struct Input {
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let text: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let result = input.tap
            .map { " 안녕 반가워 " }
            .asDriver(onErrorJustReturn: "")
        
        return Output(text: result)
    }
    
}
