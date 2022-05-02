//
//  Protocols.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 21/03/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

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
