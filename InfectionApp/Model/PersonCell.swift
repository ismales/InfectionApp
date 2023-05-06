//
//  PersonCell.swift
//  InfectionApp
//
//  Created by Сманчос on 05.05.2023.
//

import UIKit

class PersonCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 4
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Person {
    var healthy: Bool

    init(healthy: Bool) {
        self.healthy = healthy
    }
}
