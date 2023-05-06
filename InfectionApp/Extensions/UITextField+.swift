//
//  UITextField+.swift
//  InfectionApp
//
//  Created by Сманчос on 06.05.2023.
//
import UIKit

extension UITextField {
    func underlined(){
        self.backgroundColor = .systemGray6
        self.font = UIFont.systemFont(ofSize: 15)
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftViewMode = .always
    }
}
