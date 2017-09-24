//
//  MobiData.swift
//  MOBI
//
//  Created by Michele Bigi on 23/09/17.
//  Copyright © 2017 Michele Bigi. All rights reserved.
//

import Foundation

class MobiData {
    var TipoNodo = [ "Segmento Linea" ,
                     "Fermata" ,
                     "Stazione minore",
                     "Stazione media",
                     "Stazione principale",
                     "Stazione di testa" ]
        
    public var NodiDict :[Dictionary<String, Any>] = []
    public var ReteDict :[Dictionary<String, Any>] = []
    
    func ReadInfrastruttura() -> Int {
        // Do any additional setup after loading the view.
        NodiDict = readNodi()
        ReteDict = readRete()
        print( NodiDict.self )
        print( ReteDict.self )
        
        return 0
    }
    
    init() {
        ReadInfrastruttura()
    }
    
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
}
