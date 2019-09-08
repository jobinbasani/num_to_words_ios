//
//  NumberConfigButton.swift
//  Number To Words
//
//  Created by Jobin Basani on 2019-09-08.
//  Copyright © 2019 Jobin Basani. All rights reserved.
//

import UIKit

@IBDesignable class NumberConfigButton: UIButton {

    //MARK: - Properties
    @IBInspectable var isNumberButton:Bool = true
    
    //MARK: - Methods
    func getButtonNumber() -> Int? {
        return isNumberButton ? Int(titleLabel!.text!) : nil
    }
    
    func getButtonOption() -> String? {
        return !isNumberButton ? titleLabel!.text! : nil
    }

}
