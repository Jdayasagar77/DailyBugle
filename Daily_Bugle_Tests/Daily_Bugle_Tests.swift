//
//  Daily_Bugle_Tests.swift
//  Daily_Bugle_Tests
//
//  Created by J Dayasagar on 13/10/23.
//

import XCTest
@testable import Daily_Bugle

final class Daily_Bugle_Tests: XCTestCase {

    
    private func myFilter<T>(_ array: [T], _ isIncluded: (T) -> Bool) -> [T] {
        
        var result: [T] = []
        
        for element in array {
            if isIncluded(element) {
                result.append(element)
            }
        }
        
        return result
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
        let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        
        // Define a closure that checks if a number is even
        let isEven: (Int) -> Bool = { number in
            return number % 2 == 0
        }
        
        // Use the custom higher-order function to filter even numbers
        let evenNumbers = myFilter(numbers, isEven)
        let answer = [2,4,6,8,10]
        XCTAssertEqual(evenNumbers, answer)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
