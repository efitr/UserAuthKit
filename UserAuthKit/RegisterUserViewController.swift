//
//  SignUpViewController.swift
//  UserAuthKit
//
//  Created by Egon Fiedler on 5/15/18.
//  Copyright © 2018 App Solutions. All rights reserved.
//

import Foundation
import UIKit

class RegisterUserViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        print("SignUp button tapped")
        
        ///////////////////////////////////////////////////////////////////
        //if any or fields are empty, inform that everything must be filled
        if (firstNameTextField.text?.isEmpty)! ||
            (lastNameTextField.text?.isEmpty)! ||
            (emailTextField.text?.isEmpty)! ||
            (passwordTextField.text?.isEmpty)!
        {
            displayMessage(userMessage: "All fields are required")
            return
        }
        //////////////////////////////////////////////
        //Make the password be the same on both levels
        if ((passwordTextField.text?.elementsEqual(confirmPasswordTextField.text!))! != true)
        {
            displayMessage(userMessage: "Make sure that passwords match")
            return
        }
        
        ///////////////////////////////////////////////////////
        //The spinning wheel that appears after saving the user
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        myActivityIndicator.center = view.center
        
        myActivityIndicator.hidesWhenStopped = false
        
        myActivityIndicator.startAnimating()
        
        view.addSubview(myActivityIndicator)
        
        //Send user
        let myURL = URL(string: "http://localhost:3000/users")
        var request = URLRequest(url:myURL!)
        request.httpMethod = "POST"
        //What does the wed service requires, FILL with what the api needs
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //This will be converted into a json
        //This is the json payload
        let postString = ["firstName": firstNameTextField.text!,
                          "lastName": lastNameTextField.text!,
                          "userName": emailTextField.text!,
                          "userPassword": passwordTextField.text!
            ] as [String:String]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            displayMessage(userMessage: "Something went wrong. Try again")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            self.removeActivityIndicator(activityIndicator: myActivityIndicator)
            
            if error != nil
            {
                self.displayMessage(userMessage: "Could not succesfully perform this request. Please try again later")
                print("error=\(String(describing: error))")
                return
            }
            
            //Making the server side response into a dictionary
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    //Reading data from the dictionary
                    let userId = parseJSON["userId"] as? String
                    print("User Id: \(String(describing: userId!))")
                    
                    if (userId?.isEmpty)!
                    {
                        self.displayMessage(userMessage: "Could not succesfully perform this request. Please try again later")
                        return
                    }
                    else
                    {
                        self.displayMessage(userMessage: "Succesfully Registered a New Account. Please proceed to sign in")
                    }
                }
                else {
                    self.displayMessage(userMessage: "Could not succesfully perform this request. Please try again later")
                }
            } catch {
                self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                print(error)
                self.displayMessage(userMessage: "Could not succesfully perform this request. Please try again later")
                
            }
        }
        task.resume()
        
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        print("Cancel button tapped")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView)
    {
        DispatchQueue.main.async
            {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
        }
    }
    
    
    //Function with the purpose of giving a message depending on where it's been called, you give the content
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

