//
//  QueryViewController.swift
//  Weather
//
//  Created by Lyle Lee on 2021/06/27.
//

import UIKit

protocol QueryViewControllerDelegate {
    func didChangeCity(city: String)
}

class QueryViewController: UIViewController {
    var curCity: String?
    var delegate: QueryViewControllerDelegate?
    
    @IBOutlet weak var curCityLabel: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cityTextField.becomeFirstResponder() // Atomatic Keyboard, opposite to resignFirstResponder()
        curCityLabel.text = curCity
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func query(_ sender: Any) {
        dismiss(animated: true)
        
        if !cityTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            delegate?.didChangeCity(city: cityTextField.text!.removeWhitespace())
        }
    }
    

}
