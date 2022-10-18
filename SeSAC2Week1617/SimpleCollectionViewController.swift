//
//  SimpleCollectionViewController.swift
//  SeSAC2Week1617
//
//  Created by 강민혜 on 10/18/22.
//

import UIKit

struct User {
    let name: String
    let age: Int
}

class SimpleCollectionViewController: UICollectionViewController {
    
//    var list = ["닭곰탕", "삼계탕", "들기름김", "삼분카레", "콘소메 치킨"]
    
    // cellRegistration 선언
    var list = [
        User(name: "뽀로로", age: 3),
        User(name: "에디", age: 13),
        User(name: "해리포터", age: 33),
        User(name: "도라에몽", age: 100)
    ]

    // https://developer.apple.com/documentation/uikit/uicollectionview/cellregistration
    // cellForItemAt 전에 생성되어야 한다. => register 코드와 유사한 역할
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, User>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // UICollectionViewCompositionalLayout : 테이블뷰 모양처럼 만들기
        // 14+ 컬렉션뷰를 테이블뷰 스타일처럼 사용 가능 (List Configuration)
        // appearance 종류는 신규추가된 2개 빼고는 테이블뷰랑 동일함.
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.showsSeparators = false // 구분선 없애기
        configuration.backgroundColor = .brown
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        collectionView.collectionViewLayout = layout
        
        
        // cellRegistration 등록
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
            
            cell.contentConfiguration = content
            
        } // 이 한 덩이가 cell 하나
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    // cellRegistration 호출
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = list[indexPath.item]
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        // CellRegistration<Cell, Item> Cell, Item에 어떤 타입이 들어올지 모르므로 generic으로 표현되어 있음
        
        return cell
    }
    
    
    

    
}
