//
//  Movies.swift
//  DiagnalTest
//
//  Created by Pratyush Pratik Sinha on 23/06/23.
//

/**
 MARK: Importing modules
 */
import Foundation

/**
 MARK: ResponseModelMovieList
 - Defination of struct ResponseModelMovieList.
 */
struct ResponseModelMovieList: Decodable {
    let page: Page
}

/**
 MARK: Page
 - Defination of struct Page.
 */
extension ResponseModelMovieList {
    struct Page: Decodable {
        let title, totalContentItems, pageNum, pageSize: String
        let contentItems: ContentItems
        
        enum CodingKeys: String, CodingKey {
            case title
            case totalContentItems = "total-content-items"
            case pageNum = "page-num"
            case pageSize = "page-size"
            case contentItems = "content-items"
        }
    }
}

/**
 MARK: ContentItems
 - Defination of struct ContentItems.
 */
extension ResponseModelMovieList.Page {
    struct ContentItems: Decodable {
        let content: [Content]
    }
}

/**
 MARK: Content
 - Defination of struct Content.
 */
extension ResponseModelMovieList.Page.ContentItems {
    struct Content: Decodable, Hashable {
        let id = UUID()
        let name: String
        let posterImage: String
        
        enum CodingKeys: String, CodingKey {
            case name
            case posterImage = "poster-image"
        }
    }
}
