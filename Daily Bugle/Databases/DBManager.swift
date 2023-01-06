//
//  DBManager.swift
//  Daily Bugle
//
//  Created by J Dayasagar on 18/12/22.
//

import Foundation
import SQLite3

class MyConstants {
    static let dbpathConstant = "DailyBugle.sqlite"
}

class DBManager {
    
    private let dbPath: String = MyConstants.dbpathConstant
    private var db: OpaquePointer?
    static let sharedInstance = DBManager()
    
    private init() {
        db = openDatabase()
        createUserTable()
    }
    
    
    func getUserFromQueryStatment(queryStatement: OpaquePointer!) -> UserModel {
        
        let user = UserModel()
    //    user.userId = Int(sqlite3_column_int(queryStatement, 0))
        
        if let emailFromDB = sqlite3_column_text(queryStatement, 1) {
            user.email = String(cString: emailFromDB)
        }
        
        if let nameFromDB = sqlite3_column_text(queryStatement, 0) {
            user.name = String(cString: nameFromDB)
        }
        
        if let mobileFromDB = sqlite3_column_text(queryStatement, 2) {
            user.mobile = String(cString: mobileFromDB)
        }
        
        if let passwordFromDB = sqlite3_column_text(queryStatement, 3) {
            user.password = String(cString: passwordFromDB)
        }
        
        if let addressFromDB = sqlite3_column_text(queryStatement, 5) {
            user.address = String(cString: addressFromDB)
        }
        
        if let stateFromDB = sqlite3_column_text(queryStatement, 6) {
            user.state = String(cString: stateFromDB)
        }
        
        if let pinFromDB = sqlite3_column_text(queryStatement, 4) {
            user.pincode = String(cString: pinFromDB)
        }
        if let profilePicFromDB = sqlite3_column_text(queryStatement, 7) {
            user.profilePic = String(cString: profilePicFromDB)
        }
     //   user.getUserImage()
        return user
    }
    
    
    
    func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        print(fileURL, "This is the fileURL")
        var db: OpaquePointer? = nil
        //This function calls sqlite3_open(), which opens or creates a new database file. If it’s successful, it returns an OpaquePointer, which is a Swift type for C pointers.
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK { //SQLITE_OK is the result code
            print("Successfully opened connection to database at \(dbPath)")
            return db
        } else {
            print("error opening database")
            return nil
        }
    }
    
    
    
    func createUserTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS User(name TEXT, email TEXT PRIMARY KEY, mobilenumber TEXT, password TEXT, pincode TEXT, address TEXT, state TEXT, profilePic TEXT);"
        var createTableStatement: OpaquePointer? = nil
               //sqlite3_prepare_v2() compiles the SQL statement into byte code and returns a status code — an important step before executing arbitrary statements against your database.
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            //runs the compiled statement.
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("User table created.")
            } else {
                print("User table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        //You must always call sqlite3_finalize() on your compiled statement to delete it and avoid resource leaks. Once a statement finalizes, you should never use it again.
        sqlite3_finalize(createTableStatement)
    }
    
    
    
    func insert(user: UserModel) {
        let insertStatementString = "INSERT INTO User(name, email, mobilenumber, password, pincode, address, state, profilePic) VALUES ('\(user.name ?? "")', '\(user.email ?? "")', '\(user.mobile ?? "")', '\(user.password ?? "")', '\(user.pincode ?? "")', '\(user.address ?? "")', '\(user.state ?? "" )','\(user.profilePic ?? "")');"
        
        var insertStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    
    
    func read() -> [UserModel] {
        let queryStatementString = "SELECT * FROM User;"
        var queryStatement: OpaquePointer? = nil
        var persons: [UserModel] = []
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW { //at last we will get SQLITE_DONE status code
                let user = self.getUserFromQueryStatment(queryStatement: queryStatement)
                persons.append(user)
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return persons
    }
    
    
    
    func update(name:String, email:String, mobilenumber:String, password:String, pincode:String, address:String, state:String, profilePic:String) {
        let updateStatementStirng = "UPDATE User set name = '\(name)', password = '\(password)', mobilenumber = '\(mobilenumber)' address = '\(address)', state = '\(state)', pincode = '\(pincode)', profilePic = '\(profilePic)' WHERE email = '\(email)';"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementStirng, -1, &updateStatement, nil) == SQLITE_OK {
            //binding data into delete statement
            sqlite3_bind_text(updateStatement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, (email as NSString).utf8String, -1, nil)
            //sqlite3_bind_int() — implies you’re binding an Int to the statement.
            sqlite3_bind_text(updateStatement, 3, (mobilenumber as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 4, (password as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 5, (pincode as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 6, (address as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 7, (state as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 8, (profilePic as NSString).utf8String, -1, nil)

            //SQLITE_DONE -> status message
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not updated row.")
            }
        } else {
            print("UPDATE statement could not be prepared")
        }

        //release resources to avoid memory leak
        sqlite3_finalize(updateStatement)
    }

    
    
    func getUserDetail(email: String) -> UserModel? {
        let queryStatementString = "SELECT * FROM User where email = '\(email)';"
        var queryStatement: OpaquePointer? = nil
        var user: UserModel?
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW { //at last we will get SQLITE_DONE status code
                user = self.getUserFromQueryStatment(queryStatement: queryStatement)
                break
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return user
    }

   
    
    func drop(){
        let dropQuery = "DROP TABLE User;"
        var dropStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, dropQuery, -1, &dropStatement, nil) == SQLITE_OK{
            if sqlite3_step(dropStatement) == SQLITE_DONE{
                print("Table Droped")
            }else {
                print("Table Not Droped")
            }
        }else {
            print("Drop Query Failed")
        }
    }
    
    
    
    func deleteByEmailID(email: String) {
        let deleteStatementString = "DELETE FROM User WHERE email = '\(email)';"

        var deleteStatement: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            //binding data into delete statement
            sqlite3_bind_text(deleteStatement, 2, (email as NSString).utf8String, -1, nil)            //SQLITE_DONE -> status message
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }

        //release resources to avoid memory leak
        sqlite3_finalize(deleteStatement)
    }
}
