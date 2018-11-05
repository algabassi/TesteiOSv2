//
//  LoginViewController.swift
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
import SwiftKeychainWrapper

protocol LoginDisplayLogic: class
{
  func displayLogin(viewModel: Login.LoginFormFields.ViewModel)
}

class LoginViewController: UIViewController, LoginDisplayLogic, UIGestureRecognizerDelegate
{
  var interactor: LoginBusinessLogic?
  var router: (NSObjectProtocol & LoginRoutingLogic & LoginDataPassing)?
  
    var tapGesture = UITapGestureRecognizer()

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = LoginInteractor()
    let presenter = LoginPresenter()
    let router = LoginRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
}
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
  }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.configureFields()
    }
  
  // MARK: Do Login
    func checkUserRules() -> Bool {
        var retStatus = false
        if let user = UserLoginTextField.text, !user.isEmpty {
            if !user.isNumeric {
                if !isValidEmail(user)
                {
                    messageLabel.text = "Você digitou um E-Mail inválido no campo User"
                } else {
                    retStatus = true
                }
            } else {
                if user.count != 11 {
                    messageLabel.text = "Você digitou um CPF inválido no campo User"
                } else {
                    retStatus = true
                }
            }
        } else {
            messageLabel.text = "Favor digitar o User"
        }
        return retStatus
    }
    
    func checkPasswordRules() -> Bool {
        var retStatus = false
        if let passwd = PasswordTestField.text, !passwd.isEmpty {
            let capitalLetterRegEx  = ".*[A-Z]+.*"
            let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
            guard texttest.evaluate(with: passwd) else
            {
                messageLabel.text = "Sua Senha deve possuir pelo menos uma Letra Maiúscula"
                return false
            }
            let specialCharacterRegEx  = ".*[!&^%$#@()/_*+-]+.*"
            let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
            guard texttest2.evaluate(with: passwd) else
            {
                messageLabel.text = "Sua Senha deve possuir pelo menos um caracter Especial"
                return false
            }
            
            if (passwd.letterCount >= 1) || passwd.digitCount >= 1 {
                retStatus = true
            } else {
                messageLabel.text = "Sua Senha deve possuir pelo menos um caracter Alphanumérico"
            }
        } else {
            messageLabel.text = "Favor digitar sua Senha"
        }
        return retStatus
    }
    @IBAction func doLogin(_ sender: Any) {
        
        let user = UserLoginTextField.text ?? ""
        let password = PasswordTestField.text ?? ""
        let request = Login.LoginFormFields.Request(user: user, password: password)
        messageLabel.text = ""
        
        if checkUserRules() && checkPasswordRules(){
            let saveSuccessful: Bool = KeychainWrapper.standard.set(user, forKey: "userStringKey")
            print("Save was successful: \(saveSuccessful)")
            messageLabel.text = "Efetuando o Login"
            interactor?.doLogin(request: request)
        }
    }
    
    @IBOutlet weak var UserLoginTextField: UITextField!
    @IBOutlet weak var PasswordTestField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    
    func configureFields() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickView(_:)))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)

        UserLoginTextField.borderStyle = UITextBorderStyle.roundedRect
        PasswordTestField.borderStyle = UITextBorderStyle.roundedRect
        PasswordTestField.clearsOnBeginEditing = false

        messageLabel.text = ""
        
        if let retrievedUser = KeychainWrapper.standard.string(forKey: "userStringKey"), !retrievedUser.isEmpty {
            UserLoginTextField.text = retrievedUser
        }
        
        PasswordTestField.text = ""
    }
    
    func displayLogin(viewModel: Login.LoginFormFields.ViewModel)
    {
        if viewModel.success {
            showGreeting(greeting: viewModel.greeting)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.router?.routeToShowUserData(segue: nil)
            }
        } else {
            showErrors(greeting: viewModel.greeting)
        }
    }
    
    func showGreeting(greeting: String)
    {
        messageLabel.text = greeting
    }
    
    func showErrors(greeting: String)
    {
        messageLabel.text = greeting
    }
    
    func isValidEmail(_ emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailStr)
    }
    
    @objc func clickView(_ sender: UIView) {
        view.endEditing(true)
    }    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        print("textFieldShouldReturn")
        view.removeGestureRecognizer(tapGesture)
        view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
        view.addGestureRecognizer(tapGesture)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
        self.view.endEditing(true)
        view.addGestureRecognizer(tapGesture)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString stringDigitada: String) -> Bool {
        print("shouldChangeCharactersIn")
        return true
    }
}


