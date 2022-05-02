//
//  ConstanRegistry.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 19/05/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation

class ConstantRegistry {
    
    static let CONTACT_REQUEST = "CONTACT_REQUEST"
    static let CONTACTS_LIST = "CONTACTS_LIST"
    static let CHATS_LIST = "CHATS_LIST"
    static let CHATS_SETTINGS = "CHATS_SETTINGS"
    static let IMAGE_DETAIL = "IMAGE_DETAIL"
    static let IMAGE_DETAIL_REQUEST = "IMAGE_DETAIL_REQUEST"
    static let CHAT_REQUEST = "CHAT_REQUEST"
    static let GROUP_CHATS_LIST_REQUEST = "GROUP_CHATS_LIST_REQUEST"
    static let GROUP_CHATS_LIST = "GROUP_CHATS_LIST"
    static let IMAGE = "image"
    static let VIDEO = "video"
    static let TEXT = "text"
    static let JOINED_GROUP_CHAT = "joined_group_chat"
    static let LOADING = "LOADING"
    static let SUCCESS = "success"
    static let ERROR = "error"
    static let DONE = "done"
    static let GROUP_IMAGE = "group image"
    static let LEFT_GROUP = "leftGroup"
    static let DEFAULT = "default"
    static let GROUP_CHAT_ID = "groupChatId"
    static let AVAILABLE = "available"
    static let UNAVAILABLE = "unavailable"
    static let YES = "yes"
    static let NO = "no"
    
    
    static let MY_PERMISSIONS_REQUEST_READ_CONTACTS = 1000
    static let MY_PERMISSIONS_REQUEST_READ_PHONE_STATE = 1001
    static let MY_PERMISSIONS_REQUEST_WRITE_EXTERNAL_STORAGE = 1002
    
    
    static let BASE_SERVER_URL = "https://chatster-net-lbc-ec3426b7dcd55e97.elb.us-west-2.amazonaws.com"
    static let IMAGE_URL_PREFIX = "https:"
    
    static let CHATSTER_API_USER_PORT = ":3000"
    static let CHATSTER_API_USER_Q_PORT = ":3100"
    static let CHATSTER_E2E_PORT = ":4000"
    static let CHATSTER_E2E_Q_PORT = ":4100"
    static let CHATSTER_CHAT_PORT = ":5000"
    static let CHATSTER_CHAT_Q_PORT = ":5100"
    static let CHATSTER_GROUP_E2E_PORT = ":6000"
    static let CHATSTER_GROUP_E2E_Q_PORT = ":6100"
    static let CHATSTER_GROUP_CHAT_PORT = ":7000"
    static let CHATSTER_GROUP_CHAT_Q_PORT = ":7100"
    static let CHATSTER_CREATORS_PORT = ":8000"
    static let CHATSTER_CREATORS_Q_PORT = ":8100"
    
    
    static let CHATSTER_GROUP_CHAT_MESSAGE = "groupchat"
    static let CHATSTER_ONE_TO_ONE_CHAT_MESSAGE = "chat"
    static let CHATSTER_SPY_CHAT_MESSAGE = "spyChat"
    static let CHATSTER_SPY_CHAT_CONNECTION = "connectionToSpyChat"
    static let CHATSTER_OPEN_GROUP_CHAT_MESSAGE = "opengroupchat"
    static let CHATSTER_OPEN_CHAT_MESSAGE = "openchat"
    static let CHATSTER_HANDLE_CHAT_MESSAGE = "message"
    static let CHATSTER_HANDLE_GROUP_CHAT_MESSAGE = "groupchatmessage"
    static let CHATSTER_HANDLE_CHAT_ONLINE_STATUS = "contactOnline"
    static let CHATSTER_MESSAGE_RECEIVED = "messageReceived"
    static let CHATSTER_GROUP_MESSAGE_RECEIVED = "groupMessageReceived"
    static let CHATSTER_SAVE_CREATORS_POST = "saveCreatorPost"
    static let CHATSTER_SAVE_CREATORS_TEXT_POST = "saveCreatorTextPost"
    static let CHATSTER_CONNECT_WITH_CREATOR = "connectWithCreator"
    static let CHATSTER_DISCONNECT_WITH_CREATOR = "disconnectWithCreator"
    static let CHATSTER_LIKE_CREATORS_POST = "likeCreatorPost"
    static let CHATSTER_UNLIKE_CREATORS_POST = "unlikeCreatorPost"
    static let CHATSTER_DELETE_CREATORS_POST = "deleteCreatorPost"
    static let CHATSTER_SEARCH_FOR_CREATOR = "searchForCreator"
    static let CHATSTER_POST_COMMENT_FOR_CREATOR_POST = "postCommentForCreatorPost"
    
    static let CHATSTER_IMAGE_MESSAGE = "Sent you an image"
    
    static let CHATSTER_EMPTY_STRING = ""
    static let CHATSTER_SPACE_STRING = " "
    static let CHATSTER_EQUALS = "="
    static let CHATSTER_OPEN_SQUARE_BRACKETS = "["
    static let CHATSTER_CLOSE_SQUARE_BRACKETS = "]"
    static let CHATSTER_OPEN_ROUND_BRACKETS = "("
    static let CHATSTER_CLOSE_ROUND_BRACKETS = ")"
    static let CHATSTER_FORWARD_SLASH = "/"
    static let CHATSTER_LETTER_N = "N"
    static let CHATSTER_COMMA = ","
    static let CHATSTER_POINT = "."
    static let CHATSTER_STAR = "*"
    static let CHATSTER_SEMICOLON = ""
    static let CHATSTER_HASH_TAG = "#"
    static let CHATSTER_MINUS = "-"
    static let CHATSTER_DASH = "-"
    static let CHATSTER_AT = "@"
    static let CHATSTER_QUESTION_MARK = "?"
    
    static let CHATSTER_PLUS = "+"
    static let CHATSTER_ZERO = "0"
    static let CHATSTER_DOUBLE_ZERO = "00"
    static let CHATSTER_HI_MY_NAME_IS = "Hi, my name is "
    static let CHATSTER_GROUP_CHAT_INVITATION_MSG = "groupChatInvitation"
    static let CHATSTER_CHAT_MSG = "chatMsg"
    static let CHATSTER_MESSAGE_TYPE = "msgType"
    static let CHATSTER_GROUP_CHAT_MSG = "groupChatMsg"
    static let CHATSTER_SELECT_PICTURE = "Select Picture"
    static let CHATSTER_SELECT_VIDEO = "Select Video"
    static let CHATSTER_UPDATE_USER = "updateUser"
    static let CHATSTER_UPDATED_USER = "updatedUser"
    static let CHATSTER_UPDATE_GROUP = "updateGroup"
    static let CHATSTER_UPDATED_GROUP = "updatedGroup"
    static let CHATSTER_UPDATED_UNSEND = "updatedUnsend"
    static let CHATSTER_UNSEND_ALLOW = "unsendAllow"
    static let CHATSTER_UNSEND_FORBID = "unsendForbid"
    static let CHATSTER_UNSEND_MESSAGE = "unsendMessage"
    static let CHATSTER_UNSEND_MESSAGE_GROUP = "unsendMessageGroup"
    static let CHATSTER_NOT_ALLOWED_UNSEND_MESSAGE = "notAllowedToUnsend"
    static let CHATSTER_MESSAGE_DELIVERY_STATUS = "messageDeliveryStatus"
    static let CHATSTER_USERNAME_AVAILABILITY = "checkUserNameAvailability"
    
    
    static let CHATSTER_PHONE_TO_VERIFY = "phoneToVerify"
    static let CHATSTER_VERIFY_AGE = "minimumAgeDialog"
    
    static let CHATSTER_SPY_MODE_QUESTION = "spyModeQuestion"
    static let CHATSTER_CONTACT_NOT_REGISTERED = "notRegistered"
    static let CHATSTER_CONTACT_NAME = "conatctName"
    
    
    static let CHATSTER_PRIVACY_POLICY_URL = "http://www.mwsoft.nl/chatster/privacy-policy.html"
    static let CHATSTER_TERMS_AND_POLICIES_URL = "http://www.mwsoft.nl/chatster/terms-policies.html"
    static let CHATSTER_GDPR_URL = "http://www.mwsoft.nl/chatster/gdpr-rights.html"
    static let CHATSTER_PASTE = "PASTE"
    
    static let MAX_HEIGHT = 1024
    static let MAX_WIDTH = 1024
    
    static let PICK_IMAGE_REQUEST = 1
    static let REQUEST_IMAGE_CAPTURE = 2
    static let PICK_VIDEO_REQUEST = 3
    
    
    static let ACCEPT_GROUP_INVITATION_INTENT = "ACCEPT_GROUP_INVITATION_INTENT"
    static let ACCEPT_GROUP_INVITATION_REQUEST = "ACCEPT_GROUP_INVITATION_REQUEST"
    static let DECLINE_GROUP_INVITATION_INTENT = "DECLINE_GROUP_INVITATION_INTENT"
    static let DECLINE_GROUP_INVITATION_REQUEST = "DECLINE_GROUP_INVITATION_REQUEST"
    
    static let READ_GROUP_CHAT_MESSAGE_INTENT = "READ_GROUP_CHAT_MESSAGE_INTENT"
    static let READ_GROUP_CHAT_MESSAGE_REQUEST = "READ_GROUP_CHAT_MESSAGE_REQUEST"
    
    static let READ_MESSAGE_INTENT = "READ_MESSAGE_INTENT"
    static let READ_MESSAGE_REQUEST = "READ_MESSAGE_REQUEST"
    
    static let ACCEPT_MESSAGE_FROM_UNKNOWN_INTENT = "ACCEPT_MESSAGE_FROM_UNKNOWN_INTENT"
    static let ACCEPT_MESSAGE_FROM_UNKNOWN_REQUEST = "ACCEPT_MESSAGE_FROM_UNKNOWN_REQUEST"
    static let DECLINE_MESSAGE_FROM_UNKNOWN_INTENT = "DECLINE_MESSAGE_FROM_UNKNOWN_INTENT"
    static let DECLINE_MESSAGE_FROM_UNKNOWN_REQUEST = "DECLINE_MESSAGE_FROM_UNKNOWN_REQUEST"
    
    static let REQUEST_CODE = 10
    
    static let READ_CONTACTS = 0
    static let MAKE_MANAGE_CALLS = 1
    static let ACCESS_FILES = 2
    static let PERMISSION_DENIED = 3
    static let ALL_PERMISSIONS_GRANTED = 4
    
    static let NULL = "NULL"
    
    static let CHATSTER_FILE_PROVIDER = "nl.mwsoft.www.chatster.fileprovider"
    
    static let LOCAL_NOTIFICATION_JOB_SERVICE = 1002
    static let CONTACT_LATEST_NOTIFICATION_JOB_SERVICE = 1004
    static let RESEND_MESSAGE_JOB_SERVICE = 1005
    
    
    static let ACCEPT_PENDING_INTENT_REQUEST = 1002
    static let DECLINE_PENDING_INTENT_REQUEST = 1001
    static let REPLY_MESSAGE_PENDING_INTENT_REQUEST = 1000
    
    static let FRAGMENT_TAG = "fragment_tag"
    
    
    static let CHATSTER_DOCUMENT_TYPE_IMAGE = "image/*"
    static let CHATSTER_DOCUMENT_TYPE_VIDEO = "video/*"
    
    
    static let CHATSTER_SENDER_ID = "senderId"
    static let CHATSTER_GROUP_CHAT_ID = "groupChatId"
    static let CHATSTER_MESSAGE_TEXT = "messageText"
    static let CHATSTER_MESSAGE_CREATED = "messageCreated"
    static let CHATSTER_MESSAGE_UUID = "uuid"
    static let CHATSTER_MESSAGE_PBK_UUID = "groupMemberPBKUUID"
    static let CHATSTER_MESSAGE_CONTACT_PK_UUID = "contactPublicKeyUUID"
    static let CHATSTER_MESSAGE_STATUS = "status"
    static let CHATSTER_MESSAGE_CHAT_NAME = "chatname"
    static let CHATSTER_SPY_CHAT_ACTION = "action"
    static let CHATSTER_SPY_CHAT_ACTION_JOIN = "join"
    static let CHATSTER_SPY_CHAT_ACTION_DISCONNECT = "disconnect"
    static let CHATSTER_SPY_CHAT_ACTION_JOINED = "joined"
    static let CHATSTER_SPY_CHAT_ACTION_REJECTED = "rejected"
    static let CHATSTER_SPY_CHAT_ACTION_SPY_IS_OFFLINE = "spyIsOffline"
    
    static let CHATSTER_CREATORS_POST_UUID = "uuid"
    static let CHATSTER_CREATORS_POST_STATUS = "status"
    static let CHATSTER_CREATORS_POST_UPDATED_LIKES = "updatedLikes"
    static let CHATSTER_CREATORS_NAME = "creatorsName"
    
    
    static let OFFLINE_MESSAGE_NOTIFICATION = "{data_type=offline_message}"
    static let GROUP_OFFLINE_MESSAGE_NOTIFICATION = "{data_type=group_offline_message}"
    static let GROUP_INVITATION_NOTIFICATION = "{data_type=group_invitation_message}"
    static let CREATOR_POST_NOTIFICATION = "{data_type=creator_post_message}"
    static let CREATOR_FOLLOW_NOTIFICATION = "{data_type=creator_follow_message}"
    static let CREATOR_UNFOLLOW_NOTIFICATION = "{data_type=creator_unfollow_message}"
    static let CREATOR_POST_COMMENT_NOTIFICATION = "{data_type=creator_post_comment_message}"
    static let CREATOR_POST_LIKE_NOTIFICATION = "{data_type=creator_post_like_message}"
    static let CREATOR_POST_UNLIKE_NOTIFICATION = "{data_type=creator_post_unlike_message}"
    
    
    static let NEW_GROUP_MEMBERS_ADDED = "New members added to the group."
    
    static let CHATSTER_DATE_TIME_FORMAT = "yyyyMMdd_HHmmss"
    static let CHATSTER_JPG_EXTENSION = ".jpg"
    static let CHATSTER_MP4_EXTENSION = ".mp4"
    static let CHATSTER_IMAGE_NAME_PART1 = "JPEG_"
    static let CHATSTER_VIDEO_NAME_PART1 = "MP4_"
    static let CHATSTER_IMAGE_NAME_PART2 = "_"
    static let CHATSTER_VIDEO_NAME_PART2 = "_"
    static let CHATSTER_PROJECTION_ORIENTATION = "orientation"
    static let CHATSTER_PROJECTION_DATE_ADDED = "date_added"
    static let CHATSTER_SORT_ORDER_DATE_ADDED_DESC = "date_added desc"
    static let CHATSTER_TEMP_IMAGE_NAME = "temporary_file.jpg"
    
    
    static let SPEECH_INPUT_REQUEST = 100
    
    
    static let INTRO_VIEW_PAGER_FIRST_PAGE = 0
    static let INTRO_VIEW_PAGER_LAST_PAGE = 5
    static let INTRO_VIEW_PAGER_ONE_BEFORE_LAST_PAGE = 4
    static let INTRO_VIEW_PAGER_TOTAL_AMOUNT_PAGES = 6
    
    static let ALLOWED_TO_UNSEND = 1
    static let NOT_ALLOWED_TO_UNSEND = 0
    
    static let CREATORS_POST_TYPE = "postType"
    static let CREATORS_POST_TEXT = "postText"
    static let CREATORS_URI = "uri"
    static let CREATORS_PHOTO_URI = "photoUri"
    static let CREATORS_VIDEO_URI = "videoUri"
    static let CREATORS_POST = "creatorPost"
    static let CREATORS_PROFILE = "creatorProfile"
    
    static let CREATORS_NOTIFICATION_TYPE_POST = "post"
    static let CREATORS_NOTIFICATION_TYPE_POST_LIKE = "postLike"
    static let CREATORS_NOTIFICATION_TYPE_POST_UNLIKE = "postUnlike"
    static let CREATORS_NOTIFICATION_TYPE_POST_COMMENT = "postComment"
    
    static let READ_HISTORY_ITEM_INTENT = "READ_HISTORY_ITEM_INTENT"
    static let READ_HISTORY_ITEM_REQUEST = "READ_HISTORY_ITEM_REQUEST"
    
    static let READ_HISTORY_ITEM_PENDING_INTENT_REQUEST = 1005
    
    static let USER_NAME = "userName"
    static let INVITEE_NAME = "inviteeName"
    
    static let AMOUNT_OF_ONE_TIME_KEY_PAIRS_AT_REGISTRATION = 20
    static let AMOUNT_OF_ONE_TIME_KEY_PAIRS_AT_REPLENISHMENT = 20
    
    static let AMOUNT_OF_GROUP_ONE_TIME_KEY_PAIRS_AT_CREATION = 20
    static let AMOUNT_OF_GROUP_ONE_TIME_KEY_PAIRS_AT_REPLENISHMENT = 20

    
}
