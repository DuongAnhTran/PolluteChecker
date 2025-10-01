# PolluteChecker
A seamless application for searching and accessing air quality forecast assessments. PolluteChecker allows the users to search, view and save their favorites locations, in which they want to see a "forecast" of the air quality for the day. The main objective of the app is to create a portable information viewer that raises users' awareness of health problems that can be caused by poor air quality. The app provides predictions on air quality to encourage users to actively protect their own health, especially during the time where air pollution has become a problem that can cause severe health issues.

All version and commit history for **PolluteChecker** can be found on this [Github Repository](https://github.com/DuongAnhTran/PolluteChecker)

## Team member:
- Duong Anh Tran (24775456)

## Supporting platforms:
This app mainly supports the iOS platform. However, it is also usable on iPadOS as the UI elements are supported on that platform.

## Dependencies:
- Swift and SwiftUI Components (including MapKit, Charts, etc)
- Minimum Deployment (can be changed depending on usage): iOS 18.6+
- External libraries and API:
	- Open-Meteo Air Quality API ([Document](https://open-meteo.com/en/docs/air-quality-api) and [Full Github Repo](https://github.com/open-meteo/open-meteo))

**Notes:** This app mainly utilise the SDK version of this API (even though it allows normal JSON fetching as an alternate method). This is imported directly using SwiftUI Package Dependencies. The URL for the Swift SDK version: https://github.com/open-meteo/sdk.git

## Installation:
1. Clone the repo: `git clone https://github.com/DuongAnhTran/PolluteChecker.git`
2. Open the project in XCode
3. Change application's signing in the project's settings (located in `Signing and Capabilities`) base on intended use (This is only required if the app is going to be used on a device)
4. Build and run the application


## Usage Instruction:
1. For location search:
	- Users can directly access the map view and search bar as soon as the app is loaded
	- Three different search options can be used: **Query** (any prompt - location, address, city, etc), **Coordinate** and **Current Location** (only available if user allows the access to user's location)
	
2. For air quality prediction access:
	- After finish finding a location, user can click on the pin annotation to open a view that shows data related to the air quality prediction of the day (from 00:00 to 23:00 of the current day)
	
3. For location saving, deleting, modifying:
	- Users can click on the "+" button on the top right of the data view to save the location
	- Saved location can be accessed in **Saved Location** in a format of list. When clicked, list item will open the data view again. At this point, the button at the top-right is now the modify button, which allows the user to modify the location's name (Since most of the data related to the location is predetermined by the API and the MapKit Coordination, users can't change those).
	- In **Saved Location** user can also swipe a list item to the left to delete the saved location. Moreover, they can also use the search bar to filter out location for easier access.

**Requirements**: The application needs to be connected with internet all the time in order to work. This is due to the fact that almost all air quality forecast related information are fetched directly from the API. Without internet connection, user can possibly use map search, save, modify, delete functionalities, but won't be able to view air quality forecast.
	

## Current Functionalities:
- Search for location using random query, coordination or fetch user's current location
- View location geological information and air quality forecast for the current day
- Save, modify and delete saved location

	
	
	
	
	
	
