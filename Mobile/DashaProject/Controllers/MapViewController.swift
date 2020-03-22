//
//  MapViewController.swift
//  DashaProject
//
//  Created by Георгий Кашин on 21.03.2020.
//  Copyright © 2020 Georgii Kashin. All rights reserved.
//

import NMAKit
import UIKit

class MapViewController: UIViewController {
    
    static var items = Results()
    var markers = [NMAMapMarker]()
    
    var mapView = NMAMapView()
    let label = UILabel(text: "Initial pos")

    class Defaults {
        static let latitude = 30.494713
        static let longitude = 59.775360
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Change data source to HERE position data source
        NMAPositioningManager.sharedInstance().dataSource = NMAHEREPositionSource()

        // Set initial position
        let geoCoodCenter = NMAGeoCoordinates(latitude: Defaults.latitude,
                                              longitude: Defaults.longitude)
        mapView.set(geoCenter: geoCoodCenter, animation: .none)
        mapView.copyrightLogoPosition = .center

        // Set zoom level
        mapView.zoomLevel = NMAMapViewMaximumZoomLevel - 1

        // Subscribe to position updates
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MapViewController.didUpdatePosition),
                                               name: NSNotification.Name.NMAPositioningManagerDidUpdatePosition,
                                               object: NMAPositioningManager.sharedInstance())

        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
//        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
//            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        // Set position indicator visible. Also starts position updates.
        mapView.positionIndicator.isVisible = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        for item in MapViewController.items.results.items {
            NetworkManager.shared.getIcon(at: item.icon) { image in
                guard let image = image else { return }
                
                let coords = NMAGeoCoordinates(latitude: item.position.first!, longitude: item.position.last!)
                
                let icon = NMAImage(uiImage: image)!
                let marker = NMAMapMarker(geoCoordinates: coords, icon: icon)
                
//                self.markers.append(marker)
                
                DispatchQueue.main.async {
                    self.mapView.add(mapObject: marker as NMAMapObject)
                }
            }
        }
    }

    @objc func didUpdatePosition() {

        // Update position indicator position.
        mapView.set(geoCenter: TrackingLocation.coordinates, animation: .linear)
        label.text = "\(TrackingLocation.coordinates.latitude), \(TrackingLocation.coordinates.longitude)"
    }
}

class TrackingLocation {
    
    static var position = NMAGeoPosition()
    static var coordinates = NMAGeoCoordinates()
    
    init() {
        // Change data source to HERE position data source
        NMAPositioningManager.sharedInstance().dataSource = NMAHEREPositionSource()

        // Subscribe to position updates
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didUpdatePosition),
                                               name: NSNotification.Name.NMAPositioningManagerDidUpdatePosition,
                                               object: NMAPositioningManager.sharedInstance())
    }
    
    @objc func didUpdatePosition() {
        if NMAPositioningManager.sharedInstance().currentPosition != nil,
            TrackingLocation.position.coordinates != nil {
            TrackingLocation.position = NMAPositioningManager.sharedInstance().currentPosition!
            TrackingLocation.coordinates = TrackingLocation.position.coordinates!
        }
        
        NotificationCenter.default.post(name: TasksViewController.updateNotificationName, object: nil, userInfo: ["location": (TrackingLocation.coordinates.latitude, TrackingLocation.coordinates.longitude)])
    }
}
