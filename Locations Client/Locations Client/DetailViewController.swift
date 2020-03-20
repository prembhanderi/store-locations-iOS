//
//  DetailViewController.swift
//  Locations Client
//
//  Created by rb on 7/16/19.
//  Copyright © 2019 premBhanderi. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class DetailViewController : UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var selectedLocation: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
