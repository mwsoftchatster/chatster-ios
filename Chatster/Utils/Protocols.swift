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

protocol ProfileHeaderDelegate {
    func handleFollowUnfollowTapped(for header: ProfileHeader)
    func handleFollowersTapped(for header: ProfileHeader)
    func handleFollowingTapped(for header: ProfileHeader)
}

protocol MainFeedCellDelegate {
    func handleUsernameTapped(for cell: MainFeedCell)
    func handleOptionsTapped(for cell: MainFeedCell)
    func handleLikeTapped(for cell: MainFeedCell, isDoubleTap: Bool)
    func handleCommentTapped(for cell: MainFeedCell)
    func handleConfigureLikeButton(for cell: MainFeedCell)
    func handleShowLikes(for cell: MainFeedCell)
    func configureCommentIndicatorView(for cell: MainFeedCell)
}

protocol CommentInputAccesoryViewDelegate {
    func didSubmit(forComment comment: String)
}

protocol HistoryItemCellDelegate {
    func handleFollowTapped(for cell: HistoryItemCell)
    func handlePostTapped(for cell: HistoryItemCell)
}

protocol Printable {
    var description: String { get }
}

protocol MessageInputAccesoryViewDelegate {
    func handleUploadMessage(message: String)
    func handleSelectImage()
}

protocol ChatCellDelegate {
    func handlePlayVideo(for cell: ChatCell)
}

protocol MessageCellDelegate {
    func configureUserData(for cell: MessageCell)
}
