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
    
    //mutable storage slot for response
    //bindable is created to observe change in values
    lazy var arrMovieList = Bindable<[ResponseModelContent]>()
    
    //mutable storage slot testing error for storing custom errors
    var testingError: CustomErrors?

    //for testing value initialization
    func testMovieListModel(arrMovieList: [ResponseModelContent]) {
        self.arrMovieList.value = arrMovieList
    }
    
    //method to be called from controller
    //result enum is used for success and faliure
    final func fireAPIGETMovieList(for page: Int, onCompletion: (() -> ())? = nil) {
        getMovieList(for: page) { (result) in
            switch result {
            case .success(let movieList):
                print(movieList)
                DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                    self?.arrMovieList.value = movieList
                    onCompletion?()
                }
            case .failure(let error):
                self.testingError = error
                onCompletion?()
            }
        }
    }
    
    //method to provide data from json file
    private func getMovieList(for page: Int, onCompletion: @escaping (Result<[ResponseModelContent], CustomErrors>) -> Void) {
        let fileName = "CONTENTLISTINGPAGE-PAGE\(page)"
        if let model = loadJson(for: fileName, type: ResponseModelMovieList.self) {
            onCompletion(.success(model.page.contentItems.content))
        } else {
            onCompletion(.failure(.parsingError))
        }
    }
    
    //method to filter elements from array for searchbar
    func filterContentForSearchText(searchText: String, arr: [ResponseModelContent], onCompletion: @escaping ([ResponseModelContent]) -> ()) {
        if searchText != "" {
            let arrMovieList = arr.filter { element in
                return element.name.lowercased().contains(searchText.lowercased())
            }
            onCompletion(arrMovieList)
        } else {
            onCompletion(arr)
        }
    }
}
