//
//  DailyTests.swift
//  NABWeatherTests
//
//  Created by Omnimobile on 2/9/22.
//

import XCTest
import RxSwift
import RxBlocking
import RxCocoa
@testable import NABWeather

class DailyTests: XCTestCase {

    private var viewModel: DailyViewModel!
    private var input: DailyViewModel.Input!
    private var output: DailyViewModel.Output!
    private var disposeBag: DisposeBag!
    
    private let keywordTrigger = BehaviorRelay<String?>(value: nil)
        
    
    
    override func setUp() {
        super.setUp()
        viewModel = DailyViewModel()
        input = DailyViewModel.Input(searchParameters: keywordTrigger)
        output = viewModel.makeBinding(input: input)
        disposeBag = DisposeBag()
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNullKeyword() throws {
        keywordTrigger.accept(nil)
        let data = try? output.results.toBlocking(timeout: 1).first()
        XCTAssertEqual(0, data?.count)
    }

    func testEmptyKeyword() throws {
        keywordTrigger.accept("")
        let data = try? output.results.toBlocking(timeout: 1).first()
        XCTAssertEqual(0, data?.count)
    }
    
    func testValidKeyword() throws {
        keywordTrigger.accept("Melbourne")
        //let data1 = try? output.results.toBlocking(timeout: 5).first()
        
        keywordTrigger.accept("Melbourne")
        //let data2 = try? output.results.toBlocking(timeout: 5).first()
        let data3 = try? output.flagFromCache.toBlocking(timeout: 1).first()
        XCTAssertEqual(true, data3)
    }
    
    func testValidKeyword2() throws {
        keywordTrigger.accept("Hai phong")
        //let data1 = try? output.results.toBlocking(timeout: 5).first()
        
        keywordTrigger.accept("Quang binh")
        //let data2 = try? output.results.toBlocking(timeout: 5).first()
        let data3 = try? output.flagFromCache.toBlocking(timeout: 1).first()
        XCTAssertEqual(true, data3)
    }
    
    func testInvalidKeyword() throws {
        keywordTrigger.accept("M3lb0urne")
        let data = try? output.errors.toBlocking(timeout: 5).first()
        XCTAssertNotNil(data)
    }
}
