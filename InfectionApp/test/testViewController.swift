//
//  testViewController.swift
//  InfectionApp
//
//  Created by Сманчос on 05.05.2023.
//

import UIKit

class testViewController: UIViewController {
    // UI компоненты
    private let scrollView = UIScrollView()
    private let simulationView = UIView()
    private let healthyLabel = UILabel()
    private let infectedLabel = UILabel()

    // Параметры из первого экрана
    private var groupSize: Int
    private var infectionRate: Int
    private var updateInterval: TimeInterval

    init(groupSize: Int, infectionRate: Int, updateInterval: TimeInterval) {
        self.groupSize = groupSize
        self.infectionRate = infectionRate
        self.updateInterval = updateInterval
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Массив объектов в группе
    private var groupObjects: [GroupObject] = []

    // Массив зараженных объектов
    private var infectedObjects: [GroupObject] = []

    // Таймер для перерисовки "здоровых" объектов
    private var updateTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray6

        // Установим размеры и масштаб отображения
        simulationView.frame = CGRect(x: 0, y: 0, width: groupSize * 50, height: groupSize * 50)
        simulationView.transform = CGAffineTransform(scaleX: 1, y: 1)

        // Создадим объекты в группе
        for i in 0..<groupSize {
            let groupObject = GroupObject(frame: CGRect(x: (i % 10) * 50, y: (i / 10) * 50, width: 50, height: 50))
            groupObject.delegate = self
            simulationView.addSubview(groupObject)
            groupObjects.append(groupObject)
        }

        // Установим параметры скролла
        scrollView.contentSize = simulationView.frame.size
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2.0
        scrollView.delegate = self

        // Добавим лейблы для отображения количества здоровых и зараженных людей
        healthyLabel.frame = CGRect(x: 20, y: view.frame.height - 70, width: 100, height: 30)
        healthyLabel.text = "Здоровые: \(groupSize)"
        view.addSubview(healthyLabel)

        infectedLabel.frame = CGRect(x: view.frame.width - 120, y: view.frame.height - 70, width: 100, height: 30)
        infectedLabel.text = "Зараженные: 0"
        view.addSubview(infectedLabel)

        // Добавим UI компоненты на экран
        view.addSubview(scrollView)
        scrollView.addSubview(simulationView)
    }

    // Метод для запуска симуляции
    private func startSimulation() {
        // Создаем очередь для выполнения пересчета в другом потоке
        let queue = DispatchQueue(label: "com.simulation.queue", qos: .userInteractive)

        // Запускаем пересчет в другом потоке
        queue.async {
            // Выполняем пересчет
            while self.infectedObjects.count < self.groupSize {
                self.calculateInfection()
                sleep(1)
            }

            // Обновляем UI в главном потоке
            DispatchQueue.main.async {
                self.stopSimulation()
            }
        }
    }

    // Метод для остановки симуляции
    func stopSimulation() {
        // Остановим таймер для перерисовки "здоровых" объектов
        updateTimer?.invalidate()
        updateTimer = nil
    }

    private func calculateInfection() {
        // Создаем массив соседних объектов для каждого зараженного объекта
        var infectedNeighbors: [[GroupObject]] = []
        for infectedObject in infectedObjects {
            let neighbors = getNeighbors(of: infectedObject)
            let infectedNeighborsArray = neighbors.filter { $0.isInfected }
            infectedNeighbors.append(infectedNeighborsArray)
        }

        // Заражаем здоровых соседей зараженных объектов
        for neighbors in infectedNeighbors {
            for neighborObject in neighbors {
                if !infectedObjects.contains(neighborObject) && !neighborObject.isInfected {
                    let randomIndex = Int.random(in: 0..<100)
                    if randomIndex < infectionRate {
                        neighborObject.setInfected()
                        infectedObjects.append(neighborObject)
                    }
                }
            }
        }
    }


    // Метод для перерисовки "здоровых" объектов
    private func updateHealthyObjects() {
        for groupObject in groupObjects {
            if !infectedObjects.contains(groupObject) {
                groupObject.setHealthy()
            }
        }
        healthyLabel.text = "Здоровые: \(groupSize - infectedObjects.count)"
        infectedLabel.text = "Зараженные: \(infectedObjects.count)"
        while groupSize != 0 {
            updateInfections()
        }
    }

    // Метод для пересчета заражений
    private func updateInfections() {
        // Создадим массив зараженных объектов, чтобы не изменять infectedObjects во время пересчета
        let currentInfectedObjects = infectedObjects

        for infectedObject in currentInfectedObjects {
            // Получим соседние объекты
            var neighbors = getNeighbors(of: infectedObject)

            // Заразим случайные соседние объекты, но не больше, чем указано в infectionRate
            var infectedCount = 0
            while infectedCount < infectionRate && !neighbors.isEmpty {
                let randomIndex = Int.random(in: 0..<neighbors.count)
                let neighborObject = neighbors[randomIndex]
                neighborObject.setInfected()
                infectedObjects.append(neighborObject)
                neighbors.remove(at: randomIndex)
                infectedCount += 1
            }
        }
    }

    // Метод для получения соседних объектов
    private func getNeighbors(of groupObject: GroupObject) -> [GroupObject] {
        var neighbors: [GroupObject] = []

        let x = groupObject.frame.origin.x / 50
        let y = groupObject.frame.origin.y / 50

        if x > 0 {
            neighbors.append(groupObjects[Int(y) * 10 + Int(x) - 1])
        }
        if x < 9 {
            neighbors.append(groupObjects[Int(y) * 10 + Int(x) + 1])
        }
        if y > 0 {
            neighbors.append(groupObjects[Int(y - 1) * 10 + Int(x)])
        }
        if y < (CGFloat(groupSize) / 10 - 1) {
            neighbors.append(groupObjects[Int(y + 1) * 10 + Int(x)])
        }

        return neighbors
    }
}

// Расширение для работы с UIScrollViewDelegate
extension testViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return simulationView
    }
}

// Расширение для работы с GroupObjectDelegate
extension testViewController: GroupObjectDelegate {
    func didTap(groupObject: GroupObject) {
        // Если объект был заражен, удалим его из массива зараженных объектов
        if infectedObjects.contains(groupObject) {
            groupObject.setHealthy()
            if let index = infectedObjects.firstIndex(of: groupObject) {
                infectedObjects.remove(at: index)
            }
        } else {
            // Если объект был здоров, заразим его и добавим в массив зараженных объектов
            groupObject.setInfected()
            infectedObjects.append(groupObject)
        }
        healthyLabel.text = "Здоровые: \(groupSize - infectedObjects.count)"
        infectedLabel.text = "Зараженные: \(infectedObjects.count)"
    }
}
