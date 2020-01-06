//
//  ViewController.swift
//  WeatherCombine
//
//  Created by Derrick Ho on 1/5/20.
//  Copyright © 2020 Derrick Ho. All rights reserved.
//

import UIKit
import Combine

struct Keys {
    static let weatherAPIKey = "11a7d7b914027fde9fd0e4ef358e2d1c"
    static let appIdKey = "APPID"
    static let weatherURL = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=London,us&\(appIdKey)=\(weatherAPIKey)")!
}

struct WeatherData: Codable {
    struct Main: Codable {
        let temp: CGFloat
    }
        
    let main: Main
    let dt_txt: String
}

struct WeatherContainer: Codable {
    let list: [WeatherData]
}

class ViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    @Published var listModels: [WeatherModel] = []
    var subscribers = [AnyCancellable]()
    
    var weatherPublisher: URLSession.DataTaskPublisher?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        subscribers <- $listModels.receive(on: RunLoop.main).sink(receiveValue: { [weak self] _ in
            self?.tableView.reloadData()
        })
        
        let weatherPublisher = URLSession.shared.dataTaskPublisher(for: Keys.weatherURL)
        self.weatherPublisher = weatherPublisher
        
        subscribers <- weatherPublisher
            .map({
                $0.data
            })
            .decode(type: WeatherContainer.self, decoder: JSONDecoder())
            .replaceError(with: WeatherContainer(list: []))
            .sink(receiveValue: { [weak self] in
                self?.listModels = $0.list.map { (data) in
                    let temp = data.main.temp
                    let measure = Measurement(value: Double(temp), unit: UnitTemperature.kelvin)
                    return WeatherModel(dayText: data.dt_txt, temperatureValue: CGFloat(measure.converted(to: .fahrenheit).value))
                }
            })
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WeatherTableViewCell.self), for: indexPath)
        
        if let cell = cell as? WeatherTableViewCell {
            cell.model = listModels[indexPath.row]
        }
        
        return cell
    }
    
    
}

