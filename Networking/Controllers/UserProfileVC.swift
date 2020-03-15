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
import FirebaseDatabase
import GoogleSignIn


class UserProfileVC: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var provider: String?
    private var currentUser: CurrentUser?
    
    lazy var logoutButton: UIButton = {
        
        let button = UIButton()
        button.frame = CGRect(x: 32, y: 700, width: view.frame.width - 64, height: 50)
        button.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        button.setTitle("Log Out", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addVerticalGradientLayer(topColor: .blue, bottomColor: .white)
        userNameLabel.isHidden = true
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchingUserData()
    }
    
    private func setupViews() {
        
        view.addSubview(logoutButton)
    }
}


extension UserProfileVC {
    
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
    
    //  Load data from Firebase
    
    private func fetchingUserData() {
        
        if Auth.auth().currentUser != nil {
            
            if let userName = Auth.auth().currentUser?.displayName {
                activityIndicator.stopAnimating()
                userNameLabel.isHidden = false
                userNameLabel.text = getProviderData(with: userName)
                
            } else {
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                Database.database().reference()
                    .child("Users")
                    .child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        guard let userData = snapshot.value as? [String: Any] else { return }
                        
                        self.currentUser = CurrentUser(uid: uid, data: userData)
                        
                        self.activityIndicator.stopAnimating()
                        self.userNameLabel.isHidden = false
                        self.userNameLabel.text = self.getProviderData(with: self.currentUser?.name ?? "Noname")
                    }) { (error) in
                        print(error)
                }
            }
            
        }
    }
    
    @objc private func signOut() {
        
        // Extract userID
        if let providerData = Auth.auth().currentUser?.providerData {
            for userInfo in providerData {
                
                switch userInfo.providerID {
                case "facebook.com" :
                    LoginManager().logOut()
                    print("User did log out of facebook")
                    openLoginViewController()
                case "google.com" :
                    GIDSignIn.sharedInstance()?.signOut()
                    print("User did log out of google")
                    openLoginViewController()
                case "password" :
                    try! Auth.auth().signOut()
                    print("User did sign out")
                    openLoginViewController()
                default:
                    print("User is signed in with \(userInfo.providerID)")
                }
            }
        }
    }
    
    // We determine the provider and return the finished text for label
    
    private func getProviderData(with user: String) -> String{
        
        var greetings = ""
        
        if let providerData = Auth.auth().currentUser?.providerData {
            
            for userInfo in providerData {
                
                switch userInfo.providerID {
                case "facebook.com" :
                    provider = "Facebook"
                case "google.com" :
                    provider = "Google"
                case "password" :
                    provider = "Email"
                default:
                    break
                }
            }
            
            greetings = "\(user) Logged in with \(provider!)"
        }
        return greetings
    }
}

/*
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
 
 */
