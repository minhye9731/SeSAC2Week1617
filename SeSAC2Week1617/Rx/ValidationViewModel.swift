//
//  ValidationViewModel.swift
//  SeSAC2Week1617
//
//  Created by 강민혜 on 10/27/22.
//

import Foundation
import RxSwift
import RxCocoa

class ValidationViewModel: CommonViewModel {
    
    // 이렇게 절대 변하지 않을 문구일 경우, 굳이 rx로 안써도 된다 사실은
    // but 다양한 조건별 반영을 실시간으로 확인해서 문구를 바꿔준다면 rx로 해줘라.
    let validText = BehaviorRelay(value: "닉네임은 최소 8자 이상 필요해요")
    
    struct Input {
        let text: ControlProperty<String?> // nameTextField.rx.text
        let tap: ControlEvent<Void> // stepButton.rx.tap
    }
    
    struct Output {
        let validStatus: Observable<Bool>
        let validText: Driver<String>
        let tap: ControlEvent<Void> // 얘는 연산과정이 없어서, input 그대로 써줌
    }
    
    func transform(input: Input) -> Output {
        let resultText = input.text
            .orEmpty // 옵셔널 해제해줌, String
            .map { $0.count >= 8 } // Bool
            .share() // share 대신에 driver, asdriver 로 써볼 수도 있음
        
        let text = validText.asDriver()
        
        return Output(validStatus: resultText, validText: text, tap: input.tap)
    }
    
    
}
