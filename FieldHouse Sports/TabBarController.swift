//
//  TabBarController.swift
//  FieldHouse Sports
//
//  Created by Mike Reinhard on 3/13/18.
//  Copyright © 2018 Mike Reinhard. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
	let logo = UIImageView(frame: CGRect(x: 0, y: 0, width: 287, height: 111))
	let background = UIImageView(frame: UIScreen.main.bounds)
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		delegate = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
//		background.translatesAutoresizingMaskIntoConstraints = false;
		background.image = #imageLiteral(resourceName: "turf")
		background.contentMode = .scaleToFill
		background.alpha = 1
		
		logo.image = #imageLiteral(resourceName: "logo")
		logo.center = CGPoint(x: background.frame.midX, y: background.frame.midY);
		
		view.addSubview(background)
		view.addSubview(logo)
		
	
		let item1 = SessionsViewController()
//		let item1 = MatchesViewController()
//		item1.title = "Test View"
//		item1.teamID = "28084"
		let icon1 = UITabBarItem(title: "Sessions", image: #imageLiteral(resourceName: "soccar-tabs"), tag: 1)
				item1.tabBarItem = icon1
		
		let item2 = FavoritesViewController()
		let icon2 = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
				item2.tabBarItem = icon2
		
		let item3 = BetterTableViewController();
		let icon3 = UITabBarItem(tabBarSystemItem: .more, tag: 3)
				item3.tabBarItem = icon3
		
		let nav1 = UINavigationController()
				nav1.viewControllers = [item1]
		
		let nav2 = UINavigationController()
				nav2.viewControllers = [item2]
		
		let nav3 = UINavigationController()
				nav3.viewControllers = [item3]

		let controllers = [nav1,nav2,nav3]  //array of the root view controllers displayed by the tab bar interface
		self.viewControllers = controllers
		
				
		
		UIView.animate(withDuration: 0.6, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
			self.logo.center = CGPoint(x: self.background.frame.midX, y: 100);
			self.background.alpha = 0
		}) { (success: Bool) in
			item1.logo.alpha = 1
			print("Done moving image: \(success)")
			self.logo.isHidden = true
		}
	}
	
	// Delegate methods
	func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//		print("Should select viewController: \(viewController.title ?? "Dud") ?")
		return true;
	}
}
