//
//  DiffableCollectionViewController.swift
//  SeSAC2Week1617
//
//  Created by 강민혜 on 10/19/22.
//

import UIKit

class DiffableCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel = DiffableViewModel()
    
    var list = ["아이폰", "아이패드", "에어팟", "맥북", "애플워치"]
    
    // 이거 삭제해도 됨, configureDataSource에서만 쓰니까
//    private var cellRegisteration: UICollectionView.CellRegistration<UICollectionViewListCell, String>!
    
    // Int:  , String:
    private var dataSource: UICollectionViewDiffableDataSource<Int, SearchResult>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        collectionView.collectionViewLayout = createLayout()
        configureDataSource()
        collectionView.delegate = self
        
        searchBar.delegate = self
        
        viewModel.photoList.bind { photo in
            var snapshot = NSDiffableDataSourceSnapshot<Int, SearchResult>()
            snapshot.appendSections([0])
            snapshot.appendItems(photo.results)
            self.dataSource.apply(snapshot)
        }
    }
    

}

extension DiffableCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let item = list[indexPath.item] 이거쓰면 인덱스 에러나니까
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return } // 스냅샷에 itemIdentifier 가져와서 쓰자
        
        let alert = UIAlertController(title: item, message: "클릭!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
}


extension DiffableCollectionViewController: UISearchBarDelegate {
 
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var snapshoit = dataSource.snapshot()
        snapshoit.appendItems([searchBar.text!])
        dataSource.apply(snapshoit, animatingDifferences: true)
        
        viewModel.requestSearchPhoto(query: searchBar)
    }

}


extension DiffableCollectionViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
    
    private func configureDataSource() {
        // 여기서만 cellRegisteration쓰니까, 여기서 정의를 해줘서 사용할 수 있음
        // 근데 이전의 < , > 타입명시도 위에서 삭제했으니까 타입을 추론할 근거가 없어서 에[러가 남.
        
        let cellRegisteration = UICollectionView.CellRegistration<UICollectionViewListCell, String>(handler: { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            content.text = "\(itemIdentifier.likes)"
            
            let url = URL(string: "adsfd")
            
            // 굳이 asnc하는 이유는 이 작업이 되는동안 앱이 얼지 안혿록 하기 위해
            // string > url > data > image
            DispatchQueue.global().async {
                let url = URL(string: itemIdentifier.urls.thumb)!
                let data = try? Data(contentsOf: url)
                
                DispatchQueue.main.async {
                    content.image = UIImage(data: data!)
                    cell.contentConfiguration = content // 여기에 넣어주어야 하는게 중요함.
                    // 왜햐면 content를 configuration에 할당이 끝나고 나서야 이미지가 로드되어서 타이밍이 맞도록 하기 위해 두개 코드 모두 dispatch main 에다가 적어주어야 함
                }
            }
            
            
            var background = UIBackgroundConfiguration.listPlainCell()
            background.strokeWidth = 2
            background.strokeColor = .brown
            cell.backgroundConfiguration = background
        })
        
        // collectionView.dataSource = self 더이상 안써도 됨.
        // numberOfItemInSection, cellForItemAt
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: itemIdentifier) // 여기서 타입을 알 수 없어서 에러가 남
            return cell
        })
        
        // Initial
//        var snapshot = NSDiffableDataSourceSnapshot<Int, SearchResult>()
//        snapshot.appendSections([0])
//        snapshot.appendItems(list)
//        dataSource.apply(snapshot)
        
        
        
    }
    
}








