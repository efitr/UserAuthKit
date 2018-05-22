//
//  UICustomizableButton.swift
//  UserAuthKit
//
//  Created by Egon Fiedler on 5/17/18.
//  Copyright © 2018 App Solutions. All rights reserved.
//

import UIKit

class UICustomizableButton: UIButton {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor.blue
        self.layer.cornerRadius = 15
        
    }
    
    let button = UIButton()
    button.frame = CGRect(x: self.view.frame.size.width - 60, y: 60, width: 50, height: 50)
    button.backgroundColor = UIColor.red
    button.setTitle("Name your Button ", for: .normal)
    button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    self.view.addSubview(button)
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
    }
    
}

