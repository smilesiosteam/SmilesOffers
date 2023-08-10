//
//  DiscountAndDetailsMapViewTableViewCell.swift
//  House
//
//  Created by Shahroze Zaheer on 11/17/21.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import UIKit
import GoogleMaps
import Foundation
import SmilesUtilities

class DiscountAndDetailsMapViewTableViewCell: SuperTableViewCell {
    @IBOutlet weak var mapView: GMSMapView!
    var branches: [MerchantLocationSwift]?
    var categoryId : Int = 0
    var markerCustomView: MapCustomPinView?
    var tappedMarker = GMSMarker()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func updateCell(rowModel: BaseRowModel) {
        if let model = rowModel.rowValue as? [MerchantLocationSwift] {
            self.branches = model
        }
        categoryId = Int(rowModel.rowTitle) ?? 0
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = false
        setupMapView()
    }
    
    func setupMapView() {
        let path = GMSMutablePath()
        
        var locationPin = ""
        switch categoryId {
        case 1,2,3:
            locationPin = "locationPin"
        case 4:
            locationPin = "diningPin"
        case 5:
            locationPin = "iconEntretainment"
        case 6:
            locationPin = "wellnessPin"
        case 7:
            locationPin = "TravelPin"
        case 8:
            locationPin = "EtisalatOfferPin"
        default:
            locationPin = "locationPin"
        }
        
        
        branches?.forEach { branch in
            
            let location = CLLocationCoordinate2D(latitude: branch.locationLatitude ?? 0.00, longitude: branch.locationLongitude ?? 0.00)
            print("location: \(location)")
            let marker = GMSMarker()
            marker.position = location
            marker.icon = UIImage(named: locationPin)
            marker.userData = branch
            
            do {
                // Set the map style by passing the URL of the local file.
                if let styleURL = Bundle.main.url(forResource: "MapsStyling", withExtension: "json") {
                    self.mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                } else {
                    NSLog("Unable to find style.json")
                }
            } catch {
                NSLog("One or more of the map styles failed to load. \(error)")
            }
            
            marker.map = self.mapView
            
            path.add(CLLocationCoordinate2DMake(branch.locationLatitude ?? 0.00, branch.locationLongitude ?? 0.00))
        }
        
        
        let bounds = GMSCoordinateBounds(path: path)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: UInt64(0.5))) {
            self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 110.0))
        }
        
    }
    //TODO: replace string with model
    class func rowModel(value: [MerchantLocationSwift] , categoryId:String) -> BaseRowModel {
        let rowModel = BaseRowModel()
        rowModel.rowCellIdentifier = "DiscountAndDetailsMapViewTableViewCell"
        rowModel.rowHeight = UITableView.automaticDimension
        rowModel.rowValue = value
        rowModel.rowTitle = categoryId
        return rowModel
    }
}

extension DiscountAndDetailsMapViewTableViewCell: GMSMapViewDelegate {
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        return true
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
//        if let branch = marker.userData as? Restaurant {
//            self.markerCustomView = presenter?.generateCustomPinView(branch: branch)
//            return markerCustomView
//        }
        return UIView()
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
//        if let selectedMarker = mapView.selectedMarker {
//                selectedMarker.icon = #imageLiteral(resourceName: "iconDine")
//            }
//
//
//        marker.icon = nil
//        marker.icon = #imageLiteral(resourceName: "iconDineSelected")
        
        
        let location = CLLocationCoordinate2D(latitude: marker.position.latitude, longitude: marker.position.longitude)
        
        if let branch = marker.userData as? MerchantLocationSwift {
            tappedMarker = marker
            markerCustomView?.removeFromSuperview()
    
            let rest = Restaurant()
            rest.restaurantName = branch.locationName
            rest.location = branch.locationAddress
            rest.latitude = String(branch.locationLatitude ?? 0)
            rest.longitude = String(branch.locationLongitude ?? 0)
            rest.restaurantNumber = branch.locationPhoneNumber
            markerCustomView?.restaurant = rest
            markerCustomView = generateCustomPinView(branch: rest)
            markerCustomView?.center = mapView.projection.point(for: location)
            markerCustomView?.center.y -= 60
            contentView.addSubview(markerCustomView ?? UIView())
        }
        return false // return false to display info window
    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
//        marker.icon = #imageLiteral(resourceName: "iconDine")
    }
    
    // let the custom infowindow follows the camera
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if tappedMarker.userData != nil {
            let location = CLLocationCoordinate2D(latitude: tappedMarker.position.latitude, longitude: tappedMarker.position.longitude)
            markerCustomView?.center = mapView.projection.point(for: location)
            markerCustomView?.center.y -= 60
            markerCustomView?.center.x = 20
        }
    }
    
    // take care of the close event
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
//        tappedMarker.icon = #imageLiteral(resourceName: "iconDine")
        markerCustomView?.removeFromSuperview()
    }
    
    
    func generateCustomPinView(branch: Restaurant) -> MapCustomPinView {
        let customView = MapCustomPinView.instantiate()
        customView.roundView.backgroundColor = .white
        customView.titleLabel.text = (branch.restaurantName ?? "") + ", " + (branch.location ?? "")
        customView.titleLabel.textColor = .black
        customView.imageView.image = customView.imageView.image?.imageWithColor(color1: .white)
        customView.frame = CGRect(x: customView.frame.origin.x, y: customView.frame.origin.y, width: 256, height: 75)
        //customView.frame.size.height * Constants.ASPECT_RATIO_RESPECT
        return customView
    }
}
