/** BEGIN: Globals ************************************************************************/
const_block_style = 'block';
const_inline_style = 'inline';
const_none_style = 'none';

const_absolute_symbol = 'absolute';

const_debug_symbol = 'DEBUG';

const_text_symbol = 'text';
const_hidden_symbol = 'hidden';
const_textarea_symbol = 'textarea';
const_password_symbol = 'password';

const_blank_symbol = '_blank';
const_slash_slash_symbol = '\/\/';
const_slash_symbol = '/';
const_indexcfm_symbol = 'index.cfm';

const_http_symbol = 'http:\/\/';
const_https_symbol = 'https:\/\/';
const_mailto_symbol = 'mailto:';
const_ftp_symbol = 'ftp:\/\/';
const_other_symbol = '(other)';

const_cursor_hand = 'hand';
const_cursor_default = 'default';

const_object_symbol = 'object';
const_number_symbol = 'number';
const_function_symbol = 'function';

const_radio_symbol = 'radio';
const_checkbox_symbol = 'checkbox';
const_button_symbol = 'button';

const_submit_symbol = 'submit';
const_cancel_symbol = 'cancel';

const_backgroundColor_symbol = 'backgroundColor';

const_no_response_symbol = 'No';

const_true_value_symbol = 'True';

const_gif_filetype_symbol = '.gif';
const_jpg_filetype_symbol = '.jpg';
const_jpeg_filetype_symbol = '.jpeg';

const_images_symbol = '/images/';             		// used by _autoCorrectLinksAndImages()
const_components_symbol = '/components/';     		// used by _autoCorrectLinksAndImages()
const_images_prime_symbol = 'images/';        		// used by _autoCorrectLinksAndImages()
const_images_uploaded_symbol = '/uploaded-images/'; // used by _autoCorrectLinksAndImages()

const_anchor_menu_anchorStyles = 'text-decoration: none; font-weight: bold; color: white; padding: 2px;';

/** END! Globals ************************************************************************/

function uuid() {
	var uuid = (new Date().getTime() + "" + Math.floor(1000 * Math.random()));
	return uuid;
}

/** MathAndStringExtend.js
 *  JavaScript to extend String class
 *  - added trim methods 
 *    - uses regular expressions and pattern matching. 
 * *  eg. *    var s1 = new String("   abc   "); 
 *    var trimmedS1 = s1.trim(); 
 * *  similary for String.triml() and String.trimr(). 
 *
 //**************************************************************************/
 
function _int(i){
	var _s = i.toString().split(".");
	return eval(_s[0]);
};

// Relaxed the requirement than "SBC" MSIE Browsers be used - now any MSIE browser that's not a disallowed type such as Opera or Netscape or Mozilla will be allowed without warning.
browser_is_ie = ( /msie/i.test(navigator.userAgent) &&	!/opera/i.test(navigator.userAgent) &&	!/Gecko/i.test(navigator.userAgent) &&	!/Netscape/i.test(navigator.userAgent) &&	!/Firefox/i.test(navigator.userAgent) ); //  && /sbc/i.test(navigator.userAgent)

if (browser_is_ie == false) {
//	alert('Unsupported Browser has been detected !  Some site functionality may not be available.  This site supports the SBC Standard Microsoft IE Browser. Your browser appears to be (' + navigator.userAgent + ').');
}
