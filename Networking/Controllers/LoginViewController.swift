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
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn


class LoginViewController: UIViewController {
    
    var userProfile: UserProfile?
    
    
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
    
    lazy var googleLoginButton: GIDSignInButton = {
       
        let loginButton = GIDSignInButton()
        loginButton.frame = CGRect(x: 32, y: 530 + 80, width: view.frame.width - 64, height: 50)
        return loginButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        setupViews()
        
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
    }
    
    private func setupViews() {
        
        view.addSubview(fbLoginButton)
        view.addSubview(customFBLoginButton)
        view.addSubview(googleLoginButton)
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

        print("Successfully logged in the facebook...")
        self.signIntoFirebase()
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
                self.signIntoFirebase()
            }
        }
    }
    
    private func signIntoFirebase() {
        
        let accessToken = AccessToken.current
        
        // Converted token in string
        
        guard let accessTokenString = accessToken?.tokenString else { return }
        
        //  We transfer the current user Facebook-token to the service Firebase for its registration
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        Auth.auth().signIn(with: credentials) { (user, error) in
            
            if let error = error {
                print("Something went wrong with our facebook user: ", error.localizedDescription)
                return
            }
            print("Successfully logged in with our Facebook user: ")
            self.fetchFacebookFields()
        }
    }
    
    private func fetchFacebookFields() {
        
        GraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"]).start { (_, result, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let userData = result as? [String: Any] {
                
                //  Parsing dictionary
                
                self.userProfile = UserProfile.init(data: userData)
                print(userData)
                print(self.userProfile?.name ?? "nil")
                self.saveIntoFirebase()
            }
        }
    }
    
    //  We transfer the received data from the user profile to the database - Firebase
    
    private func saveIntoFirebase() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // For example - create dictionary with name: email
        let userData = ["name": userProfile?.name, "email": userProfile?.email]
        
        // Values that are passed to the server
        let values = [uid: userData]
        
        Database.database().reference().child("Users").updateChildValues(values) { (error , _) in
            
            if let error = error {
                print(error)
                return
            }
            print("Successfully saved user into firebase database")
            self.openMainViewController()
        }
    }
}

// MARK: Google SDK

extension LoginViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print("Failed to log into Google: ", error)
            return
        }
        
        print("Successfully logged in Google")
        
        guard let authentication = user.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            
            if let error = error {
                print("Something went wrong with our Google user: ", error)
                return
            }
                
            print("Successfully logged into Firebase with Google")
            self.openMainViewController()
        }
            
            
            
    }
}
