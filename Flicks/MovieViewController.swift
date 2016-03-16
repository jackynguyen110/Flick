//
//  MovieViewController.swift
//  Flicks
//
//  Created by jacky nguyen on 3/7/16.
//  Copyright © 2016 jacky nguyen. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var movies: [NSDictionary]!
    var endPoint:String!
    var errorLabel:UILabel!

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        FetchMovie()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: .ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        createErrorLabel()
        
        if isConnectedToNetwork() == true {
            errorLabel.hidden = true
        } else {
            errorLabel.hidden = false
        }
    }
    
    func refreshControlAction(refreshControl : UIRefreshControl) {
        if isConnectedToNetwork() == true {
            print("a")
            errorLabel.hidden = true
            FetchMovie()
            refreshControl.endRefreshing()
        } else {
            errorLabel.hidden = false
            refreshControl.endRefreshing()

        }


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCellTableViewCell
        let movie = movies[indexPath.row]
        cell.cellTitle.text = movie["title"] as? String
        //cell.cellReview.adjustsFontSizeToFitWidth = true
        cell.cellReview.text = movie["overview"] as? String
        
        let BasePath = "https://image.tmdb.org/t/p/w342"
        
        if let urlPath = movie["poster_path"] as? String {
            let url = NSURL(string: BasePath + urlPath)
            cell.cellIPoster.setImageWithURL(url!)
        }
        
        return cell
    }
    
    func FetchMovie(){
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endPoint)?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        // Display HUD right before the request is made
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                // Hide HUD once the network request comes back (must be done on main UI thread)
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            self.movies = responseDictionary["results"] as![NSDictionary]
                            self.tableView.reloadData()
                            
                    }
                }
        })
        task.resume()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let index = self.tableView.indexPathForCell(cell)
        let movie = movies![index!.row]
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.movie = movie
        
    }
    
    func createErrorLabel() {
        errorLabel = UILabel(frame: CGRect(x: 0, y: 63, width: view.bounds.width, height: 20))
        errorLabel.textAlignment = NSTextAlignment.Center
        errorLabel.textColor = UIColor.whiteColor()
        errorLabel.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        errorLabel.font = UIFont(name: "HelveticaNeue-Bold",
            size: 10.0)
        errorLabel.text = "⚠︎ Network Error"
        view.addSubview(errorLabel)
    }
    
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, UnsafePointer($0))
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = flags == .Reachable
        let needsConnection = flags == .ConnectionRequired
        
        return isReachable && !needsConnection
        
    }

}
