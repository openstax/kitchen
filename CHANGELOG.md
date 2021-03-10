# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.1.0] - 2021-03-10

* Created `UnitElement` and `UnitElementEnumerator` classes

* Added support for Units in `BakeToc` direction

* Added `Unit` to `en.yml`

* Remove chapter summary titles only if they exist

## [2.0.0] - 2020-12-18

* Refactored bake_exercises to better support parallel work on multiple versions.
(minor change) Does not affect existing recipes.

* Changed the main gem source file to have the same name as the gem (`openstax_kitchen`) so that you don't have to `require` a different name than you use in your `gem` call.

## [1.0.0] - 2020-12-15

* First official version.
