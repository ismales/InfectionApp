//
//  ParametersViewController.swift
//  InfectionApp
//
//  Created by Сманчос on 04.05.2023.
//

import UIKit

final class ParametersViewController: UIViewController {

    private let groupSizeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Сколько всего человек в заражаемой группе"
        label.numberOfLines = 0
        return label
    }()

    private lazy var groupSizeTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "250"
        textField.underlined()
        textField.delegate = self
        return textField
    }()

    private let infectionRateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Сколько человек может заразиться после контакта с зараженным"
        label.numberOfLines = 0
        return label
    }()

    private lazy var infectionRateTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "2"
        textField.underlined()
        textField.delegate = self
        return textField
    }()

    private let updateIntervalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Как быстро зараженные заболеют (сек)"
        return label
    }()

    private lazy var updateIntervalTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "2"
        textField.underlined()
        textField.delegate = self
        return textField
    }()

    private lazy var startSimulationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Запуск симуляции", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(startSimulationButtonTapped), for: .touchUpInside)
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        setupSubViews()
    }

    private func configureView() {
        view.backgroundColor = .white
        title = "Параметры"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupSubViews() {
        view.addSubview(groupSizeLabel)
        view.addSubview(groupSizeTextField)
        view.addSubview(infectionRateLabel)
        view.addSubview(infectionRateTextField)
        view.addSubview(updateIntervalLabel)
        view.addSubview(updateIntervalTextField)
        view.addSubview(startSimulationButton)

        NSLayoutConstraint.activate([
            groupSizeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Resouces.Metric.offset),
            groupSizeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Resouces.Metric.offset),
            groupSizeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Resouces.Metric.offset),
            groupSizeLabel.heightAnchor.constraint(equalToConstant: Resouces.Metric.height),

            groupSizeTextField.topAnchor.constraint(equalTo: groupSizeLabel.bottomAnchor),
            groupSizeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Resouces.Metric.offset),
            groupSizeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Resouces.Metric.offset),
            groupSizeTextField.heightAnchor.constraint(equalToConstant: Resouces.Metric.height),

            infectionRateLabel.topAnchor.constraint(equalTo: groupSizeTextField.bottomAnchor, constant: Resouces.Metric.offset),
            infectionRateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Resouces.Metric.offset),
            infectionRateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Resouces.Metric.offset),
            infectionRateLabel.heightAnchor.constraint(equalToConstant: Resouces.Metric.height),

            infectionRateTextField.topAnchor.constraint(equalTo: infectionRateLabel.bottomAnchor),
            infectionRateTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Resouces.Metric.offset),
            infectionRateTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Resouces.Metric.offset),
            infectionRateTextField.heightAnchor.constraint(equalToConstant: Resouces.Metric.height),

            updateIntervalLabel.topAnchor.constraint(equalTo: infectionRateTextField.bottomAnchor, constant: Resouces.Metric.offset),
            updateIntervalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Resouces.Metric.offset),
            updateIntervalLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Resouces.Metric.offset),
            updateIntervalLabel.heightAnchor.constraint(equalToConstant: Resouces.Metric.height),

            updateIntervalTextField.topAnchor.constraint(equalTo: updateIntervalLabel.bottomAnchor),
            updateIntervalTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Resouces.Metric.offset),
            updateIntervalTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Resouces.Metric.offset),
            updateIntervalTextField.heightAnchor.constraint(equalToConstant: Resouces.Metric.height),

            startSimulationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startSimulationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Resouces.Metric.offset),
            startSimulationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Resouces.Metric.offset),
            startSimulationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Resouces.Metric.offset),
            startSimulationButton.heightAnchor.constraint(equalToConstant: Resouces.Metric.height),
        ])
    }

    @objc private func startSimulationButtonTapped() {
        guard let groupSizeText = groupSizeTextField.text,
              let infectionRateText = infectionRateTextField.text,
              let updateIntervalText = updateIntervalTextField.text,
              let groupSize = Int(groupSizeText),
              let infectionRate = Int(infectionRateText),
              let updateInterval = Double(updateIntervalText) else {
            let alert = UIAlertController(title: "Ошибка", message: "Недопустимые параметры", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }

        let simulationViewController = SimulationViewController(groupSize: groupSize, infectionRate: infectionRate, updateInterval: updateInterval)
        navigationController?.pushViewController(simulationViewController, animated: true)
    }
}

extension ParametersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}
