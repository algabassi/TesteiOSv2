//
//  HomePresenter.swift
//  TesteiOSv2
//
//  Created by Alexandre Gabassi on 30/10/18.
//  Copyright (c) 2018 Alexandre Gabassi. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol HomePresentationLogic
{
  func presentRegisters(response: Home.FetchRegisters.Response)
  func presentUserInfo(response: Home.GetUserInfo.Response)
}

class HomePresenter: HomePresentationLogic
{
  weak var viewController: HomeDisplayLogic?
    
    let currencyFormatter: NumberFormatter = {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "pt_BR")
        return currencyFormatter
    }()
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale(identifier: "pt_BR")

        return dateFormatter
    }()
    
    // MARK: - Fetch order
    
    func presentUserInfo(response: Home.GetUserInfo.Response)
    {
        let userInfo = response.userInfo
        let s = userInfo.agency!
        let formattedAgency = s[0..<2] + "." + s[2..<8] + "-" + s[8..<s.count]
        
        let account = userInfo.bankAccount! + " / "  + formattedAgency
        
        let balance = currencyFormatter.string(from: NSNumber(value: userInfo.balance!))!
        
        let displayedUserInfo = Home.GetUserInfo.ViewModel.DisplayedUserInfo(userId: userInfo.userId, name: userInfo.name, bankAccount: account, agency: userInfo.agency, balance: balance)
        
        let viewModel = Home.GetUserInfo.ViewModel(displayedUserInfo: displayedUserInfo)
        viewController?.displayUserInfo(viewModel: viewModel)
    }

  
  func presentRegisters(response: Home.FetchRegisters.Response)
  {
    let displayedRegisters = response.registers.map { convert(register: $0) }
    
    let viewModel = Home.FetchRegisters.ViewModel(displayedRegisters: displayedRegisters, success: response.success)
    
    viewController?.displayHomeData(viewModel: viewModel)
  }
    
    // MARK: Format entry to displayed entry
    
    private func convert(register: Register) -> Home.DisplayedRegister
    {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let dateInput = inputFormatter.date(from: register.date)
        
        let title = register.title
        let desc  = register.desc
        let date  = dateFormatter.string(from: dateInput!)
        let value = currencyFormatter.string(from: NSNumber(value: register.value))!
        
        return Home.DisplayedRegister(title: title, desc: desc, date: date, value: value)
    }
}
