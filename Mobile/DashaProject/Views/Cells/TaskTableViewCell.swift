//
//  TaskTableViewCell.swift
//  DashaProject
//
//  Created by Георгий Кашин on 21.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    private let categories = ["Рестораны", "Кафе", "Фаст-Фуд", "Развлечения", "Достопримечательности", "Транспорт", "Аэропорт", "Проживание", "Шоппинг", "Активный Отдых", "Учреждения", "Природа", "Заправки", "Банкоматы", "Туалеты", "Больницы"]

    private let engCategories = ["restaurant", "coffee-tea", "snacks-fast-food", "going-out", "sights-museums", "transport", "airport", "accommodation", "shopping", "leisure-outdoor", "administrative-areas-buildings", "natural-geographical", "petrol-station", "atm-bank-exchange", "toilet-rest-area", "hospital-health-care-facility"]
    
    static let id = "taskCellId"
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Category"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .disclosureIndicator
        
        setupConstraints()
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        imageView?.frame = CGRect(x: 20, y: frame.size.height / 2 - 20, width: 40, height: 40)
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
extension TaskTableViewCell {
    private func setupConstraints() {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, categoryLabel], axis: .vertical, spacing: 10)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func setupUI(with task: Task) {
        nameLabel.text = task.name
        if categories.firstIndex(of: task.category) != nil {
            categoryLabel.text = task.category
        } else {
            categoryLabel.text = categories[engCategories.firstIndex(of: task.category)!]
        }
        
        if TasksViewController.phoneNumber == task.phone {
            backgroundColor = #colorLiteral(red: 0.7993923422, green: 0.9607662749, blue: 0.9427710453, alpha: 1)
        }
    }
}
