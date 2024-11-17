//
//  NetworkServiceTests.swift
//  EffectiveMobileTestTaskTests
//
//  Created by Ruslan Kozlov on 17.11.2024.
//

import XCTest
@testable import EffectiveMobileTestTask

final class NetworkServiceTests: XCTestCase {

    var networkService: NetworkService!
    var mockSession: MockURLSession!

    override func setUpWithError() throws {
        mockSession = MockURLSession()
        networkService = NetworkService(session: mockSession)
    }

    override func tearDownWithError() throws {
        networkService = nil
        mockSession = nil
        super.tearDown()
    }

    func testFetchData_Success() {
        let mockData = """
            {
                "todos": [
                    {
                        "id": 1,
                        "todo": "Do something nice for someone you care about",
                        "completed": false,
                        "userId": 152
                    },
                    {
                        "id": 2,
                        "todo": "Memorize a poem",
                        "completed": true,
                        "userId": 13
                    }
                ]
            }
            """.data(using: .utf8)!

        mockSession.mockData = mockData
        mockSession.mockResponse = HTTPURLResponse(url: URL(string: "https://dummyjson.com/todos")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockSession.mockError = nil

        let expectation = XCTestExpectation(description: "получение данных из сети")

        networkService.fetchData { result in
            switch result {
            case .success(let tasks):
                XCTAssertEqual(tasks.count, 2)
                XCTAssertEqual(tasks[0].title, "Do something nice for someone you care about")
                XCTAssertEqual(tasks[0].completed, false)
                XCTAssertEqual(tasks[1].title, "Memorize a poem")
                XCTAssertEqual(tasks[1].completed, true)
                expectation.fulfill()

            case .failure(let error):
                XCTFail("ошибка: \(error)")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func testFetchData_Failure() {
        mockSession.mockData = nil
        mockSession.mockResponse = nil
        mockSession.mockError = NSError(domain: "NetworkError", code: -1, userInfo: nil)

        let expectation = XCTestExpectation(description: "обработать ошибку при получении данных из сети")

        networkService.fetchData { result in
            switch result {
            case .success:
                XCTFail("ожидалась ошибка но получен успех")

            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "The operation couldn’t be completed. (NetworkError error -1.)")
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
