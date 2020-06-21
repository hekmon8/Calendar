//
//  ViewController.swift
//  Example
//
//  Created by Chi Hoang on 30/4/20.
//  Copyright © 2020 Hoang Nguyen Chi. All rights reserved.
//

import UIKit
import NCHCalendar

class ViewController: UIViewController {
    @IBOutlet weak var calendarView: NCHCalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.fromTitle = "From"
        calendarView.toTitle = "To"
        calendarView.toIcon = UIImage(named: "calendar")
        calendarView.fromIcon = UIImage(named: "calendar")
    }
}

