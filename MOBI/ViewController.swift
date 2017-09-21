//
//  ViewController.swift
//  MOBI
//
//  Created by Michele Bigi on 20/09/17.
//  Copyright © 2017 Michele Bigi. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var NodiTable: NSTableView!
    
    var dipendenti = [
        "Giuseppe" : 4000.55,
        "Matteo" : 2500.00,
        "Delia" : 3675.50
    ]
    
    var TipoNodo = [ "Segmento Linea" ,
                     "Fermata" ,
                     "Stazione minore",
                     "Stazione media",
                     "Stazione principale",
                     "Stazione di testa" ]

    @IBOutlet weak var NodiTableView: NSTableView!
    
    var NodiDict :[Dictionary<String, Any>] = []
    
    func readPList( nameFile: String ) -> [Dictionary<String, Any>] {
        
        //var dict :NSDictionary
        var datasourceDictionary: [Dictionary<String, Any>]? = nil
        //let path = Bundle.main.path(forResource: nameFile, ofType: "plist")
        
        
        if let fileUrl = Bundle.main.url(forResource: nameFile, withExtension: "plist"),
            let data = try? Data(contentsOf: fileUrl) {
            
            if let result = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [[String: Any]] { // [String: Any] which ever it is
                
                datasourceDictionary = result!
                //print(datasourceDictionary.self)
                
                return datasourceDictionary!
            }
        }
        return datasourceDictionary!
        
    }
    
    func readNodi() -> [Dictionary<String, Any>] {
        return readPList(nameFile: "nodi")
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return NodiDict.count
    }
    
    func numberOfRowsInTableView(aTableView: NSTableView!) -> Int {
        return NodiDict.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor viewForTableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        var cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "IDCell"), owner: self) as! NSTableCellView
        
        if (viewForTableColumn?.identifier.rawValue == "IDColonna") {
            var cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "IDCell"), owner: self) as! NSTableCellView
            var idNodo = NodiDict[row]
            var idNodoVal = idNodo["id"] as! Int
            cell.textField!.stringValue = String( format:"%2i", idNodoVal )
            return cell;
        }
        
        if (viewForTableColumn?.identifier.rawValue == "LabelColonna") {
            var cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "LabelCell"), owner: self) as! NSTableCellView
            var idNodo = NodiDict[row]
            cell.textField!.stringValue = idNodo["label"] as! String
            return cell;
        }
        if (viewForTableColumn?.identifier.rawValue == "TipoColonna") {
            var cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TipoCell"), owner: self) as! NSTableCellView
            var idNodo = NodiDict[row]
            var nodoTipo = idNodo["type"] as! Int
            cell.textField!.stringValue = TipoNodo[ nodoTipo ] as! String
            return cell;
        }
        if (viewForTableColumn?.identifier.rawValue == "TrackColonna") {
            var cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TrackCell"), owner: self) as! NSTableCellView
            var idNodo = NodiDict[row]
            var idNodoVal = idNodo["track"] as! Int
            cell.textField!.stringValue = String( format:"%2i", idNodoVal )
            return cell;
        }
        if (viewForTableColumn?.identifier.rawValue == "XColonna") {
            var cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "XCell"), owner: self) as! NSTableCellView
            var idNodo = NodiDict[row]
            var idNodoVal = idNodo["x"] as! Int
            cell.textField!.stringValue = String( format:"%2i", idNodoVal )
            return cell;
        }
        if (viewForTableColumn?.identifier.rawValue == "YColonna") {
            var cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "YCell"), owner: self) as! NSTableCellView
            var idNodo = NodiDict[row]
            var idNodoVal = idNodo["y"] as! Int
            cell.textField!.stringValue = String( format:"%2i", idNodoVal )
            return cell;
        }
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NodiDict = readNodi()
        print( NodiDict.self )
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

