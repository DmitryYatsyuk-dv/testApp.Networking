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


class UserProfileVC: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
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
        userNameLabel.isHidden = true
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         
        fetchingUserData()
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
    
    //  Load data from Firebase
    
    private func fetchingUserData() {
            
        if Auth.auth().currentUser != nil {
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            Database.database().reference()
                .child("Users")
                .child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    guard let userData = snapshot.value as? [String: Any] else { return }
                    
                    let currentUser = CurrentUser(uid: uid, data: userData)
                    
                    self.activityIndicator.stopAnimating()
                    self.userNameLabel.isHidden = false
                    self.userNameLabel.text = "\(currentUser?.name ?? "Noname") Logged in with Facebook"
                }) { (error) in
                    print(error)
            }
        }
        
    }
}
