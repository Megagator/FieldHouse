//
//  Constant.swift
//  FieldHouse Sports
//
//  Created by Mike Reinhard on 3/12/18.
//  Copyright © 2018 Mike Reinhard. All rights reserved.
//

import UIKit

struct Colors {
	// brand
	static let darkBlue     = UIColor(red:0.19, green:0.24, blue:0.32, alpha:1.0)
	static let blueGreen    = UIColor(red:0.48, green:0.57, blue:0.55, alpha:1.0)
//	static let green        = UIColor(red:0.44, green:0.53, blue:0.27, alpha:1.0)
	static let midGreen     = UIColor(red:0.67, green:0.75, blue:0.67, alpha:1.0)
	static let lightGreen   = UIColor(red:0.86, green:0.93, blue:0.82, alpha:1.0)
	
	static let classicGreen = UIColor(red:0.20, green:0.40, blue:0.00, alpha:1.0)
	static let classicBlue 	= UIColor(red:0.00, green:0.00, blue:0.60, alpha:1.0)
	
	static let newBlue		 	= UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
	static let newGreen			= UIColor(red:0.44, green:0.76, blue:0.18, alpha:1.0)
	
	// normal
		// greys
	static let white        = UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0)
	static let exlightgrey  = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
	static let lightgrey    = UIColor(red:0.7, green:0.7, blue:0.7, alpha:1.0)
	static let midgrey	    = UIColor(red:0.5, green:0.5, blue:0.5, alpha:1.0)
	static let grey	        = UIColor(red:0.3, green:0.3, blue:0.3, alpha:1.0)
	static let black        = UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)
	
		// other
	static let red					= UIColor(red:0.85, green:0.33, blue:0.31, alpha:1.0)
	static let green				= UIColor(red:0.36, green:0.72, blue:0.36, alpha:1.0)
}

struct Grid {
	static let cellHeight		= CGFloat(200.0)
	static let rowHeight		= CGFloat(60.0)
}

struct Padding {
	static let cells 				= CGFloat(10.0)
	static let collections	= cells * 2
}

struct Radius {
	static let cells = CGFloat(12.0)
}
