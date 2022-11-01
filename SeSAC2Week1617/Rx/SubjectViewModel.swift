//
//  SubjectViewModel.swift
//  SeSAC2Week1617
//
//  Created by 강민혜 on 10/25/22.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

// associated type == generic
protocol CommonViewModel {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
    
}
//위에 내용 잘 모르겠으면, 1)generic, 2)associatedtype 순서로 더 공부해봐라


struct Contact {
    var name: String
    var age: Int
    var number: String
}

class SubjectViewModel: CommonViewModel {
    
    var contactData = [
        Contact(name: "JACK", age: 21, number: "01012341234"),
        Contact(name: "Metaverse Jack", age: 23, number: "01012345678"),
        Contact(name: "Real JACK", age: 25, number: "01056785678")
    ]
    
//    var list = PublishSubject<[Contact]>()
    var list = PublishRelay<[Contact]>()
    
    func fetchData() {
//        list.onNext(contactData)
        list.accept(contactData)
    }
    
    func resetData() {
//        list.onNext([])
        list.accept([])
    }
    
    func newData() {
        let new = Contact(name: "고래밥", age: Int.random(in: 10...50), number: "")
        contactData.append(new)
        
//        list.onNext(contactData)
        list.accept(contactData)
    }
    
    func filterData(query: String) {
        
        let arr = query != "" ? contactData.filter { $0.name.contains(query) } : contactData
        
//        list.onNext(arr)
        list.accept(arr)
    }
    
    // MARK: - input, output
    
    struct Input {
        let addTap: ControlEvent<Void>
        let resetTap: ControlEvent<Void>
        let newTap: ControlEvent<Void>
        
        let searchText: ControlProperty<String?>
    }
    
    struct Output {
        let addTap: ControlEvent<Void>
        let resetTap: ControlEvent<Void>
        let newTap: ControlEvent<Void>
        
        let list: Driver<[Contact]>
        let searchText: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        
        let list = list.asDriver(onErrorJustReturn: [])
        
        let text = input.searchText
            .orEmpty // VC -> VM (Input)
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance) // wait
            .distinctUntilChanged() // 같은 값을 받지 않음
        
        return Output(addTap: input.addTap, resetTap: input.resetTap, newTap: input.newTap, list: list, searchText: text)
    }
    
    
    
}
