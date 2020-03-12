//
//  UserProfileVC.swift
//  Networking
//
//  Created by Lucky on 12/03/2020.
//  Copyright © 2020 DmitriyYatsyuk. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth


class UserProfileVC: UIViewController {

    lazy var fbLoginButton: UIButton = {
       
        let loginButton = FBLoginButton()
        loginButton.frame = CGRect(x: 32,
                                   y: view.frame.height - 172,
                                   width: view.frame.width - 64,
                                   height: 50)
        
        loginButton.delegate = self
        return loginButton
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addVerticalGradientLayer(topColor: .blue, bottomColor: .white)
        
        setupViews()
    }
    
    private func setupViews() {
        
        view.addSubview(fbLoginButton)
    }
}


// MARK: Facebook SDK

extension UserProfileVC: LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        if error != nil {
            print(error!)
            return
        }
            print("Successfully logged in the facebook...")
        }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
        print("Did log out of facebook")
        openLoginViewController()
    }
    
    private func openLoginViewController() {
        
        do {
            try Auth.auth().signOut()
            
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = storyboard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
                self.present( loginViewController, animated: true)
                return
            }
        } catch let error {
            
            print("Failed to sign out with error: ", error.localizedDescription)
            
        }
    }
}
