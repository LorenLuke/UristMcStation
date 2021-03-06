/obj/effect/overmap/sector/station
	var/faction = null
	var/spawn_type = null
	var/mob/living/spawned_ship
	var/spawn_time_high = 2400
	var/spawn_time_low = 1200
	var/cooldown = 0 //if we get crossed by a ship of the same faction, it gets eaten. this is so merchant ships can ferry between stations. Cooldown is so it can get away
	var/nospawn = 1
	var/patrolship = null //if you piss us off, we start spawning the big boys
	known = 1
	icon = 'icons/urist/misc/overmap.dmi'
	icon_state = "station1"

/*
/obj/effect/overmap/sector/station/Initialize()
	if(nospawn)
		qdel(src)
		return
	else
		..() */

/*/obj/effect/overmap/sector/station/New()
	..()
	if(!spawn_type)
		var/new_type = pick(typesof(/obj/effect/overmap/sector/station) - /obj/effect/overmap/sector/station)
		new new_type(get_turf(src))
		qdel(src)

	START_PROCESSING(SSobj, src)
	spawned_ship = new spawn_type(get_turf(src))

/obj/effect/overmap/sector/station/Process()
	//if any of our ships are killed, spawn new ones
	if(!spawned_ship || spawned_ship.stat == DEAD)
		cooldown = 0 //cooldown is zero, just in case our ship is killed before the cooldown runs out for some reason
		var/newship = pick(spawn_type)
		spawned_ship = new newship(src)
		//after a random timeout, at the station's location (6-30 seconds)
		spawn(rand(spawn_time_low,spawn_time_high))
			spawned_ship.loc = src.loc
			cooldown = 3000
			spawn(cooldown)
				cooldown = 0

/obj/effect/overmap/sector/station/Destroy()
	STOP_PROCESSING(SSobj, src)
	..()

/obj/effect/overmap/sector/station/Crossed(mob/living/M)
	if(istype(M, /mob/living/simple_animal/hostile/overmapship)) //if we're crossed by a ship of the same faction, we eat it
		if(!cooldown && M.faction == src.faction)
			if(M == spawned_ship)
				spawned_ship = null
			qdel(M)
	else
		..()
*/