//
//  testview.swift
//  NY Times Articles
//
//  Created by Zuhaib Imtiaz on 7/1/22.
//

import Foundation
import UIKit

class ArticleCellView: UIView{
    
    let articleTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 2
        return label
    }()
    
    let articleSublineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 1
        label.textColor = .systemGray
        return label
    }()
    
    let publishedDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 1
        label.textColor = .systemGray
        return label
    }()
    
    let avatarImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imgView.layer.cornerRadius = 25
        return imgView
    }()
    
    let calenderImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        imgView.image = UIImage(systemName: "calendar")
        return imgView
    }()
    
    //Stack View
    let stackView : UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis  = NSLayoutConstraint.Axis.horizontal
        stackView.distribution  = UIStackView.Distribution.fill
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing   = 8
        
        return stackView
    }()
    
    let parentBackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 8
        return view
    }()
    
    convenience init() {
        self.init(frame: .zero)
        self.addViews()
    }
    
    private func addViews() {
        stackView.addArrangedSubview(calenderImageView)
        stackView.addArrangedSubview(publishedDateLabel)

        addSubview(parentBackView)
        self.articleTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.parentBackView.addSubview(articleTitleLabel)
        self.avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        self.parentBackView.addSubview(avatarImageView)
        self.calenderImageView.translatesAutoresizingMaskIntoConstraints = false
        self.parentBackView.addSubview(calenderImageView)
        self.articleSublineLabel.translatesAutoresizingMaskIntoConstraints = false
        self.parentBackView.addSubview(articleSublineLabel)
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.parentBackView.addSubview(stackView)

        addConstraints()
    }
    
    private func addConstraints() {
//        NSLayoutConstraint.activate([
//            self.parentBackView.topAnchor.constraint(equalTo: topAnchor),
//            self.parentBackView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            self.parentBackView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            self.parentBackView.bottomAnchor.constraint(equalTo: bottomAnchor),
//            
//            self.avatarImageView.centerYAnchor.constraint(equalTo: parentBackView.centerYAnchor)
//            
//            self.parentUserNameLabel.leadingAnchor.constraint(equalTo: parentBackView.leadingAnchor, constant: 8),
//
//            self.parentMessageTextView.topAnchor.constraint(equalTo: parentUserNameLabel.bottomAnchor, constant: 3),
//            self.parentMessageTextView.leadingAnchor.constraint(equalTo: parentBackView.leadingAnchor, constant: 8),
//            self.parentMessageTextView.trailingAnchor.constraint(equalTo: parentBackView.trailingAnchor, constant: -50),
//            self.parentMessageTextView.bottomAnchor.constraint(equalTo: parentBackView.bottomAnchor, constant: -2),
//            
//            self.parentImageView.topAnchor.constraint(equalTo: parentBackView.topAnchor, constant: 5),
//            self.parentImageView.trailingAnchor.constraint(equalTo: parentBackView.trailingAnchor, constant: -5),
//            self.parentImageView.leadingAnchor.constraint(equalTo: parentMessageTextView.trailingAnchor, constant: 4),
//            self.parentImageView.bottomAnchor.constraint(equalTo: parentBackView.bottomAnchor, constant: -5),
//        ])
    }
}
