component accessors="true" {

    property name="APIKey" type="string";
    property name="subdomain" type="string" setter="false";
    property name="domain" type="string" setter="false";
    property name="version" type="string" setter="false";
    property name="outputFormat" type="string";

    variables.defaultFormat = 'json';
    variables.allowedFormats = 'json,xml,php';

    public any function init( string APIKey = '', string outputFormat = variables.defaultFormat ) {
        if ( len( arguments.APIKey ) ) {
            setAPIKey( arguments.APIKey );
            variables.subdomain = listLast( getAPIKey(), '-' );
        }

        variables.domain = '.api.mailchimp.com';
        variables.version = '2.0';

        setOutputFormat( arguments.outputFormat );

        return this;
    }

    public void function setOutputFormat( string format = variables.defaultFormat ) {
        arguments.format = lCase( arguments.format );

        if ( !listFind( variables.allowedFormats, arguments.format ) ) {
            variables.outputFormat = variables.defaultFormat;
        } else {
            variables.outputFormat = arguments.format;
        }
    }

    private string function getURL( required string section, required string method ) {
        var APIURL = 'https://';
        APIURL &= getSubdomain() & getDomain();
        APIURL &= '/' & getVersion();
        APIURL &= '/' & arguments.section;
        APIURL &= '/' & arguments.method & '.' & getOutputFormat();

        return APIURL;
    }

    private any function postAPI( required string section, required string method, struct options = {} ) {
        var httpService = new http();
        var httpResult = '';
        var result = {
            'status' = 'error',
            'code' = -99,
            'name' = 'Unknown_Exception',
            'error' = 'There was a connection error.'
        };

        httpService.setURL( getURL( arguments.section, arguments.method ) );
        httpService.setMethod('post');
        httpService.setTimeout( 1600 );
        httpService.addParam( name="Content-Type", type="header", value="application/json" );

        arguments.options[ "apikey" ] = getAPIKey();

        httpService.addParam( type="body", value=serializeJSON( arguments.options ) );

        httpResult = httpService.send().getPrefix().fileContent;

        if ( getOutputFormat() == 'json' && isJSON( httpResult ) ) {
            result = deserializeJSON( httpResult );
        } else if ( getOutputFormat() == 'xml' && isXML( httpResult ) ) {
            result = parseXML( httpResult );
        } else {
            result.error = httpResult;
        }

        return result;
    }




// /lists


// ------------
// /lists/list
// ------------
// Retrieve all of the lists defined for your user account
// ------------
// list(string apikey, struct filters, int start, int limit, string sort_field, string sort_dir)
// ------------
    public struct function listsList( struct filters = structNew(), numeric start = 0, numeric limit = 0, string sort_field = '', string sort_dir = '' ) {
        var results = {
            "total" = 0,
            "data" = [],
            "errors" = []
        };
        var options = {};

        if ( structCount( arguments.filters ) ) {
            options[ "filters" ] = arguments.filters;
        }

        if ( val( arguments.start ) ) {
            options[ "start" ] = val( arguments.start );
        }

        if ( val( arguments.limit ) ) {
            options[ "limit" ] = val( arguments.limit );
        }

        if ( len( arguments.sort_field ) ) {
            options[ "sort_field" ] = arguments.sort_field;
        }

        if ( len( arguments.sort_dir ) ) {
            options[ "sort_dir" ] = arguments.sort_dir;
        }

        structAppend( results, postAPI( 'lists', 'list', options ) );

        return results;
    }

// ----------------
// /lists/subscribe
// ----------------
// Subscribe the provided email to a list. By default this sends a confirmation email - you will not see new members until the link contained in it is clicked!
// ----------------
// subscribe(string apikey, string id, struct email, struct merge_vars, string email_type, bool double_optin, bool update_existing, bool replace_interests, bool send_welcome)
// ----------------
    public struct function listsSubscribe( required string listid, required struct email, struct merge_vars = {}, string email_type = '', boolean double_optin = true, boolean update_existing = false, boolean replace_interests = true, boolean send_welcome = false ) {
        var results = {
            "email" = '',
            "euid" = '',
            "leid" = ''
        };
        var options = {};

        options[ "id" ] = arguments.listid;
        options[ "email" ] = arguments.email;

        if ( structCount( arguments.merge_vars ) ) {
            options[ "merge_vars" ] = arguments.merge_vars;
        }

        if ( len( arguments.email_type ) ) {
            options[ "email_type" ] = arguments.email_type;
        }

        options[ "double_optin" ] = arguments.double_optin;
        options[ "update_existing" ] = arguments.update_existing;
        options[ "replace_interests" ] = arguments.replace_interests;
        options[ "send_welcome" ] = arguments.send_welcome;

        structAppend( results, postAPI( 'lists', 'subscribe', options ) );

        return results;
    }

// ------------------
// /lists/unsubscribe
// ------------------
// Unsubscribe the given email address from the list
// ------------------
// unsubscribe(string apikey, string id, struct email, boolean delete_member, boolean send_goodbye, boolean send_notify)
// ------------------
    public struct function listsUnsubscribe( required string listid, required struct email, boolean delete_member = false, boolean send_goodbye = true, boolean send_notify = true ) {
        var results = {
            "complete" = false
        };
        var options = {};

        options[ "id" ] = arguments.listid;
        options[ "email" ] = arguments.email;

        options[ "delete_member" ] = arguments.delete_member;
        options[ "send_goodbye" ] = arguments.send_goodbye;
        options[ "send_notify" ] = arguments.send_notify;

        structAppend( results, postAPI( 'lists', 'unsubscribe', options ) );

        return results;
    }

// ------------------
// /lists/update-member
// ------------------
// Updates a given member from the list
// ------------------
// update-member(string apikey, string id, struct email, struct merge_vars, string email_type, boolean replace_interests)
// ------------------
    public struct function listsUpdateMember( required string listid, required struct email, required struct  merge_vars, string email_type = '', boolean replace_interests = true ) {
        var results = {
            "email" = '',
            "euid" = '',
            "leid" = ''
        };
        var options = {};

        options[ "id" ] = arguments.listid;
        options[ "email" ] = arguments.email;
        options[ "merge_vars" ] = arguments.merge_vars;

        if ( len( arguments.email_type ) ) {
            options[ "email_type" ] = arguments.email_type;
        }

        options[ "replace_interests" ] = arguments.replace_interests;

        structAppend( results, postAPI( 'lists', 'update-member', options ) );

        return results;
    }


}
