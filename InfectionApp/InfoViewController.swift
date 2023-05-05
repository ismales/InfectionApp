//
//  InfoViewController.swift
//  InfectionApp
//
//  Created by Сманчос on 05.05.2023.
//

import UIKit

final class InfoViewController: UIViewController {

    private lazy var infoText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.text = text
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        view.backgroundColor = .white

        view.addSubview(infoText)

        NSLayoutConstraint.activate([
            infoText.topAnchor.constraint(equalTo: view.topAnchor),
            infoText.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoText.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoText.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

// TODO: - написать инфо
let text = ""
