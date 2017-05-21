//
//  GraveDetailsViewController.swift
//  PoznanGraves
//
//  Created by Robert Ignasiak on 21.05.2017.
//  Copyright © 2017 Torianin. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class GraveDetailsViewController: UIViewController, MKMapViewDelegate {
    
    var grave: Grave? {
        didSet {
            if let gravePrintName = grave?.printName, let gravePrintSurname = grave?.printSurname {
                nameLabel.text = "\(gravePrintName) \(gravePrintSurname)"
            }
            
            let unknown = NSLocalizedString("unknown_data_text", comment: "")
            
            birhDeathLabel.text = "ur. \(grave?.birthDate ?? unknown) - zm. \(grave?.deathDate ?? unknown)"
            graveInfoLabel.text = "kwatera: \(grave?.quarter ?? unknown) rząd: \(grave?.row ?? unknown) miejsce: \(grave?.place ?? unknown)"
            
            if (grave?.paid?.boolValue)! {
                paidLabel.text = "grób opłacony: tak"
            } else {
                paidLabel.text = "grób opłacony: nie"
            }
            
            if let latitude = grave?.latitude, let longitude = grave?.longitude {
                let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude),
                                                      longitude: CLLocationDegrees(longitude))
                let span = MKCoordinateSpanMake(0.05, 0.05)
                let region = MKCoordinateRegion(center: location, span: span)
                mapView.setRegion(region, animated: true)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                if let gravePrintName = grave?.printName, let gravePrintSurname = grave?.printSurname {
                    annotation.title = "\(gravePrintName) \(gravePrintSurname)"
                }
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightLight)
        return label
    }()
    
    var birhDeathLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightLight)
        return label
    }()
    
    var graveInfoLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightLight)
        return label
    }()
    
    var paidLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightLight)
        return label
    }()
    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        return mapView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = UIColor.white
        
        setupMapView()
        setupViews()
    }

    func setupMapView() {
        mapView.delegate = self
    }

    func setupViews() {
        view.addSubview(nameLabel)
        view.addSubview(birhDeathLabel)
        view.addSubview(graveInfoLabel)
        view.addSubview(paidLabel)
        view.addSubview(mapView)

        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        birhDeathLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        graveInfoLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        paidLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8).isActive = true
        
        view.addConstraintsWithFormat(format: "V:[v0]-10-[v1]-10-[v2]-10-[v3]-10-[v4]|", views: nameLabel, birhDeathLabel, graveInfoLabel, paidLabel, mapView)
        view.addConstraintsWithFormat(format: "H:|-30-[v0]-30-|", views: nameLabel)
        view.addConstraintsWithFormat(format: "H:|-30-[v0]-30-|", views: birhDeathLabel)
        view.addConstraintsWithFormat(format: "H:|-30-[v0]-30-|", views: graveInfoLabel)
        view.addConstraintsWithFormat(format: "H:|-30-[v0]-30-|", views: paidLabel)
        view.addConstraintsWithFormat(format: "H:|-30-[v0]-30-|", views: mapView)
    }
}
