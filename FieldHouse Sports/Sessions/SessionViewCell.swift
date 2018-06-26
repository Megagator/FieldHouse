//
//  SessionViewCell.swift
//  FieldHouse Sports
//
//  Created by Mike Reinhard on 3/10/18.
//  Copyright © 2018 Mike Reinhard. All rights reserved.
//

import UIKit

class SessionViewCell: UICollectionViewCell {
	var title = UILabel()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	func commonInit() {
		contentView.layer.shadowColor = Colors.lightgrey.cgColor
		contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
		contentView.layer.shadowOpacity = 0.95
		contentView.layer.shadowRadius = 10.0
		
		let interiorView = UIView(frame: contentView.frame)
		interiorView.layer.cornerRadius = Radius.cells
		interiorView.layer.masksToBounds = true
		interiorView.backgroundColor = Colors.green
		
		let background = UIImageView()
		background.frame = interiorView.bounds
		background.contentMode = .scaleAspectFill
		background.image = #imageLiteral(resourceName: "winter_1")
		interiorView.addSubview(background)
		
		contentView.addSubview(interiorView)
		
		title.translatesAutoresizingMaskIntoConstraints = false
		title.numberOfLines = 3
//		title.adjustsFontSizeToFitWidth = true
//		title.minimumScaleFactor = 0.25
		title.textAlignment = .center
		title.font = UIFont.systemFont(ofSize: 28, weight: .black)
		title.textColor = Colors.black
		
		let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
		visualEffectView.translatesAutoresizingMaskIntoConstraints = false
		visualEffectView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
		
		interiorView.addSubview(visualEffectView)
		interiorView.addSubview(title)
		
		NSLayoutConstraint.activate([
			visualEffectView.leadingAnchor.constraint(equalTo: interiorView.leadingAnchor),
			visualEffectView.trailingAnchor.constraint(equalTo: interiorView.trailingAnchor),
			visualEffectView.bottomAnchor.constraint(equalTo: interiorView.bottomAnchor),
			visualEffectView.heightAnchor.constraint(equalTo: title.heightAnchor, constant: Padding.collections * 2),
			
			title.widthAnchor.constraint(equalTo: interiorView.widthAnchor, constant: -(Padding.collections * 2)),
			title.centerXAnchor.constraint(equalTo: interiorView.centerXAnchor),
			title.centerYAnchor.constraint(equalTo: visualEffectView.centerYAnchor),
		])
	}
	
	func selectedItem() {
		let generator = UIImpactFeedbackGenerator(style: .light)
		generator.prepare()
		
		UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
			self.contentView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
			self.contentView.layer.shadowRadius = 5.0
		}, completion: {(Bool) -> Void in
			
		})
	}
	
	func deselectedItem() {
		UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
			self.contentView.transform = CGAffineTransform(scaleX: 1, y: 1)
			self.contentView.layer.shadowRadius = 10.0
		}, completion: nil)
	}
}
