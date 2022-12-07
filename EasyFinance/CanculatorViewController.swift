//
//  CanculatorViewController.swift
//  EasyFinance
//
//  Created by Quang Lan on 18/11/2022.
//

import UIKit
import Toast_Swift

class CanculatorViewController: UIViewController {

    @IBOutlet weak var resultLB: UILabel!
    @IBOutlet weak var resultTF: UITextField!
    
    @IBOutlet weak var finishButton: UIButton!
    
    var passData: (() -> Void)?
    var resultString: String = ""

    var number1: Double = 0
    var number2: Double = 0
    var result: Double = 0
    var operatorString: String?
    var checkOperatorPress: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"),
                                                           style: .plain, target: self,
                                                           action: #selector(backAction))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"),
                                                            style: .plain, target: self,
                                                            action: #selector(saveAction))
        setupView()
    }
    
    func setupView() {

        resultLB.text = String(result)
        resultLB.isHidden = true
        resultTF.text = formatNumber(result)
        checkOperatorPress = true
        operatorString = ""
        navigationItem.rightBarButtonItem?.isEnabled = false
        finishButton.isEnabled = false
    }
    
    func formatNumber(_ number: Double) -> String {
        if number >= 100000000000 {
            view.makeToast("Giá trị nhập vào không được lớn hơn 100 tỷ")
            resultLB.text = "0"
            resultTF.text = "0"
            return "0"
        }
        //let numberString = String(format: "%.2f %@", locale: Locale.current, number , " ")
        //let numberString = String(format: "%ld %@", locale: Locale.current, number , " ")
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        //formatter.maximumFractionDigits = 2
        let numberString = formatter.string(from: NSNumber(value: number))
        return numberString!
    }
    
    func numberPress(numberString: String) {
        if checkOperatorPress == true {
            number1 = Double(String(resultLB.text!))!
            resultLB.text = numberString
        } else {
            if resultLB.text == "0" || resultLB.text == "" {
                if numberString == "000" {
                    resultLB.text = "0"
                } else {
                    resultLB.text = numberString
                }
            } else {
                    resultLB.text = String(resultLB.text!) + numberString
            }
        }
        checkOperatorPress = false
         
    }
    
    func operatorPress() {
        if checkOperatorPress == false {
            checkOperatorPress = true
            guard let number2 = Double(resultLB.text!) else {
                //number1 = 0.0
                return
            }
            switch operatorString {
            case "+":
                result = number1 + number2
                resultLB.text = String(result)
                number1 = result
                
            case "-":
                result = number1 - number2
                resultLB.text = String(result)
                number1 = result
            case "*":
                result = number1 * number2
                resultLB.text = String(result)
                number1 = result
                
            case "/":
                result = number1 / number2
                resultLB.text = String(result)
                number1 = result
                
            default:
                break
            }
        }
        
    }
    
    @objc func saveAction(_ sender: Any) {
        result = Double(resultLB.text!)!
        navigationController?.popViewController(animated: true)
        passData?()
    }
    
    
    @objc func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func dotPress(_ sender: Any) {
        if checkOperatorPress == false {
            if resultLB.text == "0" || resultLB.text == "" {
                resultLB.text = "0."
                resultTF.text = "0."
            } else if resultLB.text?.contains(".") != true {
                resultLB.text = String(resultLB.text!) + "."
                resultTF.text = formatNumber(Double(resultLB.text!)!)
            }
        }
    }
    
    @IBAction func finishPress(_ sender: UIButton) {
        
        result = Double(resultLB.text!)!
        navigationController?.popViewController(animated: true)
        passData?()
    }
    
    
    
    @IBAction func numberPress(_ sender: UIButton) {
        let numberString = sender.titleLabel?.text ?? "0"
        numberPress(numberString: numberString)
        resultTF.text = formatNumber(Double(resultLB.text!)!)
        //resultLB.text = String(Int(resultLB.text!)!)
        navigationItem.rightBarButtonItem?.isEnabled = true
        finishButton.isEnabled = true
    }
    
    @IBAction func clearPress(_ sender: Any) {
        resultLB.text = "0"
        resultTF.text = "0"
        number1 = 0
        number2 = 0
        result = 0
        checkOperatorPress = false
        operatorString = ""
    }
    
    @IBAction func backPress(_ sender: Any) {
        if checkOperatorPress == false {
             if resultLB.text != "0" {
                 let numberString = String(resultLB.text!)
                 resultLB.text = String(numberString.prefix(numberString.count - 1))
                 if resultLB.text == "" {
                     resultLB.text = "0"
                 }
                 resultTF.text = formatNumber(Double(resultLB.text!)!)
             }
         }
    }
    
    @IBAction func operatorAddPress(_ sender: Any) {
        operatorPress()
        operatorString = "+"
    }
    @IBAction func operatorMinusPress(_ sender: Any) {
        operatorPress()
        operatorString = "-"
    }
    @IBAction func operatorMultiplePress(_ sender: Any) {
        operatorPress()
        operatorString = "*"
    }
    @IBAction func operatorDividePress(_ sender: Any) {
        operatorPress()
        operatorString = "/"
    }
    
    @IBAction func equalPress(_ sender: Any) {
        operatorPress()
        operatorString = ""
        resultTF.text = formatNumber(Double(resultLB.text!)!)
    }
    
    
    
}
