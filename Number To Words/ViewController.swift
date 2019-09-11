//
//  ViewController.swift
//  Number To Words
//
//  Created by Jobin Basani on 2019-09-07.
//  Copyright © 2019 Jobin Basani. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var buttonContainer: UIStackView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var mainBorder: UIView!
    
    private let defaultColorIndexKey = "DEFAULT_COLOR_INDEX"
    private let maxValue:Int = 100000000000000
    private let numberFormatter = NumberFormatter()
    private let synth = AVSpeechSynthesizer()
    private let colors = [ColorConfig(name:"red", primary: "#c63d4d", tint: "#f55c5f"), ColorConfig(name: "violet", primary: "#45285b", tint: "#784f98"), ColorConfig(name: "green", primary: "#1b7f63", tint: "#58bfa2"), ColorConfig(name: "pink", primary: "#b64286", tint: "#f45690")]
    private var defaultColorIndex:Int = 0 {
        didSet{
            updateColors()
        }
    }
    private var currentNumber:Int = 0{
        didSet{
            updateLabels()
        }
    }

    //MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        numberFormatter.numberStyle = .spellOut
        wordLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        wordLabel.numberOfLines = 0
        for numberConfigButton in getNumberConfigButtons(){            
            numberConfigButton.addTarget(self, action: #selector(onButtonClick(sender:)), for: .touchUpInside)
        }
        lookupSavedColorIndex()
    }
    //MARK: - Event handlers
    @objc func onButtonClick(sender: NumberConfigButton){
        sender.isNumberButton ? handleNumberButtonClick(sender) : handleOptionButtonClick(sender)
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
    
    private func handleNumberButtonClick(_ sender:NumberConfigButton){
        guard let number = sender.getButtonNumber() else {
            fatalError("Failed to read numeric value of button!")
        }
        let newNumber = (currentNumber * 10) + number
        if(newNumber < maxValue){
            currentNumber = newNumber
        }
    }
    
    private func handleOptionButtonClick(_ sender:NumberConfigButton){
        guard let option = sender.getButtonOption() else{
            fatalError("Failed to read button option!")
        }
        switch option.uppercased() {
        case "DELETE":
            currentNumber = currentNumber / 10
        case "CLEAR":
            currentNumber = 0
        case "COPY":
            UIPasteboard.general.string = wordLabel.text!
            let alertbox = UIAlertController(title: nil, message: "Copied to clipboard!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertbox.addAction(okAction)
            self.present(alertbox, animated: true, completion: nil)
        case "SPEAK":
            let utterance = AVSpeechUtterance(string: wordLabel.text!)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            synth.speak(utterance)
        case "SHARE":
            let activityViewController = UIActivityViewController(activityItems: [wordLabel.text!], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        case "COLOR":
            let newColorIndex = defaultColorIndex + 1
            defaultColorIndex = newColorIndex < colors.count ? newColorIndex : 0
        default:
            print("Invalid option!")
        }
    }
    
    private func getNumberConfigButtons() -> [NumberConfigButton] {
        return getChildViewsOf(view: buttonContainer)
    }
    
    private func updateLabels(){
        numberLabel.text = String(currentNumber)
        wordLabel .text = numberFormatter.string(from: NSNumber(value: currentNumber))?.capitalized
    }
    
    private func updateColors(){
        for numberConfigButton in getNumberConfigButtons(){
            numberConfigButton.backgroundColor = colors[defaultColorIndex].getPrimaryUIColor()
            numberConfigButton.tintColor = colors[defaultColorIndex].getTintUIColor()
        }
        mainBorder.backgroundColor = colors[defaultColorIndex].getPrimaryUIColor()
        numberLabel.textColor = colors[defaultColorIndex].getPrimaryUIColor()
        wordLabel.textColor = colors[defaultColorIndex].getPrimaryUIColor()
        UserDefaults.standard.set(defaultColorIndex, forKey: defaultColorIndexKey)
    }
    
    private func lookupSavedColorIndex() {
        defaultColorIndex = UserDefaults.standard.integer(forKey: defaultColorIndexKey)
    }

}

