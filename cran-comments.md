## Resubmission

This is a resubmission after comments from CRAN via email sent on April 3, 2020.
I have copied CRAN's comments here, placed in blockquote markup and provided my
response immediately following.

CRAN wrote:

> Please add a web reference for this API in your Description field of the
> DESCRIPTION file in the form
> <http:...> or <https:...>
> with angle brackets for auto-linking and no space after 'http:' and
> 'https:'.

I have made this change.

CRAN wrote:

> Please always write non-English usage, package names, software names and
> API names in *undirected* single quotes in title and description in the
> DESCRIPTION file.

I have single-quoted references to proper names in the `DESCRIPTION` file's
'Description' field as requested.

CRAN wrote:

> Please always add all authors, contibutors and copyright holders in the
> Authors@R field with the appropriate roles...[elided]

I added my indicated copyright holder to the `DESCRIPTION` file with the role
`cph`.

CRAN wrote:

> When creating examples please keep in mind that the structure
> would be desirable: [elided]

I appreciate the feedback on the style used in the examples. I have looked over
the examples in the exported functions and made some changes but I don't think
they quite match what you're looking for. I prefer my style over yours and would
like to keep the examples the way they are if at all possible.

CRAN wrote:

> Please add \value to all .Rd files for exported functions and explain
the functions results in the documentation.

I have ensured all exported functions have `\value` tags in their associated
`.Rd` files.

## Test environments

On GitHub Actions:

- windows-latest, R 3.6
- macOS-latest, R 3.6
- macos-latest, R devel
- ubuntu 18.04, R 3.6
- ubuntu 18.04, R devel

## R CMD check results

There were no ERRORS, WARNINGS, one NOTES:

NOTE  checking CRAN incoming feasibility
   Maintainer: 'Bryce Mecum <mecum@nceas.ucsb.edu>'

   New submission

