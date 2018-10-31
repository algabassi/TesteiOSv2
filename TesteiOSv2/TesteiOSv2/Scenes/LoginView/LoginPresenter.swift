//
//  LoginPresenter.swift
//  TesteiOSv2
//
//  Created by Alexandre Gabassi on 29/10/18.
//  Copyright (c) 2018 Alexandre Gabassi. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol LoginPresentationLogic
{
  func presentLogin(response: Login.LoginFormFields.Response)
}

class LoginPresenter: LoginPresentationLogic
{
  weak var viewController: LoginDisplayLogic?
  
  // MARK: Do something
  
  func presentLogin(response: Login.LoginFormFields.Response)
  {
    let greeting = response.success ? "Olá \(response.info.name ?? "")" : "\(response.info.name ?? "")"
    let viewModel = Login.LoginFormFields.ViewModel(success: response.success, greeting: greeting)
    viewController?.displayLogin(viewModel: viewModel)
  }
}
