/datum/gear/head
	display_name = "natural philosopher's wig"
	path = /obj/item/clothing/head/philosopher_wig
	slot = slot_head
	sort_category = "Hats and Headwear"

/datum/gear/head/beret/bsec
	display_name = "beret, navy (officer)"
	path = /obj/item/clothing/head/beret/sec/navy/officer
	allowed_roles = list(/datum/job/officer, /datum/job/hos)

/datum/gear/head/beret/bsec_warden
	display_name = "beret, navy (warden)"
	path = /obj/item/clothing/head/beret/sec/navy/warden
	allowed_roles = list(/datum/job/hos)

/datum/gear/head/beret/bsec_hos
	display_name = "beret, navy (hos)"
	path = /obj/item/clothing/head/beret/sec/navy/hos
	allowed_roles = list(/datum/job/hos)

/datum/gear/head/beret/eng
	display_name = "beret, engineering"
	path = /obj/item/clothing/head/beret/engineering
	allowed_roles = list(/datum/job/engineer, /datum/job/chief_engineer)

/datum/gear/head/beret/purp
	display_name = "beret, purple"
	path = /obj/item/clothing/head/beret/purple

/datum/gear/head/beret/sec
	display_name = "beret, red (security)"
	path = /obj/item/clothing/head/beret/sec
	allowed_roles = list(/datum/job/officer, /datum/job/hos)

/datum/gear/head/seccap
	display_name = "cap, security"
	path = /obj/item/clothing/head/soft/sec
	allowed_roles = list(/datum/job/officer, /datum/job/hos)

/datum/gear/head/seccap/corp
	display_name = "cap, corporate security"
	path = /obj/item/clothing/head/soft/sec/corp
	allowed_roles = list(/datum/job/officer, /datum/job/hos)

/datum/gear/head/zhan_scarf
	display_name = "Zhan headscarf"
	path = /obj/item/clothing/head/tajaran/scarf
	whitelisted = "Tajara"

/datum/gear/head/welding
	allowed_roles = list(/datum/job/scientist, /datum/job/rd, /datum/job/engineer, /datum/job/chief_engineer)

/datum/gear/head/barber
	display_name = "boater hat"
	path = /obj/item/clothing/head/urist/barber