//
//  ViewController.swift
//  Number To Words
//
//  Created by Jobin Basani on 2019-09-07.
//  Copyright © 2019 Jobin Basani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var buttonContainer: UIStackView!
    

    //MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        for numberConfigButton in getNumberConfigButtons(){            
            numberConfigButton.addTarget(self, action: #selector(onButtonClick(sender:)), for: .touchUpInside)
        }
    }
    //MARK: - Event handlers
    @objc func onButtonClick(sender: NumberConfigButton){
        print(sender.titleLabel?.text ?? "No Title")
    }
    //MARK: - Private functions
    private func getChildViewsOf<T: UIView>(view: UIView) -> [T] {
        var subviews = [T]()
        
        for subview in view.subviews {
            subviews += getChildViewsOf(view: subview) as [T]
            if let subview = subview as? T{
                subviews.append(subview)
            }
        }
        return subviews
    }
    
    private func getNumberConfigButtons() -> [NumberConfigButton] {
        return getChildViewsOf(view: buttonContainer)
    }

}

