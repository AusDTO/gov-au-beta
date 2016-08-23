//= require sanitize-html.min
//= require showdown
//= require_self

$('#node_content_body').after('<div id="editor-preview" class="content-block" style="display: none;"></div>');

function previewMarkdown(){
    var text = $('#node_content_body')[0].value,
        target = $('#editor-preview')[0],
        converter = new showdown.Converter({tables: true}),
        // inspired by default filter settings from https://github.com/punkave/sanitize-html made explicit below
        html = converter.makeHtml(sanitizeHtml(text), {
            allowedTags: [ 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'blockquote', 'p', 'a', 'ul', 'ol',
                'nl', 'li', 'b', 'i', 'strong', 'em', 'strike', 'code', 'hr', 'br', 'div', 'span',
                'table', 'thead', 'caption', 'tbody', 'tr', 'th', 'td', 'pre',
                'dd', 'dl', 'heading', 'footer', 'section', 'article', 'main', 'img', 'figure' ],
            allowedAttributes: {
                '*': ['class'],
                a: [ 'href', 'name', 'target' ],
                img: [ 'src' ]
            },
            // Lots of these won't come up by default because we don't allow them
            selfClosing: [ 'img', 'br', 'hr', 'area', 'base', 'basefont', 'input', 'link', 'meta' ],
            // URL schemes we permit
            allowedSchemes: [ 'http', 'https', 'ftp', 'mailto' ],
            allowedSchemesByTag: {}
        });

    target.innerHTML = html;
    // hide empty preview
    if(text != ""){
        $(target).css('display', 'block');
    } else {
        $(target).css('display', 'none');
    }
};
$('#node_content_body').keyup(previewMarkdown);
previewMarkdown();