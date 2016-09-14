# Change log
All notable changes to this product will be documented below.
This file is influenced by http://keepachangelog.com/.

## [Unreleased]
### Added
- Added ability to link to another page by id
- Added EDITOR.md as a central location for documenting the editor
- News lists can be filtered by ministers and departments
- Image upload function available in editorial

### Changed
- Updated ui-kit to v1.8.0

### Fixed
- Pluralise 'ministers' only where appropriate
- Fixed HSTS settings so we don't force every gov.au subdomain to run over https
- Performance of /news page
- Updated layout of news article page


## [v1.3.1] - 2016-09-07
### Added

### Changed
- Update homepage

### Fixed
- Auth failure in /editorial now redirected to /users/sign_in


## [v1.3.0] - 2016-09-07
### Added
- Admin dashboard for sessions
- Added 'What is GOV.AU Beta?' callout to homepage
- Improved request and data change logging

### Changed
- Incorrect attempts at verifying identity locks the user out
- Change git merge strategy for CHANGELOG.md to reduce conflicts
- users are now soft deleted to preserve relationship with submissions
- Upgrade UI kit to v1.7.6
- User sessions timeout after 90 minutes idle
- Update News article page template

### Fixed
- Markdown support for images with links
- GTM tag is now in <body>
- email address is now validated on feedback form
- removed prompt to sign up when unauthenticated

## [v1.2.1] - 2016-08-31
### Added

### Changed
- Removed 30 day grace window on 2FA

### Fixed
- Fixed issue where the 'Popular now' heading on Category pages was displaying even if there were no Popular now links
- Fixed visual defect with box-shadow being incorrectly displayed on School holiday highlighted list items


## [v1.2.0] - 2016-08-31
### Added
- Added two-factor authentication via SMS and authenticator to sign-in/up and verification
- Verification of identity when accessing protected pages
- Phone number verification when changing numbers
- Simple feedback system and admin
- Rendering # links as placeholder spans
- Section owners and admins can create new users
- Importing database dump from S3
- Footer links can be maintained using a "About GOV.AU" section

### Changed
- Upgrade Rails to v5.0.0.1
- Upgrade UI kit to v1.7.5
- Improvements to Category landing page layout including collapsing regions
- Remove references to content analysis service
- HTTP basic authentication is now toggleable

### Fixed
- Fixed leaking email addresses on password reset and resend email confirmation pages
- Remove instances of permit! mass assignment
- Improved accessibility
- Switched to database backed session stores for greater security
- Fixed styling of the active page in the sidebar
- Seeded users do not require email confirmation
- Fixed bug that was preventing reordering children of a section home

### Removed
- A user can no longer sign themselves up


## [v1.1.0] - 2016-08-23
### Added
- Added ability to group topics into categories
- Added collecting test metadata for CircleCI
- Added ability to mark pages as placeholders that appear in navigation
- Rake task for dumping, santising, and uploading the database to AWS S3

### Changed
- Upgrade UI kit to v1.7.4
- Removed optional content editors like editor.md and trumbowyg
- Deleted summary text on Minister and Departments listing pages
- Improvements to the database scrubbing script
- Added new demo category layout to the homepage

### Fixed
- The page preview in the editor does not allow javascript to be previewed
- Don't let admins search on password hash
- Update visual design of admin sign-in form
- Images of states crests on homepage look correct in IE8

## [v1.0.3] - 2016-08-16
### Added
- Include git tag and sha1 on editorial footer
- Added automated accessibility tests

### Changed
- Error pages are now styled like the rest of the site

### Fixed
- The html title tag reflects the page name
- Node preview layout in editorial now correctly wraps metadata header
- Improved support for IE
- Correctly check for a valid node type when creating nodes
- Fixed some accessibility issues


## [v1.0.2] - 2016-08-03
### Added
- Transition links displayed on root page

### Changed

### Fixed


## [v1.0.1] - 2016-08-03
### Added
- DB scrub script
- Email is enabled in production
- Only allows sign-up for \*.gov.au email addresses
- Confirmation of email address is now switched on for all new users

### Changed
- Updated demo script to include all steps
- Header logo hover state is brand bar turning white
- Link beneath related topics includes anchor

### Fixed
- Accessing news for an unknown section returns file not found

## [v1.0.0] - 2016-08-02
### Added
- Added favicon
- Added link to homepage via GOV.AU logo in header

### Changed
- /departments listing style is now the same as /ministers
- Upgrade UI kit to v1.7.2
- 'More News' links below news on section homepages
- Removed summaries from /departments

### Fixed
- Made agencies link null again
- Abstract markup fixed to match uikit-1.7.1
- Added missing heros to /ministers, /departments and /categories
- Images provided in vendor folder can be referenced using the asset system
- Reduced height of homepage category listings
- Popular links breakpoints now react as expected

## [v0.9.0] - 2016-08-01
- Section news index page now has a navbar consistent with rest of section
- Incumbent minister's name next to related minister link in dept homepages
- Added Times and Dates content for ACT, Victoria and NSW
- Links to State government websites on homepage

### Changed

- News item listings use h3s instead of h2s
- Updated 'Popular now' links
- Upgrade UI kit to v1.7.1
- Make 'abstract' CSS class in dates and times custom templates look like h3
- Removed dummy links from the footer
- Section news index pages now include distributed items
- Updated homepage category descriptions


### Fixed

- Section navbar correctly displays the active and current list items
- Fixed footer markup
- Added the long summary form field back to the new submission page
- Renamed summary to long summary in node creation form
- Added News header to section news listing page
- Fixed the markup of the hero on section news listing page
- UI Kit updater now overwrites updated images
- Public holiday and School holiday dates for QLD and TAS
- States in dates and times consistently use h4

## [v0.8.1] - 2016-07-29
### Added

- Link to 'Our Role' beneath related topics for department homepages
- Support for Google Tag Manager

### Changed

- Amended ministers index text
- Disabled Turbolinks
- Added missing authorization checks
- Removed spurious `<p>` tag around the node content body
- Applied proper ui-kit styling to the approve membership button on requests

### Fixed

- Added validation to news article release_date
- Agencies link on homepage does nothing rather than 404ing
- Distributions saving on news article create
- Removed borders from related topics on department homepages


## [v0.8.0] - 2016-07-29
### Added

- Static related topics for department homepages

### Changed
- Updated to ui-kit v1.5
- News hero is now conditional on whether it's the root or section news index


### Fixed

- Listing pages of departments/news/ministers etc. now show links correctly styled
- Fixed editing custom template nodes


## [v0.7.1] - 2016-07-28
### Added

- Support setting user names in admin
- Allow users to specify their name when they sign up

### Changed

- Wrapped news summary in abstract block
- Show currently signed in name in the top right
- Submissions now show all content fields other than just the name & body.
- Refactor homepage images into responsive HTML components
- Update homepage copy
- Refactor SCSS image inlining

### Fixed

- Added breadcrumbs to school holiday pages


## [v0.7.0] - 2016-07-27
### Added

- Added admin-only option to stop a node appearing in breadcrumbs and the menu
- Added links on department homepages to related ministers
- Added long summary field for section_home form and template
- Added route for /:section/news to offer section-filtered view of news items

### Changed

- Short/long summary fields for all nodes sit within page abstract
- Display dates in Sydney timezone
- Relabeled 'Summary' field to 'Long summary'
- Shifted news item breadcrumbs to sit beneath Home > News

### Fixed

- Update link to TV reception page
- Fix check for whether a user can see the accept/reject buttons on a submission
- Add breadcrumbs to times and dates custom pages
- Correctly format news release dates on the root page and section home pages

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
