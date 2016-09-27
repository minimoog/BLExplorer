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

class BLServicesTableViewController: UITableViewController, BLEManagerDelegate, BLCharacteristicsDelegate {
    var bleManager: BLEManager?
    var services = [CBService]()
    
    weak var delegate: BLServicesDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Services"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        discoverServices()
    }
    
    func discoverServices() {
        bleManager?.discoverServices {
            if let discoveredServices = self.bleManager?.connectedPeripheral?.services {
                self.services = discoveredServices
            }
            
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CharacteristicsSegue" {
            if let characteristicsTableViewController = segue.destination as? BLCharacteristicsTableViewController {
                
                if let indexPath = tableView.indexPathForSelectedRow {
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath)
        
        if let serviceName = StandardServices[services[indexPath.row].uuid]  {
            cell.textLabel?.text = serviceName
        } else {
            cell.textLabel?.text = services[(indexPath as NSIndexPath).row].uuid.uuidString
        }
        
        //disable included services for now services for now
        cell.enable(services[(indexPath as NSIndexPath).row].isPrimary)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "CharacteristicsSegue", sender: self)
    }
    
    // ------------- BLEManagerDelegate ------------
    func didDisconnectPeripheral(_ manager: BLEManager, peripheral: CBPeripheral) {
        
    }
}
