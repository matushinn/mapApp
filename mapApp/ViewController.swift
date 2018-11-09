//
//  ViewController.swift
//  mapApp
//
//  Created by 大江祥太郎 on 2018/10/28.
//  Copyright © 2018年 shotaro. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    let userDefName = "pins"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadPins()
    }
    
    // ピンの保存
    func savePin(_ pin: Pin) {
        let userDefaults = UserDefaults.standard
        
        // 保存するピンをUserDefaults用に変換します。
        let pinInfo = pin.toDictionary()
        
        if var savedPins = userDefaults.object(forKey: userDefName) as? [[String: Any]] {
            // すでにピン保存データがある場合、それに追加する形で保存します。
            savedPins.append(pinInfo)
            userDefaults.set(savedPins, forKey: userDefName)
            
        } else {
            // まだピン保存データがない場合、新しい配列として保存します。
            let newSavedPins: [[String: Any]] = [pinInfo]
            userDefaults.set(newSavedPins, forKey: userDefName)
        }
    }
    
    // 既に保存されているピンを取得
    func loadPins() {
        let userDefaults = UserDefaults.standard
        
        if let savedPins = userDefaults.object(forKey: userDefName) as? [[String: Any]] {
            
            // 現在のピンを削除
            self.mapView.removeAnnotations(self.mapView.annotations)
            
            for pinInfo in savedPins {
                let newPin = Pin(dictionary: pinInfo)
                self.mapView.addAnnotation(newPin)
            }
        }
    }


    @IBAction func longTapMapView(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state != UIGestureRecognizer.State.began{
            //ロングタップ認識時以外は何もしない
            return
        }
        //位置情報の取得
        //座標を取ってくる
        let point = sender.location(in: mapView)
        //地図上の位置へ変換
        let geo = mapView.convert(point, toCoordinateFrom: mapView)
        // アラートの作成
        let alert = UIAlertController(title: "スポット登録", message: "この場所に残すメッセージを入力してください。", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "登録", style: .default, handler: { (action: UIAlertAction) -> Void in
        
            //アラートで作成したtextFieldの内容
            let pin = Pin(geo: geo, text: alert.textFields?.first?.text)
            //ピンとして登録
            self.mapView.addAnnotation(pin)
            
            self.savePin(pin)
        
        }))
    
        // ピンに登録するテキスト用の入力フィールドをアラートに追加します。
        alert.addTextField(configurationHandler: { (textField: UITextField) in
            
            //textField.attributedPlaceholder = NSAttributedString(string: "メッセージ", attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])
            textField.placeholder = "メッセージ"
        })
        // アラートの表示
        present(alert, animated: true, completion: nil)
    
    print("ロングタップ検出したよ！！")
    }
    
    
}

