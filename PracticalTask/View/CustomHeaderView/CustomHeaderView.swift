//
//  CustomHeaderView.swift
//  PracticalTask
//
//  Created by Rutvik on 08/01/23.
//

import UIKit

protocol BtnAddCellDelegate{
    func isbtnTapped(section: Int, index : Int)
}

class CustomHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var lblTitleHeader: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    
    var index = -1
    var delegate : BtnAddCellDelegate? = nil
    
    @IBAction func btnAddTapped(_ sender: UIButton) {
        self.index += 1
        self.delegate?.isbtnTapped(section: sender.tag, index: self.index)
    }
}
