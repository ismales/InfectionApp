//
//  SimulationViewController.swift
//  InfectionApp
//
//  Created by Сманчос on 05.05.2023.
//

import UIKit

class SimulationViewController: UIViewController {

    let groupSize: Int
    let infectionRate: Int
    let updateInterval: Double

    var people: [Person] = []
    var infectedCount = 0
    var infectedTimer: Timer?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemGray6
        collectionView.allowsMultipleSelection = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PersonCell.self, forCellWithReuseIdentifier: "PersonCell")
        return collectionView
    }()

    private lazy var healthyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Здоровых: \(groupSize)"
        return label
    }()

    private let infectedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Зараженных: 0"
        return label
    }()

    init(groupSize: Int, infectionRate: Int, updateInterval: Double) {
        self.groupSize = groupSize
        self.infectionRate = infectionRate
        self.updateInterval = updateInterval
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        setupSubViews()
        creatingObjects()
        reloadCollectionView()
    }

    private func configureView() {
        view.backgroundColor = .white
        title = "Симулятор"
    }

    private func setupSubViews() {
        view.addSubview(collectionView)
        view.addSubview(healthyLabel)
        view.addSubview(infectedLabel)

        NSLayoutConstraint.activate([
            healthyLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Resouces.Metric.offset),
            healthyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            infectedLabel.topAnchor.constraint(equalTo: healthyLabel.topAnchor),
            infectedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Resouces.Metric.offset),

            collectionView.topAnchor.constraint(equalTo: healthyLabel.bottomAnchor, constant: Resouces.Metric.offset),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func creatingObjects() {
        for _ in 0..<groupSize {
            let person = Person(healthy: true)
            people.append(person)
        }
    }

    private func reloadCollectionView() {
        Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }
}

extension SimulationViewController: UICollectionViewDelegateFlowLayout {
    private var inset: CGFloat { return 8 }
    private var elementCount: CGFloat { return 10 }
    private var insetsCount: CGFloat { return elementCount + 1 }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (collectionView.bounds.width - inset * insetsCount) / elementCount
        return CGSize(width: side, height: side)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        inset
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        guard person.healthy else { return }
        person.healthy = false
        infectedCount += 1
        collectionView.reloadItems(at: [indexPath])
        infectedLabel.text = "Зараженных: \(infectedCount)"
        healthyLabel.text = "Здоровых: \(groupSize - infectedCount)"

        // TODO: - написать алгоритм зарожения соседей
    }
}



extension SimulationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        groupSize
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCell", for: indexPath) as! PersonCell
        let person = people[indexPath.item]
        cell.backgroundColor = person.healthy ? .white : .red
        return cell
    }
}
