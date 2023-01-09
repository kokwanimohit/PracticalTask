//
//  ViewController.swift
//  PracticalTask
//
//  Created by Rutvik on 08/01/23.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackSelectDepartment: UIStackView!
    @IBOutlet weak var txtFSelectDepartment: UITextField!
    
    let pickerView = UIPickerView()
    var pickerDataSource = ["Android","iOS","Web"]
    var tableViewDataSource = [String]()
    var cellAndroidData = [CellData]()
    var cellIOSData = [CellData]()
    var cellWebData = [CellData]()
    var refreshControl = UIRefreshControl()
    
    let userDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        self.setupUI()
        self.checkPreviousData()
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
        
        self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "tableViewCell")
        self.tableView.register(UINib(nibName: "CustomHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "customHeaderView")
        
    }
    
    @objc func refresh(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func checkPreviousData(){
        if let data =  self.userDefaults.value(forKey: Constants.cellAndroidData) as? Data{
           if let cellAndroidData = try? JSONDecoder().decode([CellData].self, from: data) {
               self.cellAndroidData.removeAll()
               self.cellAndroidData = cellAndroidData
           }
        }
        if let data =  self.userDefaults.value(forKey: Constants.celliOSData) as? Data{
           if let cellIOSData = try? JSONDecoder().decode([CellData].self, from: data) {
               self.cellIOSData.removeAll()
               self.cellIOSData = cellIOSData
           }
        }
        if let data =  self.userDefaults.value(forKey: Constants.cellWebData) as? Data{
           if let cellWebData = try? JSONDecoder().decode([CellData].self, from: data) {
               self.cellWebData.removeAll()
               self.cellWebData = cellWebData
           }
        }
        if let data =  self.userDefaults.value(forKey: Constants.pickerDataSource) as? Data{
           if let pickerDataSource = try? JSONDecoder().decode([String].self, from: data) {
               self.pickerDataSource.removeAll()
               self.pickerDataSource = pickerDataSource
           }
        }
        if let data =  self.userDefaults.value(forKey: Constants.tableViewDataSource) as? Data{
           if let tableViewDataSource = try? JSONDecoder().decode([String].self, from: data) {
               self.tableViewDataSource.removeAll()
               self.tableViewDataSource = tableViewDataSource
           }
        }
        DispatchQueue.main.async {
            self.pickerView.reloadAllComponents()
            self.tableView.reloadData()
        }
    }
    
    func setupUI(){
        self.stackSelectDepartment.layer.borderWidth = 1.0
        self.stackSelectDepartment.layer.borderColor = UIColor.gray.cgColor
        
        self.pickerView.backgroundColor = .white

        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancelPicker))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        self.txtFSelectDepartment.delegate = self
        txtFSelectDepartment.inputView =  self.pickerView
        txtFSelectDepartment.inputAccessoryView = toolBar
    
    }
    
    func showInvalidAlert(message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            @unknown default:
                fatalError()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveDataToUserDefaults(){
        if let encoded = try? JSONEncoder().encode(self.cellAndroidData) {
            self.userDefaults.set(encoded, forKey: Constants.cellAndroidData)
        }
        if let encoded = try? JSONEncoder().encode(self.cellIOSData) {
            self.userDefaults.set(encoded, forKey: Constants.celliOSData)
        }
        if let encoded = try? JSONEncoder().encode(self.cellWebData) {
            self.userDefaults.set(encoded, forKey: Constants.cellWebData)
        }
        if let encoded = try? JSONEncoder().encode(self.pickerDataSource) {
            self.userDefaults.set(encoded, forKey: Constants.pickerDataSource)
        }
        if let encoded = try? JSONEncoder().encode(self.tableViewDataSource) {
            self.userDefaults.set(encoded, forKey: Constants.tableViewDataSource)
        }
    }
    
    func maintainDataSource(){
        if self.cellAndroidData.count == 0{
            if let index1 = self.tableViewDataSource.firstIndex(of: Constants.android){
                self.tableViewDataSource.remove(at: index1)
                self.pickerDataSource.append(Constants.android)
            }
        }
        if self.cellIOSData.count == 0{
            if let index1 = self.tableViewDataSource.firstIndex(of: Constants.iOS){
                self.tableViewDataSource.remove(at: index1)
                self.pickerDataSource.append(Constants.iOS)
            }
        }
        if self.cellWebData.count == 0{
            if let index1 = self.tableViewDataSource.firstIndex(of: Constants.web){
                self.tableViewDataSource.remove(at: index1)
                self.pickerDataSource.append(Constants.web)
            }
        }
    }
    
    @objc func donePicker(){
        if self.pickerDataSource.count > 0{
            let selectedValue = self.pickerDataSource[self.pickerView.selectedRow(inComponent: 0)]
//            self.txtFSelectDepartment.text = selectedValue
            self.tableViewDataSource.append(selectedValue)
            if let index = self.pickerDataSource.firstIndex(of: selectedValue){
                self.pickerDataSource.remove(at: index)
                self.pickerView.reloadAllComponents()
            }
            if selectedValue == Constants.android && self.cellAndroidData.count == 0{
                let data1 = CellData.init(section: 0, index: 0, employeeEmail: "", btnSwitch: false)
                self.cellAndroidData.append(data1)
            }else if selectedValue == Constants.iOS && self.cellIOSData.count == 0{
                let data2 = CellData.init(section: 1, index: 0, employeeEmail: "", btnSwitch: false)
                self.cellIOSData.append(data2)
            }else if selectedValue == Constants.web && self.cellWebData.count == 0{
                let data3 = CellData.init(section: 2, index: 0, employeeEmail: "", btnSwitch: false)
                self.cellWebData.append(data3)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        self.view.endEditing(true)
    }
    
    @objc func cancelPicker(){
        self.view.endEditing(true)
    }
    
}
//MARK: - UITextFieldDelegate
extension ViewController : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.pickerDataSource.count > 0 {
            txtFSelectDepartment.inputView =  self.pickerView
        }else {
            self.view.endEditing(true)
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
//MARK: - UITableViewCell, UITableViewDataSource
extension ViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.tableViewDataSource.count > 0{
            tableView.restore()
            return self.tableViewDataSource.count
        }else {
            tableView.setEmptyMessage("Please Select Department")
            return 0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if self.tableViewDataSource[section] == Constants.android{
                return self.cellAndroidData.count
            }else if self.tableViewDataSource[section] == Constants.iOS{
                return self.cellIOSData.count
            }else if self.tableViewDataSource[section] == Constants.web{
                return self.cellWebData.count
            }
        }else if section == 1{
            if self.tableViewDataSource[section] == Constants.android{
                return self.cellAndroidData.count
            }else if self.tableViewDataSource[section] == Constants.iOS{
                return self.cellIOSData.count
            }else if self.tableViewDataSource[section] == Constants.web{
                return self.cellWebData.count
            }
        }else if section == 2{
            if self.tableViewDataSource[section] == Constants.android{
                return self.cellAndroidData.count
            }else if self.tableViewDataSource[section] == Constants.iOS{
                return self.cellIOSData.count
            }else if self.tableViewDataSource[section] == Constants.web{
                return self.cellWebData.count
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! TableViewCell
        
        var data : CellData?
        if indexPath.section == 0{
            if self.tableViewDataSource[indexPath.section] == Constants.android{
                data = self.cellAndroidData[indexPath.row]
            }else if self.tableViewDataSource[indexPath.section] == Constants.iOS{
                data = self.cellIOSData[indexPath.row]
            } else if self.tableViewDataSource[indexPath.section] == Constants.web{
                data = self.cellWebData[indexPath.row]
            }
            cell.txtFEmployeeEmail.text = data?.employeeEmail
            cell.btnSwitch.tag = indexPath.row
            cell.section = indexPath.section
            cell.delegate = self
            cell.btnSwitch.isOn = data?.btnSwitch ?? false
            return cell
        }else if indexPath.section == 1{
            if self.tableViewDataSource[indexPath.section] == Constants.android{
                data = self.cellAndroidData[indexPath.row]
            }else if self.tableViewDataSource[indexPath.section] == Constants.iOS{
                data = self.cellIOSData[indexPath.row]
            } else if self.tableViewDataSource[indexPath.section] == Constants.web{
                data = self.cellWebData[indexPath.row]
            }
            cell.txtFEmployeeEmail.text = data?.employeeEmail
            cell.btnSwitch.tag = indexPath.row
            cell.section = indexPath.section
            cell.delegate = self
            cell.btnSwitch.isOn = data?.btnSwitch ?? false
            return cell
        }else if indexPath.section == 2{
            if self.tableViewDataSource[indexPath.section] == Constants.android{
                data = self.cellAndroidData[indexPath.row]
            }else if self.tableViewDataSource[indexPath.section] == Constants.iOS{
                data = self.cellIOSData[indexPath.row]
            } else if self.tableViewDataSource[indexPath.section] == Constants.web{
                data = self.cellWebData[indexPath.row]
            }
            cell.txtFEmployeeEmail.text = data?.employeeEmail
            cell.btnSwitch.tag = indexPath.row
            cell.section = indexPath.section
            cell.delegate = self
            cell.btnSwitch.isOn = data?.btnSwitch ?? false
            return cell
        }else{
            return UITableViewCell()
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "customHeaderView") as! CustomHeaderView
        headerView.lblTitleHeader.text = self.tableViewDataSource[section]
        headerView.btnAdd.tag = section
        headerView.delegate = self
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

//MARK: - ValueChangedDelegate
extension ViewController : ValueChangedDelegate{
    func btnValueChanged(section: Int, index: Int, btnSwitch: Bool) {
        if section == 0{
            if self.tableViewDataSource[section] == Constants.android{
                self.cellAndroidData[index].btnSwitch = btnSwitch
            }else if self.tableViewDataSource[section] == Constants.iOS{
                self.cellIOSData[index].btnSwitch = btnSwitch
            }else if self.tableViewDataSource[section] == Constants.web{
                self.cellWebData[index].btnSwitch = btnSwitch
            }
        }else if section == 1{
            if self.tableViewDataSource[section] == Constants.android{
                self.cellAndroidData[index].btnSwitch = btnSwitch
            }else if self.tableViewDataSource[section] == Constants.iOS{
                self.cellIOSData[index].btnSwitch = btnSwitch
            }else if self.tableViewDataSource[section] == Constants.web{
                self.cellWebData[index].btnSwitch = btnSwitch
            }
        }else if section == 2{
            if self.tableViewDataSource[section] == Constants.android{
                self.cellAndroidData[index].btnSwitch = btnSwitch
            }else if self.tableViewDataSource[section] == Constants.iOS{
                self.cellIOSData[index].btnSwitch = btnSwitch
            }else if self.tableViewDataSource[section] == Constants.web{
                self.cellWebData[index].btnSwitch = btnSwitch
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        self.saveDataToUserDefaults()
    }
    
    func removeCell(section: Int, index: Int) {
        if section == 0{
            if self.tableViewDataSource[section] == Constants.android{
                self.cellAndroidData.remove(at: index)
            }else if self.tableViewDataSource[section] == Constants.iOS{
                self.cellIOSData.remove(at: index)
            }else if self.tableViewDataSource[section] == Constants.web{
                self.cellWebData.remove(at: index)
            }
            self.maintainDataSource()
        }else if section == 1{
            if self.tableViewDataSource[section] == Constants.android{
                self.cellAndroidData.remove(at: index)
            }else if self.tableViewDataSource[section] == Constants.iOS{
                self.cellIOSData.remove(at: index)
            }else if self.tableViewDataSource[section] == Constants.web{
                self.cellWebData.remove(at: index)
            }
            self.maintainDataSource()
        }else if section == 2{
            if self.tableViewDataSource[section] == Constants.android{
                self.cellAndroidData.remove(at: index)
            }else if self.tableViewDataSource[section] == Constants.iOS{
                self.cellIOSData.remove(at: index)
            }else if self.tableViewDataSource[section] == Constants.web{
                self.cellWebData.remove(at: index)
            }
            self.maintainDataSource()
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        self.saveDataToUserDefaults()
    }
    
    func changed(section: Int, index: Int, text: String, btnSwitch: Bool) {
        if section == 0{
            let isValidEmail = isValidEmailAddress(emailAddressString: text)
            if isValidEmail{
                self.checkIfEmailAvailable(text: text, section: section, index: index)
            }else{
                self.showInvalidAlert(message: "Invalid Email")
            }
            if self.tableViewDataSource[section] == Constants.android{
                self.cellAndroidData[index].btnSwitch = btnSwitch
            }else if self.tableViewDataSource[section] == Constants.iOS{
                self.cellIOSData[index].btnSwitch = btnSwitch
            }else if self.tableViewDataSource[section] == Constants.web{
                self.cellWebData[index].btnSwitch = btnSwitch
            }
        }else if section == 1{
            let isValidEmail = isValidEmailAddress(emailAddressString: text)
            if isValidEmail{
                self.checkIfEmailAvailable(text: text, section: section, index: index)
            }else{
                self.showInvalidAlert(message: "Invalid Email")
            }
            if self.tableViewDataSource[section] == Constants.android{
                self.cellAndroidData[index].btnSwitch = btnSwitch
            }else if self.tableViewDataSource[section] == Constants.iOS{
                self.cellIOSData[index].btnSwitch = btnSwitch
            }else if self.tableViewDataSource[section] == Constants.web{
                self.cellWebData[index].btnSwitch = btnSwitch
            }
        }else if section == 2{
            let isValidEmail = isValidEmailAddress(emailAddressString: text)
            if isValidEmail{
                self.checkIfEmailAvailable(text: text, section: section, index: index)
            }else{
                self.showInvalidAlert(message: "Invalid Email")
            }
            if self.tableViewDataSource[section] == Constants.android{
                self.cellAndroidData[index].btnSwitch = btnSwitch
            }else if self.tableViewDataSource[section] == Constants.iOS{
                self.cellIOSData[index].btnSwitch = btnSwitch
            }else if self.tableViewDataSource[section] == Constants.web{
                self.cellWebData[index].btnSwitch = btnSwitch
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        self.saveDataToUserDefaults()
    }
    
    func checkIfEmailAvailable(text: String,section : Int, index : Int){
        if self.tableViewDataSource[section] == Constants.android{
            var isAlredyEmail = false
            for x in self.cellAndroidData{
                if x.employeeEmail == text{
                    isAlredyEmail = true
                }
            }
            if isAlredyEmail{
                self.showInvalidAlert(message: "Email Already Used")
            }else{
                self.cellAndroidData[index].employeeEmail = text
            }
        }else if self.tableViewDataSource[section] == Constants.iOS{
            var isAlredyEmail = false
            for x in self.cellIOSData{
                if x.employeeEmail == text{
                    isAlredyEmail = true
                }
            }
            if isAlredyEmail{
                self.showInvalidAlert(message: "Email Already Used")
            }else{
                self.cellIOSData[index].employeeEmail = text
            }
        }else if self.tableViewDataSource[section] == Constants.web{
            var isAlredyEmail = false
            for x in self.cellWebData{
                if x.employeeEmail == text{
                    isAlredyEmail = true
                }
            }
            if isAlredyEmail{
                self.showInvalidAlert(message: "Email Already Used")
            }else{
                self.cellWebData[index].employeeEmail = text
            }
        }
    }
}

//MARK: - BtnAddCellDelegate
extension ViewController : BtnAddCellDelegate{
    func isbtnTapped(section: Int, index: Int) {
        var data : CellData?
        if section == 0{
            if self.tableViewDataSource[section] == Constants.android{
                data = CellData.init(section: section, index: index, employeeEmail: "", btnSwitch: false)
                self.cellAndroidData.append(data!)
            }else if self.tableViewDataSource[section] == Constants.iOS{
                data = CellData.init(section: section, index: index, employeeEmail: "", btnSwitch: false)
                self.cellIOSData.append(data!)
            }else if self.tableViewDataSource[section] == Constants.web{
                data = CellData.init(section: section, index: index, employeeEmail: "", btnSwitch: false)
                self.cellWebData.append(data!)
            }
        }else if section == 1{
            if self.tableViewDataSource[section] == Constants.android{
                data = CellData.init(section: section, index: index, employeeEmail: "", btnSwitch: false)
                self.cellAndroidData.append(data!)
            }else if self.tableViewDataSource[section] == Constants.iOS{
                data = CellData.init(section: section, index: index, employeeEmail: "", btnSwitch: false)
                self.cellIOSData.append(data!)
            }else if self.tableViewDataSource[section] == Constants.web{
                data = CellData.init(section: section, index: index, employeeEmail: "", btnSwitch: false)
                self.cellWebData.append(data!)
            }
        }else if section == 2{
            if self.tableViewDataSource[section] == Constants.android{
                data = CellData.init(section: section, index: index, employeeEmail: "", btnSwitch: false)
                self.cellAndroidData.append(data!)
            }else if self.tableViewDataSource[section] == Constants.iOS{
                data = CellData.init(section: section, index: index, employeeEmail: "", btnSwitch: false)
                self.cellIOSData.append(data!)
            }else if self.tableViewDataSource[section] == Constants.web{
                data = CellData.init(section: section, index: index, employeeEmail: "", btnSwitch: false)
                self.cellWebData.append(data!)
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        self.saveDataToUserDefaults()
    }
}

//MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension ViewController : UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerDataSource[row]
    }
}
