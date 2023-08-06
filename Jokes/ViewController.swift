// ViewController.swift
// Created by Anastasiya Kudasheva

import UIKit

class ViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet weak var jokeView: UIView!
    @IBOutlet weak var setupJokeLabel: UILabel!
    @IBOutlet weak var typeJokeLabel: UILabel!
    @IBOutlet weak var countJokeIDLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    var joke: JokeModel?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRandomJoke()
    }
    
    // MARK: - Loading Indicator Helpers
    
    func startLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
            self.setupJokeLabel.isHidden = true
        }
    }
    func stopLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.setupJokeLabel.isHidden = false
        }
    }
    
    // MARK: - Displaying Jokes
    
    func showJoke(_ joke: JokeModel?) {
        if let joke = joke {
            setupJokeLabel.text = "\(joke.setup)"
            typeJokeLabel.text = "\(joke.type)"
            countJokeIDLabel.text = "\(joke.id)"
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func showPunchButtonTapped(_ sender: Any) {
        if let joke = joke {
            let alertController = UIAlertController(title: "Punchline",
                                                    message: "\(joke.punchline)",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok",
                                         style: .default,
                                         handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            let feedbackGenerator = UINotificationFeedbackGenerator()
            feedbackGenerator.notificationOccurred(.success)
        }
    }
    @IBAction func refreshButtonTapped(_ sender: Any) {
        fetchRandomJoke()
    }
    
    // MARK: - Fetching Jokes
    
    func fetchRandomJoke() {
        guard let url = URL(string: "https://official-joke-api.appspot.com/jokes/random") else {
            return
        }
        startLoading()
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                self?.stopLoading()
                if let data = data,
                   let joke = try? JSONDecoder().decode(JokeModel.self, from: data) {
                    self?.joke = joke
                    self?.showJoke(joke)
                } else {
                    print("Error fetching joke.")
                }
            }
        }
        task.resume()
        let feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator.selectionChanged()
    }
}
