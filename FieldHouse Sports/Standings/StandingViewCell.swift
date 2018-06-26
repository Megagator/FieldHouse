//
//  SessionViewCell.swift
//  FieldHouse Sports
//
//  Created by Mike Reinhard on 3/10/18.
//  Copyright © 2018 Mike Reinhard. All rights reserved.
//

import UIKit

class StandingViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
	var standing: UILabel!
	var teamName: UILabel!
	var teamRecord: UILabel!
	
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
		contentView.layer.addPartialRowBorder(color: Colors.exlightgrey, thickness: 1.0, xOffset: 45.0 )
		
		standing = UILabel()
		standing.translatesAutoresizingMaskIntoConstraints = false
		standing.textAlignment = .right
		standing.font = UIFont.systemFont(ofSize: 18, weight: .black)
		standing.textColor = Colors.lightgrey
		
		teamName = UILabel()
		teamName.adjustsFontSizeToFitWidth = true
		teamName.minimumScaleFactor = 0.5
		teamName.numberOfLines = 1
		teamName.translatesAutoresizingMaskIntoConstraints = false
		teamName.textAlignment = .left
		teamName.font = UIFont.systemFont(ofSize: 18, weight: .bold)
		teamName.textColor = Colors.black
		
		teamRecord = UILabel()
		teamRecord.translatesAutoresizingMaskIntoConstraints = false
		teamRecord.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
		teamRecord.textAlignment = .right
		teamRecord.font = UIFont.systemFont(ofSize: 16, weight: .light)
		teamRecord.textColor = Colors.midgrey
		
		let arrow = UIImageView()
		arrow.image = #imageLiteral(resourceName: "caret")
		arrow.contentMode = .center
		arrow.translatesAutoresizingMaskIntoConstraints = false


		contentView.addSubview(standing)
		contentView.addSubview(teamName)
		contentView.addSubview(teamRecord)
		contentView.addSubview(arrow)
		
		NSLayoutConstraint.activate([
			standing.widthAnchor.constraint(equalToConstant: 24.0),
			standing.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Padding.cells),
			standing.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Padding.cells ),
			standing.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Padding.cells),
			
			teamName.leadingAnchor.constraint(equalTo: standing.trailingAnchor, constant: (Padding.cells*1.5)),
			teamName.trailingAnchor.constraint(equalTo: teamRecord.leadingAnchor, constant: -Padding.cells),
			teamName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Padding.cells ),
			teamName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Padding.cells),
			
			teamRecord.leadingAnchor.constraint(equalTo: teamName.trailingAnchor, constant: Padding.cells),
			teamRecord.trailingAnchor.constraint(equalTo: arrow.leadingAnchor, constant: -(Padding.cells/2)),
			teamRecord.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Padding.cells ),
			teamRecord.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Padding.cells),
			
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
