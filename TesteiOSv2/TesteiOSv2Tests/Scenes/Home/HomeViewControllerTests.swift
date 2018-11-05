//
//  HomeViewControllerTests.swift
//  TesteiOSv2
//
//  Created by Alexandre Gabassi on 05/11/18.
//  Copyright (c) 2018 Alexandre Gabassi. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import TesteiOSv2
import XCTest

class HomeViewControllerTests: XCTestCase
{
  // MARK: Subject under test
  
  var sut: HomeViewController!
  var window: UIWindow!
  
  // MARK: Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    window = UIWindow()
    setupHomeViewController()
  }
  
  override func tearDown()
  {
    window = nil
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupHomeViewController()
  {
    let bundle = Bundle.main
    let storyboard = UIStoryboard(name: "Main", bundle: bundle)
    sut = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
  }
  
  func loadView()
  {
    window.addSubview(sut.view)
    RunLoop.current.run(until: Date(timeIntervalSinceNow: 10))
  }
  
  // MARK: Test doubles
  
  class HomeBusinessLogicSpy: HomeBusinessLogic
  {
    var doUserInfoCalled = false
    
    func getFetchRegisters(request: Home.FetchRegisters.Request) {        
    }

    func fetchRegisters(request: Home.FetchRegisters.Request) {
    }
    
    func getUserInfo(request: Home.GetUserInfo.Request) {
        doUserInfoCalled = true
    }
  }
  
  // MARK: Tests
    
  func testDisplayUserInfo()
  {
    // Given
    sut.router?.dataStore?.userInfo = UserInfo.init(userId: "1", name: "Mr Tester", bankAccount: "2050", agency: "109876542", balance: 1000.0)
    
    // When
    loadView()
    sut.getUserInfo()
    
    // Then
    XCTAssertEqual(sut.userNameTextField.text, "Mr Tester", "displaySomething(viewModel:) should update the name text field")
    XCTAssertEqual(sut.accountTextField.text, "2050 / 10.987654-2", "displaySomething(viewModel:) should update the name text field")
    XCTAssertEqual(sut.balanceTextField.text, "R$1.000,00", "displaySomething(viewModel:) should update the name text field")
  }
}