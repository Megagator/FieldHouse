//
//  SessionViewCell.swift
//  FieldHouse Sports
//
//  Created by Mike Reinhard on 3/10/18.
//  Copyright © 2018 Mike Reinhard. All rights reserved.
//

import UIKit

class TeamViewCell: UICollectionViewCell {
	var label: UILabel!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	func commonInit() {
		label = UILabel(frame: contentView.frame)
		contentView.addSubview(label)
		label.textAlignment = .center
		label.font = UIFont(name: label.font.fontName, size: 18)
		label.textColor = Colors.white
		self.contentView.backgroundColor = Colors.darkBlue
	}
}
