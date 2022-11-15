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
    
    func test_saving_of_json_data() {
        let arrayOfCompanies = [Company(id: "123",
                                        name: "Company A",
                                        employees: [Employee(id: "123",
                                                             name: "Employee A",
                                                             isEmployed: true)]),
                                Company(id: "456",
                                        name: "Company B",
                                        employees: []),
                                Company(id: "789",
                                        name: "Company C",
                                        employees: [Employee(id: "456",
                                                             name: "Employee B",
                                                             isEmployed: true),
                                                    Employee(id: "789",
                                                             name: "Employee C",
                                                             isEmployed: false)])]
        self.dataService?.saveModelDetails(arrayOfCompanies, fileName: "Companies.json", completion: { success in
            XCTAssertTrue(success)
        })
    }
    
    func test_retrieve_json_data() {
        let arrayOfCompanies = [Company(id: "123",
                                        name: "Company A",
                                        employees: [Employee(id: "123",
                                                             name: "Employee A",
                                                             isEmployed: true)]),
                                Company(id: "456",
                                        name: "Company B",
                                        employees: []),
                                Company(id: "789",
                                        name: "Company C",
                                        employees: [Employee(id: "456",
                                                             name: "Employee B",
                                                             isEmployed: true),
                                                    Employee(id: "789",
                                                             name: "Employee C",
                                                             isEmployed: false)])]
        self.dataService?.saveModelDetails(arrayOfCompanies, fileName: "Companies.json", completion: { success in
            XCTAssertTrue(success)
        })
    }
    
    func test_convert_data_to_models() {
        let arrayOfCompanies = [Company(id: "123",
                                        name: "Company A",
                                        employees: [Employee(id: "123",
                                                             name: "Employee A",
                                                             isEmployed: true)]),
                                Company(id: "456",
                                        name: "Company B",
                                        employees: []),
                                Company(id: "789",
                                        name: "Company C",
                                        employees: [Employee(id: "456",
                                                             name: "Employee B",
                                                             isEmployed: true),
                                                    Employee(id: "789",
                                                             name: "Employee C",
                                                             isEmployed: false)])]
        self.dataService?.saveModelDetails(arrayOfCompanies, fileName: "Companies.json", completion: { success in
            XCTAssertTrue(success)
            self.dataService?.retrieveModelFromFile(fileName: "Companies.json", { (result: Result<[Company], Error>) in
                switch result {
                case .success(let companies):
                    XCTAssertNotEqual(companies.count, 0)
                    XCTAssertNotNil(companies.first)
                    XCTAssertEqual(companies.last?.name, "Company C")
                case .failure(let error):
                    XCTFail("Failed to encode json \(error.localizedDescription)")
                }
            })
        })
    }
    
}
