//
//  OnboardingViewController.swift
//  Epark
//
//  Created by iheb mbarki on 4/11/2022.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var slides: [OnboardingSlide] = []
    
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                nextBtn.setTitle("Get Started", for: .normal)
            } else {
                nextBtn.setTitle("Next", for: .normal)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        slides = [
//            OnboardingSlide(title: "Best Parking Spots", description: "When you're on the go, the free Carpark app makes it easy to find and pay for parking without running back to feed the meter. And for added convenience, you can reserve spots ahead of time.", image: UIImage(named: "park.png")!),
//            OnboardingSlide(title: "Quick Navigation", description: "Carpark puts the power to park in your hands. Whether you're looking for a spot now or reserving a spot for later, Carpark has you covered.", image:UIImage(named: "map.png")!),
//            OnboardingSlide(title: "Easy Payment", description: "No change? Quickly pay for on-street parking right from your mobile device.", image:UIImage(named: "payment.png")!)
//
//        ]
//        pageControl.numberOfPages = slides.count
    }
    
    @IBAction func nextBtnClicked(_ sender: Any) {
        if currentPage == slides.count - 1 {
            let controller = storyboard?.instantiateViewController(withIdentifier: "firstHomeVC") as! UINavigationController
            controller.modalPresentationStyle = .automatic
            controller.modalTransitionStyle = .coverVertical
            
        
            
            present(controller, animated: true, completion: nil)
              

        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
        }

    }
    
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as! OnboardingCollectionViewCell
        cell.setUp(slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}
