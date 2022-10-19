//
//  SimpleCollectionViewController.swift
//  SeSAC2Week1617
//
//  Created by 강민혜 on 10/18/22.
//

import UIKit

// Hashable 추가
// 누구를 고유한 형태로 쓸건가 기준이 필요하게 됨!
struct User: Hashable {
    let id = UUID().uuidString // Hashable "abc"
    let name: String // Hashable "123"
    let age: Int // Hashable 3
}

class SimpleCollectionViewController: UICollectionViewController {
    
//    var list = ["닭곰탕", "삼계탕", "들기름김", "삼분카레", "콘소메 치킨"]
    
    // cellRegistration 선언
    var list = [
        User(name: "뽀로로", age: 3),
        User(name: "뽀로로", age: 3),
        User(name: "해리포터", age: 33),
        User(name: "도라에몽", age: 100)
    ]

    // https://developer.apple.com/documentation/uikit/uicollectionview/cellregistration
    // cellForItemAt 전에 생성되어야 한다. => register 코드와 유사한 역할
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, User>!
    
    var dataSource: UICollectionViewDiffableDataSource<Int, User>!
    
//    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, User>!
//    var hello: (() -> Void)!
//
//    func welcome() {
//        print("hello")
//    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        print(hello)
//
//        hello = welcome // welcome vs welcome(). 함수 타입을 담았을 뿐, 실행을 한 게 아님
//
//        print(hello)
//
//        hello() // hello 출력됨
        
        collectionView.collectionViewLayout = createLayout()
        
        // 장점 2가지 1. Identifier 2. struct
        
        
        // cellRegistration 등록
        // cellRegistration는 구조체. 클로저 구문이 초기화 구문에 들어가있다.
        // 아래 cellRegistration 등록코드는 클로저가 아니라 handler를 작성한 것임.
        cellRegistration = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell() // cell.defaultContentConfiguration()
            
            content.text = itemIdentifier.name
            content.textProperties.color = .red
            
            content.secondaryText = "\(itemIdentifier.age)살" // text가 길어지면 secondaryText가 밑으로 내려간다
            content.prefersSideBySideTextAndSecondaryText = false
            content.textToSecondaryTextVerticalPadding = 20
            
//            content.image = indexPath.item < 3 ? UIImage(systemName: "person.fill") :  UIImage(systemName: "star")
            content.image = itemIdentifier.age < 8 ? UIImage(systemName: "person.fill") :  UIImage(systemName: "star")
            
            content.imageProperties.tintColor = .cyan
            
            print("setup")
            cell.contentConfiguration = content
            
            //(1019 새롭게 추가한 부분들)
            var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
            backgroundConfig.backgroundColor = .lightGray
            backgroundConfig.cornerRadius = 10
            backgroundConfig.strokeWidth = 2
            backgroundConfig.strokeColor = .systemPink
            cell.backgroundConfiguration = backgroundConfig
        
        } // 이 한 덩이가 cell 하나
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, User>()
        snapshot.appendSections([0])
        snapshot.appendItems(list)
        dataSource.apply(snapshot)
    }
    
    
    

    
}


extension SimpleCollectionViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        // UICollectionViewCompositionalLayout : 테이블뷰 모양처럼 만들기
        // 14+ 컬렉션뷰를 테이블뷰 스타일처럼 사용 가능 (List Configuration)
        // 컬렉션뷰 스타일 (컬렉션 뷰 셀 X)
        // appearance 종류는 신규추가된 2개 빼고는 테이블뷰랑 동일함.
//        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false // 구분선 없애기
        configuration.backgroundColor = .brown
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    
    // 위에서 compositionalLayout타입에게 어차피 할당해줘야 하니까 타입을 미리 통일시켜주자
}

