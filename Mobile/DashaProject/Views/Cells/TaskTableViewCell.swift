//
//  TaskTableViewCell.swift
//  DashaProject
//
//  Created by Георгий Кашин on 21.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = CGRect(x: 20, y: frame.size.height / 2 - 20, width: 40, height: 40)
    }
    
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
        categoryLabel.text = task.category
//        peopleCountLabel.text = "Участники: \(queue.people.count)"
        
//        let dateFormatter = DateFormatter()
//        let dateTime = dateFormatter.getString(from: queue.startDate).split(separator: " ")
//        dateLabel.text = "\(dateTime.first!)\n\(dateTime.last!)"
        
//        imageView?.image = queue.isOwnCreated ? #imageLiteral(resourceName: "crown") : #imageLiteral(resourceName: "circle")
    }
}
