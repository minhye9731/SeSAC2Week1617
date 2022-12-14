//
//  NewsViewController.swift
//  SeSAC2Week1617
//
//  Created by 강민혜 on 10/20/22.
//

import UIKit
import RxSwift
import RxCocoa

class NewsViewController: UIViewController {
    
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var loadButton: UIButton!
    
    var viewModel = NewsViewModel()
    let disposeBag = DisposeBag()
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, News.NewsItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierachy()
        configureDataSource()
        bindData()
    }
    
    // MVVM 형태로 썼던 코드가 다 여기있으니까, 여기 코드 수정할 것임.
    func bindData() {
        viewModel.sample
            .withUnretained(self)
            .bind { (vc, item) in
                var snapshot = NSDiffableDataSourceSnapshot<Int, News.NewsItem>()
                snapshot.appendSections([0])
                snapshot.appendItems(item)
                vc.dataSource.apply(snapshot, animatingDifferences: false)
            }
            .disposed(by: disposeBag)
        
        loadButton
            .rx
            .tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.viewModel.loadSample()
            }
            .disposed(by: disposeBag)
        
        resetButton
            .rx
            .tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.viewModel.resetSample()
            }
            .disposed(by: disposeBag)
        
    }
    
//    func configureView() {
//        numberTextField.addTarget(self, action: #selector(numberTextFieldChanged), for: .editingChanged)
//
//        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
//
//        loadButton.addTarget(self, action: #selector(loadButtonTapped), for: .touchUpInside)
//    }
//
//    @objc func resetButtonTapped() {
//        viewModel.resetSample()
//    }
//
//    @objc func loadButtonTapped() {
//        viewModel.loadSample()
//    }
//
//    @objc func numberTextFieldChanged() {
//        guard let text = numberTextField.text else { return }
//        viewModel.changePageNumberFormat(text: text)
//    }

}


extension NewsViewController {
    
    
    func configureHierachy() {
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = .lightGray
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, News.NewsItem> { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier.title
            content.secondaryText = itemIdentifier.body
            
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
//        var snapshot = NSDiffableDataSourceSnapshot<Int, News.NewsItem>()
//        snapshot.appendSections([0])
//        snapshot.appendItems(News.items)
//        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func createLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    
    
}




