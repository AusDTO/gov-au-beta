# Change log (as per http://keepachangelog.com/)
All notable changes to this product will be documented below. 
This file is influenced by http://keepachangelog.com/.

## [Unreleased]
- 

## [0.3.4] - 2016-07-14
### Added

- Add editorial view of a page to display history
- Config to support blue/green deployment
- Prometheus metrics 
- Add instructions for migrating data between prod and staging
- Import govCMS data from admin
- Added table support for content
- Support for Minister sections
- Make title of page editable as part of a submission
- Update to ui-kit 1.1
- Support for PaaS instance of govCMS
- Ability to edit page order
- Give user option to update page parent


### Changed

- Only permit a single submission per page
- Only show sections to users if they are a collaborator
- Determine hierarchy by page parent/child relationships instead of using sections


### Fixed

- Only show published pages on section index
- Publish pages when a submission is accepted
- User details can be updated without supplying a new password in admin
- Make page titles a H1
- Display tel: protocol links to telephone numbers correctly

