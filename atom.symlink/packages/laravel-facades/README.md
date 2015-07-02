# Laravel Facades

An atom.io package to view the source of built-in Laravel 4 facades.

## Installation

Use the atom package manager, which can be found in the Preferences view, or run `apm install laravel-facades` from the command line.

This package assumes your composer vendor/ directory is at the root of the project you have open as that it what it uses to retrieve the source files to open.

## Usage

This package can be accessed view the `Packages/Laravel Facades` menu in the top menu bar, or it can be accessed by opening the command panel using `cmd + shift + p` and typing the Facade class name and hitting enter when the correct item is selected. If there are other items in the command panel, just prefix what you're searching with `Laravel Facades` or `Facade` to narrow the results.

When a Facade is selected using either of these methods, its source file will open in a new tab.
