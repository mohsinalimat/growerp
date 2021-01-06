# GrowERP Admin App

A live version is now available at https://admin.growerp.org where you can create your own company

# if you want to run the system locally.
## Quick start: after installation of [Java 11](https://openjdk.java.net/install/):
### Moqui backend:
  - git clone https://github.com/growerp/moqui-framework.git moqui && cd moqui
  - ./gradlew getRuntime
  - git clone https://github.com/growerp/growerp-moqui.git runtime/component/growerp
  - git clone https://github.com/growerp/moqui-paypal.git runtime/component/paypal
  - git clone https://github.com/growerp/PopCommerce.git runtime/component/PopCommerce
  - git clone https://github.com/growerp/mantle-udm.git runtime/component/mantle-udm
  - git clone https://github.com/growerp/mantle-usl.git runtime/component/mantle-usl
  - git clone https://github.com/growerp/SimpleScreens.git runtime/component/SimpleScreens
  - git clone https://github.com/growerp/moqui-fop.git runtime/component/moqui-fop
  - ./gradlew downloadElasticSearch
  - ./gradlew load
  - java -jar moqui.war

### OR...Apache OFBiz backend:
  https://github.com/growerp/growerp-ofbiz

### Flutter app, after [installation of Flutter](https://flutter.dev/docs/get-started/install):
  - git clone https://github.com/growerp/growerp/ admin
  - cd admin
  - flutter run -d chrome

# Introduction.
GrowERP Admin Flutter frontend component for Android, IOS and Web using https://flutter.dev This application is build for the beta version of flutter, you can find the installation instructions at: https://flutter.dev/docs/get-started/web

Although all screens work on IOS/Anderoid/Web devices however a smaller screen will show less information but it is still usable.

It is a simplified frontend however with the ability to still use with, or in addition to the original ERP system screens.
The system is a true multicompany system and can support virtually any ERP backend as long as it has a REST interface.

The system is implemented with https://pub.dev/packages/flutter_bloc state management with the https://bloclibrary.dev documentation, data models, automated tests and a separated rest interface for the different systems. 

The system configuration file is in /assets/cfg/app_settings.json. Select OFBiz or Moqui here.

For test purposes we can provide access to Moqui or OFBiz systems in the cloud.

This admin branch is using the core package stored in the same repository in the 'packages' branch.
This package contains all the basic ERP functions, see the [readme](https://github.com/growerp/growerp/blob/packages/core/README.md) file for more info.

Other branches are under development:
  - Ecommerce : https://github.com/growerp/growerp/tree/ecommerce
  - Hotel : https://github.com/growerp/growerp/tree/hotel

For the backend you need the Moqui or OFBiz ERP framework ERP system
  with an extra component:
  - Moqui:  https://github.com/growerp/growerp-moqui
  - OFBiz:  https://github.com/growerp/growerp-ofbiz

Additional ERP systems can be added on request, A REST interface is required.
The implementation time is 40+ hours.

Functions coming up:
* Accounting
* Inventory
* Purchasing.

Phone                                                                                         |  Tablet/PC
:--------------------------------------------------------------------------------------------:|:---------------------------------------------------------------------------------------:
![](https://raw.githubusercontent.com/growerp/growerp/master/screenPrints/phoneDashboard.png) | ![](https://raw.githubusercontent.com/growerp/growerp/master/screenPrints/pcDashboard.png)
![](https://raw.githubusercontent.com/growerp/growerp/master/screenPrints/phoneCat.png)       | ![](https://raw.githubusercontent.com/growerp/growerp/master/screenPrints/pcCat.png)

![Phone menu](https://raw.githubusercontent.com/growerp/growerp/master/screenPrints/phoneMenu.png)

![Download here a short movie to show the Adaptive App in action](https://raw.githubusercontent.com/growerp/growerp/master/screenPrints/responsive.mp4)

