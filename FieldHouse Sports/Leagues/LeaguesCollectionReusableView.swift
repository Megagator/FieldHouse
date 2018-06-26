//
//  LeaguesCollectionReusableView.swift
//  FieldHouse Sports
//
//  Created by Mike Reinhard on 4/12/18.
//  Copyright © 2018 Mike Reinhard. All rights reserved.
//

import UIKit

class LeaguesCollectionReusableView: UICollectionReusableView {
	override func prepareForReuse() {
		super.prepareForReuse()
		
		for view in self.subviews {
			view.removeFromSuperview()
		}
	}
}
