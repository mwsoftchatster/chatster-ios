/*
  Copyright (C) 2017 - 2020 MWSOFT
  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.
  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.
  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import Foundation

class GroupChatMessage {
    
    var messageText: String!
    var fromId: String!
    var toId: String!
    var creationDate: Date!
    var imageUrl: String?
    var imageHeight: NSNumber?
    var imageWidth: NSNumber?
    var videoUrl: String?
    var read: Bool!
    
    init(messageText: String!, fromId: String!, toId: String!, creationDate: Date!, imageUrl: String?, imageHeight: NSNumber?, imageWidth: NSNumber?, videoUrl: String?, read: Bool!) {
        
        self.messageText = messageText
        
        self.fromId = fromId
        
        self.toId = toId
        
        self.creationDate = creationDate
        
        self.imageUrl = imageUrl
        
        self.imageHeight = imageHeight
        
        self.imageWidth = imageWidth
        
        self.videoUrl = videoUrl
        
        self.read = read
        
    }
    
    func getChatPartnerId() -> String {
        return "2"
    }
    
}
