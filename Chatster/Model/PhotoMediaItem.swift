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
import JSQMessagesViewController

class PhotoMediaItem: JSQPhotoMediaItem {
    
    override func mediaViewDisplaySize() -> CGSize {
        
        let defaultSize : CGFloat = 256
        
        var thumbSize : CGSize = CGSize(width: defaultSize, height: defaultSize)
        
        if (self.image != nil && self.image.size.height > 0 && self.image.size.width > 0) {
            
            let aspect : CGFloat = self.image.size.width / self.image.size.height
            
            if (self.image.size.width > self.image.size.height) {
                thumbSize = CGSize(width: defaultSize, height: defaultSize / aspect)
            } else {
                thumbSize = CGSize(width: defaultSize * aspect, height: defaultSize)
            }
            
        }
        
        return thumbSize
        
    }
    
}
