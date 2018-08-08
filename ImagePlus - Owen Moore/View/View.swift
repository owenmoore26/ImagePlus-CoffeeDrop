//
//  MainTableView.swift
//  ImagePlus - Owen Moore
//
//  Created by Ashley Moore on 06/08/2018.
//  Copyright © 2018 Owen Moore. All rights reserved.
//

import UIKit

/* Inside this file would usually be view elements such as custom table view cells, in this example custom cells are not needed as standard cells come with a text label by defaults. I utilise the default cells text label from UITableViewCell rather than create my own.
*/


//MARK: Creating View and UI Elements for cashback POST

var ristrettoTextField: UITextField = {
    let ristrettoTextField = UITextField()
    ristrettoTextField.borderStyle = UITextBorderStyle.roundedRect
    ristrettoTextField.keyboardType = .numberPad
    ristrettoTextField.textColor = .black
    ristrettoTextField.textAlignment = .center
    ristrettoTextField.placeholder = " Ristretto Pod Quantity"
    ristrettoTextField.backgroundColor = .white
    return ristrettoTextField
}()

var exspressoTextField: UITextField = {
    let exspressoTextField = UITextField()
    exspressoTextField.borderStyle = UITextBorderStyle.roundedRect
    exspressoTextField.keyboardType = .numberPad
    exspressoTextField.textColor = .black
    exspressoTextField.textAlignment = .center
    exspressoTextField.placeholder = " Expresso Pod Quantity"
    exspressoTextField.backgroundColor = .white
    return exspressoTextField
}()

var lungoTextField: UITextField = {
    let lungoTextField = UITextField()
    lungoTextField.borderStyle = UITextBorderStyle.roundedRect
    lungoTextField.keyboardType = .numberPad
    lungoTextField.textColor = .black
    lungoTextField.textAlignment = .center
    lungoTextField.placeholder = " Lungo Pod Quantity"
    lungoTextField.backgroundColor = .white
    return lungoTextField
}()

var cashBackTotalLabel: UILabel = {
    let cashBackTotalLabel = UILabel()
    cashBackTotalLabel.text = ""
    cashBackTotalLabel.textAlignment = .center
    cashBackTotalLabel.textColor = .black
    return cashBackTotalLabel
}()

//MARK: Creating View and UI Elements for querying the closest shop

var postcodeTextField: UITextField = {
    let postcodeTextField = UITextField()
    postcodeTextField.borderStyle = UITextBorderStyle.roundedRect
    postcodeTextField.textColor = .black
    postcodeTextField.textAlignment = .center
    postcodeTextField.placeholder = " Enter Postcode"
    postcodeTextField.backgroundColor = .white
    return postcodeTextField
}()

var queryResultsView: UITextView = {
    let queryResultsView = UITextView()
    queryResultsView.isEditable = false
    queryResultsView.isEditable = false
    queryResultsView.textColor = .black
    queryResultsView.text = ""
    queryResultsView.font = UIFont(name: "Avenir-Heavy", size: 24)
    queryResultsView.textAlignment = .center
    return queryResultsView
}()
