//
//  CollectionViewCell.swift
//  MiniAppsForOK
//
//  Created by Дмитрий Мартьянов on 05.09.2024.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "CollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 12.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.systemGray.cgColor
    }
    
    func configure(with childView: UIView) {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        childView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(childView)
        NSLayoutConstraint.activate([
            childView.topAnchor.constraint(equalTo: contentView.topAnchor),
            childView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            childView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            childView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
    }
}
