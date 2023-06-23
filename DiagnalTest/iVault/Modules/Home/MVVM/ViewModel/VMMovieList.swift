//
//  VMMovieList.swift
//  DiagnalTest
//
//  Created by Pratyush Pratik Sinha on 22/06/23.
//

/**
 MARK: Importing modules
 */
import Foundation

/**
 MARK: VMMovieList
 - Defination of class VMMovieList.
 */
class VMMovieList {
    
    lazy var arrMovieList = Bindable<[ResponseModelContent]>()
    var testingError: CustomErrors?

    //for testing
    func testMovieListModel(arrMovieList: [ResponseModelContent]) {
        self.arrMovieList.value = arrMovieList
    }
    
    final func fireAPIGETMovieList(for page: Int) {
        getMovieList(for: page) { (result) in
            switch result {
            case .success(let movieList):
                print(movieList)
                DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                    self?.arrMovieList.value = movieList
                }
            case .failure(let error):
                self.testingError = error
            }
        }
    }
    
    private func getMovieList(for page: Int, onCompletion: @escaping (Result<[ResponseModelContent], CustomErrors>) -> Void) {
        let fileName = "CONTENTLISTINGPAGE-PAGE\(page)"
        if let model = loadJson(for: fileName, type: ResponseModelMovieList.self) {
            onCompletion(.success(model.page.contentItems.content))
        } else {
            onCompletion(.failure(.parsingError))
        }
    }
}
