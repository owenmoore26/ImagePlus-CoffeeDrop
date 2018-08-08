//
//  MainViewController.swift
//  ImagePlus - Owen Moore
//
//  Created by Ashley Moore on 06/08/2018.
//  Copyright © 2018 Owen Moore. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON
import PureLayout

class mainNavController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    //MARK: View Did Load
    
    override func viewDidLoad() {
        
        title = "Coffee Drop"
        
        getData()
        
        setupBarButtonItems()
        setupTableView()
        setupSearchView()
        setupCashBackView()
        searchView.isHidden = true
        cashBackView.isHidden = true
        setupContraints()
    }
    
    // MARK: Creating TableView + MapView & Reuse identifier
    
    let cellID = "Cell"
    
    var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    let mapView = MKMapView()
    
    //MARK: Creating View and UI Elements for querying the closest shop
    
    var searchView: UIView = {
        let searchView = UIView()
        searchView.backgroundColor = .white
        return searchView
    }()
    
    lazy var searchButton: UIButton = {
        let searchButton = UIButton()
        searchButton.setTitle("Find Nearest Store", for: .normal)
        searchButton.setTitleColor(.blue, for: .normal)
        searchButton.addTarget(self, action: #selector(queryPostcode), for: .touchUpInside)
        return searchButton
    }()
    
    lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.red, for: .normal)
        cancelButton.addTarget(self, action: #selector(dismissSearchView), for: .touchUpInside)
        return cancelButton
    }()
    
    //MARK: Creating View and UI Elements for cashback POST
    
    var cashBackView: UIView = {
        let cashBackView = UIView()
        cashBackView.backgroundColor = .white
        return cashBackView
    }()
    
    lazy var cashBackCancelButton: UIButton = {
        let cashBackCancelButton = UIButton()
        cashBackCancelButton.setTitle("Cancel", for: .normal)
        cashBackCancelButton.setTitleColor(.red, for: .normal)
        cashBackCancelButton.addTarget(self, action: #selector(dismissCashBackView), for: .touchUpInside)
        return cashBackCancelButton
    }()
    
    lazy var cashBackSearchButton: UIButton = {
        let cashBackSearchButton = UIButton()
        cashBackSearchButton.setTitle("Calculate Cashback", for: .normal)
        cashBackSearchButton.setTitleColor(.blue, for: .normal)
        cashBackSearchButton.addTarget(self, action: #selector(queryCashBack), for: .touchUpInside)
        return cashBackSearchButton
    }()
    
    //MARK: Setup Search View
    
    func setupSearchView() {
        view.addSubview(searchView)
        searchView.addSubview(cancelButton)
        searchView.addSubview(postcodeTextField)
        searchView.addSubview(searchButton)
        searchView.addSubview(queryResultsView)
    }
    
    func setupCashBackView() {
        view.addSubview(cashBackView)
        cashBackView.addSubview(ristrettoTextField)
        cashBackView.addSubview(exspressoTextField)
        cashBackView.addSubview(lungoTextField)
        cashBackView.addSubview(cashBackSearchButton)
        cashBackView.addSubview(cashBackCancelButton)
        cashBackView.addSubview(cashBackTotalLabel)
    }
    
    //MARK: Handle Display for SearchView & CashBackView
    
    @objc func handleSearch(sender: UIBarButtonItem) {
        if searchView.isHidden == true {
            searchView.isHidden = false
        }
    }
    
    @objc func handleCashback(sender: UIBarButtonItem) {
        if searchView.isHidden == true && cashBackView.isHidden == true {
            cashBackView.isHidden = false
        }
    }
    
    //MARK: Dismiss SearchView & CashBackView
    
    @objc func dismissSearchView() {
        searchView.isHidden = true
        postcodeTextField.text = ""
        queryResultsView.text = ""
        searchView.endEditing(true)
    }
    
    @objc func dismissCashBackView() {
        cashBackView.isHidden = true
        ristrettoTextField.text = ""
        exspressoTextField.text = ""
        lungoTextField.text = ""
        cashBackTotalLabel.text = ""
        cashBackView.endEditing(true)
    }
    
    //MARK: Query user entered postcode
    
    @objc func queryPostcode() {
        
        if postcodeTextField.text == "" {
            
            let alert = UIAlertController(title: "Please enter a postcode", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            storePostcodeArray.append(postcodeTextField.text!)
            NetworkingController().query()
            storePostcodeArray.removeAll()
            searchView.endEditing(true)
            
            if closestShop.count == 0 {
                
                let alert = UIAlertController(title: "Please format postcode", message: "E.G CV128NN not CV12 8NN", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                queryResultsView.text = "Closest Shop is: " + closestShop[0] + " " + closestShop[1] + ", " + closestShop[2] + ", " + closestShop[3]
                closestShop.removeAll()
            }
        }
    }
    
    //MARK: Query cashback POST
    
    @objc func queryCashBack() {
        
        if ristrettoTextField.text == "" || exspressoTextField.text == "" || lungoTextField.text == ""{
            
            let alert = UIAlertController(title: "Fields must not be blank", message: "Enter 0 for no pods", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            podQuantityArray.append(contentsOf: [ristrettoTextField.text!, exspressoTextField.text!, lungoTextField.text!])
            NetworkingController().postRequest()
            
            podQuantityArray.removeAll()
            cashBackView.endEditing(true)
        }
    }
    
    //MARK: Setup Right Bar Button Item
    
    func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"Search"), style: .plain, target: self, action: #selector(handleSearch))
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"Cashback"), style: .plain, target: self, action: #selector(handleCashback))
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    //MARK: Get Data
    
    func getData() {
        for i in 0...3 {
            print(i)
            NetworkingController().parse()
            setupMap()
        }
    }
    
    //MARK: Setup MapView
    
    func setupMap(){

        mapView.autoSetDimension(.height, toSize: 300)
//        mapView.autoSetDimension(.width, toSize: view.frame.size.width)
        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        for locations in coffeeDropDataArray {
            let annotation = MKPointAnnotation()
            annotation.title = locations.locationName
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(locations.latitude), longitude: CLLocationDegrees(locations.longitude))
            mapView.addAnnotation(annotation)
        }
        view.addSubview(mapView)
    }
    
    //MARK: Setup TableView
    
    func setupTableView() {
        
//        tableView.autoSetDimension(.height, toSize: 300)
//        tableView.autoSetDimension(.width, toSize: view.frame.size.width)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coffeeDropDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        cell.textLabel?.text = coffeeDropDataArray[indexPath.row].locationName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tempOpeningTimes.removeAll()
        tableView.deselectRow(at: indexPath, animated: true)
        
        let times = coffeeDropDataArray[indexPath.row].openingTimes

        var n = 0
        for i in 0...6 {
            print(i)
            let day = times[n]
            let open = times[n+1]
            let close = times[n+2]
            let createTimes = day + " " + open + " - " + close
            tempOpeningTimes.append(createTimes)
            n=n+3
        }
        
        let clickThroughController = ClickThroughViewController()
        self.navigationController?.pushViewController(clickThroughController, animated: true)
    }
    
    //MARK: Setup Contraints
    
    func setupContraints() {
        
        // MainView
        
        mapView.autoPinEdge(toSuperviewEdge: .left)
        mapView.autoPinEdge(toSuperviewEdge: .right)
        mapView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        
        tableView.autoPinEdge(toSuperviewEdge: .left)
        tableView.autoPinEdge(toSuperviewEdge: .right)
        tableView.autoPinEdge(toSuperviewEdge: .bottom)
        tableView.autoPinEdge(.top, to: .bottom, of: mapView)
        
        // Postal Query View
        
        searchView.autoPinEdgesToSuperviewEdges()
        cashBackView.autoPinEdgesToSuperviewEdges()

        postcodeTextField.autoPinEdge(toSuperviewEdge: .left)
        postcodeTextField.autoPinEdge(toSuperviewEdge: .right)
        postcodeTextField.autoPinEdge(.top, to: .top, of: searchView, withOffset: 120)
        
        searchButton.autoPinEdge(toSuperviewEdge: .left)
        searchButton.autoPinEdge(toSuperviewEdge: .right)
        searchButton.autoPinEdge(.top, to: .top, of: postcodeTextField, withOffset: 40)
        
        cancelButton.autoPinEdge(toSuperviewEdge: .left)
        cancelButton.autoPinEdge(toSuperviewEdge: .right)
        cancelButton.autoPinEdge(.top, to: .top, of: searchButton, withOffset: 100)
        
        queryResultsView.autoPinEdge(toSuperviewEdge: .left)
        queryResultsView.autoPinEdge(toSuperviewEdge: .right)
        queryResultsView.autoPinEdge(.top, to: .top, of: cancelButton, withOffset: 100)
        queryResultsView.autoPinEdge(toSuperviewEdge: .bottom)
        
        // Cashback View
        
        ristrettoTextField.autoPinEdge(toSuperviewEdge: .left)
        ristrettoTextField.autoPinEdge(toSuperviewEdge: .right)
        ristrettoTextField.autoPinEdge(.top, to: .top, of: searchView, withOffset: 120)
        
        exspressoTextField.autoPinEdge(toSuperviewEdge: .left)
        exspressoTextField.autoPinEdge(toSuperviewEdge: .right)
        exspressoTextField.autoPinEdge(.top, to: .top, of: ristrettoTextField, withOffset: 50)
 
        lungoTextField.autoPinEdge(toSuperviewEdge: .left)
        lungoTextField.autoPinEdge(toSuperviewEdge: .right)
        lungoTextField.autoPinEdge(.top, to: .top, of: exspressoTextField, withOffset: 50)
        
        cashBackSearchButton.autoPinEdge(toSuperviewEdge: .left)
        cashBackSearchButton.autoPinEdge(toSuperviewEdge: .right)
        cashBackSearchButton.autoPinEdge(.top, to: .top, of: lungoTextField, withOffset: 40)
        
        cashBackCancelButton.autoPinEdge(toSuperviewEdge: .left)
        cashBackCancelButton.autoPinEdge(toSuperviewEdge: .right)
        cashBackCancelButton.autoPinEdge(.top, to: .top, of: cashBackSearchButton, withOffset: 100)
        
        cashBackTotalLabel.autoPinEdge(toSuperviewEdge: .left)
        cashBackTotalLabel.autoPinEdge(toSuperviewEdge: .right)
        cashBackTotalLabel.autoPinEdge(.top, to: .top, of: cashBackCancelButton, withOffset: 100)
    }
}
