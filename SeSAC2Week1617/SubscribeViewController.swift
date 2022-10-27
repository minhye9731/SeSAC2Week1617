//
//  SubscribeViewController.swift
//  SeSAC2Week1617
//
//  Created by 강민혜 on 10/26/22.
//

import UIKit
import RxSwift
import RxCocoa

class SubscribeViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1~5 번까지만 명화하게 알아도 충분함. 근데 drive 키워드도 알면 좋다.
        
        // 탭 > 레이블 : "안녕 반가워"
        // 1.
        button.rx.tap
            .subscribe { [weak self] _ in
                self?.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
        
        // 2.
        button.rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                
                vc.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)

        // 3. 네트워크 통신이나 파일 다운로드 등 백드라운드 작업?
        button.rx.tap
            .observe(on: MainScheduler.instance) // 다른 쓰레드로 동작하게 변경
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
        
        // 4. bind : subscribe, mainSchedular, error X
        button.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
        
        // 5. operator로 데이터의 stream 조작
        button
            .rx
            .tap
            .map { " 안녕 반가워 " }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        // 6. driver traits: bind + stream 공유(리소스 방지 낭비 가능, share() )
        button.rx.tap
            .map { " 안녕 반가워 " }
            .asDriver(onErrorJustReturn: "")
            .drive(label.rx.text)
            .disposed(by: disposeBag)
        
        
    }
    
    

    

}
