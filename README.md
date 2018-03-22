# Clima(APP ESERCIZIO)

L'app recupera da OpenWeather il meteo per la posizione attuale o per la città selezionata dall'utente.

Sunto passaggi modifica app in XCode 9:

    ° clonazione progetto madre(appbrewery.com)

    ° creazione file pod e installazione "Alamofire", "SwiftyJSON" e "SVProgressHUD" da terminale
    
    ° modifica Model
    
    ° funzioni di recupero e parsing JSON per messa a video 
    
    ° funzione modifica interfaccia VC
    
    ° delegati e protocolli 
    
    ° segues
    
    
## App Finita
![Finished App](https://github.com/londonappbrewery/Images/blob/master/Clima.gif)

## Fix for Cocoapods v1.0.1 and below

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
      config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.10'
    end
  end
end
```

## Fix for App Transport Security Override

```XML
	<key>NSAppTransportSecurity</key>
	<dict>
		<key>NSExceptionDomains</key>
		<dict>
			<key>openweathermap.org</key>
			<dict>
				<key>NSIncludesSubdomains</key>
				<true/>
				<key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
				<true/>
			</dict>
		</dict>
	</dict>
```


Copyright © The App Brewery
