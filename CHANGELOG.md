# Change log
All notable changes to this product will be documented below.
This file is influenced by http://keepachangelog.com/.

## [Unreleased] -
### Added

### Changed

### Fixed

## [0.6.0] - 2016-07-26
### Added

- Add ability to add news articles from /editorial/news
- Provide link to add news to control bar
- Published news articles now viewable from /:section/news/:slug
- Added scopes to query nodes based on json items
- Ministers index page
- Infrastructure and Telecommunications category (static)
- Categories (static) shown on the homepage
- Provided aggregate list of news from /news
- Added a node type for nodes with custom templates
- Added list of available custom template files when creating a custom template node
- Added published_at field to all pages
- All pages now have short_summary fields
- News article metadata can be edited
- Section home displays most recent published news
- Added public holiday, school holidays and daylight saving pages (static)

### Changed

- Used ui kit via SCSS include for greater customisation
- News articles slugs are now a combination of release dates and article names
- News articles can now be created without a parent
- Nodes can now specify a layout to override with
- Removed news article from the node creation prepare select box
- Moved breadcrumbs above hero banner
- Changed Table of Contents heading to 'On this page'
- News Articles get sorted by published_at date
- News Articles short summary field can be edited

### Fixed

- Skip links work correctly in Chrome

## [0.5.1] - 2016-07-19
### Fixed

- Included necessary imports to fix styling

## [0.5.0] - 2016-07-19
### Added

- Option for adding a table of contents on a general content page
- Links between editorial and public views of pages and section
- Added initial home page layout based on prototype
- Added section home pages
- Added gov.au home page

### Changed

- Update ui kit to v1.2.0
- Improvements to node validators

### Fixed

- Node slugs only need to be unique within a parent
- Update node slugs when updating the name or parent
- Fixed NoMethodError exception on admin agency page
- Fixed NameError exception on editorial node show page

## [0.4.0] - 2016-07-14
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
