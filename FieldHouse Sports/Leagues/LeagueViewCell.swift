//
//  SessionViewCell.swift
//  FieldHouse Sports
//
//  Created by Mike Reinhard on 3/10/18.
//  Copyright © 2018 Mike Reinhard. All rights reserved.
//

import UIKit

class LeagueViewCell: UICollectionViewCell {
	var name = UILabel()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	func commonInit() {
		
		contentView.backgroundColor = Colors.white
		contentView.layer.addPartialRowBorder(color: Colors.exlightgrey, thickness: 1.0, xOffset: 20.0)
		
		name.adjustsFontSizeToFitWidth = true
		name.minimumScaleFactor = 0.5
		name.numberOfLines = 1
		name.translatesAutoresizingMaskIntoConstraints = false
		name.textAlignment = .left
		name.font = UIFont.systemFont(ofSize: 18, weight: .bold)
		name.textColor = Colors.black
		
		let arrow = UIImageView()
		arrow.image = #imageLiteral(resourceName: "caret")
		arrow.contentMode = .center
		arrow.translatesAutoresizingMaskIntoConstraints = false
		
		
		contentView.addSubview(name)
		contentView.addSubview(arrow)
		
		NSLayoutConstraint.activate([
			name.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Padding.cells * 2),
			name.trailingAnchor.constraint(equalTo: arrow.leadingAnchor, constant: -(Padding.cells * 2)),
			name.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Padding.cells ),
			name.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Padding.cells),
			
			arrow.widthAnchor.constraint(equalToConstant: 20),
			arrow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Padding.cells),
			arrow.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Padding.cells ),
			arrow.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Padding.cells),
		])
	}
	
	func selectedRow() {
		contentView.backgroundColor = Colors.exlightgrey
	}
	func deselectedRow() {
		contentView.backgroundColor = Colors.white
	}
}
