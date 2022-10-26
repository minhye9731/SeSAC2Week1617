//
//  SubjectViewModel.swift
//  SeSAC2Week1617
//
//  Created by 강민혜 on 10/25/22.
//

import UIKit
import RxSwift
import RxCocoa

struct Contact {
    var name: String
    var age: Int
    var number: String
}

class SubjectViewModel {
    
    var contactData = [
        Contact(name: "JACK", age: 21, number: "01012341234"),
        Contact(name: "Metaverse Jack", age: 23, number: "01012345678"),
        Contact(name: "Real JACK", age: 25, number: "01056785678")
    ]
    
    var list = PublishSubject<[Contact]>()
    
    func fetchData() {
        list.onNext(contactData)
    }
    
    func resetData() {
        list.onNext([])
    }
    
    func newData() {
        let new = Contact(name: "고래밥", age: Int.random(in: 10...50), number: "")
        contactData.append(new)
        list.onNext(contactData)
    }
    
    func filterData(query: String) {
        
        let arr = query != "" ? contactData.filter { $0.name.contains(query) } : contactData
        list.onNext(arr)
        
    }
}
