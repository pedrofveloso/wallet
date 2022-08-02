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

