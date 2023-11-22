//
//  DBHelper.swift
//  CryptoNews
//
//  Created by Alexey Kurto on 14.11.23.
//

import UIKit
import SQLite3

class DBHelper {
    init() {
        db = openDatabase()
        createWatchlistTable()
    }

    let dbPath: String = "crypto.sqlite"
    var db: OpaquePointer?

    func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            //debugPrint("error opening database")
            return nil
        } else {
            debugPrint("Successfully opened connection to database at \(dbPath)")
            debugPrint(fileURL.path)
            sqlite3_exec(db, "PRAGMA foreign_keys = on", nil, nil, nil)
            return db
        }
    }
    
    func closeDatabase() {
        if db != nil {
            if sqlite3_close(db!) != SQLITE_OK {
                //debugPrint("error closing database")
            } else {
                db = nil
                //debugPrint("Successfully closed connection to database")
            }
        }
    }
    
    func createWatchlistTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS watchlistTable (currencyID INTEGER,currencyInfo TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                //debugPrint("Banner table created.")
            } else {
                //debugPrint("Banner table could not be created.")
            }
        } else {
            //debugPrint("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insertDataInWatchlistTable(currencyID: Int, currencyInfo: String) {
        let insertStatementString = "INSERT INTO watchlistTable (currencyID, currencyInfo) VALUES (?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(currencyID))
            sqlite3_bind_text(insertStatement, 2, (currencyInfo as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                //debugPrint("Successfully inserted row.")
            } else {
                //debugPrint("Could not insert row.")
            }
        } else {
            //debugPrint("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func readFromWatchlistTable() -> [[String : Any]] {
        let queryStatementString = "SELECT * FROM watchlistTable;"
        var queryStatement: OpaquePointer? = nil
        var arrCurrency = [[String : Any]]()
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            let columnCount = sqlite3_column_count(queryStatement)
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                var tmpDic = [String : Any]()
                for i in 0...columnCount - 1 {
                    let columnName = String(describing: String(cString: sqlite3_column_name(queryStatement, i)))
                    switch (sqlite3_column_type(queryStatement, i)) {
                    case SQLITE_NULL:
                        tmpDic[columnName] = ""
                        break
                    case SQLITE_TEXT:
                        tmpDic[columnName] = String(describing: String(cString: sqlite3_column_text(queryStatement, i)))
                        break
                    case SQLITE_INTEGER:
                        tmpDic[columnName] = sqlite3_column_int(queryStatement, i)
                        break
                    case SQLITE_FLOAT:
                        tmpDic[columnName] = sqlite3_column_double(queryStatement, i)
                        break
                    default:
                        tmpDic[columnName] = ""
                        break
                    }
                }
                
                arrCurrency.append(tmpDic)
            }
        } else {
            //debugPrint("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return arrCurrency
    }
    
    func isCurrencyWatchlisted(currencyID: Int) -> Bool {
        let queryStatementString = "SELECT * FROM watchlistTable WHERE currencyID='\(currencyID)';"
        var queryStatement: OpaquePointer? = nil
        var arrCurrencyID: [Int32] = [Int32]()
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                arrCurrencyID.append(sqlite3_column_int(queryStatement, 1))
            }
        } else {
            //debugPrint("SELECT statement could not be prepared")
        }
        
        sqlite3_finalize(queryStatement)
        if arrCurrencyID.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    func deleteDataFromWatchlistTableWithCurrencyID(currencyID: Int) {
        let deleteStatementStirng = "DELETE FROM main.watchlistTable WHERE currencyID='\(currencyID)';"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                //debugPrint("Successfully deleted row.")
            } else {
                //debugPrint("Could not delete row.")
            }
        } else {
            //debugPrint("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    func deleteAllDataFromWatchlistTable() {
        let deleteStatementStirng = "DELETE FROM main.watchlistTable;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                //debugPrint("Successfully deleted row.")
            } else {
                //debugPrint("Could not delete row.")
            }
        } else {
            //debugPrint("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
}
