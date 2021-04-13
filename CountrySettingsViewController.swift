//
//  NewsSettingsViewController.swift
//  TestTask
//
//  Created by Stanislav Teslenko on 13.04.2021.
//

import UIKit

class NewsSettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var cathegoryPicker: UIPickerView!
    
    private let countryCodeArray = ["ae","ar","at","au","be","bg","br","ca","cn","de","fr","gb","jp","nl","pl","ua","us"]
    
    private let countryNameArray = ["United Arab Emirates", "Argentina", "Austria", "Australia", "Belgium", "Bulgaria", "Brazil", "Canada", "China", "Germany", "France", "United Kingdom", "Japan", "Netherlands", "Poland", "Ukraine", "USA"]
    
    private let cathegoryArray = ["general", "business", "entertainment", "health", "science", "sports", "technology"]
    
    private var regionCode: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Select desired row in the Picker
        loadPickerData()
        
    }
    
    private func loadPickerData() {
        
        // Get phone's locale
        let locale = Locale.current
        regionCode = locale.regionCode?.lowercased() ?? "us"
        
        // Get country index from array and select Picker's position
        if let index = countryCodeArray.firstIndex(where: {$0 == regionCode}) {
            countryPicker.selectRow(index, inComponent:0, animated:false)
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == countryPicker {
            return countryCodeArray.count
        } else {
            return cathegoryArray.count
        }
    
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        print(pickerView)
        
        return countryNameArray[row]
    }
    
    
    @IBAction func doneButtonAction(_ sender: UIButton) {
        
        // Get selected country code from array
        let selectedCountryRow = countryPicker.selectedRow(inComponent: 0)
        regionCode = countryCodeArray[selectedCountryRow]
        
        // Reload country news from network
        DataManager.shared.reloadData(from: regionCode)
        
        // Close ViewController
        dismiss(animated: true, completion: nil)
    }

}
