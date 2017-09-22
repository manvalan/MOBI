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
    @IBOutlet weak var ReteTable: NSTableView!
    
    var TipoNodo = [ "Segmento Linea" ,
                     "Fermata" ,
                     "Stazione minore",
                     "Stazione media",
                     "Stazione principale",
                     "Stazione di testa" ]
    
    @IBOutlet weak var NodiTableView: NSTableView!
    
    var NodiDict :[Dictionary<String, Any>] = []
    var ReteDict :[Dictionary<String, Any>] = []
    
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
    
    func readRete() -> [Dictionary<String, Any>] {
        return readPList(nameFile: "rete")
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if( tableView.identifier?.rawValue == "NodiTable" ) {
            return NodiDict.count
        }
        if( tableView.identifier?.rawValue == "ReteTable" ) {
            return ReteDict.count
        }
        return 0;
    }
    
    func numberOfRowsInTableView(aTableView: NSTableView!) -> Int {
        return NodiDict.count
    }
    
    
    func intInCell( cell :NSTableCellView, cellVal : Int ) -> NSTableCellView {
        cell.textField!.stringValue = String( format:"%i", cellVal )
        return cell;
    }
    
    func textInCell( cell :NSTableCellView, cellVal : String ) -> NSTableCellView {
        cell.textField!.stringValue = cellVal
        return cell;
    }
    
    func cellSetText(_ TableView: NSTableView, cellID: String , cellText : String ) -> NSTableCellView {
        
        let cell = TableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellID), owner: self) as! NSTableCellView
        cell.textField!.stringValue = cellText
        return cell
    }
    
    func tableView(_ tableView: NSTableView, viewFor viewForTableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        
        var cell = ( tableView.identifier?.rawValue == "NodiTable"  ) ? tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "IDCell"), owner: self) as! NSTableCellView : tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ReteIDCell"), owner: self) as! NSTableCellView
        
        
        if( tableView.identifier?.rawValue == "NodiTable" ) {
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "IDCell"), owner: self) as! NSTableCellView
            
            if (viewForTableColumn?.identifier.rawValue == "IDColonna") {
                let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "IDCell"), owner: self) as! NSTableCellView
                var idNodo = NodiDict[row]
                let idNodoVal = idNodo["id"] as! Int
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
        }
        if( tableView.identifier?.rawValue == "ReteTable" ) {
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ReteIDCell"), owner: self) as! NSTableCellView
            
            if (viewForTableColumn?.identifier.rawValue == "ReteIDColonna") {
                let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ReteIDCell"), owner: self) as! NSTableCellView
                var idRete = ReteDict[row]
                let idReteVal = idRete["id"] as! Int
                cell.textField!.stringValue = String( format:"%2i", idReteVal )
                return cell;
            }
            if (viewForTableColumn?.identifier.rawValue == "ReteStartColonna") {
                var cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ReteStartCell"), owner: self) as! NSTableCellView
                var idRete = ReteDict[row]
                cell.textField!.stringValue = idRete["start"] as! String
                return cell;
            }
            if (viewForTableColumn?.identifier.rawValue == "ReteEndColonna") {
                var cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ReteEndCell"), owner: self) as! NSTableCellView
                var idRete = ReteDict[row]
                cell.textField!.stringValue = idRete["end"] as! String
                return cell;
            }
            if (viewForTableColumn?.identifier.rawValue == "ReteLenghtColonna") {
                var cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ReteLenghtCell"), owner: self) as! NSTableCellView
                var idRete = ReteDict[row]
                var idNodoVal = idRete["lenght"] as! Double
                cell.textField!.stringValue = String( format:"%f", idNodoVal )
                return cell;
            }
            if (viewForTableColumn?.identifier.rawValue == "ReteTypeColonna") {
                var cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ReteTypeCell"), owner: self) as! NSTableCellView
                var idRete = ReteDict[row]
                var idNodoVal = idRete["type"] as! Int
                cell.textField!.stringValue = String( format:"%2i", idNodoVal )
                return cell;
            }
            return cell
        }
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NodiDict = readNodi()
        ReteDict = readRete()
        print( NodiDict.self )
        print( ReteDict.self )
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
}

