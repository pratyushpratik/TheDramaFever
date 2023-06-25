//
//  VMMovieListTestCase.swift
//  DiagnalTestTests
//
//  Created by Pratyush Pratik Sinha on 24/06/23.
//

import XCTest
@testable import DiagnalTest

final class VMMovieListTestCase: XCTestCase {
    
    func testfireAPIGetMovieListSuccess() {
        let viewModel = VMMovieList()
        viewModel.fireAPIGETMovieList(for: 1) {
            print("viewModel.arrMovieList.value", viewModel.arrMovieList.value ?? [])
            XCTAssertTrue(viewModel.arrMovieList.value?.isEmpty == false)
        }
    }
    
    func testfireAPIGetMovieListFaliure() {
        let viewModel = VMMovieList()
        viewModel.fireAPIGETMovieList(for: 4) { //since page 4 json is not available
            print("viewModel.testingError==>", viewModel.testingError?.description ?? "")
            XCTAssertTrue(viewModel.testingError != nil)
        }
    }
    
    func testVMMovieListWithDataModel() {
        let obj = [ResponseModelContent.init(name: "The Heirs", posterImage: "poster8")]
        let viewModelMovieList = VMMovieList()
        viewModelMovieList.testMovieListModel(arrMovieList: obj)
        XCTAssertEqual(obj[0], viewModelMovieList.arrMovieList.value?[0])
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
