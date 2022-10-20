# Attribute-based Access Control (ABAC)
# -------------------------------------
#
# This example implements ABAC for a Pet Store API. The Pet Store API allows
# users to look at pets, adopt them, update their stats, and so on. The policy
# controls which users can perform actions on which resources. The policy implements
# a Attribute-based Access Control model where users, resources, and actions have
# attributes and the policy makes decisions based on those attributes.
#
# This example shows how to:
#
#	* Implement ABAC using Rego that leverages external data.
#	* Define helper rules that provide useful abstractions (e.g., `user_is_senior`).
#
# For more information see:
#
#	* Rego comparison to other systems: https://www.openpolicyagent.org/docs/latest/comparison-to-other-systems/
#
# Hint: The Coverage feature lets you view the policy statements that were executed
# when the policy was last evaluated. Try enabling Coverage and running evaluation
# with different inputs.

package app.abac

import future.keywords.if

default allow := false

allow if user_is_sreenath

allow if {
	user_is_sreenath
	action_is_read
}

allow if {
	user_is_sreenath
	user_is_senior
	action_is_update
}

allow if {
	user_is_customer
	action_is_read
	not pet_is_adopted
}

user_is_sreenath if data.user_attributes[input.user].title == "sreenath"

user_is_surgen if data.user_attributes[input.user].title == "employee"

user_is_customer if data.user_attributes[input.user].title == "customer"

user_is_senior if data.user_attributes[input.user].tenure > 8

action_is_read if input.action == "read"

action_is_update if input.action == "update"

pet_is_adopted if data.pet_attributes[input.resource].adopted == true

