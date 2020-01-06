//
//  WeatherTableViewCell.swift
//  WeatherCombine
//
//  Created by Derrick Ho on 1/5/20.
//  Copyright © 2020 Derrick Ho. All rights reserved.
//

import UIKit
import Combine

struct WeatherModel {
    var dayText: String
    var temperatureValue: CGFloat
}

class WeatherTableViewCell: UITableViewCell {
    @IBOutlet private var dayLabel: UILabel!
    @IBOutlet private var temperatureLabel: UILabel!
    
    @Published public var model: WeatherModel?
    private var subscribers = [AnyCancellable]()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        subscribers <- $model.sink { [weak self] (model) in
            guard let model = model else { return }
            self?.dayLabel.text = model.dayText
            self?.temperatureLabel.text = "\(model.temperatureValue)"
        }
    }
    
}
