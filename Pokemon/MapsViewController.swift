//
//  MapsViewController.swift
//  Pokemon
//
//  Created by rem{e}koh on 11/2/16.
//  Copyright © 2016 rem{e}koh. All rights reserved.
//

import UIKit
import MapKit

class MapsViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager!
    
    var pokemonsLocation = [Pokemon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager = CLLocationManager()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        
        self.locationManager.delegate = self
        
        self.locationManager.requestAlwaysAuthorization()
        
        self.mapView.showsUserLocation = true
        
        self.mapView.delegate = self
        
        self.locationManager.startUpdatingLocation()
        
        processJSON()

    }

    func addPokemonLocation(){
        
        for pokemon in pokemonsLocation {
            let pokemonAnnotation = MKPointAnnotation()
            pokemonAnnotation.title = pokemon.name
            pokemonAnnotation.coordinate = CLLocationCoordinate2DMake(pokemon.latitude, pokemon.longitude)
            pokemonAnnotation.accessibilityLabel = pokemon.imageURL
            
            DispatchQueue.main.async {
                self.mapView.addAnnotation(pokemonAnnotation)
                
            }
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        } else {
            
            let currentAnnotation = annotation as! MKPointAnnotation
            
            let currentAnnotationPhoto = currentAnnotation.accessibilityLabel
            
            let photoURL = URL(string: currentAnnotationPhoto!)
            
            let imageData = try? Data(contentsOf: photoURL!)
            
//            let imageData = try! Data(contentsOf: URL(string: pokemon.imageURL)!)
            
            var pokemonAnnotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "PokemonAnnotationView")
            
            if pokemonAnnotationView == nil {
                pokemonAnnotationView = PokemonAnnotationView(annotation: annotation, reuseIdentifier: "PokemonAnnotatonView")
            }
            
            pokemonAnnotationView?.canShowCallout = true
            
            let pokemonImageView = UIImageView(image: UIImage(data: imageData!))
            
            pokemonImageView.frame.size = CGSize(width: 50, height: 50)
            
            pokemonAnnotationView?.addSubview(pokemonImageView)
            
            return pokemonAnnotationView
            
        }
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        
        if let annotationView = views.last {
            if let annotation = annotationView.annotation {
                if annotation is MKPointAnnotation {
                    let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 750, 750)
                    self.mapView.setRegion(region, animated: true)
                }
            }
        }
    }
    
    func processJSON(){
        
        self.pokemonsLocation = [Pokemon]()
        
        let pokemonsURL = "https://still-wave-26435.herokuapp.com/pokemon/all"
        
        let url = URL(string: pokemonsURL)
        
        
        URLSession.shared.dataTask(with: url!) { (data : Data?, response: URLResponse?, error: Error?) in
            
            let result = try! JSONSerialization.jsonObject(with: data!, options: []) as! [[String:Any]]
            
            for item in result {
                
                let pokemon = Pokemon()
                pokemon.name = item["name"] as! String
                pokemon.imageURL = item["imageURL"] as! String
                pokemon.latitude = item["latitude"] as! Double
                pokemon.longitude = item["longitude"] as! Double
                
                self.pokemonsLocation.append(pokemon)
                
                print(self.pokemonsLocation)
                
            }
            
            self.addPokemonLocation()
            
        }.resume()

        
    }
    
    /*
 
         fileprivate func populateTableView() {
         
             self.pokemons = [Pokemon]()
             
             let pokemonsURL = "https://still-wave-26435.herokuapp.com/pokemon/all"
             
             let url = URL(string: pokemonsURL)
             
             
             
             URLSession.shared.dataTask(with: url!) { (data : Data?, response: URLResponse?, error: Error?) in
             
             let result = try! JSONSerialization.jsonObject(with: data!, options: []) as! [[String:Any]]
             
             for item in result {
             
             let pokemon = Pokemon()
             pokemon.id = item["id"] as! Int
             pokemon.name = item["name"] as! String
             pokemon.imageURL = item["imageURL"] as! String
             
             self.pokemons.append(pokemon)
             
             }
             
             DispatchQueue.main.async {
             self.tableView.reloadData()
             }
             
             }.resume()
         
         
         
         }
 
    */
    
    /*
     
         fileprivate func populateTableView() {
         
             let pizzaAPI = "https://dl.dropboxusercontent.com/u/20116434/locations.json"
             
             guard let url = URL(string: pizzaAPI) else { fatalError("Invalid URL") }
             
             let session = URLSession.shared
             
             session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
             
             //            guard let jsonResult = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) else {
             //                fatalError("Unable to format data")
             //            }
             //            print(jsonResult)
             
             let pizzaLocationsArray = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [AnyObject]
             
             for g in 0...(pizzaLocationsArray.count - 1) {
             
             let pizzaLocationsDictionary = pizzaLocationsArray[g] as! [String:AnyObject]
             
             
             let pizzaLocation = PizzaLocation()
             
             pizzaLocation.name = pizzaLocationsDictionary["name"] as! String
             pizzaLocation.latitude = pizzaLocationsDictionary["latitude"] as! Double
             pizzaLocation.longitude = pizzaLocationsDictionary["longitude"] as! Double
             pizzaLocation.photoURL = pizzaLocationsDictionary["photoUrl"] as! String
             
             self.locationsArray.append(pizzaLocation)
             
             
             }
             
             self.addPizzaStores()
             
             }.resume()

     
     
     
         }
     
     */
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
 
    }
 
}
