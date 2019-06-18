// Hard Drive
/obj/item/weapon/computer_hardware/hard_drive/
	name = "basic hard drive"
	desc = "A small power efficient solid state drive, with 128GQ of storage capacity for use in basic computers where power efficiency is desired."
	power_usage = 25					// SSD or something with low power usage
	icon_state = "hdd_normal"
	hardware_size = 1
	origin_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	var/max_capacity = 128
	var/used_capacity = 0
	var/list/stored_files = list()		// List of stored files on this drive. DO NOT MODIFY DIRECTLY!

/obj/item/weapon/computer_hardware/hard_drive/nano

/obj/item/weapon/computer_hardware/hard_drive/micro

/obj/item/weapon/computer_hardware/hard_drive/macro

/obj/item/weapon/computer_hardware/hard_drive/giga


/obj/item/weapon/computer_hardware/hard_drive/diagnostics(var/mob/user)
	..()
	// 999 is a byond limit that is in place. It's unlikely someone will reach that many files anyway, since you would sooner run out of space.
	to_chat(user, "NT-NFS File Table Status: [stored_files.len]/999")
	to_chat(user, "Storage capacity: [used_capacity]/[max_capacity]GQ")

// Use this proc to add file to the drive. Returns 1 on success and 0 on failure. Contains necessary sanity checks.
/obj/item/weapon/computer_hardware/hard_drive/proc/store_file(var/datum/computer_file/F)
	if(!try_store_file(F))
		return 0
	F.holder = src
	stored_files.Add(F)
	recalculate_size()
	return 1

// Use this proc to add file to the drive. Returns 1 on success and 0 on failure. Contains necessary sanity checks.
/obj/item/weapon/computer_hardware/hard_drive/proc/install_default_programs()
	store_file(new/datum/computer_file/program/computerconfig(src)) 		// Computer configuration utility, allows hardware control and displays more info than status bar
	store_file(new/datum/computer_file/program/ntnetdownload(src))			// NTNet Downloader Utility, allows users to download more software from NTNet repository
	store_file(new/datum/computer_file/program/filemanager(src))			// File manager, allows text editor functions and basic file manipulation.


// Use this proc to remove file from the drive. Returns 1 on success and 0 on failure. Contains necessary sanity checks.
/obj/item/weapon/computer_hardware/hard_drive/proc/remove_file(var/datum/computer_file/F)
	if(!F || !istype(F))
		return 0

	if(!stored_files)
		return 0

	if(!check_functionality())
		return 0

	if(F in stored_files)
		stored_files -= F
		recalculate_size()
		return 1
	else
		return 0

// Loops through all stored files and recalculates used_capacity of this drive
/obj/item/weapon/computer_hardware/hard_drive/proc/recalculate_size()
	var/total_size = 0
	for(var/datum/computer_file/F in stored_files)
		total_size += F.size

	used_capacity = total_size

// Checks whether file can be stored on the hard drive.
/obj/item/weapon/computer_hardware/hard_drive/proc/can_store_file(var/size = 1)
	// In the unlikely event someone manages to create that many files.
	// BYOND is acting weird with numbers above 999 in loops (infinite loop prevention)
	if(stored_files.len >= 999)
		return 0
	if(used_capacity + size > max_capacity)
		return 0
	else
		return 1

// Checks whether we can store the file. We can only store unique files, so this checks whether we wouldn't get a duplicity by adding a file.
/obj/item/weapon/computer_hardware/hard_drive/proc/try_store_file(var/datum/computer_file/F)
	if(!F || !istype(F))
		return 0
	if(!can_store_file(F.size))
		return 0
	if(!check_functionality())
		return 0
	if(!stored_files)
		return 0

	var/list/badchars = list("/","\\",":","*","?","\"","<",">","|","#", ".")
	for(var/char in badchars)
		if(findtext(F.filename, char))
			return 0

	// This file is already stored. Don't store it again.
	if(F in stored_files)
		return 0

	var/name = F.filename + "." + F.filetype
	for(var/datum/computer_file/file in stored_files)
		if((file.filename + "." + file.filetype) == name)
			return 0
	return 1

// Tries to find the file by filename. Returns null on failure
/obj/item/weapon/computer_hardware/hard_drive/proc/find_file_by_name(var/filename)
	if(!check_functionality())
		return null

	if(!filename)
		return null

	if(!stored_files)
		return null

	for(var/datum/computer_file/F in stored_files)
		if(F.filename == filename)
			return F
	return null

/obj/item/weapon/computer_hardware/hard_drive/Destroy()
	if(holder2 && (holder2.hard_drive == src))
		holder2.hard_drive = null
	stored_files = null
	return ..()

/obj/item/weapon/computer_hardware/hard_drive/New()
	install_default_programs()
	..()


// Processor

/obj/item/weapon/computer_hardware/processor_unit
	name = "standard processor"
	desc = "A standard CPU used in most computers. It can run up to three programs simultaneously."
	icon_state = "cpu_normal"
	hardware_size = 2
	power_usage = 50
	origin_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)

	var/max_idle_programs = 2 // 2 idle, + 1 active = 3 as said in description.


/obj/item/weapon/computer_hardware/processor_unit/nano
/obj/item/weapon/computer_hardware/processor_unit/micro
/obj/item/weapon/computer_hardware/processor_unit/macro
/obj/item/weapon/computer_hardware/processor_unit/giga


/obj/item/weapon/computer_hardware/processor_unit/Destroy()
	if(holder2 && (holder2.processor_unit == src))
		holder2.processor_unit = null
	return ..()


// Battery

/obj/item/weapon/computer_hardware/battery_module
	name = "standard battery"
	desc = "A standard power cell, commonly seen in high-end portable microcomputers or low-end laptops. It's rating is 75 Wh."
	icon_state = "battery_normal"
	critical = 1
	malfunction_probability = 1
	origin_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	var/battery_rating = 75
	var/obj/item/weapon/cell/battery = null

/obj/item/weapon/computer_hardware/battery_module/nano

/obj/item/weapon/computer_hardware/battery_module/micro

/obj/item/weapon/computer_hardware/battery_module/macro

/obj/item/weapon/computer_hardware/battery_module/giga


// This is not intended to be obtainable in-game. Intended for adminbus and debugging purposes.
/obj/item/weapon/computer_hardware/battery_module/lambda
	name = "lambda coil"
	desc = "A very complex power source compatible with various computers. It is capable of providing power for nearly unlimited duration."
	icon_state = "battery_lambda"
	hardware_size = 1
	battery_rating = 3000

/obj/item/weapon/computer_hardware/battery_module/lambda/New()
	..()
	battery = new/obj/item/weapon/cell/infinite(src)


/obj/item/weapon/computer_hardware/battery_module/diagnostics(var/mob/user)
	..()
	to_chat(user, "Internal battery charge: [battery.charge]/[battery.maxcharge] CU")

/obj/item/weapon/computer_hardware/battery_module/New()
	battery = new/obj/item/weapon/cell(src)
	battery.maxcharge = battery_rating
	battery.charge = 0
	..()

/obj/item/weapon/computer_hardware/battery_module/Destroy()
	QDEL_NULL(battery)
	if(holder2 && (holder2.battery_module == src))
		holder2.ai_slot = null
	return ..()

/obj/item/weapon/computer_hardware/battery_module/proc/charge_to_full()
	if(battery)
		battery.charge = battery.maxcharge

/obj/item/weapon/computer_hardware/battery_module/get_cell()
	return battery


// Network Card

var/global/ntnet_card_uid = 1

/obj/item/weapon/computer_hardware/network_card/
	name = "basic NTNet network card"
	desc = "A basic network card for usage with standard NTNet frequencies."
	power_usage = 50
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 1)
	critical = 0
	icon_state = "netcard_basic"
	hardware_size = 1
	var/identification_id = null	// Identification ID. Technically MAC address of this device. Can't be changed by user.
	var/identification_string = "" 	// Identification string, technically nickname seen in the network. Can be set by user.
	var/long_range = 0
	var/ethernet = 0 // Hard-wired, therefore always on, ignores NTNet wireless checks.
	malfunction_probability = 1

/obj/item/weapon/computer_hardware/network_card/diagnostics(var/mob/user)
	..()
	to_chat(user, "NIX Unique ID: [identification_id]")
	to_chat(user, "NIX User Tag: [identification_string]")
	to_chat(user, "Supported protocols:")
	to_chat(user, "511.m SFS (Subspace) - Standard Frequency Spread")
	if(long_range)
		to_chat(user, "511.n WFS/HB (Subspace) - Wide Frequency Spread/High Bandiwdth")
	if(ethernet)
		to_chat(user, "OpenEth (Physical Connection) - Physical network connection port")

/obj/item/weapon/computer_hardware/network_card/New(var/l)
	..(l)
	identification_id = ntnet_card_uid
	ntnet_card_uid++

/obj/item/weapon/computer_hardware/network_card/advanced
	name = "advanced NTNet network card"
	desc = "An advanced network card for usage with standard NTNet frequencies. It's transmitter is strong enough to connect even when far away."
	long_range = 1
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 2)
	power_usage = 100 // Better range but higher power usage.
	icon_state = "netcard_advanced"
	hardware_size = 1

/obj/item/weapon/computer_hardware/network_card/wired
	name = "wired NTNet network card"
	desc = "An advanced network card for usage with standard NTNet frequencies. This one also supports wired connection."
	ethernet = 1
	origin_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 3)
	power_usage = 100 // Better range but higher power usage.
	icon_state = "netcard_ethernet"
	hardware_size = 3

/obj/item/weapon/computer_hardware/network_card/Destroy()
	if(holder2 && (holder2.network_card == src))
		holder2.network_card = null
	holder2 = null
	return ..()

// Returns a string identifier of this network card
/obj/item/weapon/computer_hardware/network_card/proc/get_network_tag()
	return "[identification_string] (NID [identification_id])"

/obj/item/weapon/computer_hardware/network_card/proc/is_banned()
	return ntnet_global.check_banned(identification_id)

// 0 - No signal, 1 - Low signal, 2 - High signal. 3 - Wired Connection
/obj/item/weapon/computer_hardware/network_card/proc/get_signal(var/specific_action = 0)
	if(!holder2) // Hardware is not installed in anything. No signal. How did this even get called?
		return 0

	if(!enabled)
		return 0

	if(!check_functionality() || !ntnet_global || is_banned())
		return 0

	if(!ntnet_global.check_function(specific_action)) // NTNet is down, we're isolated from the rest of the network.
		return 0

	if(ethernet) // Computer is connected via wired connection.
		return 3

	if(holder2)
		var/turf/T = get_turf(holder2)
		if(!istype(T)) //no reception in nullspace
			return 0
		if(T.z in GLOB.using_map.station_levels)
			// Computer is on station. Low/High signal depending on what type of network card you have
			if(long_range)
				return 2
			else
				return 1
		if(T.z in GLOB.using_map.contact_levels) //not on station, but close enough for radio signal to travel
			if(long_range) // Computer is not on station, but it has upgraded network card. Low signal.
				return 1

	return 0 // Computer is not on station and does not have upgraded network card. No signal.


// Addons (AI storage, tesla link, nanoprinter, card reader)
// A wrapper that allows the computer to contain an inteliCard.
/obj/item/weapon/computer_hardware/ai_slot
	name = "inteliCard slot"
	desc = "An IIS interlink with connection uplinks that allow the device to interface with most common inteliCard models. Too large to fit into tablets. Uses a lot of power when active."
	icon_state = "aislot"
	hardware_size = 1
	critical = 0
	power_usage = 100
	origin_tech = list(TECH_POWER = 2, TECH_DATA = 3)
	var/obj/item/weapon/aicard/stored_card
	var/power_usage_idle = 100
	var/power_usage_occupied = 2 KILOWATTS

/obj/item/weapon/computer_hardware/ai_slot/proc/update_power_usage()
	if(!stored_card || !stored_card.carded_ai)
		power_usage = power_usage_idle
		return
	power_usage = power_usage_occupied

/obj/item/weapon/computer_hardware/ai_slot/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if(..())
		return 1
	if(istype(W, /obj/item/weapon/aicard))
		if(stored_card)
			to_chat(user, "\The [src] is already occupied.")
			return
		if(!user.unEquip(W, src))
			return
		stored_card = W
		update_power_usage()
	if(isScrewdriver(W))
		to_chat(user, "You manually remove \the [stored_card] from \the [src].")
		stored_card.forceMove(get_turf(src))
		stored_card = null
		update_power_usage()

/obj/item/weapon/computer_hardware/ai_slot/Destroy()
	if(holder2 && (holder2.ai_slot == src))
		holder2.ai_slot = null
	if(stored_card)
		stored_card.forceMove(get_turf(holder2))
	holder2 = null
	return ..()


// USB (external hard drive, tesla adapter, porta-charger, external nanoprinter, external wifi card)

