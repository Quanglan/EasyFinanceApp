//
//  ViewController.swift
//  EasyFinance
//
//  Created by Quang Lan on 13/11/2022.
//

import UIKit
import FirebaseAuth
import Toast_Swift
import RealmSwift

class ViewController: UIViewController {

    @IBOutlet weak var statusLB: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()
        //setupViewControllers()

        
        // Do any additional setup after loading the view.
    }
    
    func getUser() {
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let email = user.email
            let displayName = user.displayName
            let photoURL = user.photoURL
            
            statusLB.text = """
            uid: \(uid)
            email: \(email ?? "N/A")
            displayName: \(displayName ?? "N/A")
            photoURL: \(photoURL?.absoluteString ?? "N/A")
            """
        }
    }

    func logOut() {
        do {
            try Auth.auth().signOut()
            routeToLogin()
        } catch let signOutError as NSError {
            let alert = UIAlertController(title: "Error", message: signOutError.localizedDescription, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
    
    func routeToLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        keyWindow?.rootViewController = homeVC
    }
    
    func setupViewControllers() {
        let tabBarController = TabBarController()
//        present(tabBarController, animated: true)
        navigationController?.pushViewController(tabBarController, animated: true)
    }
    @IBAction func tapNextButton(_ sender: Any) {
        let tabBarVC = TabBarController()
        tabBarVC.modalPresentationStyle = .overFullScreen
        present(tabBarVC, animated: true)
    }
    
    @IBAction func createItemData(_ sender: Any) {
        
        addNewItemData()
        addNewCurrency()
        addNewWallet()
   
        //get location
        let locale = Locale.current.identifier
        print(String(locale).prefix(2))
        let locate = Locale.current.identifier
        let countryCode = String(locate).prefix(2)
        if countryCode == "vi" {
            let currency = realm.objects(Currency.self).where { query in
                query.country == "Việt Nam"
            }.first
            try! realm.write({
                currency?.selected = true
            })
        }

    }
    func updateItem() {
        let item = realm.objects(Item.self)
        for queryItem in item {
            if queryItem.name == "Thu tài chính" || queryItem.name == "Thu nhập" {
                try! realm.write {
                    queryItem.type = "income"
                }
            }
        }
    }
    func addNewItemData() {
        addItem("Ăn uống" , "fork.knife.circle.fill" , "Color18" , "spend")
        addItem("Chỗ ở" , "house.circle.fill" , "Color10" , "spend")
        addItem("Mua sắm" , "cart.circle.fill" , "Color04" , "spend")
        addItem("Xe cộ - Đi lại" , "car.circle.fill" , "Color28" , "spend")
        addItem("Giải trí - Thể thao" , "headphones.circle.fill" , "Color12" , "spend")
        addItem("Y tế - Sức khỏe" , "cross.circle.fill" , "Color06" , "spend")
        addItem("Giáo dục" , "graduationcap.circle.fill" , "Color16" , "spend")
        addItem("Quan hệ" , "person.2.circle.fill" , "Color01" , "spend")
        addItem("Đầu tư" , "chart.line.uptrend.xyaxis.circle.fill" , "Color21" , "spend")
        addItem("Chi tài chính" , "calendar.badge.minus" , "Color22" , "spend")
        addItem("Thu tài chính" , "calendar.badge.plus" , "Color31" , "income")
        addItem("Thu nhập" , "dollarsign.circle.fill" , "Color29" , "income")

        addSubItem("Ăn sáng" , "ansang" , "Color18" , "Ăn uống")
        addSubItem("Ăn trưa" , "antrua" , "Color18" , "Ăn uống")
        addSubItem("Ăn nhậu" , "annhau" , "Color18" , "Ăn uống")
        addSubItem("Fast food" , "annhanh" , "Color18" , "Ăn uống")
        addSubItem("Gọi đồ ăn" , "goidoan" , "Color18" , "Ăn uống")
        addSubItem("Ăn nhà hàng" , "annhahang" , "Color18" , "Ăn uống")
        addSubItem("Café, sinh tố.." , "cafe" , "Color18" , "Ăn uống")
        addSubItem("Ăn uống vặt" , "anvat" , "Color18" , "Ăn uống")
        addSubItem("Đi chợ" , "dicho" , "Color18" , "Ăn uống")
        addSubItem("Ăn uống khác" , "anuongkhac" , "Color18" , "Ăn uống")

        addSubItem("Thuê nhà" , "thuenha" , "Color10" , "Chỗ ở")
        addSubItem("Trả góp nhà" , "tragopnha" , "Color10" , "Chỗ ở")
        addSubItem("Tiền điện" , "dien" , "Color10" , "Chỗ ở")
        addSubItem("Tiền nước" , "nuoc" , "Color10" , "Chỗ ở")
        addSubItem("Tiền net" , "net" , "Color10" , "Chỗ ở")
        addSubItem("Cước viễn thông" , "dienthoai" , "Color10" , "Chỗ ở")
        addSubItem("Truyền hình cáp" , "cabtv" , "Color10" , "Chỗ ở")
        addSubItem("Phí chung cư" , "phicanho" , "Color10" , "Chỗ ở")
        addSubItem("Sửa chữa nhà cửa.." , "suanha" , "Color10" , "Chỗ ở")
        addSubItem("Phí chỗ ở khác" , "house.circle.fill" , "Color10" , "Chỗ ở")

        addSubItem("Quần áo, giày dép" , "tshirt.fill" , "Color04" , "Mua sắm")
        addSubItem("Phụ kiện thời trang" , "command.circle.fill" , "Color04" , "Mua sắm")
        addSubItem("Các thiết bị điện tử" , "power.circle.fill" , "Color04" , "Mua sắm")
        addSubItem("Trang sức và phụ kiện" , "sun.max.circle" , "Color04" , "Mua sắm")
        addSubItem("Đồ gia dụng, làm vườn" , "snowflake.circle.fill" , "Color04" , "Mua sắm")
        addSubItem("Các đồ dùng thiết yếu" , "leaf.circle.fill" , "Color04" , "Mua sắm")
        addSubItem("Văn phòng phẩm" , "bolt.slash.circle.fill" , "Color04" , "Mua sắm")
        addSubItem("Thú cưng, vật nuôi" , "hare.fill" , "Color04" , "Mua sắm")
        addSubItem("Đồ cho bé" , "moon.circle" , "Color04" , "Mua sắm")
        addSubItem("Mỹ phẩm" , "mouth.fill" , "Color04" , "Mua sắm")
        addSubItem("Mua sắm khác" , "cart.circle.fill" , "Color04" , "Mua sắm")

                
        addSubItem("Vé máy bay" , "airplane.circle.fill" , "Color28" , "Xe cộ - Đi lại")
        addSubItem("Vé xe công cộng" , "tram.circle.fill" , "Color28" , "Xe cộ - Đi lại")
        addSubItem("Phí gọi taxi" , "car.circle.fill" , "Color28" , "Xe cộ - Đi lại")
        addSubItem("Phí gọi motobike" , "bicycle.circle.fill" , "Color28" , "Xe cộ - Đi lại")
        addSubItem("Phí thuê xe" , "car.circle" , "Color28" , "Xe cộ - Đi lại")
        addSubItem("Mua xe, Trả góp" , "dollarsign.circle.fill" , "Color28" , "Xe cộ - Đi lại")
        addSubItem("Xăng dầu" , "fuelpump.circle" , "Color28" , "Xe cộ - Đi lại")
        addSubItem("Sửa chữa bảo dưỡng" , "wrench.and.screwdriver.fill" , "Color28" , "Xe cộ - Đi lại")
        addSubItem("Bảo hiểm xe" , "dollarsign.circle.fill" , "Color28" , "Xe cộ - Đi lại")
        addSubItem("Gửi xe" , "p.circle.fill" , "Color28" , "Xe cộ - Đi lại")
        addSubItem("Xe cộ - giao thông khác" , "o.circle.fill" , "Color28" , "Xe cộ - Đi lại")
                
        addSubItem("Đi bar" , "hourglass.circle.fill" , "Color12" , "Giải trí - Thể thao")
        addSubItem("Đi karaoke" , "music.mic.circle.fill" , "Color12" , "Giải trí - Thể thao")
        addSubItem("Đi sàn nhảy" , "figure.walk.circle.fill" , "Color12" , "Giải trí - Thể thao")
        addSubItem("Đi xem phim" , "film.circle.fill" , "Color12" , "Giải trí - Thể thao")
        addSubItem("Đi xem ca kịch" , "theatermasks.circle.fill" , "Color12" , "Giải trí - Thể thao")
        addSubItem("Đi casino" , "figure.walk.circle.fill" , "Color12" , "Giải trí - Thể thao")
        addSubItem("Đi cắm trại" , "figure.walk.circle.fill" , "Color12" , "Giải trí - Thể thao")
        addSubItem("Đi du lịch, thăm quan" , "figure.walk.circle.fill" , "Color12" , "Giải trí - Thể thao")
        addSubItem("Vé xem thể thao" , "sportscourt.fill" , "Color12" , "Giải trí - Thể thao")
        addSubItem("Phí chơi thể thao" , "sportscourt.fill" , "Color12" , "Giải trí - Thể thao")
        addSubItem("Thể thao - giải trí khác" , "o.circle.fill" , "Color12" , "Giải trí - Thể thao")

        addSubItem("Spa" , "heart.circle" , "Color06" , "Y tế - Sức khỏe")
        addSubItem("Tập yoga" , "heart.circle.fill" , "Color06" , "Y tế - Sức khỏe")
        addSubItem("Tập thể hình, gsym" , "figure.roll" , "Color06" , "Y tế - Sức khỏe")
        addSubItem("Khám chữa bệnh" , "cross.circle.fill" , "Color06" , "Y tế - Sức khỏe")
        addSubItem("Thuốc thang" , "pills.circle.fill" , "Color06" , "Y tế - Sức khỏe")
        addSubItem("Y tế - sức khỏe khác" , "cross.circle.fill" , "Color06" , "Y tế - Sức khỏe")
            
        addSubItem("Học phí chính" , "graduationcap.circle" , "Color16" , "Giáo dục")
        addSubItem("Sách vở đồ dùng" , "books.vertical.circle.fill" , "Color16" , "Giáo dục")
        addSubItem("Bản quyền software" , "r.circle.fill" , "Color16" , "Giáo dục")
        addSubItem("Ipad, laptop.vv" , "tv.circle.fill" , "Color16" , "Giáo dục")
        addSubItem("Các khoá học thêm" , "bag.circle.fill" , "Color16" , "Giáo dục")
        addSubItem("Giáo dục khác" , "graduationcap.circle" , "Color16" , "Giáo dục")

        addSubItem("Người thân" , "person.2.circle.fill" , "Color01" , "Quan hệ")
        addSubItem("Họ hàng" , "person.2.circle.fill" , "Color01" , "Quan hệ")
        addSubItem("Bạn bè" , "person.2.circle.fill" , "Color01" , "Quan hệ")
        addSubItem("Đồng nghiệp" , "person.2.circle.fill" , "Color01" , "Quan hệ")
        addSubItem("Quan hệ, giao lưu" , "person.2.circle.fill" , "Color01" , "Quan hệ")
        addSubItem("Đám giỗ, hiếu hỉ" , "larisign.circle.fill" , "Color01" , "Quan hệ")
        addSubItem("Cưới hỏi, tiệc tùng.." , "bolt.heart.fill" , "Color01" , "Quan hệ")
        addSubItem("Xã hội khác" , "person.2.circle.fill" , "Color01" , "Quan hệ")

        addSubItem("Trái phiếu" , "banknote.fill" , "Color21" , "Đầu tư")
        addSubItem("Cổ phiếu" , "chart.line.uptrend.xyaxis.circle.fill" , "Color21" , "Đầu tư")
        addSubItem("Vàng bạc, đá quý" , "diamond.circle.fill" , "Color21" , "Đầu tư")
        addSubItem("Đồ cổ" , "lock.rectangle.on.rectangle.fill" , "Color21" , "Đầu tư")

        addSubItem("Cho vay" , "arrowshape.turn.up.right.circle.fill" , "Color22" , "Chi tài chính")
        addSubItem("Trả nợ" , "calendar.badge.minus" , "Color22" , "Chi tài chính")
                
        addSubItem("Thu nợ" , "calendar.badge.plus" , "Color31" , "Thu tài chính")
        addSubItem("Đi vay" , "arrowshape.turn.up.left.circle.fill" , "Color31" , "Thu tài chính")

        addSubItem("Lương, thưởng" , "creditcard.circle.fill" , "Color29" , "Thu nhập")
        addSubItem("Bán hàng, kinh doanh" , "manatsign.circle.fill" , "Color29" , "Thu nhập")
        addSubItem("Được cho biếu tài trợ" , "gift.circle.fill" , "Color29" , "Thu nhập")
        addSubItem("Đi làm thêm" , "figure.walk.circle.fill" , "Color29" , "Thu nhập")
        addSubItem("Nhận cổ tức" , "coloncurrencysign.circle.fill" , "Color29" , "Thu nhập")
        addSubItem("Cho thuê tài sản" , "building.columns.circle.fill" , "Color29" , "Thu nhập")
        addSubItem("Thu bán tài sản" , "building.columns.circle.fill" , "Color29" , "Thu nhập")
        addSubItem("Youtuber, TikToker.." , "camera.fill.badge.ellipsis" , "Color29" , "Thu nhập")
        addSubItem("Thu nhập khác" , "dollarsign.circle.fill" , "Color29" , "Thu nhập")

    }
    
    func addNewCurrency() {
        addCurrency("Việt Nam",    "Việt Nam Đồng", "VND", "đ", "vietnam")
        addCurrency("Hoa Kỳ", "Đô la", "USD", "$", "american")
        addCurrency("Canada", "Đô la", "CAD", "$", "canada")
        addCurrency("Anh", "Bảng", "GBP", "£", "england")
        addCurrency("Úc", "Đô la", "AUD", "$", "australia")
        addCurrency("Đức", "Euro", "EUR", "€", "german")
        addCurrency("Pháp", "Euro", "EUR", "€", "france")
        addCurrency("Italy", "Euro", "EUR", "€", "italy")
        addCurrency("Nga", "Rúp", "RUB", "₽", "russia")
        addCurrency("Trung Quốc", "Nhân dân tệ", "CNY", "¥", "china")
        addCurrency("Nhật Bản",    "Yên", "JPY", "¥", "japan")
        addCurrency("Hàn Quốc",    "Won", "KRW", "₩", "korea")
        addCurrency("Indonesia", "Rupiar", "IRD", "Rp", "indonesia")
        addCurrency("Singapore", "Đô la", "SGD", "$", "singapore")
        addCurrency("Thái Lan",    "Bạt", "THB", "฿", "thailand")
        addCurrency("Philippin", "Peso", "PHP", "₱", "philippin")
        addCurrency("Malaysia",    "Ringgit", "RM", "RM", "malaysia")

    }
    
    func addNewWallet() {
        addWallet("Tiền mặt", "", "Color20", 500000)
    }
    
    func addItem(_ name: String, _ iconName: String, _ colorName: String, _ type: String) {
        let item = Item(name: name, iconName: iconName, colorName: colorName, type: type)
        try! realm.write {
            realm.add(item)
        }
    }
    
    func addCurrency(_ country: String, _ name: String, _ symbol: String, _ shortSymbol: String, _ flagName: String) {
        let currency = Currency(country: country, name: name, symbol: symbol, shortSymbol: shortSymbol, flagName: flagName)
        
        try! realm.write {
            realm.add(currency)
        }
    }
    
    func addWallet(_ name: String, _ note: String, _ colorName: String, _ openBal: Double) {
        let wallet = Wallet(name: name, note: note, colorName: colorName, openBal: openBal)
        try! realm.write({
            realm.add(wallet)
        })
    }
    
    func addSubItem(_ name: String, _ iconName: String, _ colorName: String, _ itemName: String) {
        let item = realm.objects(Item.self).where { query in
            query.name == itemName
        }.first
        
        if let item = item {
            let subItem = SubItem(name: name, iconName: iconName, colorName: colorName, item: item)
            
            try! realm.write {
                realm.add(subItem)
                //item.subItems.append(subItem)
            }
        }
        
    }
}
