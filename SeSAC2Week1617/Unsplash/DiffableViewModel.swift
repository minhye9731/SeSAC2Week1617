//
//  DiffableViewModel.swift
//  SeSAC2Week1617
//
//  Created by 강민혜 on 10/20/22.
//

import Foundation

class DiffableViewModel {
    
    var photoList: CObservable<SearchPhoto> = CObservable(SearchPhoto(total: 0, totalPages: 0, results: []))
    
    func requestSearchPhoto(query: String) {
        APIService.searchPhoto(query: query) { photo, statusCode, error in
            guard let photo = photo else { return }
            self.photoList.value = photo
        }
        
    }
    
}