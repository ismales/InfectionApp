//1. Создадим класс `Person`, который будет представлять объекты, которые могут быть заражены или нет:

class Person1 {
    var isInfected: Bool

    init(isInfected: Bool) {
        self.isInfected = isInfected
    }
}

import UIKit

//2. Создадим массив объектов `people` и заполним его случайными объектами `Person`:
class test: UIViewController {

    var people: [Person1] = []
    let gridSize = 10

    for _ in 0..<gridSize {
        for _ in 0..<gridSize {
            let person = Person1(isInfected: Bool.random())
            people.append(person)
        }
    }


    //3. Создадим функцию `infect(_:)`, которая будет заражать объекты:


    func infect(_ index: Int) {
        guard people[index].isInfected == false else { return }

        // Заражаем текущий объект
        people[index].isInfected = true

        // Заражаем соседние объекты
        let row = index / gridSize
        let column = index % gridSize

        if row > 0 {
            infect(index - gridSize) // Заражаем объект сверху
        }

        if row < gridSize - 1 {
            infect(index + gridSize) // Заражаем объект снизу
        }

        if column > 0 {
            infect(index - 1) // Заражаем объект слева
        }

        if column < gridSize - 1 {
            infect(index + 1) // Заражаем объект справа
        }
    }


    //4. Создадим функцию `startSimulation()`, которая будет запускать симуляцию:


    func startSimulation() {
        var infectedCount = 0

        // Заражаем случайный объект
        let randomIndex = Int.random(in: 0..<people.count)
        infect(randomIndex)
        infectedCount += 1

        // Обновляем UI
        updateUI()

        // Заражаем соседние объекты через определенный интервал времени
        let infectionInterval: TimeInterval = 1.0
        let infectionRate = 3

        Timer.scheduledTimer(withTimeInterval: infectionInterval, repeats: true) { timer in
            if infectedCount >= self.people.count {
                timer.invalidate()
                return
            }

            // Выбираем случайный зараженный объект
            let infectedIndexes = self.people.enumerated().filter { $0.element.isInfected }.map { $0.offset }
            let randomInfectedIndex = infectedIndexes.randomElement()!

            // Заражаем соседние объекты
            let row = randomInfectedIndex / self.gridSize
            let column = randomInfectedIndex % self.gridSize

            var infectedIndexesToInfect: [Int] = []
            if row > 0 {
                infectedIndexesToInfect.append(randomInfectedIndex - self.gridSize) // Заражаем объект сверху
            }
            if row < self.gridSize - 1 {
                infectedIndexesToInfect.append(randomInfectedIndex + self.gridSize) // Заражаем объект снизу
            }
            if column > 0 {
                infectedIndexesToInfect.append(randomInfectedIndex - 1) // Заражаем объект слева
            }
            if column < self.gridSize - 1 {
                infectedIndexesToInfect.append(randomInfectedIndex + 1) // Заражаем объект справа
            }

            let infectedIndexesToInfectShuffled = infectedIndexesToInfect.shuffled()
            let indexesToInfect = infectedIndexesToInfectShuffled.prefix(infectionRate)

            for index in indexesToInfect {
                self.infect(index)
                infectedCount += 1
            }

            // Обновляем UI
            self.updateUI()
        }
    }


    //5. Создадим функцию `updateUI()`, которая будет обновлять цвета объектов в коллекции:


    func updateUI() {
        for (index, person) in people.enumerated() {
            let indexPath = IndexPath(item: index, section: 0)
            let cell = collectionView.cellForItem(at: indexPath)!
            cell.backgroundColor = person.isInfected ? .red : .green
        }
    }
}
