//
//  NetworkModelTests.swift
//  FundamentosIOSTests
//
//  Created by Hernán Rodríguez on 22/9/24.
//

import XCTest
@testable import FundamentosIOS

final class NetworkModelTests: XCTestCase {
    
    // MARK: - Properties
    private var sut: NetworkModel!
    private var mock: APIClientProtocolMock<String>!
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        mock = APIClientProtocolMock()
        sut = NetworkModel(client: mock)
    }
    
    // MARK: - Login Tests
    func test_login_success() {
        let someResult = Result<String, FundamentosIOS.APIError>.success("")
        mock.receivedResult = someResult
        var receivedResult: Result<String, FundamentosIOS.APIError>?
        
        sut.login(email: "hernanrg85@gmail.com", password: "123456") { result in
            receivedResult = result
        }
        
        XCTAssertEqual(someResult, receivedResult)
        XCTAssert(mock.didCallRequest)
    }
    
    func test_login_failure() {
        let someResult = Result<String, FundamentosIOS.APIError>.failure(FundamentosIOS.APIError.unknown)
        mock.receivedResult = someResult
        var receivedResult: Result<String, FundamentosIOS.APIError>?
        
        sut.login(email: "hernanrg85@gmail.com", password: "123456") { result in
            receivedResult = result
        }
        
        XCTAssertEqual(someResult, receivedResult)
        XCTAssert(mock.didCallRequest)
    }

    // MARK: - Fetch Heroes Tests
    func test_fetchHeroes_success() {
        let someResult = Result<[Hero], FundamentosIOS.APIError>.success([])
        mock.receivedResult = someResult
        var receivedResult: Result<[Hero], FundamentosIOS.APIError>?
        
        sut.fetchHeroes { result in
            receivedResult = result
        }
        
        XCTAssertEqual(someResult, receivedResult)
        XCTAssert(mock.didCallRequest)
    }

    func test_fetchHeroes_failure() {
        let someResult = Result<[Hero], FundamentosIOS.APIError>.failure(FundamentosIOS.APIError.unknown)
        mock.receivedResult = someResult
        var receivedResult: Result<[Hero], FundamentosIOS.APIError>?
        
        sut.fetchHeroes { result in
            receivedResult = result
        }
        
        XCTAssertEqual(someResult, receivedResult)
        XCTAssert(mock.didCallRequest)
    }
    
    // MARK: - Fetch Transformations Tests
    func test_fetchTransformations_success() {
        let someResult = Result<[Transformation], FundamentosIOS.APIError>.success([])
        mock.receivedResult = someResult
        var receivedResult: Result<[Transformation], FundamentosIOS.APIError>?
        
        sut.fetchTransformations(heroId: "someHeroId") { result in
            receivedResult = result
        }
        
        XCTAssertEqual(someResult, receivedResult)
        XCTAssert(mock.didCallRequest)
    }

    func test_fetchTransformations_failure() {
        let someResult = Result<[Transformation], FundamentosIOS.APIError>.failure(FundamentosIOS.APIError.unknown)
        mock.receivedResult = someResult
        var receivedResult: Result<[Transformation], FundamentosIOS.APIError>?
        
        sut.fetchTransformations(heroId: "someHeroId") { result in
            receivedResult = result
        }
        
        XCTAssertEqual(someResult, receivedResult)
        XCTAssert(mock.didCallRequest)
    }
}
