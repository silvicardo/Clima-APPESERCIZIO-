//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit

//Dichiarazione del protocollo...

protocol ChangeCityDelegate {
    //...e i suoi metodi
    func userEnteredANewCityName(city: String)

}


class ChangeCityViewController: UIViewController {
    
    //var per la definizione del delegato del protocollo di questo VC
    var delegate :  ChangeCityDelegate?
    
    //This is the pre-linked IBOutlets to the text field:
    @IBOutlet weak var changeCityTextField: UITextField!

    //IBAction del bottone per avviare la ricerca del meteo nella città digitata
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        //Otteniamo il nome della città digitata dall'utente
        let cityName = changeCityTextField.text!
        
        //Se abbiamo impostato un delegato, chiama il metodo userEnteredANewCityName
        delegate?.userEnteredANewCityName(city: cityName)//Optional Chaining
        
        //"chiude" Change City View Controller per tornare a  WeatherViewController
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //IBAction che "chiude" Change City View Controller per tornare a  WeatherViewController
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
