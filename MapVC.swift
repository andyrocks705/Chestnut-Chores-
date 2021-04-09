//
//  MapVC.swift
//  Chestnut Chores Revamp
//
//  Created by Andy Lau on 3/10/21.
//  Copyright © 2021 SCH Academy. All rights reserved.
//
	
import UIKit
import MapKit
import CoreLocation
import Contacts

//Data structure setting the values for each key in the 'Location' array 
struct Location {
//       let address: String
//       let service: String
       let latitude: Double
       let longitude: Double
   }

class MapVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    //Manages the location shown and how it's shown on the mapView
    let manager = CLLocationManager()

    //Zooms map in to a particular area/region
    var selectedRegion = MKCoordinateRegion()
    
    //Defining a variable 'addLocations' as the 'Location' array in ChoresInfoVC.swift
    var addLocations:[Location]!
    var jobs:[Job]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        dump(addLocations)
        
        //Set manager constants delegate and mapView delegate to the viewcontroller
        manager.delegate = self
        mapView.delegate = self
        
        //Set accuracy of GPS information (set to the highest level of accuracy)
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        //Request to use to the GPS (for first time users)
        manager.requestWhenInUseAuthorization()
        
        //Updates and reports the user's current location
        manager.startUpdatingLocation()
    
        //Calls the function to add the pin markers for the locations in the array
        addAnnotations()
    }
    
    //Constantly update the user's location
    //The array of updating locations would change very minimally since it's simulated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //Set 'location' to the first one out of an array of updating locations
        let location = locations[0]
        
        //Pulls longitude and latitiude out of the location
        //Used later to center the mapView onto the user's location
        let myLocationCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        //Span = zoom of the map
        //Smaller the numbers (in degrees), larger the zoom
        let span = MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.003)
        
        //Centers the simulated location (using the gpx file) and sets the region
        let region = MKCoordinateRegion(center: myLocationCoordinate, span: span)
        selectedRegion = region
        
        //Zoom boundary
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 100000)
        mapView.setCameraZoomRange(zoomRange, animated: true)
        
        //Sets and shows user's location
        mapView.setRegion(selectedRegion, animated: true)
        mapView.showsUserLocation = true
    }
    
    //Takes the 'Locations' array and loops through each element and adds it as an annotation to the mapView
    func addAnnotations() {
        for location in addLocations {
            let annotation = MKPointAnnotation()
            annotation.title = jobs.address
            annotation.subtitle = jobs.service
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            //Specifically adds each annotation with their data of each index in the array to the mapView
            mapView.addAnnotation(annotation)
        }
    }
    
    //Creates the "pin markers" for the locations along with a 'PinAnnotationView'
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //Keeps the user's current location as a blue dot instead of making a pin for it
        if annotation is MKUserLocation {
            return nil
        }
        let identifier = "Pin"
        var view: MKPinAnnotationView
        
        //Check to see if a reusable annotation view is available before creating a new one
        //Give an identifier to a dequeued reusable annotation
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            //Create new annotation marker if an annotation view couldn't be dequeued
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            //Adds certain accessories to the annotationView
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            //Sets a map image for callOut Button 
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width:48, height: 48)))
            mapsButton.setBackgroundImage(UIImage(named: "mapCallout"), for: .normal)
            view.rightCalloutAccessoryView = mapsButton
            
            

        }
        return view
    }
    
    //Creates a variable for the selectedAnnotationView method
    //Sets the variable type to MKPointAnnotation
    var selectedAnnotationView: MKPointAnnotation!
    
    //This function sets the selected annotationView as the variable above and stores all of its data: (coordinate & address)
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.selectedAnnotationView = view.annotation as? MKPointAnnotation
    }
    
    //Uses the selectedAnnotationView variable data to create mapItems that allows the MKMap Directions to work
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        //Creates two variable of the coordinate and address title of the selectedAnnotationView
        let coordinate = selectedAnnotationView!.coordinate
        let address = selectedAnnotationView!.title
        
        //Sets the title (which is the address of the annotationView) as the streetname/address for mapItem key reference
        let addressDict = [CNPostalAddressStreetKey: address]
        
        //Creates a mapItem for current location
        let currentMapItem = MKMapItem.forCurrentLocation()
        
        //Passes all of the data in terms of coordinate and address name to this MKPlacemark
        let selectedPlacemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict as [String : Any])
        
        //Creates a mapItem for the selected location
        let selectedMapItem = MKMapItem(placemark: selectedPlacemark)
        
        //The order of which the MapItem is placed in the array is how you will navigate (from place to place basis)
        //In this case, from current location to the selected pin location
        let mapItems = [currentMapItem, selectedMapItem]
        
        //Sets the direction Method to driving mode
        let launchMapDriving = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            
        //Launches the map
        MKMapItem.openMaps(with: mapItems, launchOptions: launchMapDriving)
    }
}

  
    



