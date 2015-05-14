# MailChimp List API Wrapper

> A simple wrapper around MailChimp's 2.0 List API.

**NOTE** We only really implemented the methods we needed. This isn't a full library around MailChimp's offerings, and others are encourage to submit pull requests to fill in the missing gaps.

Methods we implemented:
  * /lists/list: Retrieve all of the lists defined for your user account ([API Docs](https://apidocs.mailchimp.com/api/2.0/lists/list.php))
  * /lists/subscribe: Subscribe the provided email to a list. By default this sends a confirmation email - you will not see new members until the link contained in it is clicked! ([API Docs](https://apidocs.mailchimp.com/api/2.0/lists/subscribe.php))
  * /lists/unsubscribe: Unsubscribe the given email address from the list ([API Docs](https://apidocs.mailchimp.com/api/2.0/lists/unsubscribe.php))
  * /lists/update-member: Updates a given member from the list ([API Docs](https://apidocs.mailchimp.com/api/2.0/lists/update-member.php))

And that's literally it.
