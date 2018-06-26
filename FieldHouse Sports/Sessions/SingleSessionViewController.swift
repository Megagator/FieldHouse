//
//  SessionViewController.swift
//  FieldHouse Sports
//
//  Created by Mike Reinhard on 3/13/18.
//  Copyright © 2018 Mike Reinhard. All rights reserved.
//

import UIKit

class SingleSessionViewController: UIViewController {
	
	var session: Session!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = session.attributes.name
		navigationController?.navigationBar.prefersLargeTitles = false

		view.backgroundColor = Colors.lightGreen
	
		let dates = UILabel(frame: CGRect(x: 0, y: 87, width: view.frame.width, height: 150))
		dates.numberOfLines = 2
		dates.textAlignment = .center
		dates.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
		dates.textColor = Colors.black
		dates.layer.borderColor = Colors.green.cgColor
		dates.layer.borderWidth = 5
		
//		dates.translatesAutoresizingMaskIntoConstraints = false
//		dates.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
//		dates.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
//		dates.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//		dates.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
		
		
		let beginDate = Utilities.transform(date: session.attributes.start )
		let endDate = Utilities.transform(date: session.attributes.end )
		dates.text = beginDate + " - " + endDate
		
		dates.sizeToFit()
		dates.frame = CGRect(x: 0, y: 87, width: view.frame.width, height: dates.frame.height)
//		view.addSubview(sessionTitle)
		view.addSubview(dates)
		
		
	}
	
	override func didReceiveMemoryWarning() {
			super.didReceiveMemoryWarning()
			// Dispose of any resources that can be recreated.
	}
	

	/*
	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
			// Get the new view controller using segue.destinationViewController.
			// Pass the selected object to the new view controller.
	}
	*/

}
