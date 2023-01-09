//
//  TableViewCell.swift
//  PracticalTask
//
//  Created by Rutvik on 08/01/23.
//

import UIKit

protocol ValueChangedDelegate{
    func changed(section: Int, index: Int, text: String, btnSwitch: Bool)
    func btnValueChanged(section: Int, index: Int,btnSwitch: Bool)
    func removeCell(section: Int, index: Int)
}

class TableViewCell: UITableViewCell {

    @IBOutlet weak var txtFEmployeeEmail: UITextField!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var btnSwitch: UISwitch!
    
    var section  = 0
    var delegate : ValueChangedDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.txtFEmployeeEmail.delegate = self
    }
    
    override func prepareForReuse() {
        txtFEmployeeEmail.text = ""
        btnSwitch.isOn = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btnSwitchTapped(_ sender: UISwitch) {
        self.delegate?.btnValueChanged(section: self.section, index: self.btnSwitch.tag, btnSwitch: self.btnSwitch.isOn)

    }
    @IBAction func btnRemoveTapped(_ sender: UIButton) {
        self.delegate?.removeCell(section: self.section, index: self.btnSwitch.tag)
    }
}
//MARK: - UITextFieldDelegate
extension TableViewCell : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
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
        if let text = textField.text{
            self.delegate?.changed(section: self.section, index: self.btnSwitch.tag, text: text, btnSwitch: self.btnSwitch.isOn)
        }
        return true
    }
}
