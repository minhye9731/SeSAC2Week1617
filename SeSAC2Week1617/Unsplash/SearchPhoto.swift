//
//  SearchPhoto.swift
//  SeSAC2Week1617
//
//  Created by 강민혜 on 10/20/22.
//

import Foundation

/*
 SearchPhoto
 */

struct SearchPhoto: Codable, Hashable {
     
    let total, totalPages: Int
    let results: [SearchResult]
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

// MARK: - Result
struct SearchResult: Codable, Hashable {
     
    let id: String
    let urls: Urls
    let likes: Int

    enum CodingKeys: String, CodingKey {
        case id
        case urls, likes
    }
}

struct Urls: Codable, Hashable {
    let raw, full, regular, small: String
    let thumb, smallS3: String

    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
        case smallS3 = "small_s3"
    }
}

