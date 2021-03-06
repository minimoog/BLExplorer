//
//  BLServicesTableViewController.swift
//  BLExplorer
//
//  Created by Antonie Jovanoski on 6/23/16.
//  Copyright © 2016 Antonie Jovanoski. All rights reserved.
//

import UIKit
import CoreBluetooth

extension UITableViewCell {
    func enable(_ on: Bool) {
        self.isUserInteractionEnabled = on
        for view in contentView.subviews {
            view.isUserInteractionEnabled = on
            view.alpha = on ? 1 : 0.5
        }
    }
}

protocol BLServicesDelegate : class {
    func finishedShowing(_ controller: BLServicesTableViewController)
}

class BLServicesTableViewController: UIViewController, BLEManagerDelegate, BLCharacteristicsDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var servicesTableView: UITableView!
    
    var bleManager: BLEManager?
    var services = [CBService]()
    
    weak var delegate: BLServicesDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Services"
        
        servicesTableView?.dataSource = self
        servicesTableView?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let name = bleManager?.connectedPeripheral?.name {
            self.navigationItem.title = "Services of " + name
        }
        
        discoverServices()
    }
    
    func discoverServices() {
        bleManager?.discoverServices {
            if let discoveredServices = self.bleManager?.connectedPeripheral?.services {
                self.services = discoveredServices
            }
            
            self.servicesTableView?.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CharacteristicsSegue" {
            if let characteristicsTableViewController = segue.destination as? BLCharacteristicsTableViewController {
                
                if let indexPath = servicesTableView?.indexPathForSelectedRow {
                    characteristicsTableViewController.bleManager = bleManager
                    characteristicsTableViewController.service = services[(indexPath as NSIndexPath).row]
                    
                    characteristicsTableViewController.delegate? = self
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            
        if isBeingDismissed || isMovingFromParentViewController {
            delegate?.finishedShowing(self)
        }
    }
    
    // --------------- BLCharacteristicsTableViewController-----------
    func finishedShowing(_ controller: BLCharacteristicsTableViewController) {
        bleManager?.delegate = self
    }
    
    // ------------ Table view --------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath)
        
        if let serviceName = StandardServices[services[indexPath.row].uuid]  {
            cell.textLabel?.text = serviceName
        } else {
            cell.textLabel?.text = services[indexPath.row].uuid.uuidString
        }
        
        //disable included services for now services for now
        cell.enable(services[indexPath.row].isPrimary)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "CharacteristicsSegue", sender: self)
    }
    
    // ------------- BLEManagerDelegate ------------
    func didDisconnectPeripheral(_ manager: BLEManager, peripheral: CBPeripheral) {
        let ac = UIAlertController(title: "Disconnected", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        
        if let presenter = ac.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        }
        
        services = []
        servicesTableView?.reloadData()
        
        present(ac, animated: true)
    }
}
