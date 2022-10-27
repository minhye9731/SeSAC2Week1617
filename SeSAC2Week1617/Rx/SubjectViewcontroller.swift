//
//  SubjectViewcontroller.swift
//  SeSAC2Week1617
//
//  Created by 강민혜 on 10/25/22.
//

import UIKit
import RxSwift
import RxCocoa

class SubjectViewcontroller: UIViewController {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var newButton: UIBarButtonItem!
    
    let publish = PublishSubject<Int>() // 초기값이 없는 빈 상태
    let behavior = BehaviorSubject(value: 100) // 초기값 필수
    let replay = ReplaySubject<Int>.create(bufferSize: 3) // bufferSize 작성된 이벤트 갯수만큼 메모리에서 이벤트를 가지고 있다가, subscribe 직후 한 번에 이벤트를 전달
    let async = AsyncSubject<Int>() // 초기값이 없는 빈 상태
    // Variable 키워드 보이면 넘어가라. 더이상 안쓰는거다.
    
    let disposeBag = DisposeBag()
    let viewModel = SubjectViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "ContactCell")
        
        viewModel.list
            .bind(to: tableview.rx.items(cellIdentifier: "ContactCell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element.name): \(element.age)세 (\(element.number))"
            }
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.fetchData()
            }
            .disposed(by: disposeBag)
        
        resetButton.rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.resetData()
            }
            .disposed(by: disposeBag)
        
        newButton.rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.newData()
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .distinctUntilChanged() // 같은 값을 받지 않음
            .withUnretained(self)
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance) // wait
            .subscribe { (vc, value) in
                print("=====\(value)")
                vc.viewModel.filterData(query: value)
            }
            .disposed(by: disposeBag)
    }
    


}

// MARK: - 복습용
//extension SubjectViewcontroller {
//
//    func asyncSubject() {
//        async.onNext(100)
//        async.onNext(200)
//        async.onNext(300)
//        async.onNext(400)
//        async.onNext(500)
//
//        // observable
//        async
//            .subscribe { value in
//                print("async - \(value)")
//            } onError: { error in
//                print("async - \(error)")
//            } onCompleted: {
//                print("async onCompleted")
//            } onDisposed: {
//                print("async disposed")
//            }
//            .disposed(by: disposeBag)
//
//        //observer
//        async.onNext(3)
//        async.onNext(4)
//        async.on(.next(5))
//
//        async.onCompleted() // 만약 이게 없다면, 안뜬다. 이게 전달이 되면 실행이 된다.
//
//        // 그래서 여기 아래 두개는 실행되지 않음
//        // 왜? subscribe한 observable 시퀀스가 위에서 onCompleted 되어서
//        async.onNext(6)
//        async.onNext(7)
//    }
//
//    func replaySubject() {
//        // bufferSize에 작성이 된 이벤트 만큼, 메모리에 이벤트를 가지고 있다가 subscribe를 한 직후에 한 번에 이벤트를 전달
//        // BufferSize 메모리, array, 이미지
//
//        replay.onNext(100)
//        replay.onNext(200)
//        replay.onNext(300)
//        replay.onNext(400)
//        replay.onNext(500)
//
//        // observable
//        replay
//            .subscribe { value in
//                print("replay - \(value)")
//            } onError: { error in
//                print("replay - \(error)")
//            } onCompleted: {
//                print("replay onCompleted")
//            } onDisposed: {
//                print("replay disposed")
//            }
//            .disposed(by: disposeBag)
//
//        replay.onNext(3)
//        replay.onNext(4)
//        replay.on(.next(5))
//
//        replay.onCompleted()
//
//        // 아래 두개는 실행되지 않음
//        // 왜? 얘도 subscribe한 observable 시퀀스가 위에서 onCompleted 되어서
//        replay.onNext(6)
//        replay.onNext(7)
//
//    }
//
//    func publishSubject() {
//        // 초기값이 없는 빈 상태
//        // subscribe 이후 시점부터 emit되는 이벤트는 다 처리
//        // subscribe 전 emit된 이벤트들은 무시
//
//        publish.onNext(1) // 무시
//        publish.onNext(2) // 무시
//
//        publish
//            .subscribe { value in
//                print("publish - \(value)")
//            } onError: { error in
//                print("publish - \(error)")
//            } onCompleted: {
//                print("publish onCompleted")
//            } onDisposed: {
//                print("publish isposed")
//            }
//            .disposed(by: disposeBag)
//
//        publish.onNext(3)
//        publish.onNext(4)
//        publish.on(.next(5))
//
//        publish.onCompleted()
//
//        // 아래 두개는 실행되지 않음
//        // 왜? 얘도 subscribe한 observable 시퀀스가 위에서 onCompleted 되어서
//        publish.onNext(6)
//        publish.onNext(7)
//
//
//    }
//
//    func behaviorSubject() {
//        // 초기값 필수
//        // subscribe 이후 시점부터 emit되는 이벤트는 다 처리 & 이전 시점에 emit된 이벤트 있으면 가장 최근거 하나만 전달
//        // 만약 subscribe 이전에 emit한 이벤트가 아예 없다? -> 초기값 전달함
//
//        publish.onNext(1)
//        publish.onNext(200) // 이렇게 버로 이전 것만 의미있는 것임
//
//        behavior
//            .subscribe { value in
//                print("behavior - \(value)")
//            } onError: { error in
//                print("behavior - \(error)")
//            } onCompleted: {
//                print("behavior onCompleted")
//            } onDisposed: {
//                print("behavior isposed")
//            }
//            .disposed(by: disposeBag)
//
//        behavior.onNext(3)
//        behavior.onNext(4)
//        behavior.on(.next(5))
//
//        behavior.onCompleted()
//
//        // 아래 두개는 실행되지 않음
//        // 왜? 얘도 subscribe한 observable 시퀀스가 위에서 onCompleted 되어서
//        behavior.onNext(6)
//        behavior.onNext(7)
//
//    }
//}
