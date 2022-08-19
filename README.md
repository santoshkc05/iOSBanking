# IOS Banking

Sample IOS application using Firebase Authentication, Stripe payment, and Firestore.



## Demo

[Click here](https://github.com/santoshkc05/iOSBanking/blob/main/Samples/Simulator%20Screen%20Recording%20-%20iPhone%2013%20Pro%20Max%20-%202022-08-19%20at%2016.05.42.mp4) to download the demo recorded video.







## Installation

Install the [docker](https://docs.docker.com/get-docker/) in your machine.

[Backend Server](https://github.com/santoshkc05/stripe-springboot) is required for the stripe payment. To complete the payment features you need to run the backend server in your machine.

[Create IOS project](https://firebase.google.com/docs/ios/setup) in the firebase console. You need to complete step 1, step 2 and step 3 of the mentioned document.

Clone this project and hit following command from the project directory.

`
pod install
`

Then build and run the project.

## Features

- User registration using FirebaseAuth
- User login using FirebaseAuth
- Password reset using FirebaseAuth
- Payment using stripe gateway
- Save payment for future uses
- View saved payment methods
- Sign Out
- Support for Light/dark mode




## Used Libraries

 - [Resolver](https://github.com/hmlongco/Resolver)
 - [Stripe](https://github.com/stripe/stripe-ios)
 - [Alamofire](https://github.com/Alamofire/Alamofire)
 - [Firebase](https://firebase.google.com/docs/ios/installation-methods)

## TODO

- Unit test Dashboard modules
- Save products in the backend
- Get products from the backend
- Feature enhancements


## Tests

The test coverage report of the current application is shown below. It is sorted by coverage percentage.

![Coverage](/Samples/coverage.png)
