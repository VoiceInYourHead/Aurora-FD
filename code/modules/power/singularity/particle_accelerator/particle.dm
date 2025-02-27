//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/obj/effect/accelerated_particle
	name = "Accelerated Particles"
	desc = "Small things moving very fast."
	icon = 'icons/obj/machinery/particle_accelerator.dmi'
	icon_state = "particle"//Need a new icon for this
	anchored = TRUE
	density = FALSE
	var/movement_range = 10
	var/energy = 10		//energy in eV
	var/mega_energy = 0	//energy in MeV
	var/frequency = 1
	var/ionizing = 0
	var/particle_type
	var/additional_particles = 0
	var/turf/target
	var/turf/source
	var/movetotarget = 1

/obj/effect/accelerated_particle/weak
	movement_range = 8
	energy = 5

/obj/effect/accelerated_particle/strong
	movement_range = 15
	energy = 15

// Can only be obtained by hacking the machine
/obj/effect/accelerated_particle/powerful
	movement_range = 20
	energy = 50

/obj/effect/accelerated_particle/New(loc, dir = 2)
	src.forceMove(loc)
	src.set_dir(dir)
	if(movement_range > 20)
		movement_range = 20
	spawn(0)
		move(1)
	return


/obj/effect/accelerated_particle/Collide(atom/A)
	. = ..()
	if (A)
		if(ismob(A))
			toxmob(A)
		if((istype(A,/obj/machinery/the_singularitygen))||(istype(A,/obj/singularity/)))
			A:energy += energy
	return

/obj/effect/accelerated_particle/CollidedWith(atom/A)
	. = ..()
	if(ismob(A))
		toxmob(A)


/obj/effect/accelerated_particle/ex_act(severity)
	qdel(src)
	return



/obj/effect/accelerated_particle/proc/toxmob(var/mob/living/M)
	var/radiation = (energy*2)
	M.apply_damage((radiation*3), DAMAGE_RADIATION, damage_flags = DAMAGE_FLAG_DISPERSED)
	M.updatehealth()
	return


/obj/effect/accelerated_particle/proc/move(var/lag)
	if(target)
		if(movetotarget)
			if(!step_towards(src,target))
				src.forceMove(get_step(src, get_dir(src,target)))
			if(get_dist(src,target) < 1)
				movetotarget = 0
		else
			if(!step(src, get_step_away(src,source)))
				src.forceMove(get_step(src, get_step_away(src,source)))
	else
		if(!step(src,dir))
			src.forceMove(get_step(src,dir))
	movement_range--
	if(movement_range <= 0)
		qdel(src)
	else
		sleep(lag)
		move(lag)
