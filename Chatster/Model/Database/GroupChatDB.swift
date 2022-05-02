//
//  GroupChatDB.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 05/05/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class GroupChatDB {
    
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
    
    // Fetch group profile picture uri.
    func getGroupProfilePicUriById(groupChatId: String) -> (DBError, String?) {
        var err:DBError = .NoError
        var groupProfilePicURI:String? = nil
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            var stmt:OpaquePointer? = nil
            var result = sqlite3_prepare_v2(db, """
                SELECT \(DBConstants.GROUP_CHAT_PROFILE_PIC)
                FROM \(DBConstants.TABLE_GROUP_CHAT)
                WHERE \(DBConstants.GROUP_CHAT_ID)='\(groupChatId)'
                """, -1, &stmt, nil)
            
            var retryCount:Int = 0
            while SQLITE_BUSY == result && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                result = sqlite3_prepare_v2(db, """
                    SELECT \(DBConstants.GROUP_CHAT_PROFILE_PIC)
                    FROM \(DBConstants.TABLE_GROUP_CHAT)
                    WHERE \(DBConstants.GROUP_CHAT_ID)='\(groupChatId)'
                    """, -1, &stmt, nil)
            }
            
            if SQLITE_OK == result {
                result = sqlite3_step(stmt)
                if SQLITE_ROW == result {
                    
                    let rawGroupProfilePicURI = sqlite3_column_text(stmt, 0)
                    groupProfilePicURI = String(cString:rawGroupProfilePicURI!)
                    
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        
        return (err, groupProfilePicURI)
    }
    
    // Fetch unread group chat messages count for group chat with id.
    func getUnreadMessageCountByGroupChatId(groupChatId: String) -> (DBError, String?) {
        var err:DBError = .NoError
        var unreadMessageCount:String? = nil
        
        let chatsterDB = ChatsterDB.sharedDB
        
        let query = """
            SELECT COUNT (*) AS c
            FROM \(DBConstants.TABLE_MESSAGE)
            WHERE \(DBConstants.MESSAGE_HAS_BEEN_READ)=0
            AND \(DBConstants.MESSAGE_GROUP_CHAT_ID)='\(groupChatId)'
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
    
    // Fetch all group messages for group chat with id.
    func getAllMessagesForChatWithId(groupChatId: String) -> (DBError, Array<GroupChatMessage>) {
        var err:DBError = .NoError
        var groupMessages:Array<GroupChatMessage> = Array<GroupChatMessage>()
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let query = """
                SELECT * FROM \(DBConstants.TABLE_MESSAGE)
                WHERE \(DBConstants.MESSAGE_GROUP_CHAT_ID) =\(groupChatId)
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
                    
                    // groupMessages(<#T##newElement: Message##Message#>)
                    
                    result = sqlite3_step(stmt)
                }
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        return (err, groupMessages)
    }
    
    // Fetch last group chat message in group chat with id.
    func getLastGroupChatMessageByChatId(groupChatId: String) -> (DBError, GroupChatMessage?) {
        var err:DBError = .NoError
        var groupChatMessage:GroupChatMessage? = nil
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let query = """
                SELECT * FROM \(DBConstants.TABLE_MESSAGE)
                WHERE \(DBConstants.MESSAGE_GROUP_CHAT_ID) ='\(groupChatId)'
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
        
        return (err, groupChatMessage)
    }

    // Fetch last group chat invitation.
    func getGroupChatInvitation(groupChatId: String) -> (DBError, GroupChatInvitation?) {
        var err:DBError = .NoError
        var groupChatInvitation:GroupChatInvitation? = nil
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let query = """
              SELECT * FROM \(DBConstants.TABLE_OFFLINE_CONTACT_RESPONSE)
              WHERE \(DBConstants.OFFLINE_CONTACT_RESPONSE_TYPE_MESSAGE) = 'groupChatInvitation'
              AND _id =(SELECT MAX(_id) FROM \(DBConstants.TABLE_OFFLINE_CONTACT_RESPONSE))
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
                    
                    let rawGroupChatInvitationChatId = sqlite3_column_text(stmt, 8)
                    let groupChatInvitationChatId = String(cString:rawGroupChatInvitationChatId!)
                    
                    let rawGroupChatInvitationChatName = sqlite3_column_text(stmt, 10)
                    let groupChatInvitationChatName = String(cString:rawGroupChatInvitationChatName!)
                    
                    let rawGroupProfilePicPath = sqlite3_column_text(stmt, 11)
                    let groupProfilePicPath = String(cString:rawGroupProfilePicPath!)
                    
                    let groupChatInvitationSenderId = sqlite3_column_int64(stmt, 9)
                    
                    let rawGroupChatInvitationGroupChatMembers = sqlite3_column_text(stmt, 12)
                    let groupChatInvitationGroupChatMembers = String(cString:rawGroupChatInvitationGroupChatMembers!)
                    
                }
                
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        
        return (err, groupChatInvitation)
    }
    
    // Fetch all group ids.
    func getAllGroupChatIds() -> (DBError, Array<String>) {
        var err:DBError = .NoError
        var groupChatIds:Array<String> = Array<String>()
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let query = "SELECT * FROM \(DBConstants.TABLE_GROUP_CHAT)";
            
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
                    
                    let rawGroupChatId = sqlite3_column_text(stmt, 0)
                    let groupChatId = String(cString:rawGroupChatId!)
                    
                    groupChatIds.append(groupChatId)
                    
                    result = sqlite3_step(stmt)
                }
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        return (err, groupChatIds)
    }

    // Fetch group chat name for group chat with id.
    func getGroupChatNameById(groupChatId: String) -> (DBError, String?) {
        var err:DBError = .NoError
        var groupChatName:String? = nil
        
        let chatsterDB = ChatsterDB.sharedDB
        
        let query = """
            SELECT \(DBConstants.GROUP_CHAT_NAME) FROM \(DBConstants.TABLE_GROUP_CHAT) WHERE
            \(DBConstants.GROUP_CHAT_ID) LIKE '\(groupChatId)'
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
                    
                    let rawGroupChatName = sqlite3_column_text(stmt, 0)
                    groupChatName = String(cString:rawGroupChatName!)
                    
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        
        return (err, groupChatName)
    }
    
    // Fetch group chat name for group chat with id.
    func getGroupChatAdminByGroupId(groupChatId: String) -> (DBError, Int64?) {
        var err:DBError = .NoError
        var groupChatAdminId:Int64? = nil
        
        let chatsterDB = ChatsterDB.sharedDB
        
        let query = """
            SELECT \(DBConstants.GROUP_CHAT_ADMIN_ID)
            FROM \(DBConstants.TABLE_GROUP_CHAT)
            WHERE \(DBConstants.GROUP_CHAT_ID) LIKE '\(groupChatId)'
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
                    
                    groupChatAdminId = sqlite3_column_int64(stmt, 0)
                    
                }
                
                sqlite3_finalize(stmt)
            }  else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        
        return (err, groupChatAdminId)
    }

    // Fetch all group chats.
    func getAllChats() -> (DBError, Array<GroupChat>) {
        var err:DBError = .NoError
        var groupChats:Array<GroupChat> = Array<GroupChat>()
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let query = "SELECT * FROM \(DBConstants.TABLE_GROUP_CHAT)";
            
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
                    
                    let groupChatId:Int64 = sqlite3_column_int64(stmt, 0)
                    
                    let groupChatAdminId:Int64 = sqlite3_column_int64(stmt, 1)
                    
                    let rawGroupChatName = sqlite3_column_text(stmt, 2)
                    let groupChatName = String(cString:rawGroupChatName!)
                    
                    let rawGroupChatStatusMessage = sqlite3_column_text(stmt, 3)
                    let groupChatStatusMessage = String(cString:rawGroupChatStatusMessage!)
                    
                    let rawGroupChatProfilePic = sqlite3_column_text(stmt, 4)
                    let groupChatProfilePic = String(cString:rawGroupChatProfilePic!)
                    
                    let lastMessageId = sqlite3_column_int64(stmt, 5)
                    
                    let rawGroupChatCreated = sqlite3_column_text(stmt, 6)
                    let chatGroupCreated = String(cString:rawGroupChatCreated!)
                    
                    // groupChats.append(groupChat)
                    
                    result = sqlite3_step(stmt)
                }
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        return (err, groupChats)
    }
    
    // Fetch group chat by group chat id.
    func getGroupChatById(groupChatId:String) -> (DBError, GroupChat?) {
        var err:DBError = .NoError
        var groupChat:GroupChat? = nil
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let query = """
                SELECT * FROM \(DBConstants.TABLE_GROUP_CHAT)
                WHERE \(DBConstants.GROUP_CHAT_ID)='\(groupChatId)'
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
                    
                    let groupChatId:Int64 = sqlite3_column_int64(stmt, 0)
                    
                    let groupChatAdminId:Int64 = sqlite3_column_int64(stmt, 1)
                    
                    let rawGroupChatName = sqlite3_column_text(stmt, 2)
                    let groupChatName = String(cString:rawGroupChatName!)
                    
                    let rawGroupChatStatusMessage = sqlite3_column_text(stmt, 3)
                    let groupChatStatusMessage = String(cString:rawGroupChatStatusMessage!)
                    
                    let rawGroupChatProfilePic = sqlite3_column_text(stmt, 4)
                    let groupChatProfilePic = String(cString:rawGroupChatProfilePic!)
                    
                    let lastMessageId = sqlite3_column_int64(stmt, 5)
                    
                    let rawGroupChatCreated = sqlite3_column_text(stmt, 6)
                    let chatGroupCreated = String(cString:rawGroupChatCreated!)
                    
                }
                
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        
        return (err, groupChat)
    }
    
    // Delete group chat message by id.
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
    
    // Updates message status to has been read.
    func updateMessageUnsentByUUID(uuid: String) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let sql = """
                UPDATE \(DBConstants.TABLE_MESSAGE)
                SET \(DBConstants.TYPE_MESSAGE)='text',
                \(DBConstants.BINARY_MESSAGE_FILE_PATH)='',
                \(DBConstants.TEXT_MESSAGE)='This message has been deleted by sender',
                WHERE \(DBConstants.MESSAGE_UUID)='\(uuid)'
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

    // Create new group chat message.
    func insertGroupChatMessage(senderId: Int64, typeMessage: String, groupChatId: String, uuid: String, messageCreated: String, message: String, binaryFilePath: String) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let sql = """
                INSERT INTO \(DBConstants.TABLE_MESSAGE)
                    (\(DBConstants.MESSAGE_SENDER_ID),
                    \(DBConstants.TYPE_MESSAGE),
                    \(DBConstants.MESSAGE_GROUP_CHAT_ID),
                    \(DBConstants.MESSAGE_HAS_BEEN_READ),
                    \(DBConstants.MESSAGE_UUID),
                    \(DBConstants.MESSAGE_CREATED),
                    \(typeMessage == "text" ? DBConstants.TEXT_MESSAGE : DBConstants.BINARY_MESSAGE_FILE_PATH))
                VALUES
                    (\(senderId),
                    '\(typeMessage)',
                    '\(groupChatId)',
                    1,
                    '\(uuid)',
                    '\(messageCreated)',
                    '\(typeMessage == "text" ? message : binaryFilePath)')
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
    
    // Create new group chat.
    func insertGroupChat(groupChatId: String, groupAdminId: Int64, groupChatName: String, groupStatusMessage: String, groupProfilePic: String) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let sql = """
                INSERT INTO \(DBConstants.TABLE_GROUP_CHAT)
                    (\(DBConstants.GROUP_CHAT_ID),
                    \(DBConstants.GROUP_CHAT_ADMIN_ID),
                    \(DBConstants.GROUP_CHAT_NAME),
                    \(DBConstants.GROUP_CHAT_STATUS_MESSAGE),
                    \(DBConstants.GROUP_CHAT_PROFILE_PIC))
                VALUES
                    ('\(groupChatId)',
                    \(groupAdminId),
                    '\(groupChatName)',
                    '\(groupStatusMessage)',
                    '\(groupProfilePic)')
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
    
    // Create new group chat member.
    func createGroupChatMember(groupChatId: String, groupMemberId: Int64) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let sql = """
                INSERT INTO \(DBConstants.TABLE_GROUP_CHAT_MEMBER)
                    (\(DBConstants.GROUP_CHAT_MEMBER_GROUP_CHAT_ID),
                    \(DBConstants.GROUP_CHAT_MEMBER_ID))
                VALUES
                    ('\(groupChatId)',
                    \(groupMemberId))
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
    
    // Updates message status to has been read.
    func updateGroupProfilePic(uri: String, groupChatId: String) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let sql = """
                UPDATE \(DBConstants.TABLE_GROUP_CHAT)
                SET \(DBConstants.GROUP_CHAT_PROFILE_PIC)='\(uri)'
                WHERE \(DBConstants.GROUP_CHAT_ID)='\(groupChatId)'
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
    
    // Delete group chat by id.
    func deleteGroupChat(groupChatId: String) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let deleteGroup = """
                DELETE FROM \(DBConstants.TABLE_GROUP_CHAT)
                WHERE \(DBConstants.GROUP_CHAT_ID)='\(groupChatId)'
            """;
            let deleteGroupMembers = """
                DELETE FROM \(DBConstants.TABLE_GROUP_CHAT_MEMBER)
                WHERE \(DBConstants.GROUP_CHAT_MEMBER_GROUP_CHAT_ID)='\(groupChatId)'
            """;
            let deleteGroupMessages = """
                DELETE FROM \(DBConstants.TABLE_MESSAGE)
                WHERE \(DBConstants.GROUP_CHAT_MEMBER_GROUP_CHAT_ID)='\(groupChatId)'
            """;
            
            var resultDeleteGroupMessages = sqlite3_exec(db, deleteGroupMessages, nil, nil, nil)
            var resultDeleteGroupMembers = sqlite3_exec(db, deleteGroupMembers, nil, nil, nil)
            var resultDeleteGroup = sqlite3_exec(db, deleteGroup, nil, nil, nil)
            
            var retryCount:Int = 0
            while (SQLITE_BUSY == resultDeleteGroupMessages || SQLITE_BUSY == resultDeleteGroupMembers || SQLITE_BUSY == resultDeleteGroup) && retryCount < RETRY_LIMIT {
                sleep(1)
                retryCount += 1
                resultDeleteGroupMessages = sqlite3_exec(db, deleteGroupMessages, nil, nil, nil)
                resultDeleteGroupMembers = sqlite3_exec(db, deleteGroupMembers, nil, nil, nil)
                resultDeleteGroup = sqlite3_exec(db, deleteGroup, nil, nil, nil)
            }
            
            if SQLITE_OK == resultDeleteGroupMessages {
                let errStr = String(cString: sqlite3_errstr(resultDeleteGroupMessages))
                err = .SQLError(errStr)
            } else {
                changes = Int(sqlite3_changes(db))
            }
            
            if SQLITE_OK == resultDeleteGroupMembers {
                let errStr = String(cString: sqlite3_errstr(resultDeleteGroupMembers))
                err = .SQLError(errStr)
            } else {
                changes = Int(sqlite3_changes(db))
            }
            
            if SQLITE_OK == resultDeleteGroup {
                let errStr = String(cString: sqlite3_errstr(resultDeleteGroup))
                err = .SQLError(errStr)
            } else {
                changes = Int(sqlite3_changes(db))
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        
        return (err, changes)
    }
    
    // Delete group chat by id.
    func deleteGroupChatInvitationNotification(groupChatId: String) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let sql = """
                DELETE FROM \(DBConstants.TABLE_OFFLINE_CONTACT_RESPONSE)
                WHERE \(DBConstants.OFFLINE_CONTACT_RESPONSE_GROUP_CHAT_INVITATION_CHAT_ID)='\(groupChatId)'
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
            } else {
                changes = Int(sqlite3_changes(db))
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        
        return (err, changes)
    }

    // Delete group chat message queue item by uuid.
    func deleteGroupChatMessageQueueItemByUUID(messageUUID: String) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let sql = """
                DELETE FROM \(DBConstants.TABLE_GROUP_MESSAGE_QUEUE)
                WHERE \(DBConstants.GROUP_MESSAGE_QUEUE_MESSAGE_UUID)='\(messageUUID)'
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
    
    // Create new group chat message queue item.
    func insertGroupChatMessageQueueItem(messageUUID: String) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let sql = """
                INSERT INTO \(DBConstants.TABLE_GROUP_MESSAGE_QUEUE)
                    (\(DBConstants.GROUP_MESSAGE_QUEUE_MESSAGE_UUID)
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
    
    // Fetch group chat by group chat id.
    func getGroupMessageQueueItemGroupChat(groupChatId: String) -> (DBError, GroupMessageQueueItem?) {
        var err:DBError = .NoError
        var groupMessageQueueItem:GroupMessageQueueItem? = nil
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let query = """
                SELECT * FROM \(DBConstants.TABLE_GROUP_MESSAGE_QUEUE)
                WHERE \(DBConstants.GROUP_CHAT_ID)='\(groupChatId)'
                LIMIT 1
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
                    
                    let id:Int64 = sqlite3_column_int64(stmt, 0)
                    
                    let rawUUID = sqlite3_column_text(stmt, 1)
                    let uuid = String(cString:rawUUID!)
  
                }
                
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        
        return (err, groupMessageQueueItem)
    }
    
    // Fetch group chat message with uuid.
    func getGroupChatMessageByUUID(uuid: String) -> (DBError, GroupChatMessage?) {
        var err:DBError = .NoError
        var groupChatMessage:GroupChatMessage? = nil
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let query = """
                SELECT * FROM \(DBConstants.TABLE_MESSAGE)
                WHERE \(DBConstants.MESSAGE_UUID) ='\(uuid)'
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
        
        return (err, groupChatMessage)
    }
    
    // Create new group chat message queue item.
    func insertReceivedOnlineGroupMessage(messageUUID: String) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let sql = """
                INSERT INTO \(DBConstants.TABLE_RECEIVED_ONLINE_GROUP_MESSAGE)
                    (\(DBConstants.RECEIVED_ONLINE_GROUP_MESSAGE_UUID)
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

    // Delete received on;ine group chat message by uuid.
    func deleteReceivedOnlineGroupMessageByUUID(messageUUID: String) -> (DBError, Int) {
        var err:DBError = .NoError
        var changes:Int = 0
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let sql = """
                DELETE FROM \(DBConstants.TABLE_RECEIVED_ONLINE_GROUP_MESSAGE)
                WHERE \(DBConstants.RECEIVED_ONLINE_GROUP_MESSAGE_UUID)='\(messageUUID)'
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
    
    // Fetch group chat received online message by group chat id.
    func getReceivedOnlineGroupMessage() -> (DBError, ReceivedOnlineGroupMessage?) {
        var err:DBError = .NoError
        var receivedOnlineGroupMessage:ReceivedOnlineGroupMessage? = nil
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let query = """
                SELECT * FROM \(DBConstants.TABLE_RECEIVED_ONLINE_GROUP_MESSAGE)
                LIMIT 1
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
                    
                    let id:Int64 = sqlite3_column_int64(stmt, 0)
                    
                    let rawUUID = sqlite3_column_text(stmt, 1)
                    let uuid = String(cString:rawUUID!)
                    
                }
                
                sqlite3_finalize(stmt)
            } else {
                let errStr = String(cString: sqlite3_errstr(result))
                err = .SQLError(errStr)
            }
            
            _ = chatsterDB.dbClose(db: db)
            
        }
        
        return (err, receivedOnlineGroupMessage)
    }

    // Fetch all group chats received online message uuids.
    func getReceivedOnlineGroupMessageUUIDs() -> (DBError, Array<String>) {
        var err:DBError = .NoError
        var uuids:Array<String> = Array<String>()
        
        let chatsterDB = ChatsterDB.sharedDB
        
        if let db = chatsterDB.dbOpen() {
            
            let query = "SELECT * FROM \(DBConstants.TABLE_RECEIVED_ONLINE_GROUP_MESSAGE)";
            
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

//    
//    public OneTimeGroupKeyPair getGroupOneTimeKeyPair(Context context, String groupChatId, long userId) {
//    OneTimeGroupKeyPair oneTimeGroupKeyPair = null;
//    Cursor cursor = null;
//    SQLiteDatabase db = new DBOpenHelper(context).getReadableDatabase();
//    cursor = db.rawQuery("SELECT * FROM " + DBOpenHelper.TABLE_GROUP_ONE_TIME_PRE_KEY_PAIR
//    + " WHERE " + DBOpenHelper.GROUP_ONE_TIME_PRE_KEY_PAIR_GROUP_ID + " LIKE '" + groupChatId + "'", null);
//    if (cursor != null) {
//    oneTimeGroupKeyPair = new OneTimeGroupKeyPair();
//    while (cursor.moveToNext()) {
//    oneTimeGroupKeyPair.setOneTimeGroupPrivateKey(
//    cursor.getBlob(cursor.getColumnIndexOrThrow(DBOpenHelper.GROUP_ONE_TIME_PRE_KEY_PAIR_PRK))
//    );
//    oneTimeGroupKeyPair.setOneTimeGroupPublicKey(
//    cursor.getBlob(cursor.getColumnIndexOrThrow(DBOpenHelper.GROUP_ONE_TIME_PRE_KEY_PAIR_PBK))
//    );
//    oneTimeGroupKeyPair.setUuid(
//    cursor.getString(cursor.getColumnIndexOrThrow(DBOpenHelper.GROUP_ONE_TIME_PRE_KEY_PAIR_UUID))
//    );
//    oneTimeGroupKeyPair.setGroupChatId(groupChatId);
//    oneTimeGroupKeyPair.setUserId(userId);
//    }
//    }
//    cursor.close();
//    db.close();
//    
//    return oneTimeGroupKeyPair;
//    }
//    
//    public byte[] getGroupOneTimePublicPreKey(Context context, String groupChatId) {
//    byte[] groupOneTimePublicPreKey = null;
//    Cursor cursor = null;
//    SQLiteDatabase db = new DBOpenHelper(context).getReadableDatabase();
//    cursor = db.rawQuery("SELECT "+ DBOpenHelper.GROUP_ONE_TIME_PRE_KEY_PAIR_PBK
//    + " FROM " + DBOpenHelper.TABLE_GROUP_ONE_TIME_PRE_KEY_PAIR
//    + " WHERE " + DBOpenHelper.GROUP_ONE_TIME_PRE_KEY_PAIR_GROUP_ID + " LIKE '" + groupChatId + "'", null);
//    if (cursor != null) {
//    if (cursor.moveToNext()) {
//    groupOneTimePublicPreKey =
//    cursor.getBlob(cursor.getColumnIndexOrThrow(DBOpenHelper.GROUP_ONE_TIME_PRE_KEY_PAIR_PBK));
//    }
//    }
//    cursor.close();
//    db.close();
//    
//    return groupOneTimePublicPreKey;
//    }
//    
//    public byte[] getGroupOneTimePrivatePreKeyByUUID(Context context, String uuid) {
//    byte[] groupOneTimePrivatePreKey = null;
//    Cursor cursor = null;
//    SQLiteDatabase db = new DBOpenHelper(context).getReadableDatabase();
//    cursor = db.rawQuery("SELECT "+ DBOpenHelper.GROUP_ONE_TIME_PRE_KEY_PAIR_PRK
//    + " FROM " + DBOpenHelper.TABLE_GROUP_ONE_TIME_PRE_KEY_PAIR
//    + " WHERE " + DBOpenHelper.GROUP_ONE_TIME_PRE_KEY_PAIR_UUID + " LIKE '" + uuid + "'", null);
//    if (cursor != null) {
//    if (cursor.moveToNext()) {
//    groupOneTimePrivatePreKey = cursor.getBlob(cursor.getColumnIndexOrThrow(DBOpenHelper.GROUP_ONE_TIME_PRE_KEY_PAIR_PRK));
//    }
//    }
//    cursor.close();
//    db.close();
//    
//    return groupOneTimePrivatePreKey;
//    }
//    
//    public byte[] getGroupOneTimePublicPreKeyByUUID(Context context, String uuid) {
//    byte[] groupOneTimePublicPreKey = null;
//    Cursor cursor = null;
//    SQLiteDatabase db = new DBOpenHelper(context).getReadableDatabase();
//    cursor = db.rawQuery("SELECT "+ DBOpenHelper.GROUP_ONE_TIME_PRE_KEY_PAIR_PBK
//    + " FROM " + DBOpenHelper.TABLE_GROUP_ONE_TIME_PRE_KEY_PAIR
//    + " WHERE " + DBOpenHelper.GROUP_ONE_TIME_PRE_KEY_PAIR_UUID + " LIKE '" + uuid + "'", null);
//    if (cursor != null) {
//    if (cursor.moveToNext()) {
//    groupOneTimePublicPreKey =
//    cursor.getBlob(cursor.getColumnIndexOrThrow(DBOpenHelper.GROUP_ONE_TIME_PRE_KEY_PAIR_PBK));
//    }
//    }
//    cursor.close();
//    db.close();
//    
//    return groupOneTimePublicPreKey;
//    }
//    
//    public void insertGroupOneTimeKeyPair(String uuid, String groupChatId, byte[] groupOneTimePrivatePreKey,
//    byte[] groupOneTimePublicPreKey, Context context) {
//    ContentValues setValues = new ContentValues();
//    setValues.put(DBOpenHelper.GROUP_ONE_TIME_PRE_KEY_PAIR_UUID, uuid);
//    setValues.put(DBOpenHelper.GROUP_ONE_TIME_PRE_KEY_PAIR_GROUP_ID, groupChatId);
//    setValues.put(DBOpenHelper.GROUP_ONE_TIME_PRE_KEY_PAIR_PRK, groupOneTimePrivatePreKey);
//    setValues.put(DBOpenHelper.GROUP_ONE_TIME_PRE_KEY_PAIR_PBK, groupOneTimePublicPreKey);
//    
//    Uri setUri = context.getContentResolver().insert(ChatsProvider.CONTENT_URI_GROUP_ONE_TIME_PRE_KEY_PAIR, setValues);
//    }
//    
//    public void deleteOneTimeGroupKeyPairByUUID(String uuid, Context context){
//    String selection = DBOpenHelper.GROUP_ONE_TIME_PRE_KEY_PAIR_UUID + "='" + uuid + "'";
//    context.getContentResolver().delete(ChatsProvider.CONTENT_URI_GROUP_ONE_TIME_PRE_KEY_PAIR, selection, null);
//    }
//    
//    public OneTimeGroupKeyPair getUserOneGroupTimeKeyPairByUUID(Context context, String uuid, long userId, String groupChatId) {
//    OneTimeGroupKeyPair oneTimeGroupKeyPair = null;
//    Cursor cursor = null;
//    SQLiteDatabase db = new DBOpenHelper(context).getReadableDatabase();
//    cursor = db.rawQuery("SELECT * FROM " + DBOpenHelper.TABLE_GROUP_ONE_TIME_PRE_KEY_PAIR
//    + " WHERE " + DBOpenHelper.GROUP_ONE_TIME_PRE_KEY_PAIR_UUID + "='" + uuid + "'", null);
//    if (cursor != null) {
//    oneTimeGroupKeyPair = new OneTimeGroupKeyPair();
//    while (cursor.moveToNext()) {
//    oneTimeGroupKeyPair.setOneTimeGroupPrivateKey(cursor.getBlob(cursor.getColumnIndexOrThrow(DBOpenHelper.GROUP_ONE_TIME_PRE_KEY_PAIR_PRK)));
//    oneTimeGroupKeyPair.setOneTimeGroupPublicKey(cursor.getBlob(cursor.getColumnIndexOrThrow(DBOpenHelper.GROUP_ONE_TIME_PRE_KEY_PAIR_PBK)));
//    oneTimeGroupKeyPair.setUserId(userId);
//    oneTimeGroupKeyPair.setGroupChatId(groupChatId);
//    oneTimeGroupKeyPair.setUuid(cursor.getString(cursor.getColumnIndexOrThrow(DBOpenHelper.GROUP_ONE_TIME_PRE_KEY_PAIR_UUID)));
//    }
//    }
//    cursor.close();
//    db.close();
//    
//    return oneTimeGroupKeyPair;
//    }
    
}
