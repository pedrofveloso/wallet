# Wallet 
A simple wallet where you can add incomes and expenses to track down your finances.

## CI/CD ![example workflow](https://github.com/pedrofveloso/wallet/actions/workflows/ios.yml/badge.svg)
This project is connected with github actions. Each *Pull Request* triggers the workflow responsible for run all the unit tests and the UI test. 

Both tests run using *fastlane*.

## Fastlane
This project provides two lanes which executes unit tests and ui tests.

1. `fastlane unit_tests`: Run the unit tests;
2. `fastlane ui_tests`: Run the UI tests;

To execute them, just open the terminal in the project root folder and run these commands.

## MVP -> Model View Presenter
This project is using MVP architecture.

The View (ViewController) layer is responsible for display the layout and control actions received/triggered by its components.
The Model layer is responsible is responsible for map the entity used by the features.
The Presenter is responsible for apply business logics and treat the data that will be displayed by the view.

## Features
### Statement
This feature is responsible for list all the transactions added by the user. It segregates these transactions by date to improve legibility.

The user can **add** a transaction through the button at the right bottom of the screen.
To **delete** a transaction just swipe left over the transaction cell.

### Add Transaction
In order to add a transaction the use needs to fill the **add transaction form**.
This form is presented as modal, and can be dismissed by hitting anywhere outside of the form view.