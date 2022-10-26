//
//  RxCocoaExampleViewController.swift
//  SeSAC2Week1617
//
//  Created by 강민혜 on 10/24/22.
//

import UIKit
import RxCocoa
import RxSwift

class RxCocoaExampleViewController: UIViewController {
    
    @IBOutlet weak var simpleTableView: UITableView!
    @IBOutlet weak var simplePickerView: UIPickerView!
    @IBOutlet weak var simpleLabel: UILabel!
    @IBOutlet weak var simpleSwitch: UISwitch!
    
    @IBOutlet weak var signName: UITextField!
    @IBOutlet weak var signEmail: UITextField!
    @IBOutlet weak var signButton: UIButton!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    
    var disposeBag = DisposeBag()
    var nickname = Observable.just("ggg")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nickname.bind(to: nicknameLabel.rx.text)
            .disposed(by: disposeBag)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.nickname = "_hello"
//        }
        
        
        setTableView()
        setPickerView()
        setSwitch()
        setSign()
        setOperator()
    }
    
    // viewcontroller deinit 되면, 알아서 dispose도 동작한다.
    // 또는 Dispose Bag() 객체를 새롭게 넣어주거나, nil 할당 => 예외 케이스!(rootVC애 intervaldl\ / """
    deinit {
        print("RxCocoaExampleViewController deinit")
    }
    
    func setOperator() {
        
        Observable.repeatElement("Hi").take(5) // 5회만 repeat해라 라고 설정할 수 있음, 여기까지가 이벤트를 보내는 부분(이벤트를 처리해줄 객체는 아닌 부분)
            .subscribe { value in
                print("repeat - \(value)")
            } onError: { error in
                print("repeat - \(error)")
            } onCompleted: {
                print("repeat completed")
            } onDisposed: { // 얘는 거의 deinite됐을때 프린트 찍는거랑 같은 역할을 함
                print("repeat disposed")
            }
            .disposed(by: disposeBag)
        
        // 얘도 횟수제한 안하면 안끝나고 계속됨. 그래서 수동으로 관리해주는 요소가 필요함
        
        // DisposeBag: 리소스 해제 관리 -
            // 1. 시퀀스 끝날 때 but bind
            // 2. class deinit 자동 해제
            // 3. dispose 직접 호출. -> dispose() 구독하는 것마다 별도로 관리! 그래서 이방법은 매번 해야해서 번거로움. 그럴떈 4번 참고
            // 4. DisposeBag을 새롭게 할당하거나, nil 전달.
        
        
        
//        Observable<Int>.interval(.seconds(2), scheduler: MainScheduler.instance)
//            .subscribe { value in
//                print("disposable test - \(value)")
//            } onError: { error in
//                print(error)
//            } onCompleted: {
//                print("disposable test completed")
//            } onDisposed: {
//                print("disposable test disposed")
//            }
//            .disposed(by: disposeBag)


        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.disposeBag = DisposeBag() // 한번에 리소스 정리하는 역할. 이 덕분에 하나하나 해제를 해주지 않이도 되아도 deinit됨
            
//            intervalObservable.dispose()
//            intervalObservable2.dispose()
//            intervalObservable3.dispose()
        }
        
        
        
        let itemsA = [3.3, 4.0, 5.0, 2.0, 3.6, 4.8]
        let itemsB = [2.3, 2.0, 1.3]
        
        Observable.from(itemsA)
            .subscribe { value in
                print("from - \(value)")
            } onError: { error in
                print("from - \(error)")
            } onCompleted: {
                print("from completed")
            } onDisposed: {
                print("from disposed")
            }
            .disposed(by: disposeBag)
        
        Observable.of(itemsA, itemsB)
            .subscribe { value in
                print("of - \(value)")
            } onError: { error in
                print("of - \(error)")
            } onCompleted: {
                print("of completed")
            } onDisposed: {
                print("of disposed")
            }
            .disposed(by: disposeBag)
        
        Observable.just(itemsA)
            .subscribe { value in
                print("just - \(value)")
            } onError: { error in
                print("just - \(error)")
            } onCompleted: {
                print("just completed")
            } onDisposed: {
                print("just disposed")
            }
            .disposed(by: disposeBag)
        

        
    }
    
    // MARK: - uitextfield, uibutton에 적용하기
    func setSign() {
        // ex. 택1(observable), 택2(observable) > 레이블(observer, bind)에 보여주기 (=observable 2개, observer 1개)
        // 옵셔널 해제할때 .orEmpty 추가하면 해결 가능함
        Observable.combineLatest(signName.rx.text.orEmpty, signEmail.rx.text.orEmpty) { value1, value2 in
            "name은 \(value1)이고, 이메일은 \(value2)입니다."
        }
        .bind(to: simpleLabel.rx.text)
        .disposed(by: disposeBag)
        
        // 데이터의 stream을 통제한다.
        signName // UITextField
            .rx // Reactive
            .text // String?
            .orEmpty // String
            .map { $0.count < 4 } // Int
            .bind(to: signEmail.rx.isHidden, signButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        signEmail.rx.text.orEmpty
            .map { $0.count > 4 }
            .bind(to: signButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        signButton.rx.tap // tap을 하면 비어있는? 결과만 내니까, 기능을 내는 것은 subscribe가 한다. tab도 bind가 되긴 된다. 근데 bind하려는 객체랑 bind되는 객체랑 타입이 맞아떨어져야 해서 그럼.
            .withUnretained(self) // 이거 연산자를 써주면 [weak self] 생략 가능
//            .subscribe { [weak self] _ in
//                self?.showAlert()
//            }
//            .disposed(by: disposeBag)
            .subscribe { vc, _ in
                vc.showAlert()
            }
            .disposed(by: disposeBag)
            
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "하하하", message: "nil", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    // MARK: - uiswitch에 적용하기
    func setSwitch() {
        Observable.of(false) // just? of?
            .bind(to: simpleSwitch.rx.isOn)
            .disposed(by: disposeBag)
    }
        
    // MARK: - tableview에 적용하기
    func setTableView() {
        
        simpleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
     
        let items = Observable.just([
            "First Item",
            "Second Item",
            "Third Item"
        ])

        items
        .bind(to: simpleTableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element) @ row \(row)"
            return cell
        }
        .disposed(by: disposeBag)
        
        simpleTableView.rx.modelSelected(String.self) // item어쩌구는 인덱스 가져오기만, model은 데이터 가져오기만
//            .subscribe { value in
//                print(value)
//            } onError: { error in
//                print(error)
//            } onCompleted: {
//                print("completed")
//            } onDisposed: {
//                print("disposed")
//            }
            .map { data in
                "\(data)를 클릭했습니다."
            }
            .bind(to: simpleLabel.rx.text)  // 위에 대신 깔끔하게 bind로 축약사용
            .disposed(by: disposeBag) // 마지막에 이거 붙여주기 필수

        
        
        
    }
    
    // MARK: - pickerview에 적용하기
    func setPickerView() {
        
        let items = Observable.just([
                "영화",
                "애니메이션",
                "드라마",
                "기타"
            ])
     
        items
            .bind(to: simplePickerView.rx.itemTitles) { (row, element) in
                return element
            }
            .disposed(by: disposeBag)
        
        simplePickerView.rx.modelSelected(String.self)
            .map { $0.description }
            .bind(to: simpleLabel.rx.text)
//            .subscribe { value in
//                print(value)
//            }
            .disposed(by: disposeBag)
    }
    

}
