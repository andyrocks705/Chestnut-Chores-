//
//  ChoresInfoVC.swift
//  Chestnut Chores Revamp
//
//  Created by Andy Lau on 3/15/21.
//  Copyright © 2021 SCH Academy. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Contacts

class ChoresInfoVC: UIViewController  {
    
    @IBOutlet weak var addressInput: UITextField!
    @IBOutlet weak var serviceInput: UITextField!
    @IBOutlet weak var hoursInput: UITextField!
    
    //Array of hard-coded data
    var locations =
    [
        Location(address: "5933 North Lawrence Street, Philadelphia, PA 19120", service: "Babysitting, $15/hr", latitude: 40.041484, longitude: -75.128593),
        Location(address: "182 West Maplewood Avenue, Philadelphia, PA 19144", service: "Babysitting, $15/hr", latitude: 40.031495, longitude: -75.177281),
        Location(address: "7300 Cresheim Road, Philadelphia, PA 19119", service: "House Cleaning, $17.5/hr", latitude: 40.057902, longitude: -75.195698),
        Location(address: "1654 Ridge Avenue, Philadelphia, PA 19129", service: "House Cleaning, $17.5/hr", latitude: 0.000532 , longitude: -75.186871),
        Location(address: "201 East Benezet Street, Philadelphia, PA 19118", service: "Moving Stuff, $17.5/hr", latitude: 40.072483, longitude: -75.197747),
        Location(address: "110 East Chestnut Hill Avenue, Philadelphia, PA 19118", service: "Moving Stuff, $17.5/hr", latitude: 40.080583, longitude: -75.207623),
        Location(address: "6010 North 11th Street, Philadelphia, PA 19141", service: "Raking Leaves, $18/hr", latitude: 40.044004, longitude: -75.1382542),
        Location(address: "1719 West Nedro Avenue, Philadelphia, PA 19141", service: "Raking Leaves, $18/hr", latitude: 40.0436448, longitude: -75.1489635),
        Location(address: "6024 North 19th Street, Philadelphia, PA 19141", service: "Shoveling Snow, $20/hr", latitude: 40.0456, longitude: -75.152051),
        Location(address: "1148 East Vernon Road, Philadelphia, PA 19150", service: "Shoveling Snow, $20/hr", latitude: 40.0693054, longitude: -75.1710641),
        Location(address: "8342 Millman Street, Philadelphia, PA 19118", service: "Weeding, $17.5/hr", latitude: 40.0713009, longitude: -75.2080213),
        Location(address: "800 Caledonia Street, Philadelphia, PA 19128", service: "Weeding, $17.5/hr", latitude: 40.070024, longitude: -75.236099),
        Location(address: "201 Haws Lane, Springfield Township, PA 19031", service: "Tech Assistance, $16/hr", latitude: 40.101033, longitude: -75.205143),
        Location(address: "903 East Southampton Avenue, Springfield Township, PA 19038", service: "Garage Cleaning, $17.5/hr", latitude: 40.0844343, longitude: -75.1926198),
        Location(address: "1537 West Oakdale Street, Philadelphia, PA 19132", service: "Garage Cleaning, $17.5/hr", latitude: 39.9938593, longitude: -75.1569297)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addDataToArrary(_ sender: UIButton) {
        
        //Define value types
        var lat:Double!
        var lon:Double!
        let userAddress = addressInput.text
        let userService = serviceInput.text
        
        //GeoCoder converting address string into coordinates (lat, lon)
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(userAddress!) {
            (placemarks, error) in
            //If error, stop
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            //If inputed location is invalid, print error
            else {
                //Handle no location found
                let noAddressDetected = UIAlertController(title: "Invalid Address", message: "Please re-enter your address, (try adding the city, zipcode, and state of the address) be as specific as you can", preferredStyle: .alert)
                noAddressDetected.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(noAddressDetected, animated: true, completion: nil)
//                print(error)
                return
            }
            
             print(location.coordinate.latitude, location.coordinate.longitude)
            //Set created vars to coordinates
            lat = Double(location.coordinate.latitude)
            lon = Double(location.coordinate.longitude)
            
            //Adds the inputed data into the 'Location' array above
            self.locations.append(Location(address: userAddress!, service: userService!, latitude: lat, longitude: lon))
//              dump(self.locations)
            self.performSegue(withIdentifier: "inputToMap" , sender: nil)
        }
    }
    
    //Transfers data over to mapVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "inputToMap"{
            let vc = segue.destination as! MapVC
//              print(locations.last)
            
            //Array of coordinates data transfer over to MapVC 
            vc.addLocations = locations
        }
    }
}
