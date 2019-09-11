//
//  ColorConfig.swift
//  Number To Words
//
//  Created by Jobin Basani on 2019-09-10.
//  Copyright © 2019 Jobin Basani. All rights reserved.
//

import UIKit

class ColorConfig{
    var name:String
    var primaryColor:String
    var tint:String?
    
    init(name:String, primary primaryColor:String, tint:String) {
        self.name = name
        self.primaryColor = primaryColor
        self.tint = tint
    }
    
    convenience init(name:String, primary primaryColor:String) {
        self.init(name:name, primary:primaryColor,tint:primaryColor)
    }
    
    func getPrimaryUIColor() -> UIColor {
        return hexStringToUIColor(primaryColor)
    }
    
    func getTintUIColor() -> UIColor {
        return hexStringToUIColor(tint ?? primaryColor)
    }
    
    private func hexStringToUIColor(_ hexString:String) -> UIColor {
        var cString:String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#"){
            cString.remove(at: cString.startIndex)
        }
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: CGFloat(1.0))
    }
}
