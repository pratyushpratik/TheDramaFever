//
//  JsonLoader.swift
//  DiagnalTest
//
//  Created by Pratyush Pratik Sinha on 23/06/23.
//

import Foundation

func loadJson<T: Decodable>(for fileName: String, type: T.Type) -> T? {
    let decoder = JSONDecoder()
    guard
        let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
        let data = try? Data(contentsOf: url),
        let content = try? decoder.decode(T.self, from: data)
    else {
        return nil
    }
    return content
}
