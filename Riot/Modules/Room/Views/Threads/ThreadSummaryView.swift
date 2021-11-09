// 
// Copyright 2021 New Vector Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import Reusable

@objc
protocol ThreadSummaryViewDelegate: AnyObject {
    func tappedThreadSummaryView(_ summaryView: ThreadSummaryView, for thread: MXThread)
}

/// A view to display a summary for an `MXThread` generated by the `MXThreadingService`.
@objcMembers
class ThreadSummaryView: UIView {
    
    private enum Constants {
        static let viewHeight: CGFloat = 32
        static let cornerRadius: CGFloat = 4
    }
    
    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var numberOfRepliesLabel: UILabel!
    @IBOutlet private weak var lastMessageAvatarView: UserAvatarView!
    @IBOutlet private weak var lastMessageContentLabel: UILabel!
    
    private(set) var thread: MXThread! {
        didSet {
            configure()
        }
    }
    
    weak var delegate: ThreadSummaryViewDelegate?
    
    // MARK: - Setup
    
    static func instantiate(withThread thread: MXThread) -> ThreadSummaryView {
        let view = ThreadSummaryView.loadFromNib()
        view.thread = thread
        view.update(theme: ThemeService.shared().theme)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    static func contentViewHeight(forThread thread: MXThread, fitting maxWidth: CGFloat) -> CGFloat {
        return Constants.viewHeight
    }
    
    private func configure() {
        clipsToBounds = true
        layer.cornerRadius = Constants.cornerRadius
        
        guard let thread = thread else { return }
        numberOfRepliesLabel.text = String(thread.numberOfReplies)
        guard let lastMessage = thread.lastMessage else {
            lastMessageAvatarView.avatarImageView.image = nil
            lastMessageContentLabel.text = nil
            return
        }
        guard let session = thread.session else { return }
        let lastMessageSender = session.user(withUserId: lastMessage.sender)
        
        let fallbackImage = AvatarFallbackImage.matrixItem(lastMessage.sender,
                                                           lastMessageSender?.displayname)
        let avatarViewData = AvatarViewData(matrixItemId: lastMessage.sender,
                                            displayName: lastMessageSender?.displayname,
                                            avatarUrl: lastMessageSender?.avatarUrl,
                                            mediaManager: session.mediaManager,
                                            fallbackImage: fallbackImage)
        lastMessageAvatarView.fill(with: avatarViewData)
        
        guard let eventFormatter = session.roomSummaryUpdateDelegate as? MXKEventFormatter,
              let room = session.room(withRoomId: lastMessage.roomId) else {
            return
        }
        
        room.state { [weak self] roomState in
            guard let self = self else { return }
            let formatterError = UnsafeMutablePointer<MXKEventFormatterError>.allocate(capacity: 1)
            self.lastMessageContentLabel.text = eventFormatter.string(from: lastMessage, with: roomState, error: formatterError)
        }
    }
    
    // MARK: - Action
    
}

extension ThreadSummaryView: NibLoadable {}

extension ThreadSummaryView: Themable {
    
    func update(theme: Theme) {
        backgroundColor = theme.colors.system
        numberOfRepliesLabel.textColor = theme.colors.secondaryContent
        lastMessageContentLabel.textColor = theme.colors.secondaryContent
    }
    
}
