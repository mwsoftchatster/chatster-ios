//
//  ContactDB.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 05/05/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class ContactDB {
    
    // Fetch Contact profile picture url by contact id.
    func getUserProfilePicURL(contactId: Int64) -> (DBError, String?) {
        var err:DBError = .NoError
        var contactProfilePicURL:String? = nil
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, """
                SELECT \(DBConstants.CONTACT_PROFILE_PIC)
                FROM \(DBConstants.TABLE_CONTACT)
                WHERE \(DBConstants.CONTACT_ID)=\(contactId)
                """, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, """
                    SELECT \(DBConstants.CONTACT_PROFILE_PIC)
                    FROM \(DBConstants.TABLE_CONTACT)
                    WHERE \(DBConstants.CONTACT_ID)=\(contactId)
                    """, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    
                    let rawContactProfilePicURL = sqlite3_column_text(stmt, 0)
                    contactProfilePicURL = String(cString:rawContactProfilePicURL!)
                    
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        
        return (err, contactProfilePicURL)
    }
    
    // Fetch Contact name by contact id.
    func getContactNameById(contactId: Int64) -> (DBError, String?) {
        var err:DBError = .NoError
        var contactName:String? = nil
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, """
                SELECT \(DBConstants.CONTACT_NAME)
                FROM \(DBConstants.TABLE_CONTACT)
                WHERE \(DBConstants.CONTACT_ID)=\(contactId)
                """, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, """
                    SELECT \(DBConstants.CONTACT_NAME)
                    FROM \(DBConstants.TABLE_CONTACT)
                    WHERE \(DBConstants.CONTACT_ID)=\(contactId)
                    """, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    
                    let rawContactName = sqlite3_column_text(stmt, 0)
                    contactName = String(cString:rawContactName!)
                    
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        
        return (err, contactName)
    }
    
    // Fetch contact by id.
    func getContactById(contactId: Int64) -> (DBError, Contact?) {
        var err:DBError = .NoError
        var contact:Contact? = nil
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let query = """
                SELECT * FROM \(DBConstants.TABLE_CONTACT)
                WHERE \(DBConstants.CONTACT_ID) =\(contactId)
            """;
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, query, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, query, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    
                    let contactId:Int64 = sqlite3_column_int64(stmt, 0)
                    
                    let rawContactName = sqlite3_column_text(stmt, 1)
                    let contactName = String(cString:rawContactName!)
                    
                    let rawStatusMessage = sqlite3_column_text(stmt, 2)
                    let statusMessage = String(cString:rawStatusMessage!)
                    
                    let rawProfilePic = sqlite3_column_text(stmt, 3)
                    let profilePic = String(cString:rawProfilePic!)
                    
                    let rawContactCreated = sqlite3_column_text(stmt, 5)
                    let contactCreated = String(cString:rawContactCreated!)
                    
                }
                
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        
        return (err, contact)
    }

    // Fetches all the contacts.
    func getAllContacts() -> (DBError, Array<Contact>) {
        var err:DBError = .NoError
        var contacts:Array<Contact> = Array<Contact>()
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let query = "SELECT * FROM \(DBConstants.TABLE_CONTACT)";
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, query, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, query, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                while SQLITE_ROW == result {
                    
                    let contactId:Int64 = sqlite3_column_int64(stmt, 0)
                    
                    let rawContactName = sqlite3_column_text(stmt, 1)
                    let contactName = String(cString:rawContactName!)
                    
                    let rawStatusMessage = sqlite3_column_text(stmt, 2)
                    let statusMessage = String(cString:rawStatusMessage!)
                    
                    let rawProfilePic = sqlite3_column_text(stmt, 3)
                    let profilePic = String(cString:rawProfilePic!)
                    
                    let rawContactCreated = sqlite3_column_text(stmt, 5)
                    let contactCreated = String(cString:rawContactCreated!)
                    
                    // contacts.append(contact)
                    
                    result = sqlite3_step(stmt)
                }
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        return (err, contacts)
    }

    // Fetches all the contacts.
    func getAllContactIds() -> (DBError, Array<Int64>) {
        var err:DBError = .NoError
        var ids:Array<Int64> = Array<Int64>()
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let query = "SELECT \(DBConstants.CONTACT_ID) FROM \(DBConstants.TABLE_CONTACT)";
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, query, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, query, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                while SQLITE_ROW == result {
                    
                    let contactId:Int64 = sqlite3_column_int64(stmt, 0)

                    ids.append(contactId)
                    
                    result = sqlite3_step(stmt)
                }
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        return (err, ids)
    }
    
    // Fetches all the contacts that are in teh same group chat.
    func getAllContactsByGroupChat(groupChatId: String) -> (DBError, Array<Contact>) {
        var err:DBError = .NoError
        var contacts:Array<Contact> = Array<Contact>()
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let query = """
                SELECT * FROM \(DBConstants.TABLE_CONTACT) c
                INNER JOIN \(DBConstants.TABLE_GROUP_CHAT_MEMBER) gcm ON
                c._id=gcm.group_chat_member_id WHERE gcm.group_chat_id LIKE '\(groupChatId)'
                """;
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, query, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, query, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                while SQLITE_ROW == result {
                    
                    let contactId:Int64 = sqlite3_column_int64(stmt, 0)
                    
                    let rawContactName = sqlite3_column_text(stmt, 1)
                    let contactName = String(cString:rawContactName!)
                    
                    let rawStatusMessage = sqlite3_column_text(stmt, 2)
                    let statusMessage = String(cString:rawStatusMessage!)
                    
                    let rawProfilePic = sqlite3_column_text(stmt, 3)
                    let profilePic = String(cString:rawProfilePic!)
                    
                    let rawContactCreated = sqlite3_column_text(stmt, 5)
                    let contactCreated = String(cString:rawContactCreated!)
                    
                    // contacts.append(contact)
                    
                    result = sqlite3_step(stmt)
                }
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        return (err, contacts)
    }

    // Delete contact by id.
    func deleteContactById(contactId:Int64) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let sql = "DELETE FROM \(DBConstants.TABLE_CONTACT) WHERE \(DBConstants.CONTACT_ID) = \(contactId)"
            var result = sqlite3_exec(db, sql, nil, nil, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_exec(db, sql, nil, nil, nil)
            }
            
            if SQLITE_OK == result {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            } else {
                changes = Int(sqlite3_changes(db))
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        
        return (err, changes)
    }
    
    // Updates message status to has been read.
    func updateContacts(contactIds: Array<Int64>) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let sql = """
                UPDATE \(DBConstants.TABLE_MESSAGE)
                SET \(DBConstants.CONTACT_TYPE)=1
                WHERE \(DBConstants.CONTACT_ID) IN(\((contactIds.map{String($0)}).joined(separator: ",")))
            """
            var result = sqlite3_exec(db, sql, nil, nil, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_exec(db, sql, nil, nil, nil)
            }
            
            if SQLITE_OK == result {
                changes = Int(sqlite3_changes(db))
            }
            else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        
        return (err, changes)
    }
    
    // Create new contact.
    func insertContact(contactId: Int64, contactName: String, statusMessage: String) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let sql = """
            INSERT INTO \(DBConstants.TABLE_CONTACT)
                (\(DBConstants.CONTACT_ID),
                \(DBConstants.CONTACT_NAME),
                \(DBConstants.CONTACT_STATUS_MESSAGE))
            VALUES
                (\(contactId),
                '\(contactName)',
                '\(statusMessage)')
            """;
            var result = sqlite3_exec(db, sql, nil, nil, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_exec(db, sql, nil, nil, nil)
            }
            
            if SQLITE_OK == result {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            else {
                changes = Int(sqlite3_changes(db))
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        
        return (err, changes)
    }
    
}
