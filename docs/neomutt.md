# Neomutt

Limit Feature. Search syntax.

A normal search will search the given text in the `From`, `To`, `Subject`, `Cc`, and `Date` header.

Patterns:

* `~f sender` only match messages from this `sender`
* `~s subject` only match messages with this `subject`
* `~b body` match text `body` in the email body
* `~d date` match messages by date

Logical Operators:

* `|` OR
* `&` AND

Match on email flags:

* `~N` new message
* `~U` unread message
* `~D` deleted message
* `~F` flagged message
* `~O` old message

To reset the limit filter, use the filter text `all`.

