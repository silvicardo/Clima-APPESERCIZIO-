//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

//importiamo il framework CoreLocation e conformiamo al relativo delegato
class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
   
    
    //Costanti
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    //NOTA BENE: GENERARE IL PROPRIO ID GRATUITO  PER TESTARE L'APP!!!!!
    let APP_ID = "af916bdea5bead6cada0b8999e940c4f"
    

    //creiamo un istanza di locationManager
    let locationManager = CLLocationManager()
    //creiamo un istanza del Model
    let weatherDataModel = WeatherDataModel()
    
    //IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        //assegnazione del delegato al VC
        locationManager.delegate = self
        //settiamo il nostro locationManager
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization() //aggiunte le voci al Plist
        //diamo il via alla ricerca della posizione
        locationManager.startUpdatingLocation()
        //se non è possibile trovare la posizione chiamerà il metodo didFailWithError
        //altrimenti una volta trovata la posizone chiamerà il metodo didUpdateLocation
        
    }
    
    //MARK: - Networking
    /***************************************************************/
    
    
    func getWeatherData(url:String, parameters: [String: String]){
        //utilizziamo Alamofire
        //creando una get request a partire dall'url di OpenWeather
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            //se la richiesta del JSON ha successo
            if response.result.isSuccess {
                print("Success! Got the weather data")
                //mettiamo il json ricavato in una costante
                let weatherJSON = JSON(response.result.value!)
                //aggiorniamo il prodotto vuoto del nostro model con i dati del json
                self.updateWeatherData(json: weatherJSON)
                //aggiorniamo la UI
                self.updateUIWithWeatherData()
                
            } else {//altrimenti
                //mostriamo l'errore in console e all'utente
                print("Error \(response.result.error!)")
                self.cityLabel.text = "Connection Issues"
            }
        }
        
    }

    //MARK: - JSON Parsing
    /***************************************************************/
    
    
    func updateWeatherData(json: JSON) {
        //suppur vero che l'esistenza del json è sicura a questo punto
        //non si può dire che il contenuto sarà conforme a ciò che vogliamo
        //con optional binding avviamo il passaggio al data model
        //solo se troviamo riscontro di uno dei nostri parametri
        if let tempResult = json["main"]["temp"].double{
            //correzione temperatura a gradi celsius
            weatherDataModel.temperature = Int(tempResult - 273.15)
            //nome della città
            weatherDataModel.city = json["name"].stringValue
            //valore numerico della condizione...
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            //...che rimanda a una delle nostre icone che rappresenterà la condizione meteo
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
        } else {//se non rispetta i nostri parametri
            //mostriamo l'errore in console e all'utente
            print("json non valido")
            cityLabel.text = "Unable to retrieve weather"
        }
    }
    
    //MARK: - Modifiche UI
    /***************************************************************/
    
    
    func updateUIWithWeatherData(){
        //aggiorniamo gli elementi della UI con i dati del model
        //label città
        cityLabel.text = weatherDataModel.city
        //label temperatura
        temperatureLabel.text = "\(weatherDataModel.temperature) C°"
        //icona del tempo attuale
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
        
    }
    
    //MARK: - Metodi Location Manager Delegate 
    /***************************************************************/
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //prendiamo l'ultimo valore nell'array delle locations rilevate (sarà la più accurata)
        let location = locations[locations.count - 1]
        //verifichiamo che la posizione sia valida
        //la horizontalAccuracy se maggiore di 0 indica una posizione valida
        //essa rappresenta l'estensione della posizione rilevata
        //se negativo rappresenta l'impossibilità di ottenere una posizione precisa
        if location.horizontalAccuracy > 0 {//se la condizione si verifica
            //fermiamo la ricerca
            locationManager.stopUpdatingLocation()
            //e mostriamo in console i dati della posizione
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            //prepariamo i parametri da inviare all'API di OpenWeather
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            //creiamo un dizionario con i parametri per l'api
            let params : [String:String] = ["lat" : latitude, "lon": longitude, "appid": APP_ID]
            //richiamiamo la funzione che leggerà il json(parsing)
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable. \(error)"
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    

    func userEnteredANewCityName(city: String) {
        print(city)
        //creiamo un dizionario con i parametri per l'api stavolta per città
        let params : [String:String] = ["q": city, "appid": APP_ID]
        //richiamiamo la funzione che decifrerà il json
        getWeatherData(url: WEATHER_URL, parameters: params)
    }

    //MARK: - Navigazione
    /***************************************************************/
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //se l'identifier è....
        if segue.identifier == "changeCityName" {
            //il controller di destinazione sarà ChangeCityViewController
            let destinationVC = segue.destination as! ChangeCityViewController
            //assegnazione delegato
            destinationVC.delegate = self
        }
    }
    
    
    
    
}


