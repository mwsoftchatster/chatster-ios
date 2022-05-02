//
//  ChatDB.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 22/04/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class ChatDB {
    
    // Updates message status to has been read.
    func updateMessageHasBeenReadByMessageId(messageId: Int) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let sql = "UPDATE \(DBConstants.TABLE_MESSAGE) SET \(DBConstants.MESSAGE_HAS_BEEN_READ)=1 WHERE \(DBConstants.MESSAGE_ID)=\(messageId)"
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
    
    // Updates contact is allowed to unsend.
    func updateContactIsAllowedToUnsendByChatId(chatId: Int, isAllowedToUnsend: Int) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let sql = "UPDATE \(DBConstants.TABLE_CHAT) SET \(DBConstants.CHAT_IS_ALLOWED_UNSEND)=\(isAllowedToUnsend) WHERE \(DBConstants.CHAT_ID)=\(chatId)"
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
    
    // Fetch unread messages count for chat with id.
    func getUnreadMessageCountByChatId(chatId: Int) -> (DBError, String?) {
        var err:DBError = .NoError
        var unreadMessageCount:String? = nil
        
        let chatsterDB = ChatsterDB.sharedDB
        
        let query = """
            SELECT COUNT (*) AS c
            FROM \(DBConstants.TABLE_MESSAGE)
            WHERE \(DBConstants.MESSAGE_HAS_BEEN_READ)=0
            AND \(DBConstants.MESSAGE_CHAT_ID)=\(chatId)
        """;
        
        if let db = chatsterDB.dbOpen() {
            
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
                    
                    let rawUnreadMessageCount = sqlite3_column_text(stmt, 0)
                    unreadMessageCount = String(cString:rawUnreadMessageCount!)
                    
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        
        return (err, unreadMessageCount)
    }
    
    // Fetch last message in chat with id.
    func getLastChatMessageByChatId(chatId:Int) -> (DBError, Message?) {
        var err:DBError = .NoError
        var message:Message? = nil
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let query = """
                SELECT * FROM \(DBConstants.TABLE_MESSAGE)
                WHERE \(DBConstants.MESSAGE_CHAT_ID) =\(chatId)
                ORDER BY \(DBConstants.MESSAGE_ID)
                DESC LIMIT 1
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
                    
                    let messageId:Int64 = sqlite3_column_int64(stmt, 0)
                    
                    let rawMessageType = sqlite3_column_text(stmt, 1)
                    let messageType = String(cString:rawMessageType!)
                    
                    let messageChatId = sqlite3_column_int64(stmt, 2)// next is 4 not 3 because it is chat message not group chat

                    let rawMessageSenderId = sqlite3_column_text(stmt, 4)
                    let messageSenderId = String(cString:rawMessageSenderId!)
                    
                    let rawMessageText = sqlite3_column_text(stmt, 5)
                    let messageText = String(cString:rawMessageText!)
                    
                    let rawBinaryMessageFilePath = sqlite3_column_text(stmt, 6)
                    let binaryMessageFilePath = String(cString:rawBinaryMessageFilePath!)
                    
                    let messageHasBeenRead:Int64 = sqlite3_column_int64(stmt, 7)
                    
                    let rawMessageUUID = sqlite3_column_text(stmt, 8)
                    let messageUUID = String(cString:rawMessageUUID!)
                    
                    let rawMessageCreated = sqlite3_column_text(stmt, 9)
                    let messageCreated = String(cString:rawMessageCreated!)

                }
                
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        
        return (err, message)
    }
    
    // Fetch all messages for chat with id.
    func getAllMessagesForChatWithId(chatId: Int) -> (DBError, Array<Message>) {
        var err:DBError = .NoError
        var messages:Array<Message> = Array<Message>()
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let query = """
                SELECT * FROM \(DBConstants.TABLE_MESSAGE)
                WHERE \(DBConstants.MESSAGE_CHAT_ID) =\(chatId)
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
                    
                    let messageId:Int64 = sqlite3_column_int64(stmt, 0)
                    
                    let rawMessageType = sqlite3_column_text(stmt, 1)
                    let messageType = String(cString:rawMessageType!)
                    
                    let messageChatId = sqlite3_column_int64(stmt, 2)// next is 4 not 3 because it is chat message not group chat
                    
                    let rawMessageSenderId = sqlite3_column_text(stmt, 4)
                    let messageSenderId = String(cString:rawMessageSenderId!)
                    
                    let rawMessageText = sqlite3_column_text(stmt, 5)
                    let messageText = String(cString:rawMessageText!)
                    
                    let rawBinaryMessageFilePath = sqlite3_column_text(stmt, 6)
                    let binaryMessageFilePath = String(cString:rawBinaryMessageFilePath!)
                    
                    let messageHasBeenRead:Int64 = sqlite3_column_int64(stmt, 7)
                    
                    let rawMessageUUID = sqlite3_column_text(stmt, 8)
                    let messageUUID = String(cString:rawMessageUUID!)
                    
                    let rawMessageCreated = sqlite3_column_text(stmt, 9)
                    let messageCreated = String(cString:rawMessageCreated!)
                    
                    // messages.append(<#T##newElement: Message##Message#>)
                    
                    result = sqlite3_step(stmt)
                }
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        return (err, messages)
    }
    
    // Fetch the state variable value to see if contact is allowed to unsend.
    func getIsAllowedToUnsendByChatId(chatId: Int) -> (DBError, Int64?) {
        var err:DBError = .NoError
        var isAllowedToUnsend:Int64? = nil
        
        let chatsterDB = ChatsterDB.sharedDB
        
        let query = """
            SELECT \(DBConstants.CHAT_IS_ALLOWED_UNSEND)
            FROM \(DBConstants.TABLE_CHAT)
            WHERE \(DBConstants.CHAT_ID)=\(chatId)
        """;
        
        if let db = chatsterDB.dbOpen() {
            
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
                    isAllowedToUnsend = sqlite3_column_int64(stmt, 0)
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        
        return (err, isAllowedToUnsend)
    }
    
    // Fetch unread messages count for chat with id.
    func getChatIdByChatName(chatName: String) -> (DBError, Int64?) {
        var err:DBError = .NoError
        var chatId:Int64? = nil
        
        let chatsterDB = ChatsterDB.sharedDB
        
        let query = """
            SELECT \(DBConstants.CHAT_ID) FROM \(DBConstants.TABLE_CHAT)
            WHERE \(DBConstants.CHAT_NAME)='\(chatName)'
        """;
        
        if let db = chatsterDB.dbOpen() {
            
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
                    
                    chatId = sqlite3_column_int64(stmt, 0)
                    
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        
        return (err, chatId)
    }
    
    // Fetch all chats.
    func getAllChats() -> (DBError, Array<Chat>) {
        var err:DBError = .NoError
        var chats:Array<Chat> = Array<Chat>()
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let query = "SELECT * FROM \(DBConstants.TABLE_CHAT)";
            
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
                    
                    let chatId:Int64 = sqlite3_column_int64(stmt, 0)
                    
                    let rawChatName = sqlite3_column_text(stmt, 1)
                    let chatName = String(cString:rawChatName!)
                    
                    let chatContactId = sqlite3_column_int64(stmt, 2)
                    
                    let lastMessageId = sqlite3_column_int64(stmt, 3)
                    
                    let isAllowedToUnsend = sqlite3_column_int64(stmt, 4)
                    
                    let isInSpyMode = sqlite3_column_int64(stmt, 5)
                    
                    let rawChatCreated = sqlite3_column_text(stmt, 6)
                    let chatCreated = String(cString:rawChatCreated!)
                    
                    // chats.append(chat)
                    
                    result = sqlite3_step(stmt)
                }
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        return (err, chats)
    }

    // Fetch chat by contact id.
    func getChatByContactId(contactId:Int) -> (DBError, Chat?) {
        var err:DBError = .NoError
        var chat:Chat? = nil
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let query = """
                SELECT * FROM \(DBConstants.TABLE_CHAT)
                WHERE \(DBConstants.CHAT_CONTACT_ID)=\(contactId)
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
                    
                    let chatId:Int64 = sqlite3_column_int64(stmt, 0)
                    
                    let rawChatName = sqlite3_column_text(stmt, 1)
                    let chatName = String(cString:rawChatName!)
                    
                    let chatContactId = sqlite3_column_int64(stmt, 2)
                    
                    let lastMessageId = sqlite3_column_int64(stmt, 3)
                    
                    let isAllowedToUnsend = sqlite3_column_int64(stmt, 4)
                    
                    let isInSpyMode = sqlite3_column_int64(stmt, 5)
                    
                    let rawChatCreated = sqlite3_column_text(stmt, 6)
                    let chatCreated = String(cString:rawChatCreated!)
                    
                }
                
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        
        return (err, chat)
    }
    
    // Fetch chat by chat id.
    func getChatById(chatId:Int) -> (DBError, Chat?) {
        var err:DBError = .NoError
        var chat:Chat? = nil
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let query = """
            SELECT * FROM \(DBConstants.TABLE_CHAT)
            WHERE \(DBConstants.CHAT_ID)=\(chatId)
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
                    
                    let chatId:Int64 = sqlite3_column_int64(stmt, 0)
                    
                    let rawChatName = sqlite3_column_text(stmt, 1)
                    let chatName = String(cString:rawChatName!)
                    
                    let chatContactId = sqlite3_column_int64(stmt, 2)
                    
                    let lastMessageId = sqlite3_column_int64(stmt, 3)
                    
                    let isAllowedToUnsend = sqlite3_column_int64(stmt, 4)
                    
                    let isInSpyMode = sqlite3_column_int64(stmt, 5)
                    
                    let rawChatCreated = sqlite3_column_text(stmt, 6)
                    let chatCreated = String(cString:rawChatCreated!)
                    
                }
                
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        
        return (err, chat)
    }
    
    // Delete chat by id.
    func deleteChatById(chatId:Int64) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let sql = "DELETE FROM \(DBConstants.TABLE_CHAT) WHERE \(DBConstants.CHAT_ID) = \(chatId)"
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
    
    // Delete chat message by id.
    func deleteChatMessageById(messageId:Int64) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let sql = "DELETE FROM \(DBConstants.TABLE_MESSAGE) WHERE \(DBConstants.MESSAGE_ID) = \(messageId)"
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
    
    // Delete chat message by sender id.
    func deleteChatMessageBySenderId(senderId:Int64) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let sql = "DELETE FROM \(DBConstants.TABLE_MESSAGE) WHERE \(DBConstants.MESSAGE_SENDER_ID) = \(senderId)"
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
    
    // Create new chat,
    func insertChat(contactId: String, chatName: String) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let sql = """
                INSERT INTO \(DBConstants.TABLE_CHAT) (\(DBConstants.CHAT_CONTACT_ID), \(DBConstants.CHAT_NAME))
                VALUES
                 ('\(contactId)', '\(chatName)')
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

    // Create new chat message queue item
    func insertChatMessageQueueItem(messageUUID: String, contactPKUUID: String, userPKUUID: String, receiverId: String) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let sql = """
            INSERT INTO \(DBConstants.TABLE_MESSAGE_QUEUE)
            (\(DBConstants.MESSAGE_QUEUE_MESSAGE_UUID),
            \(DBConstants.MESSAGE_QUEUE_MESSAGE_CONTACT_PK_UUID),
            \(DBConstants.MESSAGE_QUEUE_MESSAGE_USER_PK_UUID),
            \(DBConstants.MESSAGE_QUEUE_MESSAGE_RECEIVER_ID))
            VALUES
            ('\(messageUUID)', '\(contactPKUUID)', '\(userPKUUID)', '\(receiverId)')
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

//
//    public MessageQueueItem getMessageQueueItemChat(Context context){
//    MessageQueueItem messageQueueItem = null;
//    Cursor cursor = null;
//    SQLiteDatabase db = new DBOpenHelper(context).getReadableDatabase();
//    cursor = db.rawQuery("SELECT * FROM " + DBOpenHelper.TABLE_MESSAGE_QUEUE, null);
//    if (cursor != null) {
//    while(cursor.moveToNext()) {
//    messageQueueItem = new MessageQueueItem();
//    messageQueueItem.set_id(Integer.parseInt(cursor.getString(cursor.getColumnIndexOrThrow(DBOpenHelper.MESSAGE_QUEUE_ITEM_ID))));
//    messageQueueItem.setMessageUUID(cursor.getString(cursor.getColumnIndexOrThrow(DBOpenHelper.MESSAGE_QUEUE_MESSAGE_UUID)));
//    messageQueueItem.setContactPublicKeyUUID(cursor.getString(cursor.getColumnIndexOrThrow(DBOpenHelper.MESSAGE_QUEUE_MESSAGE_CONTACT_PK_UUID)));
//    messageQueueItem.setUserPublicKeyUUID(cursor.getString(cursor.getColumnIndexOrThrow(DBOpenHelper.MESSAGE_QUEUE_MESSAGE_USER_PK_UUID)));
//    messageQueueItem.setReceiverId(Long.parseLong(cursor.getString(cursor.getColumnIndexOrThrow(DBOpenHelper.MESSAGE_QUEUE_MESSAGE_RECEIVER_ID))));
//    }
//    }
//    cursor.close();
//    db.close();
//
//    return messageQueueItem;
//    }
    
    // Fetch chat message by uuid
    func getChatMessageByUUID(uuid: String) -> (DBError, Message?) {
        var err:DBError = .NoError
        var message:Message? = nil
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let query = """
                SELECT * FROM \(DBConstants.TABLE_MESSAGE)
                WHERE \(DBConstants.MESSAGE_UUID)
                LIKE '\(uuid)'
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
                    
                    let messageId:Int64 = sqlite3_column_int64(stmt, 0)
                    
                    let rawMessageType = sqlite3_column_text(stmt, 1)
                    let messageType = String(cString:rawMessageType!)
                    
                    let messageChatId = sqlite3_column_int64(stmt, 2)// next is 4 not 3 because it is chat message not group chat
                    
                    let rawMessageSenderId = sqlite3_column_text(stmt, 4)
                    let messageSenderId = String(cString:rawMessageSenderId!)
                    
                    let rawMessageText = sqlite3_column_text(stmt, 5)
                    let messageText = String(cString:rawMessageText!)
                    
                    let rawBinaryMessageFilePath = sqlite3_column_text(stmt, 6)
                    let binaryMessageFilePath = String(cString:rawBinaryMessageFilePath!)
                    
                    let messageHasBeenRead:Int64 = sqlite3_column_int64(stmt, 7)
                    
                    let rawMessageUUID = sqlite3_column_text(stmt, 8)
                    let messageUUID = String(cString:rawMessageUUID!)
                    
                    let rawMessageCreated = sqlite3_column_text(stmt, 9)
                    let messageCreated = String(cString:rawMessageCreated!)
                    
                }
                
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        
        return (err, message)
    }
    
    // Delete chat message by uuid.
    func deleteChatMessageQueueItemByUUID(messageUUID: String) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let sql = """
                DELETE FROM \(DBConstants.TABLE_MESSAGE_QUEUE)
                WHERE \(DBConstants.MESSAGE_QUEUE_MESSAGE_UUID)='\(messageUUID)'
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

    // Create new chat message
    func insertChatMessage(messageSenderId: String, messageType: String, messageChatId: Int64, messageHasBeenRead: Int64, messageUUID: String, messageCreated: String, messagetText: String) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let sql = """
                INSERT INTO \(DBConstants.TABLE_MESSAGE)
                (\(DBConstants.MESSAGE_SENDER_ID),
                \(DBConstants.TYPE_MESSAGE),
                \(DBConstants.MESSAGE_CHAT_ID),
                \(DBConstants.MESSAGE_HAS_BEEN_READ),
                \(DBConstants.MESSAGE_UUID),
                \(DBConstants.MESSAGE_CREATED),
                \(DBConstants.TEXT_MESSAGE)
                VALUES
                ('\(messageSenderId)', '\(messageType)', \(messageChatId), \(messageHasBeenRead), '\(messageUUID)', '\(messageCreated)', '\(messagetText)')
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

    // Create new chat image message
    func insertImageMessage(messageSenderId: String, messageType: String, messageChatId: Int64, messageHasBeenRead: Int64, messageUUID: String, messageCreated: String, uri: String) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let sql = """
            INSERT INTO \(DBConstants.TABLE_MESSAGE)
            (\(DBConstants.MESSAGE_SENDER_ID),
            \(DBConstants.TYPE_MESSAGE),
            \(DBConstants.MESSAGE_CHAT_ID),
            \(DBConstants.MESSAGE_HAS_BEEN_READ),
            \(DBConstants.MESSAGE_UUID),
            \(DBConstants.MESSAGE_CREATED),
            \(DBConstants.BINARY_MESSAGE_FILE_PATH)
            VALUES
            ('\(messageSenderId)', '\(messageType)', \(messageChatId), \(messageHasBeenRead), '\(messageUUID)', '\(messageCreated)', '\(uri)')
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

    // Create new received online message
    func insertReceivedOnlineMessage(messageUUID: String) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let sql = """
                INSERT INTO \(DBConstants.TABLE_RECEIVED_ONLINE_MESSAGE)
                (\(DBConstants.RECEIVED_ONLINE_MESSAGE_UUID)
                VALUES
                ('\(messageUUID)')
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
    
    // Delete received online message by uuid
    func deleteReceivedOnlineMessageByUUID(uuid: String) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let sql = """
                DELETE FROM \(DBConstants.TABLE_RECEIVED_ONLINE_MESSAGE)
                WHERE \(DBConstants.RECEIVED_ONLINE_MESSAGE_UUID)='\(uuid)'
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

//
//    public ReceivedOnlineMessage getReceivedOnlineMessage(Context context) {
//    ReceivedOnlineMessage receivedOnlineMessage = null;
//    Cursor cursor = null;
//    SQLiteDatabase db = new DBOpenHelper(context).getReadableDatabase();
//    cursor = db.rawQuery("SELECT * FROM " + DBOpenHelper.TABLE_RECEIVED_ONLINE_MESSAGE, null);
//    if (cursor != null) {
//    while (cursor.moveToNext()) {
//    receivedOnlineMessage = new ReceivedOnlineMessage();
//    receivedOnlineMessage.set_id(Integer.parseInt(cursor.getString(cursor.getColumnIndexOrThrow(DBOpenHelper.RECEIVED_ONLINE_MESSAGE_ID))));
//    receivedOnlineMessage.setUuid(cursor.getString(cursor.getColumnIndexOrThrow(DBOpenHelper.RECEIVED_ONLINE_MESSAGE_UUID)));
//    }
//    }
//    cursor.close();
//    db.close();
//
//    return receivedOnlineMessage;
//    }
//
    
    // Fetch all received online messages uuids
    func getReceivedOnlineMessageUUIDs() -> (DBError, Array<String>) {
        var err:DBError = .NoError
        var uuids:Array<String> = Array<String>()
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let query = "SELECT \(DBConstants.RECEIVED_ONLINE_MESSAGE_UUID) FROM \(DBConstants.TABLE_RECEIVED_ONLINE_MESSAGE)";
            
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

                    let rawUUID = sqlite3_column_text(stmt, 0)
                    let uuid = String(cString:rawUUID!)

                    uuids.append(uuid)
                    
                    result = sqlite3_step(stmt)
                }
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        return (err, uuids)
    }
    
}
