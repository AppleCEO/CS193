//
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by joon-ho kil on 2021/12/15.
//

import UIKit

@IBDesignable
class PlayingCardView: UIView {
	@IBInspectable
	var rank: Int = 5 { didSet { setNeedsDisplay(); setNeedsLayout() } }
	@IBInspectable
	var suit: String = "♥️" { didSet { setNeedsDisplay(); setNeedsLayout() } }
	@IBInspectable
	var isFaceUp = true { didSet { setNeedsDisplay(); setNeedsLayout() } }
	
	private func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString {
		var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
		font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = .center
		return NSAttributedString(string: string, attributes: [.paragraphStyle:paragraphStyle, .font:font])
	}
	private var cornerString: NSAttributedString {
		return centeredAttributedString(rankString+"\n"+suit, fontSize: cornerFontSize)
	}
	
	private lazy var upperLeftCornerLabel: UILabel = createCornerLabel()
	private lazy var lowerRightCornerLabel: UILabel = createCornerLabel()
	
	private func createCornerLabel() -> UILabel {
		let label = UILabel()
		label.numberOfLines = 0
		addSubview(label)
		return label
	}
	
	private func configureCornerLabel(_ label: UILabel) {
		label.attributedText = cornerString
		label.frame.size = CGSize.zero
		label.sizeToFit()
		label.isHidden = !isFaceUp
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		setNeedsDisplay()
		setNeedsLayout()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		configureCornerLabel(upperLeftCornerLabel)
		upperLeftCornerLabel.frame.origin = bounds.offsetBy(dx: cornerOffset, dy: cornerOffset).origin
		
		configureCornerLabel(lowerRightCornerLabel)
		lowerRightCornerLabel.transform = CGAffineTransform.identity
			.translatedBy(x: lowerRightCornerLabel.frame.size.width, y: lowerRightCornerLabel.frame.size.height)
			.rotated(by: CGFloat.pi)
		lowerRightCornerLabel.frame.origin = bounds.offsetBy(dx: bounds.maxX - cornerOffset - lowerRightCornerLabel.frame.size.width, dy: bounds.maxY - cornerOffset - lowerRightCornerLabel.frame.size.height).origin
		
	}
	
	override func draw(_ rect: CGRect) {
		let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
		roundedRect.addClip()
		UIColor.white.setFill()
		roundedRect.fill()
		
		if !isFaceUp {
			if let cardBackImage = UIImage(named: "cardback", in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
				cardBackImage.draw(in: bounds)
			}
		}
		
//		bounds 에는 zoom 이 없다는 에러 발생
//		if let faceCardImage = UIImage(named: rankString+suit) {
//			faceCardImage.draw(in: bounds.zoom(by: SizeRatio.faceCardImageSizeToBoundsSize))
//		}
    }

}

extension PlayingCardView {
	private struct SizeRatio {
		static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
		static let cornerRadiusToBoundsHeihgt: CGFloat = 0.06
		static let cornerOffsetToCornerRadius: CGFloat = 0.33
		static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
	}
	private var cornerRadius: CGFloat {
		return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeihgt
	}
	private var cornerOffset: CGFloat {
		return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
	}
	private var cornerFontSize: CGFloat {
		return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
	}
	private var rankString: String {
		switch rank {
		case 1: return "A"
		case 2...10: return String(rank)
		case 11: return "J"
		case 12: return "Q"
		case 13: return "K"
		default: return "?"
		}
	}
}

