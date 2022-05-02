//
//  ChatsterDB.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 21/04/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

public enum DBError {
    case NoError
    case NoSuchErrand
    case SQLError(String)
}

let RETRY_LIMIT:Int = 10

class ChatsterDB: NSObject {
    
    var dbIsOpen:Bool = false
    var lastError:Error? = nil
    var dbPath:String = ""
    
    static let sharedDB = ChatsterDB()
    
    private override init() {
        let fileURL = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Chatster.db")
        self.dbPath = fileURL.path
    }
    
    //open db
    func dbOpen() -> OpaquePointer? {
        
        var db:OpaquePointer? = nil
        let result = sqlite3_open(self.dbPath as String, &db)
        
        if SQLITE_OK == result {
            print("Database has been opened")
        } else {
            print("Database could not be opened")
        }
        
        return db
        
    }
    
    //close db
    func dbClose(db:OpaquePointer) -> Int32 {
        return sqlite3_close(db)
    }
    
    func createVersionTable() -> DBError {
        
        var err:DBError = .NoError
        
        if let db = dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_VERSION, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_VERSION, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = self.dbClose(db: db)
            
        }
        
        return err
        
    }
    
    func insertVersion(dbVersion: String) -> DBError {
        
        var err:DBError = .NoError
        
        if let db = dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "INSERT INTO Version (version) VALUES(\(dbVersion))", -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "INSERT INTO Version (version) VALUES(\(dbVersion))", -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = self.dbClose(db: db)
            
        }
        
        return err
        
    }
    
    
    func createUserTable() -> DBError {
        
        var err:DBError = .NoError
        
        if let db = dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_USER, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_USER, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = self.dbClose(db: db)
            
        }
        
        return err
        
    }
    
    func insertDefaultUser() -> DBError {
        
        var err:DBError = .NoError
        
        if let db = dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, DBConstants.INSERT_DEFAULT_USER, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, DBConstants.INSERT_DEFAULT_USER, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = self.dbClose(db: db)
            
        }
        
        return err
        
    }
    
    func createContactTable() -> DBError {
        
        var err:DBError = .NoError
        
        if let db = dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_CONTACT, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_CONTACT, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = self.dbClose(db: db)
            
        }
        
        return err
        
    }
    
    func createChatTable() -> DBError {
        
        var err:DBError = .NoError
        
        if let db = dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_CHAT, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_CHAT, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = self.dbClose(db: db)
            
        }
        
        return err
        
    }
    
    func createGroupChatTable() -> DBError {
        
        var err:DBError = .NoError
        
        if let db = dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_GROUP_CHAT, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_GROUP_CHAT, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = self.dbClose(db: db)
            
        }
        
        return err
        
    }
    
    func createGroupChatMemberTable() -> DBError {
        
        var err:DBError = .NoError
        
        if let db = dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_GROUP_CHAT_MEMBER, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_GROUP_CHAT_MEMBER, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = self.dbClose(db: db)
            
        }
        
        return err
        
    }
    
    func createMessageTable() -> DBError {
        
        var err:DBError = .NoError
        
        if let db = dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_MESSAGE, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_MESSAGE, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = self.dbClose(db: db)
            
        }
        
        return err
        
    }
    
    func createMessageQueueTable() -> DBError {
        
        var err:DBError = .NoError
        
        if let db = dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_MESSAGE_QUEUE, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_MESSAGE_QUEUE, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = self.dbClose(db: db)
            
        }
        
        return err
        
    }
    
    func createGroupMessageQueueTable() -> DBError {
        
        var err:DBError = .NoError
        
        if let db = dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_GROUP_MESSAGE_QUEUE, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_GROUP_MESSAGE_QUEUE, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = self.dbClose(db: db)
            
        }
        
        return err
        
    }
    
    func createRetrievedOfflineMessageUUIDTable() -> DBError {
        
        var err:DBError = .NoError
        
        if let db = dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_RETRIEVED_OFFLINE_MESSAGE_UUID, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_RETRIEVED_OFFLINE_MESSAGE_UUID, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = self.dbClose(db: db)
            
        }
        
        return err
        
    }
    
    func createReceivedOnlineMessageTable() -> DBError {
        
        var err:DBError = .NoError
        
        if let db = dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_RECEIVED_ONLINE_MESSAGE, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_RECEIVED_ONLINE_MESSAGE, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = self.dbClose(db: db)
            
        }
        
        return err
        
    }
    
    func createReceivedOnlineGroupMessageTable() -> DBError {
        
        var err:DBError = .NoError
        
        if let db = dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_RECEIVED_ONLINE_GROUP_MESSAGE, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_RECEIVED_ONLINE_GROUP_MESSAGE, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = self.dbClose(db: db)
            
        }
        
        return err
        
    }
    
    func createOfflineContactResponseTable() -> DBError {
        
        var err:DBError = .NoError
        
        if let db = dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_OFFLINE_CONTACT_RESPONSE, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_OFFLINE_CONTACT_RESPONSE, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = self.dbClose(db: db)
            
        }
        
        return err
        
    }
    
    func createCreatorContactTable() -> DBError {
        
        var err:DBError = .NoError
        
        if let db = dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_CREATOR_CONTACT, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_CREATOR_CONTACT, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = self.dbClose(db: db)
            
        }
        
        return err
        
    }
    
    func createPostsLikedTable() -> DBError {
        
        var err:DBError = .NoError
        
        if let db = dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_POSTS_LIKED, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_POSTS_LIKED, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = self.dbClose(db: db)
            
        }
        
        return err
        
    }
    
    func createUserOneTimeKeyPairTable() -> DBError {
        
        var err:DBError = .NoError
        
        if let db = dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_USER_ONE_TIME_PRE_KEY_PAIR, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_USER_ONE_TIME_PRE_KEY_PAIR, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = self.dbClose(db: db)
            
        }
        
        return err
        
    }
    
    func createGroupOneTimeKeyPairTable() -> DBError {
        
        var err:DBError = .NoError
        
        if let db = dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_GROUP_ONE_TIME_PRE_KEY_PAIR, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, DBConstants.TABLE_CREATE_GROUP_ONE_TIME_PRE_KEY_PAIR, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = self.dbClose(db: db)
            
        }
        
        return err
        
    }
    
}
