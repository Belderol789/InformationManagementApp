//
//  DatabaseUnitTests.swift
//  InformationAppTests
//
//  Created by Kem on 11/10/22.
//

import XCTest

final class DatabaseUnitTests: XCTestCase {

    var dataService: DatabaseService?
    
    override func setUpWithError() throws {
        self.dataService = DatabaseService()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        dataService = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_convert_json_to_models() {
        let expectation = XCTestExpectation(description: "Expect for json to be encoded")
        let jsonString = """
            [
                {
                    "name": "Company A",
                    "id": "123456",
                    "employees": [
                        {
                        "id": "123456",
                        "name": "Employee A",
                        "isEmployed": true
                        }
                    ]
                }
            ]
        """
        self.dataService?.convertJSONStringToModel(jsonString: jsonString, completion: { (result: Result<[Company], Error>) in
            switch result {
            case .success(let companies):
                let company = companies.first
                XCTAssertNotNil(company)
                XCTAssertEqual(company?.name, "Company A")
                XCTAssertNotEqual(company?.employees.count, 0)
                
                let employee = companies.first?.employees.first
                XCTAssertNotNil(employee)
                XCTAssertEqual(employee?.name, "Employee A")
                
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to encode json \(error.localizedDescription)")
            }
        })
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func test_convert_model_to_jsonString() {
        let jsonString = """
                        [
                            {
                                "name": "Company B",
                                "id": "1234567",
                                "employees": [
                                    {
                                    "id": "123456",
                                    "name": "Employee A",
                                    "isEmployed": true
                                    },
                                    {
                                    "id": "1234567",
                                    "name": "Employee B",
                                    "isEmployed": false
                                    }
                                ]
                            }
                        ]
        """
        let employees: [Employee] = [Employee(id: "123456", name: "Employee A", isEmployed: true), Employee(id: "1234567", name: "Employee B", isEmployed: false)]
        let company = Company(id: "1234567", name: "Company B", employees: employees)
        self.dataService?.convertModelToJSON(model: company, completed: { json in
            XCTAssertNotNil(json)
            XCTAssertEqual(json, jsonString)
        })
    }
    
}
