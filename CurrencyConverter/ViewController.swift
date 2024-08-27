//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Eren on 27.08.2024.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var cadLabel: UILabel!
    @IBOutlet weak var chfLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var gbpLabel: UILabel!
    @IBOutlet weak var jpyLabel: UILabel!
    @IBOutlet weak var tryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func getRateButton(_ sender: Any) {
        
        // 1) Request & Session
        // 2) Respons & Data
        // 3) Parsing & JSON Serialization
        
        // 1. Request & Session
        let url = URL(string: "http://data.fixer.io/api/latest?access_key=5bde79554a593fef2c6680a1e3316ee5") //Kendimize özel api keyimizi url olarak tanımlamak için. Http için normalde izin yok info.plist'ten düzenleme yaptım.
        let session = URLSession.shared //Data alışverişini yapacağımız fonksiyonun objesini oluşturmak için.
        
        let task = session.dataTask(with: url!) { data, response, error in //Hatalı mı değil mi kontrolünü yaomak için completionHandler kullandık.
            //Error message
            if error != nil {
                //error.localizedDescription kullanıcının anlayabileceği şekilde bir uyarı mesajı verir.
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else {
                // 2. Respons & Data
                if data != nil {
                    
                    do {
                        // 3. Parsing & JSON Serialization
                        //JSON datasını çözümlemek için kullandık. Sözlüklerden değiştirilebilir objeler oluşturulması için mutableContainers kullandık.
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>

                        //ASYNC
                        DispatchQueue.main.async {
                            if let rates = jsonResponse["rates"] as? [String : Any] {
                                
                                if let cad = rates["CAD"] as? Double {
                                    self.cadLabel.text = "CAD: \(cad)"
                                }
                                if let chf = rates["CHF"] as? Double {
                                    self.chfLabel.text = "CHF: \(chf)"
                                }
                                if let usd = rates["USD"] as? Double {
                                    self.usdLabel.text = "USD: \(usd)"
                                }
                                if let gbp = rates["GBP"] as? Double {
                                    self.gbpLabel.text = "GBP: \(gbp)"
                                }
                                if let jpy = rates["JPY"] as? Double {
                                    self.jpyLabel.text = "JPY: \(jpy)"
                                }
                                if let turkish = rates["TRY"] as? Double {
                                    self.tryLabel.text = "TRY: \(turkish)"
                                }
                            }
                        }
                    }
                    catch {
                        print("JSON Response Error!")
                    }
                    
                }
            }
        }
        
        task.resume()
        
    }
    
}

