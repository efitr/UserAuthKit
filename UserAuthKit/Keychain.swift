//
//  Keychain.swift
//  UserAuthKit
//
//  Created by Egon Fiedler on 5/15/18.
//  Copyright © 2018 App Solutions. All rights reserved.
//

import Foundation

struct Credentials {
    var username: String
    var password: String
}

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}

class KeyChain: UIViewController {
    
    //The server your app is working with
    static let server = "www.example.com"
    
    let account = Credentials.username
    let password = Credentials.password.data(using: String.Encoding.utf8)!
    var query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                kSecAttrAccount as String: account,
                                kSecAttrServer as String: server,
                                kSecValueData as String: password]
}




