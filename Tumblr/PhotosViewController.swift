//
//  PhotosViewController.swift
//  Tumblr
//
//  Created by Arnav Jain on 2/2/17.
//  Copyright © 2017 Arnav Jain. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var posts: [NSDictionary] = []

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)
        
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        //print("responseDictionary: \(responseDictionary)")
                        
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        
                        // This is where you will store the returned array of posts in your posts property
                        // self.feeds = responseFieldDictionary["posts"] as! [NSDictionary]
                        self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                        
                        self.tableView.reloadData()
                    }
                }
        });
        task.resume()
        
    }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return posts.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell
            print(indexPath.row)
            
            let post = posts[indexPath.row]
            
            let photos = post.value(forKeyPath: "photos") as? [NSDictionary]
            
            let labelView = post.value(forKeyPath: "blog_name") as? String
            cell.label.text = labelView
            
            if let photos = post.value(forKeyPath: "photos") as? [NSDictionary] {
                // photos is NOT nil, go ahead and access element 0 and run the code in the curly braces
                let photos = photos[0]
            } else {
                // photos is nil. Good thing we didn't try to unwrap it!
            }
            
            let imageUrlString = photos?[0].value(forKeyPath: "original_size.url") as? String
            
            if let imageUrl = URL(string: imageUrlString!) {
                // URL(string: imageUrlString!) is NOT nil, go ahead and unwrap it and assign it to imageUrl and run the code in the curly braces
                cell.imageView?.setImageWith(imageUrl)
            } else {
                // URL(string: imageUrlString!) is nil. Good thing we didn't try to unwrap it!
            }
            
            
            
            
            
            return cell
        }

        // Do any additional setup after loading the view.
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        //... Create; the URLRequest `myRequest` ...
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        let request = URLRequest(url: url!)
        
        // Configure session so that completion handler is executed on main UI thread
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            // ... Use the new data to update the data source ...
            if let responseDictionary = try! JSONSerialization.jsonObject(
                with: data!, options:[]) as? NSDictionary {
                print("responseDictionary: \(responseDictionary)")
                
                // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                // This is how we get the 'response' field
                let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                
                // This is where you will store the returned array of posts in your posts property
                // self.feeds = responseFieldDictionary["posts"] as! [NSDictionary]
                self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                
            }
            
            // Reload the tableView now that there is new data
            self.tableView.reloadData()
        }
        
            // Tell the refreshControl to stop spinning
            refreshControl.endRefreshing()
        
    
    task.resume()
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let vc = segue.destination as? PhotoDetailsViewController
        
        let cell = sender as! PhotoCell
        
        vc?.image = cell.photoView.image
        
        
        }

}
    


