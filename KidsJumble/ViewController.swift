import UIKit
import GameplayKit

class ViewController: UIViewController {

    private var answer: String!

    @IBOutlet weak var choicesStackView: UIStackView!

    @IBOutlet weak var answersStackView: UIStackView!

    @IBOutlet weak var playAgainButton: UIButton!

    @IBAction func playAgain(_ sender: Any) {
        startGame(word: pickWord())
    }

    let possibleAnswers = [
        "CAT",
        "DOG",
        "PIG",
        "GOAT",
        "OWL",
        "COW",
        "FROG",
        "FOX"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        startGame(word: pickWord())
    }

    private func pickWord() -> String {
        return pickRandomWord()
    }

    private func pickRandomWord() -> String {
        let total = possibleAnswers.count
        let randomIndex = Int(arc4random()) % total
        return possibleAnswers[randomIndex]
    }

    private func scrambleWord(word: String) -> [String.Element] {
        let choices = Array(word)

        var scrambled: [String.Element] = []
        repeat {
            scrambled = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: choices) as! [String.Element]
        } while scrambled == choices

        return scrambled
    }

    private func startGame(word: String) {
        self.playAgainButton.isHidden = true
        self.answer = word
        let scrambledWord: [String.Element] = scrambleWord(word: word)

        choicesStackView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        answersStackView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }

        for letter in scrambledWord {
            let button = makeButton(text: String(describing: letter))
            choicesStackView.addArrangedSubview(button)
        }
    }

    private func makeButton(text: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(text, for: .normal)
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }

    @objc func buttonAction(sender: UIButton) {
        let otherSuperview = (sender.superview == choicesStackView) ? answersStackView : choicesStackView
        sender.removeFromSuperview()
        otherSuperview!.addArrangedSubview(sender)
        checkForWin()
    }

    public func checkForWin() {
        let buttons: [UIButton] = answersStackView.arrangedSubviews as! [UIButton]
        let buttonTitles: [String] = buttons.map { (button) -> String in
            return button.title(for: .normal)!
        }
        let answerAttempt = buttonTitles.joined()
        if (answerAttempt == self.answer) {
            let alerter: UIAlertController = UIAlertController(title: "YAY!", message: "You did it!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.playAgainButton.isHidden = false
            })
            alerter.addAction(okAction)
            self.present(alerter, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

