//
//  CoreDataServiceTests.swift
//  EffectiveMobileTestTaskTests
//
//  Created by Ruslan Kozlov on 17.11.2024.
//

import XCTest
@testable import EffectiveMobileTestTask


final class CoreDataServiceTests: XCTestCase {

    var mockCoreDataService: MockCoreDataService!
    var taskInteractor: TaskInteractor!

    override func setUpWithError() throws {
        mockCoreDataService = MockCoreDataService()
        taskInteractor = TaskInteractor(coreDataService: mockCoreDataService)
    }

    override func tearDownWithError() throws {
        mockCoreDataService = nil
        taskInteractor = nil
    }

    func testSaveTasks_Success() {
        let tasks = [
            Task(id: 1, uuid: UUID(), title: "Task 1", descriptionText: "Description 1", date: "2024-11-17", completed: false)
        ]

        let expectation = XCTestExpectation(description: "Save tasks successfully")

        mockCoreDataService.saveTasks(tasks) { result in
            switch result {
            case .success:
                XCTAssertEqual(self.mockCoreDataService.tasksToReturn.count, 1)
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success, but got failure.")
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testSaveTasks_Failure() {
        let tasks = [
            Task(id: 1, uuid: UUID(), title: "Task 1", descriptionText: "Description 1", date: "2024-11-17", completed: false)
        ]

        mockCoreDataService.errorToReturn = CoreDataError.emptyCoreData

        let expectation = XCTestExpectation(description: "Handle save tasks failure")

        mockCoreDataService.saveTasks(tasks) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success.")
            case .failure(let error):
                XCTAssertEqual(error as? CoreDataError, CoreDataError.emptyCoreData)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testFetchTasks_Success() {
        let task = Task(id: 1, uuid: UUID(), title: "Task 1", descriptionText: "Description 1", date: "2024-11-17", completed: false)
        mockCoreDataService.tasksToReturn = [task]

        let expectation = XCTestExpectation(description: "Fetch tasks successfully")

        mockCoreDataService.fetchTasks { result in
            switch result {
            case .success(let tasks):
                XCTAssertEqual(tasks.count, 1)
                XCTAssertEqual(tasks.first?.title, "Task 1")
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success, but got failure.")
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testFetchTasks_Failure() {
        mockCoreDataService.errorToReturn = CoreDataError.emptyCoreData

        let expectation = XCTestExpectation(description: "Handle fetch tasks failure")

        mockCoreDataService.fetchTasks { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success.")
            case .failure(let error):
                XCTAssertEqual(error as? CoreDataError, CoreDataError.emptyCoreData)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testAddTask_Success() {
        let task = Task(id: 1, uuid: UUID(), title: "Task 1", descriptionText: "Description 1", date: "2024-11-17", completed: false)

        let expectation = XCTestExpectation(description: "Add task successfully")

        mockCoreDataService.addTask(task) { result in
            switch result {
            case .success:
                XCTAssertEqual(self.mockCoreDataService.tasksToReturn.count, 1)
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success, but got failure.")
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testDeleteTask_Success() {
        let task = Task(id: 1, uuid: UUID(), title: "Task 1", descriptionText: "Description 1", date: "2024-11-17", completed: false)
        mockCoreDataService.tasksToReturn = [task]

        let expectation = XCTestExpectation(description: "Delete task successfully")

        mockCoreDataService.deleteTask(task) { result in
            switch result {
            case .success:
                XCTAssertEqual(self.mockCoreDataService.tasksToReturn.count, 0)
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success, but got failure.")
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }

    
    func testUpdateTask_Success() {
        let task = Task(id: 1, uuid: UUID(), title: "Task 1", descriptionText: "Description 1", date: "2024-11-17", completed: false)
        mockCoreDataService.tasksToReturn = [task]

        let updatedTask = Task(id: 1, uuid: task.uuid, title: "Updated Task", descriptionText: "Updated Description", date: "2024-11-17", completed: true)

        let expectation = XCTestExpectation(description: "Update task successfully")

        mockCoreDataService.updateTask(updatedTask, uuid: task.uuid) { result in
            switch result {
            case .success:
                XCTAssertEqual(self.mockCoreDataService.tasksToReturn.first?.title, "Updated Task")
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success, but got failure.")
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testUpdateTask_Failure() {
        let task = Task(id: 1, uuid: UUID(), title: "Task 1", descriptionText: "Description 1", date: "2024-11-17", completed: false)

        mockCoreDataService.errorToReturn = CoreDataError.taskNotFound

        let expectation = XCTestExpectation(description: "Handle update task failure")

        mockCoreDataService.updateTask(task, uuid: task.uuid) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success.")
            case .failure(let error):
                XCTAssertEqual(error as? CoreDataError, CoreDataError.taskNotFound)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }
}
