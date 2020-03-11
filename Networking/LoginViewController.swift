//
//  LoginViewController.swift
//  Networking
//
//  Created by Lucky on 11/03/2020.
//  Copyright © 2020 DmitriyYatsyuk. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

    let primaryColor = UIColor(red: 110/255, green: 200/255, blue: 200/255, alpha: 1)
    let secondaryColor = UIColor(red: 107/255, green: 148/255, blue: 230/255, alpha: 1)
    
    lazy var fbLoginButton: UIButton = {
       
        let loginButton = FBLoginButton()
        loginButton.frame = CGRect(x: 32, y: 450, width: view.frame.width - 64, height: 50)
        loginButton.delegate = self
        return loginButton
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
        if (AccessToken.isCurrentAccessTokenActive) {
          print("The user is logged in")
        }

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    
    private func setupViews() {
        
        view.addSubview(fbLoginButton)
    }
}

extension LoginViewController: LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        if error != nil {
            print(error!)
            return
        } else {
            print("Successfully logged in the facebook...")
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
        print("Did log out of facebook")
    }
    
    
}
