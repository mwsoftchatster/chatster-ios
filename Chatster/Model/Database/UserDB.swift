//
//  UserDB.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 22/04/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class UserDB {
    
    // Fetch User id.
    func getUserId() -> (DBError, String?) {
        var err:DBError = .NoError
        var userId:String? = nil
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.U_ID) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.U_ID) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    
                    let rawId = sqlite3_column_text(stmt, 0)
                    userId = String(cString:rawId!)
                    
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        
        return (err, userId)
    }
    
    // Fetch User name.
    func getUserName() -> (DBError, String?) {
        var err:DBError = .NoError
        var userName:String? = nil
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_NAME) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_NAME) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    
                    let rawUserName = sqlite3_column_text(stmt, 0)
                    userName = String(cString:rawUserName!)
                    
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        
        return (err, userName)
    }
    
    // Fetch User status message.
    func getUserStatusMessage() -> (DBError, String?) {
        var err:DBError = .NoError
        var userStatusMessage:String? = nil
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.STATUS_MESSAGE) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.STATUS_MESSAGE) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    
                    let rawUserStatusMessage = sqlite3_column_text(stmt, 0)
                    userStatusMessage = String(cString:rawUserStatusMessage!)
                    
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        
        return (err, userStatusMessage)
    }
    
    // Fetch User profile picture uri.
    func getUserProfilePicURI() -> (DBError, String?) {
        var err:DBError = .NoError
        var userProfilePicURI:String? = nil
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_PROFILE_PIC_URI) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_PROFILE_PIC_URI) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    
                    let rawUserProfilePicURI = sqlite3_column_text(stmt, 0)
                    userProfilePicURI = String(cString:rawUserProfilePicURI!)
                    
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        
        return (err, userProfilePicURI)
    }
    
    // Fetch User profile picture url
    func getUserProfilePicURL() -> (DBError, String?) {
        var err:DBError = .NoError
        var userProfilePicURL:String? = nil
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_PROFILE_PIC_URL) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, "SELECT \(DBConstants.USER_PROFILE_PIC_URL) FROM \(DBConstants.TABLE_USER)", -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    
                    let rawUserProfilePicURL = sqlite3_column_text(stmt, 0)
                    userProfilePicURL = String(cString:rawUserProfilePicURL!)
                    
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        
        return (err, userProfilePicURL)
    }
    
    // Update user status message
    func updateUserStatusMessage(newStatusMessage:String) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let sql = "UPDATE \(DBConstants.TABLE_USER) SET \(DBConstants.STATUS_MESSAGE)='\(newStatusMessage)'"
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
    
    // Update user
    func updateUser(userId: String, newStatusMessage: String, userName: String, profilePicURL: String) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let sql = """
                UPDATE \(DBConstants.TABLE_USER) SET
                \(DBConstants.USER_NAME)='\(userName)',
                \(DBConstants.STATUS_MESSAGE)='\(newStatusMessage)',
                \(DBConstants.USER_PROFILE_PIC_URL)='\(profilePicURL)'
                WHERE \(DBConstants.U_ID)='\(userId)'
              """;
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
    
    // Update user id
    func updateUserId(userId: String) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let sql = """
                UPDATE \(DBConstants.TABLE_USER) SET
                \(DBConstants.U_ID)='\(userId)'
                WHERE \(DBConstants.U_ID)='0'
            """;
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

    // Update user profile pic uri
    func updateUserProfilePic(userId: String, profilePicURI: String) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let sql = """
            UPDATE \(DBConstants.TABLE_USER) SET
            \(DBConstants.USER_PROFILE_PIC_URI)='\(profilePicURI)'
            WHERE \(DBConstants.U_ID)='\(userId)'
            """;
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
}

//
//    public OneTimeKeyPair getUserOneTimeKeyPair(Context context, long userId) {
//    OneTimeKeyPair oneTimeKeyPair = null;
//    Cursor cursor = null;
//    SQLiteDatabase db = new DBOpenHelper(context).getReadableDatabase();
//    cursor = db.rawQuery("SELECT * FROM " + DBOpenHelper.TABLE_USER_ONE_TIME_PRE_KEY_PAIR
//    + " WHERE " + DBOpenHelper.USER_ONE_TIME_PRE_KEY_PAIR_USER_ID + "=" + userId, null);
//    if (cursor != null) {
//    oneTimeKeyPair = new OneTimeKeyPair();
//    while (cursor.moveToNext()) {
//    oneTimeKeyPair.setOneTimePrivateKey(cursor.getBlob(cursor.getColumnIndexOrThrow(DBOpenHelper.USER_ONE_TIME_PRE_KEY_PAIR_PRK)));
//    oneTimeKeyPair.setOneTimePublicKey(cursor.getBlob(cursor.getColumnIndexOrThrow(DBOpenHelper.USER_ONE_TIME_PRE_KEY_PAIR_PBK)));
//    oneTimeKeyPair.setUserId(userId);
//    oneTimeKeyPair.setUuid(cursor.getString(cursor.getColumnIndexOrThrow(DBOpenHelper.USER_ONE_TIME_PRE_KEY_PAIR_UUID)));
//    }
//    }
//    cursor.close();
//    db.close();
//
//    return oneTimeKeyPair;
//    }
//
//    public byte[] getUserOneTimePublicPreKey(Context context, long userId) {
//    byte[] userOneTimePublicPreKey = null;
//    Cursor cursor = null;
//    SQLiteDatabase db = new DBOpenHelper(context).getReadableDatabase();
//    cursor = db.rawQuery("SELECT "+ DBOpenHelper.USER_ONE_TIME_PRE_KEY_PAIR_PBK
//    + " FROM " + DBOpenHelper.TABLE_USER_ONE_TIME_PRE_KEY_PAIR
//    + " WHERE " + DBOpenHelper.USER_ONE_TIME_PRE_KEY_PAIR_USER_ID + "=" + userId, null);
//    if (cursor != null) {
//    if (cursor.moveToNext()) {
//    userOneTimePublicPreKey =
//    cursor.getBlob(cursor.getColumnIndexOrThrow(DBOpenHelper.USER_ONE_TIME_PRE_KEY_PAIR_PBK));
//    }
//    }
//    cursor.close();
//    db.close();
//
//    return userOneTimePublicPreKey;
//    }
//
//    public byte[] getUserOneTimePrivatePreKeyByUUID(Context context, String uuid) {
//    byte[] userOneTimePrivatePreKey = null;
//    Cursor cursor = null;
//    SQLiteDatabase db = new DBOpenHelper(context).getReadableDatabase();
//    cursor = db.rawQuery("SELECT "+ DBOpenHelper.USER_ONE_TIME_PRE_KEY_PAIR_PRK
//    + " FROM " + DBOpenHelper.TABLE_USER_ONE_TIME_PRE_KEY_PAIR
//    + " WHERE " + DBOpenHelper.USER_ONE_TIME_PRE_KEY_PAIR_UUID + " LIKE '" + uuid + "'", null);
//    if (cursor != null) {
//    if (cursor.moveToNext()) {
//    userOneTimePrivatePreKey = cursor.getBlob(cursor.getColumnIndexOrThrow(DBOpenHelper.USER_ONE_TIME_PRE_KEY_PAIR_PRK));
//    }
//    }
//    cursor.close();
//    db.close();
//
//    return userOneTimePrivatePreKey;
//    }
//
//    public byte[] getUserOneTimePublicPreKeyByUUID(Context context, String uuid) {
//    byte[] userOneTimePublicPreKey = null;
//    Cursor cursor = null;
//    SQLiteDatabase db = new DBOpenHelper(context).getReadableDatabase();
//    cursor = db.rawQuery("SELECT "+ DBOpenHelper.USER_ONE_TIME_PRE_KEY_PAIR_PBK
//    + " FROM " + DBOpenHelper.TABLE_USER_ONE_TIME_PRE_KEY_PAIR
//    + " WHERE " + DBOpenHelper.USER_ONE_TIME_PRE_KEY_PAIR_UUID + " LIKE '" + uuid + "'", null);
//    if (cursor != null) {
//    if (cursor.moveToNext()) {
//    userOneTimePublicPreKey =
//    cursor.getBlob(cursor.getColumnIndexOrThrow(DBOpenHelper.USER_ONE_TIME_PRE_KEY_PAIR_PBK));
//    }
//    }
//    cursor.close();
//    db.close();
//
//    return userOneTimePublicPreKey;
//    }
//
//    public void insertUserOneTimeKeyPair(String uuid, long userId, byte[] userOneTimePrivatePreKey,
//    byte[] userOneTimePublicPreKey, Context context) {
//    ContentValues setValues = new ContentValues();
//    setValues.put(DBOpenHelper.USER_ONE_TIME_PRE_KEY_PAIR_UUID, uuid);
//    setValues.put(DBOpenHelper.USER_ONE_TIME_PRE_KEY_PAIR_USER_ID, userId);
//    setValues.put(DBOpenHelper.USER_ONE_TIME_PRE_KEY_PAIR_PRK, userOneTimePrivatePreKey);
//    setValues.put(DBOpenHelper.USER_ONE_TIME_PRE_KEY_PAIR_PBK, userOneTimePublicPreKey);
//
//    Uri setUri = context.getContentResolver().insert(ChatsProvider.CONTENT_URI_USER_ONE_TIME_PRE_KEY_PAIR, setValues);
//    }
//
//    public void deleteOneTimeKeyPairByUUID(String uuid, Context context){
//    String selection = DBOpenHelper.USER_ONE_TIME_PRE_KEY_PAIR_UUID + "='" + uuid + "'";
//    context.getContentResolver().delete(ChatsProvider.CONTENT_URI_USER_ONE_TIME_PRE_KEY_PAIR, selection, null);
//    }
//
//    public OneTimeKeyPair getUserOneTimeKeyPairByUUID(Context context, String uuid, long userId) {
//    OneTimeKeyPair oneTimeKeyPair = null;
//    Cursor cursor = null;
//    SQLiteDatabase db = new DBOpenHelper(context).getReadableDatabase();
//    cursor = db.rawQuery("SELECT * FROM " + DBOpenHelper.TABLE_USER_ONE_TIME_PRE_KEY_PAIR
//    + " WHERE " + DBOpenHelper.USER_ONE_TIME_PRE_KEY_PAIR_UUID + "='" + uuid + "'", null);
//    if (cursor != null) {
//    oneTimeKeyPair = new OneTimeKeyPair();
//    while (cursor.moveToNext()) {
//    oneTimeKeyPair.setOneTimePrivateKey(cursor.getBlob(cursor.getColumnIndexOrThrow(DBOpenHelper.USER_ONE_TIME_PRE_KEY_PAIR_PRK)));
//    oneTimeKeyPair.setOneTimePublicKey(cursor.getBlob(cursor.getColumnIndexOrThrow(DBOpenHelper.USER_ONE_TIME_PRE_KEY_PAIR_PBK)));
//    oneTimeKeyPair.setUserId(userId);
//    oneTimeKeyPair.setUuid(cursor.getString(cursor.getColumnIndexOrThrow(DBOpenHelper.USER_ONE_TIME_PRE_KEY_PAIR_UUID)));
//    }
//    }
//    cursor.close();
//    db.close();
//
//    return oneTimeKeyPair;
//    }
    
