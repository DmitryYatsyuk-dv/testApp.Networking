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
    
    lazy var fbLoginButton: UIButton = {
       
        let loginButton = FBLoginButton()
        loginButton.frame = CGRect(x: 32, y: 450, width: view.frame.width - 64, height: 50)
        loginButton.delegate = self
        return loginButton
    }()
    
    lazy var customFBLoginButton: UIButton = {
        
        let loginButton = UIButton()
        
        loginButton.backgroundColor = .gray
        
        loginButton.setTitle("Login with Facebook", for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.frame = CGRect(x: 32, y: 450 + 80, width: view.frame.width - 64, height: 50)
        loginButton.layer.cornerRadius = 5
        loginButton.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
        return loginButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
    }

    private func setupViews() {
        
        view.addSubview(fbLoginButton)
        view.addSubview(customFBLoginButton)
    }
}

// MARK: Facebook SDK
extension LoginViewController: LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        if error != nil {
            print(error!)
            return
        }
         
        guard AccessToken.isCurrentAccessTokenActive else { return }
        
        openMainViewController()
            print("Successfully logged in the facebook...")
        }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
        print("Did log out of facebook")
    }
    
    private func openMainViewController() {
        
        dismiss(animated: true)
    }
    
    @objc private func handleCustomFBLogin() {
        
        LoginManager().logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let result = result else { return }
            
            if result.isCancelled { return }
            else {
                self.openMainViewController()
            }
        }
    }
}
