import UIKit
import GameplayKit

class ViewController: UIViewController {

    @IBOutlet weak var choicesStackView: UIStackView!

    @IBOutlet weak var answersStackView: UIStackView!

    @IBAction func playAgain(_ sender: Any) {
        startGame(answer: pickRandomWord())
    }

    let possibleAnswers = [
        "MOMMY",
        "OWEN",
        "HENRY",
        "NOTHING",
        "NO",
        "ELSE"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        startGame(answer: pickRandomWord())
    }
    
    private func pickRandomWord() -> String {
        let total = possibleAnswers.count
        let randomIndex = Int(arc4random()) % total
        return possibleAnswers[randomIndex]
    }

    private func startGame(answer: String) {
        choicesStackView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        answersStackView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }

        let choices = Array(answer)
        let randomizedChoices = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: choices)

        for letter in randomizedChoices {
            let button = makeButton(text: String(describing: letter))
            choicesStackView.addArrangedSubview(button)
        }
    }

    private func makeButton(text: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(text, for: .normal)
        button.backgroundColor = UIColor.green
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }

    @objc func buttonAction(sender: UIButton) {
        let otherSuperview = (sender.superview == choicesStackView) ? answersStackView : choicesStackView
        sender.removeFromSuperview()
        otherSuperview!.addArrangedSubview(sender)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

