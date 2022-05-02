//
//  DBConstants.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 21/04/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class DBConstants {
    
    // Version table columns
    static let TABLE_VERSION = "version"
    static let VERSION = "version"
    
    static let TABLE_CREATE_VERSION = """
        CREATE TABLE IF NOT EXISTS (\(DBConstants.TABLE_VERSION) (
        \(DBConstants.VERSION) VARCHAR(16)
        )
    """
    
    // Contact table columns
    static let TABLE_CONTACT = "contact"
    static let CONTACT_ID = "_id"
    static let CONTACT_NAME = "contact_name"
    static let CONTACT_STATUS_MESSAGE = "contact_status_message"
    static let CONTACT_PROFILE_PIC = "contact_profile_pic"
    static let CONTACT_TYPE = "contact_type"
    static let CONTACT_CREATED = "contact_created"
    
    // SQL to create table contact
    static let TABLE_CREATE_CONTACT = """
        CREATE TABLE \(DBConstants.TABLE_CONTACT)
        (\(DBConstants.CONTACT_ID) INTEGER PRIMARY KEY,
        \(DBConstants.CONTACT_NAME) TEXT NOT NULL,
        \(DBConstants.CONTACT_STATUS_MESSAGE) TEXT,
        \(DBConstants.CONTACT_PROFILE_PIC) TEXT,
        \(DBConstants.CONTACT_TYPE) INTEGER default 0,
        \(DBConstants.CONTACT_CREATED) TEXT default CURRENT_TIMESTAMP)
    """
    
    // User table columns
    static let TABLE_USER = "user"
    static let U_ID = "_id"
    static let USER_NAME = "username"
    static let USER_PROFILE_PIC_URI = "profile_pic_uri"
    static let USER_PROFILE_PIC_URL = "profile_pic_url"
    static let STATUS_MESSAGE = "status_message"
    static let PHONE_CONFIRM_MESSAGE = "phone_confirm_message"
    
    // SQL to create table user
    static let TABLE_CREATE_USER = """
        CREATE TABLE \(DBConstants.TABLE_USER) (
        \(DBConstants.U_ID) INTEGER NOT NULL,
        \(DBConstants.USER_NAME) TEXT NOT NULL,
        \(DBConstants.USER_PROFILE_PIC_URI) TEXT,
        \(DBConstants.USER_PROFILE_PIC_URL) TEXT,
        \(DBConstants.STATUS_MESSAGE) TEXT,
        \(DBConstants.PHONE_CONFIRM_MESSAGE) INTEGER)
    """
    
    // insert default user
    static let INSERT_DEFAULT_USER = "INSERT INTO \(DBConstants.TABLE_USER) VALUES ( 0, 'default', 'localUri', 's3Url', '', 0)"
    
    // Chat table columns
    static let TABLE_CHAT = "chat"
    static let CHAT_ID = "_id"
    static let CHAT_NAME = "chat_name"
    static let CHAT_CONTACT_ID = "chat_contact_id"
    static let CHAT_LAST_MESSAGE_ID = "last_message_id"
    static let CHAT_IS_ALLOWED_UNSEND = "chat_is_allowed_unsend"
    static let CHAT_IS_IN_SPY_MODE = "chat_is_in_spy_mode"
    static let CHAT_CREATED = "chat_created"
    
    // SQL to create table chat
    static let TABLE_CREATE_CHAT = """
        CREATE TABLE \(DBConstants.TABLE_CHAT) (
        \(DBConstants.CHAT_ID) INTEGER PRIMARY KEY AUTOINCREMENT,
        \(DBConstants.CHAT_NAME) TEXT,
        \(DBConstants.CHAT_CONTACT_ID) INTEGER NOT NULL,
        \(DBConstants.CHAT_LAST_MESSAGE_ID) INTEGER,
        \(DBConstants.CHAT_IS_ALLOWED_UNSEND) INTEGER NOT NULL DEFAULT 0,
        \(DBConstants.CHAT_IS_IN_SPY_MODE) INTEGER NOT NULL DEFAULT 0,
        \(DBConstants.CHAT_CREATED) TEXT default CURRENT_TIMESTAMP,
        FOREIGN KEY(\(DBConstants.CHAT_CONTACT_ID)) REFERENCES \(DBConstants.TABLE_CONTACT) (\(DBConstants.CONTACT_ID)))
    """
    
    // Group Chat table columns
    static let TABLE_GROUP_CHAT = "group_chat"
    static let GROUP_CHAT_ID = "_id"
    static let GROUP_CHAT_ADMIN_ID = "admin_id"
    static let GROUP_CHAT_NAME = "group_chat_name"
    static let GROUP_CHAT_STATUS_MESSAGE = "group_chat_status_message"
    static let GROUP_CHAT_PROFILE_PIC = "group_chat_profile_pic"
    static let GROUP_CHAT_LAST_MESSAGE_ID = "group_chat_last_message"
    static let GROUP_CHAT_CREATED = "group_chat_created"
    
    // SQL to create table group chat
    static let TABLE_CREATE_GROUP_CHAT = """
        CREATE TABLE \(DBConstants.TABLE_GROUP_CHAT) (
        \(DBConstants.GROUP_CHAT_ID) TEXT PRIMARY KEY,
        \(DBConstants.GROUP_CHAT_ADMIN_ID) INTEGER NOT NULL,
        \(DBConstants.GROUP_CHAT_NAME) TEXT NOT NULL,
        \(DBConstants.GROUP_CHAT_STATUS_MESSAGE) TEXT,
        \(DBConstants.GROUP_CHAT_PROFILE_PIC) TEXT,
        \(DBConstants.GROUP_CHAT_LAST_MESSAGE_ID) INTEGER,
        \(DBConstants.GROUP_CHAT_CREATED) TEXT default CURRENT_TIMESTAMP,
        FOREIGN KEY(\(DBConstants.GROUP_CHAT_ADMIN_ID)) REFERENCES \(DBConstants.TABLE_CONTACT) ( \(DBConstants.CONTACT_ID)))
    """
    
    // Group Chat Member table columns
    static let TABLE_GROUP_CHAT_MEMBER = "group_chat_member"
    static let GROUP_CHAT_MEMBER_GROUP_CHAT_ID = "group_chat_id"
    static let GROUP_CHAT_MEMBER_ID = "group_chat_member_id"
    
    // SQL to create table chat
    static let TABLE_CREATE_GROUP_CHAT_MEMBER = """
        CREATE TABLE \(DBConstants.TABLE_GROUP_CHAT_MEMBER ) (
        \(DBConstants.GROUP_CHAT_MEMBER_GROUP_CHAT_ID) TEXT NOT NULL,
        \(DBConstants.GROUP_CHAT_MEMBER_ID) INTEGER NOT NULL,
        FOREIGN KEY(\(DBConstants.GROUP_CHAT_MEMBER_GROUP_CHAT_ID)) REFERENCES TABLE_GROUP_CHAT (\(DBConstants.GROUP_CHAT_ID)),
        FOREIGN KEY(\(DBConstants.GROUP_CHAT_MEMBER_ID)) REFERENCES \(DBConstants.TABLE_CONTACT) (\(DBConstants.CONTACT_ID)))
    """
    
    // Message table columns
    static let TABLE_MESSAGE = "message"
    static let MESSAGE_ID = "_id"
    static let TYPE_MESSAGE = "type_message"
    static let MESSAGE_CHAT_ID = "message_chat_id"
    static let MESSAGE_GROUP_CHAT_ID = "message_group_chat_id"
    static let MESSAGE_SENDER_ID = "message_sender_id"
    static let TEXT_MESSAGE = "text_message"
    static let BINARY_MESSAGE_FILE_PATH = "file_path"
    static let MESSAGE_HAS_BEEN_READ = "message_has_been_read"
    static let MESSAGE_UUID = "message_uuid"
    static let MESSAGE_CREATED = "text_message_created"
    
    // SQL to create table message
    static let TABLE_CREATE_MESSAGE = """
        CREATE TABLE \(DBConstants.TABLE_MESSAGE) (
        \(DBConstants.MESSAGE_ID) INTEGER PRIMARY KEY AUTOINCREMENT,
        \(DBConstants.TYPE_MESSAGE) TEXT,
        \(DBConstants.MESSAGE_CHAT_ID) INTEGER,
        \(DBConstants.MESSAGE_GROUP_CHAT_ID) TEXT,
        \(DBConstants.MESSAGE_SENDER_ID) INTEGER NOT NULL,
        \(DBConstants.TEXT_MESSAGE) TEXT,
        \(DBConstants.BINARY_MESSAGE_FILE_PATH) TEXT,
        \(DBConstants.MESSAGE_HAS_BEEN_READ) INTEGER default 0,
        \(DBConstants.MESSAGE_UUID) TEXT NOT NULL UNIQUE,
        \(DBConstants.MESSAGE_CREATED) TEXT default CURRENT_TIMESTAMP ,
        FOREIGN KEY(\(DBConstants.MESSAGE_CHAT_ID)) REFERENCES \(DBConstants.TABLE_CHAT) (\(DBConstants.CHAT_ID)),
        FOREIGN KEY(\(DBConstants.MESSAGE_GROUP_CHAT_ID) REFERENCES \(DBConstants.TABLE_GROUP_CHAT) (\(DBConstants.GROUP_CHAT_ID)),
        FOREIGN KEY(\(DBConstants.MESSAGE_SENDER_ID)) REFERENCES \(DBConstants.TABLE_CONTACT) (\(DBConstants.CONTACT_ID)))
    """
    
    // Message Queue table columns
    static let TABLE_MESSAGE_QUEUE = "message_queue"
    static let MESSAGE_QUEUE_ITEM_ID = "_id"
    static let MESSAGE_QUEUE_MESSAGE_UUID = "message_queue_message_uuid"
    static let MESSAGE_QUEUE_MESSAGE_RECEIVER_ID = "message_queue_message_receiver_id"
    static let MESSAGE_QUEUE_MESSAGE_CONTACT_PK_UUID = "message_queue_message_contact_pk_uuid"
    static let MESSAGE_QUEUE_MESSAGE_USER_PK_UUID = "message_queue_message_user_pk_uuid"
    
    // SQL to create table text_message
    static let TABLE_CREATE_MESSAGE_QUEUE = """
        CREATE TABLE \(DBConstants.TABLE_MESSAGE_QUEUE) (
        \(DBConstants.MESSAGE_QUEUE_ITEM_ID) INTEGER PRIMARY KEY AUTOINCREMENT,
        \(DBConstants.MESSAGE_QUEUE_MESSAGE_UUID) TEXT NOT NULL UNIQUE,
        \(DBConstants.MESSAGE_QUEUE_MESSAGE_CONTACT_PK_UUID) TEXT NOT NULL UNIQUE,
        \(DBConstants.MESSAGE_QUEUE_MESSAGE_USER_PK_UUID) TEXT NOT NULL UNIQUE,
        \(DBConstants.MESSAGE_QUEUE_MESSAGE_RECEIVER_ID) INTEGER NOT NULL,
        FOREIGN KEY(\(DBConstants.MESSAGE_QUEUE_MESSAGE_UUID)) REFERENCES \(DBConstants.TABLE_MESSAGE) (\(DBConstants.MESSAGE_UUID)),
        FOREIGN KEY(\(DBConstants.MESSAGE_QUEUE_MESSAGE_RECEIVER_ID)) REFERENCES \(DBConstants.TABLE_CONTACT) (\(DBConstants.CONTACT_ID)))
    """
    
    // Group Message Queue
    static let TABLE_GROUP_MESSAGE_QUEUE = "group_message_queue"
    static let GROUP_MESSAGE_QUEUE_ITEM_ID = "_id"
    static let GROUP_MESSAGE_QUEUE_MESSAGE_UUID = "group_message_queue_message_uuid"
    
    // SQL to create table text_message
    static let TABLE_CREATE_GROUP_MESSAGE_QUEUE = """
        CREATE TABLE \(DBConstants.TABLE_GROUP_MESSAGE_QUEUE) (
        \(DBConstants.GROUP_MESSAGE_QUEUE_ITEM_ID) INTEGER PRIMARY KEY AUTOINCREMENT,
        \(DBConstants.GROUP_MESSAGE_QUEUE_MESSAGE_UUID) TEXT NOT NULL UNIQUE,
        FOREIGN KEY(\(DBConstants.GROUP_MESSAGE_QUEUE_MESSAGE_UUID)) REFERENCES \(DBConstants.TABLE_MESSAGE) (\(DBConstants.MESSAGE_UUID)))
    """
    
    // Retrieved Offline Message UUID table columns
    static let TABLE_RETRIEVED_OFFLINE_MESSAGE_UUID = "retrieved_offline_message_uuid"
    static let RETRIEVED_OFFLINE_MESSAGE_UUID_ID = "_id"
    static let RETRIEVED_OFFLINE_MESSAGE_UUID = "retrieved_offline_message_uuid_uuid"
    
    // SQL to create table retrieved offline message
    static let TABLE_CREATE_RETRIEVED_OFFLINE_MESSAGE_UUID = """
        CREATE TABLE \(DBConstants.TABLE_RETRIEVED_OFFLINE_MESSAGE_UUID) (
        \(DBConstants.RETRIEVED_OFFLINE_MESSAGE_UUID_ID) INTEGER PRIMARY KEY AUTOINCREMENT,
        \(DBConstants.RETRIEVED_OFFLINE_MESSAGE_UUID) TEXT NOT NULL UNIQUE,
        FOREIGN KEY(\(DBConstants.RETRIEVED_OFFLINE_MESSAGE_UUID)) REFERENCES \(DBConstants.TABLE_MESSAGE) (\(DBConstants.MESSAGE_UUID)))
    """
    
    // Received Online Message table columns
    static let TABLE_RECEIVED_ONLINE_MESSAGE = "received_online_message"
    static let RECEIVED_ONLINE_MESSAGE_ID = "_id"
    static let RECEIVED_ONLINE_MESSAGE_UUID = "received_online_message_uuid"
    
    // SQL to create table received_online_message
    static let TABLE_CREATE_RECEIVED_ONLINE_MESSAGE = """
        CREATE TABLE \(DBConstants.TABLE_RECEIVED_ONLINE_MESSAGE) (
        \(DBConstants.RECEIVED_ONLINE_MESSAGE_ID) INTEGER PRIMARY KEY AUTOINCREMENT,
        \(DBConstants.RECEIVED_ONLINE_MESSAGE_UUID) TEXT NOT NULL UNIQUE,
        FOREIGN KEY(\(DBConstants.RECEIVED_ONLINE_MESSAGE_UUID)) REFERENCES \(DBConstants.TABLE_MESSAGE) (\(DBConstants.MESSAGE_UUID)))
    """
    
    // Received Online Group Message table columns
    static let TABLE_RECEIVED_ONLINE_GROUP_MESSAGE = "received_online_group_message"
    static let RECEIVED_ONLINE_GROUP_MESSAGE_ID = "_id"
    static let RECEIVED_ONLINE_GROUP_MESSAGE_UUID = "received_online_group_message_uuid"
    
    // SQL to create table received_online_group_message
    static let TABLE_CREATE_RECEIVED_ONLINE_GROUP_MESSAGE = """
        CREATE TABLE \(DBConstants.TABLE_RECEIVED_ONLINE_GROUP_MESSAGE) (
        \(DBConstants.RECEIVED_ONLINE_GROUP_MESSAGE_ID) INTEGER PRIMARY KEY AUTOINCREMENT,
        \(DBConstants.RECEIVED_ONLINE_GROUP_MESSAGE_UUID) TEXT NOT NULL UNIQUE,
        FOREIGN KEY(\(DBConstants.RECEIVED_ONLINE_GROUP_MESSAGE_UUID)) REFERENCES \(DBConstants.TABLE_MESSAGE) (\(DBConstants.MESSAGE_UUID)))
    """
    
    // Offline Contact Response table columns
    static let TABLE_OFFLINE_CONTACT_RESPONSE = "offline_contact_response"
    static let OFFLINE_CONTACT_RESPONSE_ID = "_id"
    static let OFFLINE_CONTACT_RESPONSE_TYPE_MESSAGE = "message_type"
    static let OFFLINE_CONTACT_RESPONSE_USER_ID = "contact_response_user_id"
    static let OFFLINE_CONTACT_RESPONSE_USER_NAME = "contact_response_user_name"
    static let OFFLINE_CONTACT_RESPONSE_STATUS_MESSAGE = "contact_response_status_message"
    static let OFFLINE_CONTACT_RESPONSE_REQUEST_MESSAGE = "contact_response_request_message"
    static let OFFLINE_CONTACT_RESPONSE_CONTACT_REQUEST_ID = "contact_response_contact_request_id"
    static let OFFLINE_CONTACT_RESPONSE_REQUEST_ID = "contact_response_request_id"
    static let OFFLINE_CONTACT_RESPONSE_GROUP_CHAT_INVITATION_CHAT_ID = "contact_response_group_chat_invitation_chat_id"
    static let OFFLINE_CONTACT_RESPONSE_GROUP_CHAT_INVITATION_SENDER_ID = "contact_response_group_chat_invitation_sender_id"
    static let OFFLINE_CONTACT_RESPONSE_GROUP_CHAT_CHAT_NAME = "contact_response_group_chat_invitation_chat_name"
    static let OFFLINE_CONTACT_RESPONSE_GROUP_CHAT_PROFILE_IMAGE = "contact_response_group_chat_invitation_profile_image"
    static let OFFLINE_CONTACT_RESPONSE_GROUP_CHAT_MEMBERS = "contact_response_group_chat_members"
    
    // SQL to create table offline_contact_response
    static let TABLE_CREATE_OFFLINE_CONTACT_RESPONSE = """
        CREATE TABLE \(DBConstants.TABLE_OFFLINE_CONTACT_RESPONSE) (
        \(DBConstants.OFFLINE_CONTACT_RESPONSE_ID) INTEGER PRIMARY KEY AUTOINCREMENT,
        \(DBConstants.OFFLINE_CONTACT_RESPONSE_TYPE_MESSAGE) TEXT NOT NULL,
        \(DBConstants.OFFLINE_CONTACT_RESPONSE_USER_ID) INTEGER,
        \(DBConstants.OFFLINE_CONTACT_RESPONSE_USER_NAME) TEXT,
        \(DBConstants.OFFLINE_CONTACT_RESPONSE_STATUS_MESSAGE) TEXT,
        \(DBConstants.OFFLINE_CONTACT_RESPONSE_REQUEST_MESSAGE) TEXT,
        \(DBConstants.OFFLINE_CONTACT_RESPONSE_CONTACT_REQUEST_ID) INTEGER,
        \(DBConstants.OFFLINE_CONTACT_RESPONSE_REQUEST_ID) INTEGER,
        \(DBConstants.OFFLINE_CONTACT_RESPONSE_GROUP_CHAT_INVITATION_CHAT_ID) TEXT,
        \(DBConstants.OFFLINE_CONTACT_RESPONSE_GROUP_CHAT_INVITATION_SENDER_ID) INTEGER,
        \(DBConstants.OFFLINE_CONTACT_RESPONSE_GROUP_CHAT_CHAT_NAME) TEXT,
        \(DBConstants.OFFLINE_CONTACT_RESPONSE_GROUP_CHAT_PROFILE_IMAGE) TEXT,
        \(DBConstants.OFFLINE_CONTACT_RESPONSE_GROUP_CHAT_MEMBERS) TEXT)
    """
    
    // Creator Contact table columns
    static let TABLE_CREATOR_CONTACT = "creator_contact"
    static let CREATOR_CONTACT_ID = "_id"
    static let CREATOR_CONTACT_STATUS_MESSAGE = "creator_contact_status_message"
    static let CREATOR_CONTACT_PROFILE_PIC = "creator_contact_profile_pic"
    static let CREATOR_CONTACT_TYPE = "creator_contact_type"
    static let CREATOR_CONTACT_CREATED = "creator_contact_created"
    
    // SQL to create table creator contact
    static let TABLE_CREATE_CREATOR_CONTACT = """
        CREATE TABLE \(DBConstants.TABLE_CREATOR_CONTACT) (
        \(DBConstants.CREATOR_CONTACT_ID) TEXT PRIMARY KEY,
        \(DBConstants.CREATOR_CONTACT_STATUS_MESSAGE) TEXT,
        \(DBConstants.CREATOR_CONTACT_PROFILE_PIC) TEXT,
        \(DBConstants.CREATOR_CONTACT_TYPE) INTEGER default 0,
        \(DBConstants.CREATOR_CONTACT_CREATED) TEXT default CURRENT_TIMESTAMP)
    """
    
    // Creator Posts Liked table columns
    static let TABLE_CREATOR_POSTS_LIKED = "creator_posts_liked"
    static let CREATOR_POSTS_LIKED_ID = "_id"
    static let CREATOR_POST_UUID = "creator_post_uuid"
    static let CREATOR_POST_LIKES = "creator_post_likes"
    static let CREATOR_POST_IS_LIKED = "creator_post_is_liked"
    
    // SQL to create table posts liked
    static let TABLE_CREATE_POSTS_LIKED = """
        CREATE TABLE \(DBConstants.TABLE_CREATOR_POSTS_LIKED) (
        \(DBConstants.CREATOR_POSTS_LIKED_ID) INTEGER PRIMARY KEY AUTOINCREMENT,
        \(DBConstants.CREATOR_POST_UUID) TEXT NOT NULL,
        \(DBConstants.CREATOR_POST_LIKES) INTEGER default 0,
        \(DBConstants.CREATOR_POST_IS_LIKED) INTEGER default 0)
    """
    
    // Chat One Time Keys
    static let TABLE_USER_ONE_TIME_PRE_KEY_PAIR = "user_one_time_pre_key_pair"
    static let USER_ONE_TIME_PRE_KEY_PAIR_ID = "_id"
    static let USER_ONE_TIME_PRE_KEY_PAIR_UUID = "user_one_time_pre_key_pair_uuid"
    static let USER_ONE_TIME_PRE_KEY_PAIR_USER_ID = "user_id"
    static let USER_ONE_TIME_PRE_KEY_PAIR_PRK = "user_one_time_pre_key_pair_prk"
    static let USER_ONE_TIME_PRE_KEY_PAIR_PBK = "user_one_time_pre_key_pair_pbk"
    
    // SQL to create table user_one_time_pre_key_pair
    static let TABLE_CREATE_USER_ONE_TIME_PRE_KEY_PAIR = """
        CREATE TABLE \(DBConstants.TABLE_USER_ONE_TIME_PRE_KEY_PAIR) (
        \(DBConstants.USER_ONE_TIME_PRE_KEY_PAIR_ID) INTEGER PRIMARY KEY AUTOINCREMENT,
        \(DBConstants.USER_ONE_TIME_PRE_KEY_PAIR_UUID) TEXT NOT NULL,
        \(DBConstants.USER_ONE_TIME_PRE_KEY_PAIR_USER_ID) INTEGER NOT NULL,
        \(DBConstants.USER_ONE_TIME_PRE_KEY_PAIR_PRK) BLOB,
        \(DBConstants.USER_ONE_TIME_PRE_KEY_PAIR_PBK) BLOB)
    """
    
    // Group Chat One Time Keys table columns
    static let TABLE_GROUP_ONE_TIME_PRE_KEY_PAIR = "group_one_time_pre_key_pair"
    static let GROUP_ONE_TIME_PRE_KEY_PAIR_ID = "_id"
    static let GROUP_ONE_TIME_PRE_KEY_PAIR_UUID = "group_one_time_pre_key_pair_uuid"
    static let GROUP_ONE_TIME_PRE_KEY_PAIR_GROUP_ID = "group_id"
    static let GROUP_ONE_TIME_PRE_KEY_PAIR_PRK = "group_one_time_pre_key_pair_prk"
    static let GROUP_ONE_TIME_PRE_KEY_PAIR_PBK = "group_one_time_pre_key_pair_pbk"
    
    // SQL to create table group_one_time_pre_key_pair
    static let TABLE_CREATE_GROUP_ONE_TIME_PRE_KEY_PAIR = """
        CREATE TABLE \(DBConstants.TABLE_GROUP_ONE_TIME_PRE_KEY_PAIR) (
        \(DBConstants.GROUP_ONE_TIME_PRE_KEY_PAIR_ID) INTEGER PRIMARY KEY AUTOINCREMENT,
        \(DBConstants.GROUP_ONE_TIME_PRE_KEY_PAIR_UUID) TEXT NOT NULL,
        \(DBConstants.GROUP_ONE_TIME_PRE_KEY_PAIR_GROUP_ID) TEXT NOT NULL,
        \(DBConstants.GROUP_ONE_TIME_PRE_KEY_PAIR_PRK) BLOB,
        \(DBConstants.GROUP_ONE_TIME_PRE_KEY_PAIR_PBK) BLOB)
    """
    

}
