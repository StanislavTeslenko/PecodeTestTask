//
//  NewsSettingsViewController.swift
//  TestTask
//
//  Created by Stanislav Teslenko on 13.04.2021.
//

import UIKit

class NewsSettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    private let countryCodeArray = ["ae","ar","at","au","be","bg","br","ca","cn","de","fr","gb","jp","nl","pl","ua","us"]
    
    private let countryNameArray = ["United Arab Emirates", "Argentina", "Austria", "Australia", "Belgium", "Bulgaria", "Brazil", "Canada", "China", "Germany", "France", "United Kingdom", "Japan", "Netherlands", "Poland", "Ukraine", "USA"]
    
    private let categoryArray = ["general", "business", "entertainment", "health", "science", "sports", "technology"]
    
    private var regionCode: String = ""
    private var category: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Load start values to pickers
        loadPickersData()
    }
    
    private func loadPickersData() {
        
        // Get pickers data from manager
        let pickersData = DataManager.shared.getRequestParameters()
        regionCode = pickersData.country
        category = pickersData.category
        
        // Get country index from array and select Picker's position
        if let index = countryCodeArray.firstIndex(where: {$0 == regionCode}) {
            countryPicker.selectRow(index, inComponent:0, animated:false)
        }
        
        // Get category index from array and select Picker's position
        if let index = categoryArray.firstIndex(where: {$0 == category}) {
            categoryPicker.selectRow(index, inComponent:0, animated:false)
        }
        
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == countryPicker {
            return countryCodeArray.count
        } else {
            return categoryArray.count
        }
    }
    
    // MARK: - UIPickerViewDelegate

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == countryPicker {
            return countryNameArray[row]
        } else {
            return categoryArray[row]
        }
        
    }
    
    // MARK: - Actions
    
    @IBAction func doneButtonAction(_ sender: UIButton) {
        
        // Get selected country code from array
        let selectedCountryRow = countryPicker.selectedRow(inComponent: 0)
        regionCode = countryCodeArray[selectedCountryRow]
        
        // Get selected cathegory from array
        let selectedCathegoryRow = categoryPicker.selectedRow(inComponent: 0)
        category = categoryArray[selectedCathegoryRow]
        
        // Reload country news from network
        DataManager.shared.reloadData(from: regionCode, category: category)
        
        // Close ViewController
        dismiss(animated: true, completion: nil)
    }

}
