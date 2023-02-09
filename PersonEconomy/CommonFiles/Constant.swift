//
//  Constant.swift
//  FugitCustomer
//
//  Created by addis on 09/02/20.
//  Copyright © 2020 addis. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

//MARK:- Screen Resolution
let screenSize = UIScreen.main.bounds
let screenWidth = screenSize.width
let screenHeight = screenSize.height

let MainStoryBoard = "Main"
let ProductStoryBoard = "Products"
let LoanDetials = "LoanDetials"
let Medical = "Medical"
let LIC = "LIC"
let kBorrowStoryBoard = "Borrow"
let Advance = "Advance"
let ksuccess = "Success"
let kPost = "POST"
let kPut = "PUT"
let kLong = "long"
let kprofileImage = "profileImage"
let kContactNumber = "contactNumber"
let kToken = "token"
let kAppName = "Economy"//"SEEQyou"
let kUserId = "userId"
let kUserName = "userName"
let kGender = "gender"
let kEmail = "email"
let kPassword = "password"
let kFirstName = "firstName"
let kName = "name"
let kBirthDay = "birthday"
let kEthnicity = "ethnicity"
let kdevicetype = "I"
let ktype = "type"
let kLogin = "login"
let kDeviceToken = "deviceToken"
let kPersonDataBase = "PersonDataBase"
let kPersistanceStorageName = "PersonEconomy"
var userId:String = "1"
//var personId:String = "2"
var isDataBaseAvailable:Bool = false
var phoneNumber:String = ""
var emailId:String = ""
var cornderRadious:CGFloat = 40.0
var dateCorenerRadious:CGFloat = 10.0
var isPackageSelected:Bool = false
var strSelectedTypeFelt:String = ""//"Angry"
var strSelectedFeeling:String = ""//"Blamed"
var searchPersonName:String = ""
var searchType:String = ""
var feltid:String = ""
var feelingid:String = ""
var ksimulator = "Simulator"
var historySelectedDate = Date()
var deviceID:String = UIDevice.current.identifierForVendor!.uuidString
var kSelectOption = "please select one option"
var kPleaseAddMember = "please add member from home screen"
var kOptionalDateSelectrion = "please select Date"
var kother = "other"
var kCustomer = "Customer"
var kCompanyName = "companyName"
var kLogo = "logo"
var kQRCode = "qrCode"
var kTheamColor = "theamColor"
var kiCloudeAlert = "ShownAlert"
var kNotificationSend = "notificationSend"
var kDate = "Date"
var kMobileDigitAlert = "Mobile number is not more then 10 Digit."
var kFetureAlert = "You can't be select feture date"
var kRegisterOnePerson = "You can register only one user per app"
var kAmountSelectOption = "please enter first amount then select this option"
//MARK:- TypeDefine Declaration
typealias TASelectedIndex = (Int) -> Void
typealias TaSelectedValueSuccess = (String) -> Void
typealias ImagePass = (UIImage) -> Void
typealias taAPIErrorMessage = ((String) -> Void)
typealias taAPISucccesMessage = ((String) -> Void)
typealias updateDataWhenBackClosure = () -> Void
//MARK:- Constant API URL
let baseURL = "http://seeque.icebreakerllc.com/api.asmx/"
let signupAPI = "user_register"
let loginAPI = "login"
let forgotpassword = "forgotpassword"
let getFeelingAPI = "get_all_feeling"
let getRelaxTextAPI = "get_relaxtext"
let getFeltAPI = "get_all_felt"
let getJournalTypeAPI = "get_all_journaltype"
let setFeelingandfeltAPI = "set_feeling_and_felt"
let getFeelingtodayhistoryAPI = "get_feeling_todayhistory"
let setjournaltypequestionAPI = "set_journaltype_and_question"
let getjournaltypequeationAPI = "get_journaltype_and_quesans"
let getTop3feelingjournaltypeAPI = "get_top3_feeling_journaltype"
let getHistoryfeeling7dayAPI = "get_history_feeling_7day"
let setChangePasswordAPI = "reset_password"
let setHistoryJournalTypeAPI = "get_history_journaltype_today"
let getAllGroupsAPI = "get_all_groups"
let getchatmassageAPI = "chatmassageapi" 
let getMyMessageAPI = "getMyMessage"
let setfavoritecommentAPI = "set_favorite_comment"
let sethandclapcommentAPI = "set_handclap_comment"
let setlikecommentAPI = "set_like_comment"
let settrophycommentAPI = "set_trophy_comment"
let getgroupstatsAPI = "get_group_stats"
let getTermsandconditions = "get_Terms_and_conditions"
var strTheamColor = "#8BD1C9"
var arrMemberList = [[String:Any]]()
//let userInfo = "Users"

//MARK:- Constant Struct
typealias reloadTableViewClosure = () -> Void
struct AppMessage {
    var internetIssue:String = "Please check the internet connection"
}
struct CustomFontName {
    var textfieldFontName:String = "helvetica-neue-regular"
    var buttonFontName:String = "helvetica-neue-regular"
    var labelFontName:String = "helvetica-neue-regular"
    var boldHelvetica:String = "HelveticaNeue-Bold"
}
struct CustomFontSize {
    var textfieldFontSize:CGFloat = 28.0 * (screenWidth/320.0)
    var buttonFontSize:CGFloat = 15.0 * (screenWidth/320.0)
    var splaceScreenFontSize:CGFloat = 12.0 * (screenWidth/320.0)
    var labelFontSize:CGFloat = 15.0 * (screenWidth/320)
    var titleFontSize:CGFloat = 16.0 * (screenWidth/320.0)
    var pickerTitleLableSize:CGFloat = 23.0 * (screenWidth/320.0)
    var pickertextFieldSize:CGFloat = 20.0 * (screenWidth/320.0)
}
struct CustomColor {
    //HeaderColor4FB2B4
    var gradeintTopBackGround = "#0074E8"//"#00A9C3"
    var mainBackground = "#FF0000"//"#8BD1C9"//"#377F7F"//"#4FB2B4"//"#70CDCD"
    var textFontColor = "#4FB2B4"
    var pickerFontColor = "#4FB2B4"
    var labelSepratorColor = "#FFFFFF"
    var buttonBackGround = "#377F7F" //"#17B5B7"
    var blueColor = "#0074E8"
    var mainLightBackGround = "#84CACB"
    var journalBackGround = "#D1ECE9"
//"#00aac5"
    var gradeintBottomBackGround = "#0089C0"//"#00aac5"
}
public enum RainbowColor {
    case main,red,orange,green,blue,indigo,violet
    func selectedColor() -> String {
        switch self {
        case .main:
            return "#8BD1C9"
        case .red:
              return "#FF0000"
        case .orange:
              return "#FFA500"
        case .green:
              return "#008000"
        case .blue:
              return "#0000FF"
        case .indigo:
              return "#4B0082"
        case .violet:
              return "#EE82EE"
        default:
            return "#8BD1C9"
        }
    }
}
enum UIUserInterfaceIdiom : Int {
    case unspecified
    
    case phone // iPhone and iPod touch style UI
    case pad   // iPad style UI (also includes macOS Catalyst)
}
struct AppAlertMessage {
    var oldPassword = "Please provide old password"
    var newPassword = "Please provide new password"
    var confirmPassword = "Please provide confirm password"
    var passwordNotMatch = "password does not match"
    var passwordChageSuccess = "password change successfully"
    var accountMessage = "Your account has been deactivated.please contact to app admin"
}
struct Alert {
    func showAlert(message:String,viewController:UIViewController) {
        let alert = UIAlertController(title:kAppName, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}

func setCommanHeaderView(width:CGFloat) -> CommanView {
    let headerViewXib:CommanView = CommanView().instanceFromNib()
    headerViewXib.frame = CGRect(x: 0, y: 0, width: width, height: (screenHeight * 0.1))
    return headerViewXib
}
func getCurrentTimeAndDate() -> (Int,Int) {
    let date = Date()
    let calendar = Calendar.current
    let hour = calendar.component(. hour, from: date)
    let minutes = calendar.component(. minute, from: date)
    return(hour,minutes)
}

func convertDateWithTime(date:String,hour:Int,minutes:Int) -> Date  {
    var dateComponents = DateComponents()
    let arrdevidedString:[String] = date.components(separatedBy: "/")
    dateComponents.year = Int(arrdevidedString[2])
    dateComponents.month = Int(arrdevidedString[1])
    dateComponents.day = Int(arrdevidedString[0])
    dateComponents.timeZone = TimeZone(abbreviation: "UTC") // Japan Standard Time
    var hours:Int = hour
    var minute:Int = minutes
    if hour == nil || hour == 0 {
     let dateAndTime = getCurrentTimeAndDate()
        hours = dateAndTime.0
        minute = dateAndTime.1
    }
    dateComponents.hour = hours
    dateComponents.minute = minute
    let userCalendar = Calendar.current // user calendar
    let someDateTime = userCalendar.date(from: dateComponents)
    return someDateTime!
}
