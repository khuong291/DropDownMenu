//
//  MenuViewController.swift
//  DropDownMenu
//
//  Created by Khuong Pham on 3/1/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var navItem: UIBarButtonItem!
    @IBOutlet var activeViewContainer: UIView!
    @IBOutlet var tableViewHeightConstrain: NSLayoutConstraint!

    private var viewControllerArray: [UIViewController] = []

    private var activeViewController: UIViewController? {
        didSet {
            removeInActiveViewController(oldValue)
            updateActiveViewController()
        }
    }

    var viewControllers: [UIViewController] {

        get {
            let immutableCopy = viewControllerArray
            return immutableCopy
        }

        set {
            viewControllerArray = newValue

            if activeViewController == nil || viewControllerArray.indexOf(activeViewController!) == nil {
                activeViewController = viewControllerArray.first
            }
        }
    }

    private func removeInActiveViewController(inactiveViewController: UIViewController?) {
        if isViewLoaded() {
            if let inActiveVC = inactiveViewController {
                inActiveVC.willMoveToParentViewController(nil)
                inActiveVC.view.removeFromSuperview()
                inActiveVC.removeFromParentViewController()
            }
        }
    }

    private func updateActiveViewController() {
        if isViewLoaded() {
            if let activeVC = activeViewController {
                addChildViewController(activeVC)
                activeVC.view.frame = activeViewContainer.bounds
                activeViewContainer.addSubview((activeViewController?.view)!)
                navItem.title = activeVC.title
                activeVC.didMoveToParentViewController(self)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forHeaderFooterViewReuseIdentifier: "TableViewCell")
        tableView.rowHeight = 50

        self.tableViewHeightConstrain.constant = 0
        updateActiveViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didTapMenuButton(sender: AnyObject) {
        if tableViewHeightConstrain.constant == 0 {
            showMenu()
        } else {
            hideMenu()
        }
    }

    private func showMenu() {
        UIView.animateWithDuration(0.3) { () -> Void in
            self.tableViewHeightConstrain.constant = 0
            self.tableView.layoutIfNeeded()
        }
    }

    private func hideMenu() {
        UIView.animateWithDuration(0.3) { () -> Void in
            let totalHeight = self.tableView.rowHeight * CGFloat(self.tableView.numberOfRowsInSection(0))
            self.tableViewHeightConstrain.constant = totalHeight
            self.tableView.layoutIfNeeded()
        }
    }

}
