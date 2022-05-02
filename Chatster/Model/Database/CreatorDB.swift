//
//  CreatorDB.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 05/05/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class CreatorDB {
    
    // Create new like for creator post with uuid.
    func insertCreatorPostIsLiked(uuid: String) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let sql = """
            INSERT INTO \(DBConstants.TABLE_CREATOR_POSTS_LIKED)
                (\(DBConstants.CREATOR_POST_UUID),
                \(DBConstants.CREATOR_POST_IS_LIKED))
            VALUES
                ('\(uuid)', 1)
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
    
    // Updates creator post like.
    func updateCreatorPostIsLiked(uuid: String, status: Int64) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let sql = """
                UPDATE \(DBConstants.TABLE_CREATOR_POSTS_LIKED)
                SET \(DBConstants.CREATOR_POST_IS_LIKED)=\(status)
                WHERE \(DBConstants.CREATOR_POST_UUID)='\(uuid)')
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

    // Fetch contact by id.
    func getCreatorsPostIsLiked(uuid: String) -> (DBError, Int64?) {
        var err:DBError = .NoError
        var postIsliked:Int64? = nil
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let query = """
                SELECT \(DBConstants.CREATOR_POST_IS_LIKED) FROM \(DBConstants.TABLE_CREATOR_POSTS_LIKED)
                WHERE \(DBConstants.CREATOR_POST_UUID)='\(uuid)'
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
                    postIsliked = sqlite3_column_int64(stmt, 0)
                }
                
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        
        return (err, postIsliked)
    }
    
}
