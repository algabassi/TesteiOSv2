//
//  LoginInteractorTests.swift
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

class LoginInteractorTests: XCTestCase
{
  // MARK: Subject under test
  
  var sut: LoginInteractor!
  
  // MARK: Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    setupLoginInteractor()
  }
  
  override func tearDown()
  {
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupLoginInteractor()
  {
    sut = LoginInteractor()
  }
  
  // MARK: Test doubles
  
  class LoginPresentationLogicSpy: LoginPresentationLogic
  {
    var presentLoginCalled = false
    
    func presentLogin(response: Login.LoginFormFields.Response)
    {
        presentLoginCalled = true
    }
  }
  
  // MARK: Tests
  
  func testGetLogin()
  {
    // Given
    let spy = LoginPresentationLogicSpy()
    sut.presenter = spy
    let request = Login.LoginFormFields.Request(user: "user@test.com", password: "Test@1")
    
    // When
    sut.getLogin(request: request)
    
    // Then
    XCTAssertTrue(spy.presentLoginCalled, "doSomething(request:) should ask the presenter to format the result")
  }
}
