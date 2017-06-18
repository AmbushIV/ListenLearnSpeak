//
//  LessonsVC.swift
//  ListenLearnSpeak
//
//  Created by Ionut Demeterca on 07/06/2017.
//  Copyright © 2017 Ionut Demeterca. All rights reserved.
//

import UIKit
import SwiftyJSON

class LessonsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var collection: UICollectionView!
    
    var buttonPressed: UILabel!
    var lectieSelected: String!
    
    var lesson = [Lesson]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        collection.dataSource = self
        collection.delegate = self
        
        loadCsv()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LessonSelectCell", for: indexPath) as? LessonSelectCell {
            
            let lessons = lesson[indexPath.row]
            
            cell.configureCell(lessons)
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let lessons = lesson[indexPath.row]
        
        self.goToLesson(lectieId: lessons.lectieId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lesson.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
    
    func loadCsv() {
        
        let path = Bundle.main.path(forResource: "lectii", ofType: "csv")!
        
            do {
                let csv = try CSV(contentsOfURL: path)
                let rows = csv.rows
                
                for row in rows {
                    let lectieId = Int(row["id"]!)!
                    let titlu = row["titlu"]!
                    
                    let lessons = Lesson(lectieId: lectieId)
                    lessons.getSubj(titlu: titlu)
                    lesson.append(lessons)
                    
                }
                
            } catch let err as NSError {
                print(err.debugDescription)
            }
        
    }
    
    private func goToLesson(lectieId: Int) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LearnVC") as! LearnVC
        controller.lessonNr = lectieId
        self.present(controller, animated: true, completion: nil)
        
    }

}
