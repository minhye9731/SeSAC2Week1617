//
//  ValidationViewModel.swift
//  SeSAC2Week1617
//
//  Created by 강민혜 on 10/27/22.
//

import Foundation
import RxSwift
import RxCocoa

class ValidationViewModel {
    
    // 이렇게 절대 변하지 않을 문구일 경우, 굳이 rx로 안써도 된다 사실은
    // but 다양한 조건별 반영을 실시간으로 확인해서 문구를 바꿔준다면 rx로 해줘라.
    let validText = BehaviorRelay(value: "닉네임은 최소 8자 이상 필요해요")
    
    
    
    
    
    
}
