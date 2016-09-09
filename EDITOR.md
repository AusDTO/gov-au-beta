# Editing content

## Liquid variables

The content editing system uses [Liquid](https://github.com/Shopify/liquid) for dynamic content.
See https://shopify.github.io/liquid/ for a basic introduction to Liquid.

### Links

To create a link to a page, you need to find the id of the target page.
This can be found on the editorial view of the page.

To link to a page, using the title of the page as the link text:

    {{ nodes['123e4567-e89b-12d3-a456-426655440000'].link_to }}

To link to a page using custom link text:

    {{ 'My link text' | link_to_node: nodes['123e4567-e89b-12d3-a456-426655440000'] }}

To make a placeholder link:

    {{ 'Coming soon' | placeholder_link }}
