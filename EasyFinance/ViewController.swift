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
                query.country == "Vi???t Nam"
            }.first
            try! realm.write({
                currency?.selected = true
            })
        }

    }
    func updateItem() {
        let item = realm.objects(Item.self)
        for queryItem in item {
            if queryItem.name == "Thu t??i ch??nh" || queryItem.name == "Thu nh???p" {
                try! realm.write {
                    queryItem.type = "income"
                }
            }
        }
    }
    func addNewItemData() {
        addItem("??n u???ng" , "fork.knife.circle.fill" , "Color18" , "spend")
        addItem("Ch??? ???" , "house.circle.fill" , "Color10" , "spend")
        addItem("Mua s???m" , "cart.circle.fill" , "Color04" , "spend")
        addItem("Xe c??? - ??i l???i" , "car.circle.fill" , "Color28" , "spend")
        addItem("Gi???i tr?? - Th??? thao" , "headphones.circle.fill" , "Color12" , "spend")
        addItem("Y t??? - S???c kh???e" , "cross.circle.fill" , "Color06" , "spend")
        addItem("Gi??o d???c" , "graduationcap.circle.fill" , "Color16" , "spend")
        addItem("Quan h???" , "person.2.circle.fill" , "Color01" , "spend")
        addItem("?????u t??" , "chart.line.uptrend.xyaxis.circle.fill" , "Color21" , "spend")
        addItem("Chi t??i ch??nh" , "calendar.badge.minus" , "Color22" , "spend")
        addItem("Thu t??i ch??nh" , "calendar.badge.plus" , "Color31" , "income")
        addItem("Thu nh???p" , "dollarsign.circle.fill" , "Color29" , "income")

        addSubItem("??n s??ng" , "ansang" , "Color18" , "??n u???ng")
        addSubItem("??n tr??a" , "antrua" , "Color18" , "??n u???ng")
        addSubItem("??n nh???u" , "annhau" , "Color18" , "??n u???ng")
        addSubItem("Fast food" , "annhanh" , "Color18" , "??n u???ng")
        addSubItem("G???i ????? ??n" , "goidoan" , "Color18" , "??n u???ng")
        addSubItem("??n nh?? h??ng" , "annhahang" , "Color18" , "??n u???ng")
        addSubItem("Caf??, sinh t???.." , "cafe" , "Color18" , "??n u???ng")
        addSubItem("??n u???ng v???t" , "anvat" , "Color18" , "??n u???ng")
        addSubItem("??i ch???" , "dicho" , "Color18" , "??n u???ng")
        addSubItem("??n u???ng kh??c" , "anuongkhac" , "Color18" , "??n u???ng")

        addSubItem("Thu?? nh??" , "thuenha" , "Color10" , "Ch??? ???")
        addSubItem("Tr??? g??p nh??" , "tragopnha" , "Color10" , "Ch??? ???")
        addSubItem("Ti???n ??i???n" , "dien" , "Color10" , "Ch??? ???")
        addSubItem("Ti???n n?????c" , "nuoc" , "Color10" , "Ch??? ???")
        addSubItem("Ti???n net" , "net" , "Color10" , "Ch??? ???")
        addSubItem("C?????c vi???n th??ng" , "dienthoai" , "Color10" , "Ch??? ???")
        addSubItem("Truy???n h??nh c??p" , "cabtv" , "Color10" , "Ch??? ???")
        addSubItem("Ph?? chung c??" , "phicanho" , "Color10" , "Ch??? ???")
        addSubItem("S???a ch???a nh?? c???a.." , "suanha" , "Color10" , "Ch??? ???")
        addSubItem("Ph?? ch??? ??? kh??c" , "house.circle.fill" , "Color10" , "Ch??? ???")

        addSubItem("Qu???n ??o, gi??y d??p" , "tshirt.fill" , "Color04" , "Mua s???m")
        addSubItem("Ph??? ki???n th???i trang" , "command.circle.fill" , "Color04" , "Mua s???m")
        addSubItem("C??c thi???t b??? ??i???n t???" , "power.circle.fill" , "Color04" , "Mua s???m")
        addSubItem("Trang s???c v?? ph??? ki???n" , "sun.max.circle" , "Color04" , "Mua s???m")
        addSubItem("????? gia d???ng, l??m v?????n" , "snowflake.circle.fill" , "Color04" , "Mua s???m")
        addSubItem("C??c ????? d??ng thi???t y???u" , "leaf.circle.fill" , "Color04" , "Mua s???m")
        addSubItem("V??n ph??ng ph???m" , "bolt.slash.circle.fill" , "Color04" , "Mua s???m")
        addSubItem("Th?? c??ng, v???t nu??i" , "hare.fill" , "Color04" , "Mua s???m")
        addSubItem("????? cho b??" , "moon.circle" , "Color04" , "Mua s???m")
        addSubItem("M??? ph???m" , "mouth.fill" , "Color04" , "Mua s???m")
        addSubItem("Mua s???m kh??c" , "cart.circle.fill" , "Color04" , "Mua s???m")

                
        addSubItem("V?? m??y bay" , "airplane.circle.fill" , "Color28" , "Xe c??? - ??i l???i")
        addSubItem("V?? xe c??ng c???ng" , "tram.circle.fill" , "Color28" , "Xe c??? - ??i l???i")
        addSubItem("Ph?? g???i taxi" , "car.circle.fill" , "Color28" , "Xe c??? - ??i l???i")
        addSubItem("Ph?? g???i motobike" , "bicycle.circle.fill" , "Color28" , "Xe c??? - ??i l???i")
        addSubItem("Ph?? thu?? xe" , "car.circle" , "Color28" , "Xe c??? - ??i l???i")
        addSubItem("Mua xe, Tr??? g??p" , "dollarsign.circle.fill" , "Color28" , "Xe c??? - ??i l???i")
        addSubItem("X??ng d???u" , "fuelpump.circle" , "Color28" , "Xe c??? - ??i l???i")
        addSubItem("S???a ch???a b???o d?????ng" , "wrench.and.screwdriver.fill" , "Color28" , "Xe c??? - ??i l???i")
        addSubItem("B???o hi???m xe" , "dollarsign.circle.fill" , "Color28" , "Xe c??? - ??i l???i")
        addSubItem("G???i xe" , "p.circle.fill" , "Color28" , "Xe c??? - ??i l???i")
        addSubItem("Xe c??? - giao th??ng kh??c" , "o.circle.fill" , "Color28" , "Xe c??? - ??i l???i")
                
        addSubItem("??i bar" , "hourglass.circle.fill" , "Color12" , "Gi???i tr?? - Th??? thao")
        addSubItem("??i karaoke" , "music.mic.circle.fill" , "Color12" , "Gi???i tr?? - Th??? thao")
        addSubItem("??i s??n nh???y" , "figure.walk.circle.fill" , "Color12" , "Gi???i tr?? - Th??? thao")
        addSubItem("??i xem phim" , "film.circle.fill" , "Color12" , "Gi???i tr?? - Th??? thao")
        addSubItem("??i xem ca k???ch" , "theatermasks.circle.fill" , "Color12" , "Gi???i tr?? - Th??? thao")
        addSubItem("??i casino" , "figure.walk.circle.fill" , "Color12" , "Gi???i tr?? - Th??? thao")
        addSubItem("??i c???m tr???i" , "figure.walk.circle.fill" , "Color12" , "Gi???i tr?? - Th??? thao")
        addSubItem("??i du l???ch, th??m quan" , "figure.walk.circle.fill" , "Color12" , "Gi???i tr?? - Th??? thao")
        addSubItem("V?? xem th??? thao" , "sportscourt.fill" , "Color12" , "Gi???i tr?? - Th??? thao")
        addSubItem("Ph?? ch??i th??? thao" , "sportscourt.fill" , "Color12" , "Gi???i tr?? - Th??? thao")
        addSubItem("Th??? thao - gi???i tr?? kh??c" , "o.circle.fill" , "Color12" , "Gi???i tr?? - Th??? thao")

        addSubItem("Spa" , "heart.circle" , "Color06" , "Y t??? - S???c kh???e")
        addSubItem("T???p yoga" , "heart.circle.fill" , "Color06" , "Y t??? - S???c kh???e")
        addSubItem("T???p th??? h??nh, gsym" , "figure.roll" , "Color06" , "Y t??? - S???c kh???e")
        addSubItem("Kh??m ch???a b???nh" , "cross.circle.fill" , "Color06" , "Y t??? - S???c kh???e")
        addSubItem("Thu???c thang" , "pills.circle.fill" , "Color06" , "Y t??? - S???c kh???e")
        addSubItem("Y t??? - s???c kh???e kh??c" , "cross.circle.fill" , "Color06" , "Y t??? - S???c kh???e")
            
        addSubItem("H???c ph?? ch??nh" , "graduationcap.circle" , "Color16" , "Gi??o d???c")
        addSubItem("S??ch v??? ????? d??ng" , "books.vertical.circle.fill" , "Color16" , "Gi??o d???c")
        addSubItem("B???n quy???n software" , "r.circle.fill" , "Color16" , "Gi??o d???c")
        addSubItem("Ipad, laptop.vv" , "tv.circle.fill" , "Color16" , "Gi??o d???c")
        addSubItem("C??c kho?? h???c th??m" , "bag.circle.fill" , "Color16" , "Gi??o d???c")
        addSubItem("Gi??o d???c kh??c" , "graduationcap.circle" , "Color16" , "Gi??o d???c")

        addSubItem("Ng?????i th??n" , "person.2.circle.fill" , "Color01" , "Quan h???")
        addSubItem("H??? h??ng" , "person.2.circle.fill" , "Color01" , "Quan h???")
        addSubItem("B???n b??" , "person.2.circle.fill" , "Color01" , "Quan h???")
        addSubItem("?????ng nghi???p" , "person.2.circle.fill" , "Color01" , "Quan h???")
        addSubItem("Quan h???, giao l??u" , "person.2.circle.fill" , "Color01" , "Quan h???")
        addSubItem("????m gi???, hi???u h???" , "larisign.circle.fill" , "Color01" , "Quan h???")
        addSubItem("C?????i h???i, ti???c t??ng.." , "bolt.heart.fill" , "Color01" , "Quan h???")
        addSubItem("X?? h???i kh??c" , "person.2.circle.fill" , "Color01" , "Quan h???")

        addSubItem("Tr??i phi???u" , "banknote.fill" , "Color21" , "?????u t??")
        addSubItem("C??? phi???u" , "chart.line.uptrend.xyaxis.circle.fill" , "Color21" , "?????u t??")
        addSubItem("V??ng b???c, ???? qu??" , "diamond.circle.fill" , "Color21" , "?????u t??")
        addSubItem("????? c???" , "lock.rectangle.on.rectangle.fill" , "Color21" , "?????u t??")

        addSubItem("Cho vay" , "arrowshape.turn.up.right.circle.fill" , "Color22" , "Chi t??i ch??nh")
        addSubItem("Tr??? n???" , "calendar.badge.minus" , "Color22" , "Chi t??i ch??nh")
                
        addSubItem("Thu n???" , "calendar.badge.plus" , "Color31" , "Thu t??i ch??nh")
        addSubItem("??i vay" , "arrowshape.turn.up.left.circle.fill" , "Color31" , "Thu t??i ch??nh")

        addSubItem("L????ng, th?????ng" , "creditcard.circle.fill" , "Color29" , "Thu nh???p")
        addSubItem("B??n h??ng, kinh doanh" , "manatsign.circle.fill" , "Color29" , "Thu nh???p")
        addSubItem("???????c cho bi???u t??i tr???" , "gift.circle.fill" , "Color29" , "Thu nh???p")
        addSubItem("??i l??m th??m" , "figure.walk.circle.fill" , "Color29" , "Thu nh???p")
        addSubItem("Nh???n c??? t???c" , "coloncurrencysign.circle.fill" , "Color29" , "Thu nh???p")
        addSubItem("Cho thu?? t??i s???n" , "building.columns.circle.fill" , "Color29" , "Thu nh???p")
        addSubItem("Thu b??n t??i s???n" , "building.columns.circle.fill" , "Color29" , "Thu nh???p")
        addSubItem("Youtuber, TikToker.." , "camera.fill.badge.ellipsis" , "Color29" , "Thu nh???p")
        addSubItem("Thu nh???p kh??c" , "dollarsign.circle.fill" , "Color29" , "Thu nh???p")

    }
    
    func addNewCurrency() {
        addCurrency("Vi???t Nam",    "Vi???t Nam ?????ng", "VND", "??", "vietnam")
        addCurrency("Hoa K???", "???? la", "USD", "$", "american")
        addCurrency("Canada", "???? la", "CAD", "$", "canada")
        addCurrency("Anh", "B???ng", "GBP", "??", "england")
        addCurrency("??c", "???? la", "AUD", "$", "australia")
        addCurrency("?????c", "Euro", "EUR", "???", "german")
        addCurrency("Ph??p", "Euro", "EUR", "???", "france")
        addCurrency("Italy", "Euro", "EUR", "???", "italy")
        addCurrency("Nga", "R??p", "RUB", "???", "russia")
        addCurrency("Trung Qu???c", "Nh??n d??n t???", "CNY", "??", "china")
        addCurrency("Nh???t B???n",    "Y??n", "JPY", "??", "japan")
        addCurrency("H??n Qu???c",    "Won", "KRW", "???", "korea")
        addCurrency("Indonesia", "Rupiar", "IRD", "Rp", "indonesia")
        addCurrency("Singapore", "???? la", "SGD", "$", "singapore")
        addCurrency("Th??i Lan",    "B???t", "THB", "???", "thailand")
        addCurrency("Philippin", "Peso", "PHP", "???", "philippin")
        addCurrency("Malaysia",    "Ringgit", "RM", "RM", "malaysia")

    }
    
    func addNewWallet() {
        addWallet("Ti???n m???t", "", "Color20", 500000)
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
