//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,  LocationsViewControllerDelegate, MKMapViewDelegate {
    
    // MARK: Properties
    @IBOutlet weak var mapView: MKMapView!
    
    var userImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.delegate = self
        
        // one degree of latitude is approximately 111 kilometers (69 miles) at all times.
        let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667),
                                              MKCoordinateSpanMake(0.1, 0.1))
        mapView.setRegion(sfRegion, animated: false)

    }

    @IBAction func onCamera(_ sender: Any) {
        /* Taking/Picking Pictures */
        // Instantiate a UIImagePickerController
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        // Don't set the sourceType first b/c the camera will open, leading to a crash
        // vc.sourceType = UIImagePickerControllerSourceType.camera
        // Check source type
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            // implied UIImagePickerController syntax
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // Save the image that the user picks
        self.userImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Dismiss the view controller
        self.dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: "tagSegue", sender: nil)
        })
        
    }
    
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
        self.navigationController?.popToViewController(self, animated: true)
        
        let locationCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
        annotation.title = "( \(latitude), \(longitude) )"
        mapView.addAnnotation(annotation)

    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
        }
        
        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
        imageView.image = UIImage(named: "camera")
        
        return annotationView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        let vc = segue.destination as! LocationsViewController
        // Pass the selected object to the new view controller.
        vc.delegate = self
    }
    

}
