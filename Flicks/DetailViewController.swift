//
//  DetailViewController.swift
//  Flicks
//
//  Created by jacky nguyen on 3/9/16.
//  Copyright © 2016 jacky nguyen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var movie:NSDictionary!
    
    @IBOutlet weak var posterImage: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        print(movie)
        titleLabel.text = movie["title"] as? String
        overviewLabel.text = movie["overview"] as? String
        overviewLabel.sizeToFit()
        contentScrollView.contentSize = CGSize(width: contentView.frame.width, height: contentView.frame.height)
        let BasePath = "https://image.tmdb.org/t/p/w342"
        
        if let urlPath = movie["poster_path"] as? String {
            let url = NSURL(string: BasePath + urlPath)
            posterImage.setImageWithURL(url!)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
