//
//  NetworkTest.swift
//  EffectiveMobileTestTask
//
//  Created by Ruslan Kozlov on 17.11.2024.
//

import Foundation

class MockURLSession: URLSession, @unchecked Sendable {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?

    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        if let error = mockError {
            completionHandler(nil, nil, error)
        } else {
            completionHandler(mockData, mockResponse, nil)
        }
        return MockURLSessionDataTask()
    }
}

class MockURLSessionDataTask: URLSessionDataTask, @unchecked Sendable {
    override func resume() {
        print("мок таска была вызвана")
    }
}
