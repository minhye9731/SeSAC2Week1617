//
//  ValidationViewController.swift
//  SeSAC2Week1617
//
//  Created by 강민혜 on 10/27/22.
//

import UIKit

import RxSwift // 항상 observable, observer 객체로 관계를 설정함
import RxCocoa

class ValidationViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var stepButton: UIButton!
    
    let viewModel = ValidationViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        observableVSSubject()
    }
    

    func bind() {
        
        // MARK: - After
        let input = ValidationViewModel.Input(text: nameTextField.rx.text, tap: stepButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.validStatus
            .bind(to: stepButton.rx.isEnabled, validationLabel.rx.isHidden) // subscribe해줘도 되지만 bind로 해줌. (UI 특성을 살리고, error나 complete결과를 만날 필요가 없을때는 bind를 씀)
            .disposed(by: disposeBag)
        
        output.validText
            .drive(validationLabel.rx.text) // 여기서는 에러가 안나지만(1)
            .disposed(by: disposeBag)
        
        output.validStatus
            .withUnretained(self)
            .bind { (vc, value) in
                let color: UIColor = value ? .systemPink : .lightGray
                vc.stepButton.backgroundColor = color
            }
            .disposed(by: disposeBag)

        output.tap // VC -> VM (Input)
            .bind { _ in
                print("show alert")
            }
            .disposed(by: disposeBag)
        

        // MARK: - Before
        viewModel.validText // VM -> VC (Output)
            .asDriver() // drive를 쓰려면 항상 trait으로 쓰겠다는 명시가 필요해서 asDriver를 같이 써줘야 함
        // 여기 위에까지는 에러가 날 수도 있으니(통신같은거 할 경우 등), 대처를 하기 위해서 asDriver를 써준다 (2)
            .drive(validationLabel.rx.text) // 여기서는 에러가 안나지만(1)
            .disposed(by: disposeBag)
        
        // 반복되는 부분을 validation로 묶음
        // 단, 코드만을 묶어서 줄여줄 뿐 실행까지는 줄여줄 수 없음 => 그래서 옵져버블이랑 옵저버는 1:1
        // 그래서 이럴 떄는 위한 share()가 있음
        
        let validation = nameTextField.rx.text // String? // VC -> VM (Input)
            .orEmpty // 옵셔널 해제해줌, String
            .map { $0.count >= 8 } // Bool
            .share() // share 대신에 driver, asdriver 로 써볼 수도 있음

        
        validation
            .bind(to: stepButton.rx.isEnabled, validationLabel.rx.isHidden) // subscribe해줘도 되지만 bind로 해줌. (UI 특성을 살리고, error나 complete결과를 만날 필요가 없을때는 bind를 씀)
            .disposed(by: disposeBag)

        // 만약 조건충족 여부에 따라 버튼의 색상을 바꿔주려면?
        // bind가 아니라 bind(onNext)
        validation
            .withUnretained(self)
            .bind { (vc, value) in
                let color: UIColor = value ? .systemPink : .lightGray
                vc.stepButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
        
        
        // Stream, Sequence 이 두개는 거의 동의어라고 생각해주시오~
        stepButton.rx.tap // VC -> VM (Input)
            .bind { _ in
                print("show alert")
            }
            .disposed(by: disposeBag)
        
        
//            .subscribe { _ in
//                print("next")
//            } onError: { error in
//                print("error")
//            } onCompleted: {
//                print("complete")
//            } onDisposed: {
//                print("dispose")
//            }
//            .disposed(by: disposeBag)
        // 만약 실수로 DisposeBag() 인스턴스 그대로 반환할 경우, 바로 dispose됨. dispose() 메서드를 바로 해주는 것과 동일
        // 왜냐 리소스가 정리되어버려서 액션에 대한 연결이 끊어져버린다고 보면 됨. (수동으로 리소스 정리)
        // viewdidload 시점에 새로운 디스포즈 백으로 갈아끼워진 상태.
        
        // error나 complete가 일어날때(옵저버블 생명주기가 끝날때) dispose 호출됨
        
    }
    
    func observableVSSubject() {
        
        let testA = stepButton.rx.tap
            .map { "안녕하세요" }
            .asDriver(onErrorJustReturn: "") // driver로 하는 이유는 ui에 특화된 애로 구체화하고 싶어서.
//            .share() // 리소스 낭비 방지용으로 stream 공유를 위해 share() 추가함

        testA
            .drive(validationLabel.rx.text)
//            .bind(to: validationLabel.rx.text)
            .disposed(by: disposeBag)

        testA
            .drive(nameTextField.rx.text)
//            .bind(to: nameTextField.rx.text)
            .disposed(by: disposeBag)

        testA
            .drive(stepButton.rx.title())
//            .bind(to: stepButton.rx.title())
            .disposed(by: disposeBag)
        
        
//        let sampleInt = Observable<Int>.create { observer in
//            observer.onNext(Int.random(in: 1...100))
//            return Disposables.create() // Disposables 정의 확인해보면 그냥 비어있다.
//        }
//
//        sampleInt.subscribe { value in
//            print("sampleInt: \(value)")
//        }
//        .disposed(by: disposeBag)
//
//        sampleInt.subscribe { value in
//            print("sampleInt: \(value)")
//        }
//        .disposed(by: disposeBag)
//
//        sampleInt.subscribe { value in
//            print("sampleInt: \(value)")
//        }
//        .disposed(by: disposeBag)
        
        
        
//        let subjectInt = BehaviorSubject(value: 0)
//        subjectInt.onNext(Int.random(in: 1...100))
//
//        subjectInt.subscribe { value in
//            print("subjectInt: \(value)")
//        }
//        .disposed(by: disposeBag)
//
//        subjectInt.subscribe { value in
//            print("subjectInt: \(value)")
//        }
//        .disposed(by: disposeBag)
//
//        subjectInt.subscribe { value in
//            print("subjectInt: \(value)")
//        }
//        .disposed(by: disposeBag)
        
        
    }
    

}
