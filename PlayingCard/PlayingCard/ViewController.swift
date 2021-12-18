//
//  ViewController.swift
//  PlayingCard
//
//  Created by joon-ho kil on 2021/12/14.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet weak var playingCardView: PlayingCardView! {
		didSet {
			let swipe = UISwipeGestureRecognizer(target: self, action: #selector(nextCard))
			swipe.direction = [.left,.right]
			playingCardView.addGestureRecognizer(swipe)
		}
	}
	
	@IBAction func flipCard(_ sender: UITapGestureRecognizer) {
		switch sender.state {
		case .ended:
			playingCardView.isFaceUp.toggle()
		default: break
		}
		
	}
	@objc func nextCard() {
		if let card = deck.draw() {
			playingCardView.rank = card.rank.order
			playingCardView.suit = card.suit.rawValue
		}
	}
	
	var deck = PlayingCardDeck()
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}


}

