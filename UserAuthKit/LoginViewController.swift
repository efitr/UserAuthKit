//
//  LoginViewController.swift
//  UserAuthKit
//
//  Created by Egon Fiedler on 5/15/18.
//  Copyright © 2018 App Solutions. All rights reserved.
//

import Foundation

import UIKit
//How does a keychainunwrapper works
import SwiftKeychainWrapper


class LoginViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func SignInButtonTop(_ sender: Any) {
        print("SignIn Button Toped")
        
        //Read values
        let userName = userNameTextField.text
        let userPassword = userPasswordTextField.text
        
        if (userName?.isEmpty)! || (userPassword?.isEmpty)!
        {
            print("User name \(String(describing: userName)) or password \(String(describing: userPassword)) is empty")
            
            displayMessage(userMessage: "One of the required fields is missing.")
            return
        }
        
        ///////////////////////////////////////////////////////
        //The spinning waiting for the network call to work
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        myActivityIndicator.center = view.center
        
        myActivityIndicator.hidesWhenStopped = false
        
        myActivityIndicator.startAnimating()
        
        view.addSubview(myActivityIndicator)
        
        //HTTP Request to perform SignIn
        //The URL I'm sending the information to
        let myURL = URL(string: "http://localhost:3000/users") // <- Going to this RESTFULL web service
        //The request to where it's going
        var request = URLRequest(url: myURL!)
        //The user parameters
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //Send username and password
        let postString = ["userName": userName!, "userPassword": userPassword!] as [String:String]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options:  .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            ///////////////////////////////////////////////////////////Remove BOIIII
            displayMessage(userMessage: "Something went wrong BOIIII.")
            return
        }
        
        //When we receive response from server side, it's going to be stored in data
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            self.removeActivityIndicator(activityIndicator: myActivityIndicator)
            if error != nil
            {
                self.displayMessage(userMessage: "Could not succesfully perform this request. Please try again later")
                print("error=\(String(describing: error))")
                return
            }
            
            
            //Convert response sent from a server side code to a NSDictionary object:
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                //Parsing of json
                if let parseJSON = json {
                    
                    // Now we can access value of First Name by its key
                    let accessToken = parseJSON["token"] as? String
                    let userId = parseJSON["id"] as? String
                    //Retrieve token and id from that dictionary
                    //print("Access token: \(String(describing: accessToken!))")
                    
                    let saveAccessToken: Bool = KeychainWrapper.standard.set(accessToken!, forKey: "accessToken")
                    let saveUserId: Bool = KeychainWrapper.standard.set(userId!, forKey: "userId")
                    
                    print("The access token save result: \(saveAccessToken)")
                    print("The access token save result: \(saveUserId)")
                    
                    if (accessToken?.isEmpty)!
                    {
                        self.displayMessage(userMessage: "Could not succesfully perform this request. Please try again later")
                        return
                    }
                    
                    //This is storyboard Segue
                    DispatchQueue.main.async
                        {
                            let homePage = self.storyboard?.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
                            let appDelegate = UIApplication.shared.delegate
                            appDelegate?.window??.rootViewController = homePage
                    }
                    
                } else {
                    self.displayMessage(userMessage: "Could not succesfully perform this request. Please try again later")
                }
                
            }catch {
                self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                self.displayMessage(userMessage: "Could not succesfully perform this request. Please try again later")
                print(error)
            }
            
        }
        task.resume()
    }
    
    @IBAction func registerNewAccountButton(_ sender: Any) {
        print("Account button tapped")
        
        let registerViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterUserViewController") as! RegisterUserViewController
        self.present(registerViewController, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.registerViewController
    }
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView)
    {
        DispatchQueue.main.async
            {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
        }
    }
    
    
    func displayMessage(userMessage: String) -> Void
    {
        DispatchQueue.main.async
            {
                let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK BOIIII", style: .default)
                { (action:UIAlertAction!) in
                    print("Ok button tapped")
                    DispatchQueue.main.async
                        {
                            self.dismiss(animated: true, completion: nil)
                    }
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
        }
    }
}
