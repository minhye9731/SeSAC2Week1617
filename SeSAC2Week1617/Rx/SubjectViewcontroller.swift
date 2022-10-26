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
            .withUnretained(self)
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance) // wait
//            .distinctUntilChanged() // 같은 값을 받지 않음 - 에러나서 내일 확인해볼 것임.
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
//        async.onNext(1)
//        async.onNext(200) // 이렇게 버로 이전 것만 의미있는 것임
//
//        publish
//            .subscribe { value in
//                print("async - \(value)")
//            } onError: { error in
//                print("async - \(error)")
//            } onCompleted: {
//                print("async onCompleted")
//            } onDisposed: {
//                print("async isposed")
//            }
//            .disposed(by: disposeBag)
//
//        async.onNext(3)
//        async.onNext(4)
//        async.on(.next(5))
//
//        async.onCompleted() // 만약 이게 없다면, 안뜬다. 이게 전달이 되면 실행이 된다.
//
//        async.onNext(6)
//        async.onNext(7)
//    }
//
//    func replaySubject() {
//        // BufferSize 메모리, array, 이미지
//
//        replay.onNext(100)
//        replay.onNext(200)
//        replay.onNext(300)
//        replay.onNext(400)
//        replay.onNext(500)
//
//        replay
//            .subscribe { value in
//                print("replay - \(value)")
//            } onError: { error in
//                print("replay - \(error)")
//            }
//    }
//
//    func publishSubject() {
//        // 구독 전에 가장 최근 값을 같이 emit
//
//        // 초기값이 없는 빈 상태, subscribe 전/error/completed notification 이후 이벤트 위
//        // subscribe후에 해당 이벤트르는 다 처리
//
//        publish.onNext(1)
//        publish.onNext(200) // 이렇게 버로 이전 것만 의미있는 것임
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
//        behavior.onNext(1)
//        behavior.onNext(1)
//
//
//    }
//}
