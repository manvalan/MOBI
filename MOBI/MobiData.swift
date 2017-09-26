//
//  MobiData.swift
//  MOBI
//
//  Created by Michele Bigi on 23/09/17.
//  Copyright © 2017 Michele Bigi. All rights reserved.
//

import Foundation
import SQLite3

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
        NodiDict = readNodiSql() //readNodi()
        ReteDict = readReteSql()
        print( NodiDict.self )
        print( ReteDict.self )
        
        return 0
    }
    
    init() {
        ReadInfrastruttura()
        initDB()
        readNodiSql()
    }

    func createTable( db :OpaquePointer , nome: String, formato :String ) -> Int32 {
        var iRes = SQLITE_OK as Int32
        
        iRes = sqlite3_exec(db, "create table if not exists \(nome) ( \(formato) )", nil, nil, nil)
        if  iRes != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        return iRes
    }
    
    func createNodiTable( db :OpaquePointer ) -> Int32 {
        var iRes = SQLITE_OK as Int32
    
        return createTable(db: db, nome: "Nodi" , formato: "id integer primary key autoincrement, label text, track integer, type integer, x float, y float")
    }
    
    func createReteTable( db :OpaquePointer ) -> Int32 {
        
        return createTable(db: db, nome: "Rete" , formato: "id integer primary key autoincrement, start text, end text, lenght float, type integer")
    }
    
    func insertNodiRow( db :OpaquePointer ,id : Int, label: String, track :Int, type:Int, x:Float, y:Float ) -> Int32 {
        var iRes = SQLITE_OK as Int32
        
        var query = String( format: "INSERT INTO Nodi ( id, label, track, type, x, y) VALUES ( \'%i\', \'\(label)\', \'%i\', \'%i\', \'%f\', \'%f\');", id, track, type, x, y )
        
        if sqlite3_exec(db, query, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error insert in table: \(errmsg)")
        }
        
        print( query )
        return iRes
    }
    
    func insertRetiRow( db :OpaquePointer ,id : Int, start: String, end :String, lenght :Double, type:Int ) -> Int32 {
        var iRes = SQLITE_OK as Int32
        
        var query = String( format: "INSERT INTO Rete ( id, start, end, lenght, type ) VALUES ( \'%i\', \'\(start)\', \'\(end)\', \'%.2f\', \'%i\' );", id, lenght, type )
        
        if sqlite3_exec(db, query, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error insert in table: \(errmsg)")
        }
        
        print( query )
        return iRes
    }
    
    func initDB() {
        var db : OpaquePointer
        db = openDatabase(name: "MOBI.sqlite")
       
        createNodiTable(db: db )
        createReteTable(db: db )
        
        var iNodi : Dictionary<String, Any>
        for iNodi in NodiDict {
            insertNodiRow(db: db, id: iNodi["id"] as! Int, label: iNodi["label"] as! String , track: iNodi["track"] as! Int, type: iNodi["type"] as! Int, x: iNodi["x"] as! Float, y: iNodi["y"] as! Float )
        }
        
        var iRete :Dictionary<String, Any >
        for iRete in ReteDict {
            insertRetiRow(db: db, id: iRete["id"] as! Int , start: iRete["start"] as! String, end: iRete["end"] as! String, lenght: iRete["lenght"] as! Double, type: iRete["type"] as! Int )
        }
        
        closeDatabase( db: db )
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
    
    func openDatabase( name: String ) -> OpaquePointer {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent( name )
        var db: OpaquePointer?
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        } else {
            print("opened database")
        }
        return db!
    }
    
    func closeDatabase( db :OpaquePointer ) {
        if sqlite3_close(db) != SQLITE_OK {
            print("error closing database")
        }
    }
    
    func readNodiSql( ) -> [Dictionary<String, Any>]{
        var datasourceDictionary: [Dictionary<String, Any>] = [ Dictionary <String, Any> ]()
        var db: OpaquePointer?
        var statement: OpaquePointer?
        
        db = openDatabase(name: "MOBI.sqlite")
        
        if sqlite3_prepare_v2(db, "select id, label, track, type, x, y from Nodi", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let id = Int( sqlite3_column_int(statement, 0) )
            
            let cString = sqlite3_column_text(statement, 1)
            let label = String(cString: cString!)
            let track = Int( sqlite3_column_int64(statement, 2) )
            let type = Int( sqlite3_column_int64(statement, 3) )
            let x = Float( sqlite3_column_double(statement, 4) )
            let y = Float( sqlite3_column_double(statement, 5) )
            let iNodo = [ "id": id , "label" : label , "track" : track , "type": type , "x":x , "y": y ] as [String : Any]
            datasourceDictionary.append(iNodo )
        }
        
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        closeDatabase( db: db! )
        
        db = nil
        return datasourceDictionary
    }
    
    func readReteSql( ) -> [Dictionary<String, Any>]{
        
        var db: OpaquePointer?
        var statement: OpaquePointer?
        var datasourceDictionary: [Dictionary<String, Any>] = [ Dictionary <String, Any> ]()
        
        db = openDatabase(name: "MOBI.sqlite")
        
        if sqlite3_prepare_v2(db, "select id, start, end, lenght, type from Reti", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let id = Int( sqlite3_column_int(statement, 0) )
            let cString = sqlite3_column_text(statement, 1)
            let start = String(cString: cString!)
            let cString2 = sqlite3_column_text(statement, 2)
            let end = String(cString: cString2!)
            let lenght = Double( sqlite3_column_double(statement, 3) )
            let type = Int( sqlite3_column_int64(statement, 4) )
            
            let iRete = [ "id": id , "start" : start , "end" : end , "lenght": lenght , "type":type ] as [String : Any]
            datasourceDictionary.append( iRete )
        }
        
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        closeDatabase( db: db! )
        
        db = nil
        
        return datasourceDictionary
    }
    func readNodi() -> [Dictionary<String, Any>] {
        return readPList(nameFile: "nodi")
    }
    
    func readRete() -> [Dictionary<String, Any>] {
        return readPList(nameFile: "rete")
    }
    
    
}
