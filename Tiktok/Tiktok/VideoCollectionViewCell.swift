//
//  VideoCollectionViewCell.swift
//  Tiktok
//
//  Created by CDI on 8/10/22.
//

import UIKit
import AVFoundation

protocol VideoCollectionViewCellDelegate: AnyObject {
    func didTapProfileButton(with model: VideoModel)
    func didTapLikeButton(with model: VideoModel)
    func didTapCommentButton(with model: VideoModel)
    func didTapShareButton(with model: VideoModel)
}

class VideoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "VideoCollectionViewCell"
    
    weak var delegate: VideoCollectionViewCellDelegate?
    
    var player: AVPlayer?
    
    private var model: VideoModel?
    
    private let videoContainer = UIView()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .label
        
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .label
        
        return label
    }()
    
    private let trackLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .label
        
        return label
    }()
    
    private let profileButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "person.circle"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "text.bubble.fill"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "arrowshape.turn.up.right.fill"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.clipsToBounds = true
        contentView.layer.masksToBounds = true
        
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        
        contentView.addSubview(videoContainer)
        
        contentView.addSubview(usernameLabel)
        contentView.addSubview(captionLabel)
        contentView.addSubview(trackLabel)
        
        
        contentView.addSubview(profileButton)
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(shareButton)
        
        profileButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTapCommentButton), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        
        videoContainer.clipsToBounds = true
        contentView.sendSubviewToBack(videoContainer)
    }
    
    @objc private func didTapProfileButton() {
        print("didTapProfileButton")
        guard let model = model else { return }
        delegate?.didTapProfileButton(with: model)
    }
    
    @objc private func didTapLikeButton() {
        print("didTapLikeButton")
        guard let model = model else { return }
        delegate?.didTapLikeButton(with: model)
    }
    
    @objc private func didTapCommentButton() {
        print("didTapCommentButton")
        guard let model = model else { return }
        delegate?.didTapCommentButton(with: model)
    }
    
    @objc private func didTapShareButton() {
        print("didTapShareButton")
        guard let model = model else { return }
        delegate?.didTapShareButton(with: model)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        captionLabel.text = nil
        trackLabel.text = nil
        usernameLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        videoContainer.frame = contentView.bounds
        
        // buttons
        let buttonSize = contentView.frame.size.width/7
        let contentViewWidth = contentView.frame.size.width
        let contentViewHeight = contentView.frame.size.height - 100
        
        shareButton.frame = CGRect(
            x: contentViewWidth-buttonSize-10,
            y: contentViewHeight-buttonSize-10,
            width: buttonSize
            , height: buttonSize)
        
        commentButton.frame = CGRect(
            x: contentViewWidth-buttonSize-10,
            y: contentViewHeight-(buttonSize*2)-20,
            width: buttonSize
            , height: buttonSize)
        
        likeButton.frame = CGRect(
            x: contentViewWidth-buttonSize-10,
            y: contentViewHeight-(buttonSize*3)-30,
            width: buttonSize
            , height: buttonSize)
        
        profileButton.frame = CGRect(
            x: contentViewWidth-buttonSize-10,
            y: contentViewHeight-(buttonSize*4)-40,
            width: buttonSize
            , height: buttonSize)
        
//        shareButton.backgroundColor = .red
//        commentButton.backgroundColor = .red
//        likeButton.backgroundColor = .red
//        profileButton.backgroundColor = .red
        
        trackLabel.frame = CGRect(
            x: 10,
            y: contentViewHeight,
            width: contentViewWidth-buttonSize-10,
            height: 20)
        
        captionLabel.frame = CGRect(
            x: 10,
            y: contentViewHeight-40,
            width: contentViewWidth-buttonSize-10,
            height: 20)
        
        usernameLabel.frame = CGRect(
            x: 10,
            y: contentViewHeight-80,
            width: contentViewWidth-buttonSize-10,
            height: 20)
    }
    
    public func configure(with model: VideoModel) {
        self.model = model
        configureVideo()
        
        // labels
        captionLabel.text = model.caption
        trackLabel.text = model.audioTrackName
        usernameLabel.text = model.username
        
    }
    
    private func configureVideo() {
        guard let model = model else {
            print("Cant find model")
            return
        }
        guard let path = Bundle.main.path(
            forResource: model.videoFileName,
            ofType: model.videoFileFormat) else {
            print("Failed to find video")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        player = AVPlayer(url: url)
        
        let playerView = AVPlayerLayer()
        playerView.player = player
        playerView.frame = contentView.bounds
        playerView.videoGravity = .resizeAspectFill
        
        videoContainer.layer.addSublayer(playerView)
        player?.volume = 0.0
        player?.play()

    }
    
}
