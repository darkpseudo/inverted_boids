(*
	Display affiche une simulation, potentiellement personnalisable en donnant
	des arguments.
*)

open Graphics
open Engine

let dump_file = ref ""

let draw_boid boid =
	let x,y = boid.pos in
		set_color boid.color;
		fill_circle (truncate x) (truncate y) 3

let n = 200

let uniform n a = Array.init n (fun _ -> Array.make n a)
	(** Array.make_matrix... *)
(* let rules = [
	Array.make n 0.01, Cohesion (uniform n 1., uniform n 0.5, uniform n 100.);
	Array.make n 15., Repulsion (uniform n 1., uniform n 2., uniform n 20.);
	Array.make n 1., Alignment (uniform n 1., uniform n 0.5, uniform n 100.);
] *)
(* TODO : Procédures pratiques de construction de règle *)

let rules cb cm ca cl rb rm ra rl ab am aa al ib =
	let cb = Array.make n cb in
	let cm = uniform n cm in
	let ca = uniform n ca in
	let cl = uniform n cl in
	let rb = Array.make n rb in
	let rm = uniform n rm in
	let ra = uniform n ra in
	let rl = uniform n rl in
	let ab = Array.make n ab in
	let am = uniform n am in
	let aa = uniform n aa in
	let al = uniform n al in
	let ib = Array.make n ib in
	let rules = [
		cb, Cohesion (cm,ca,cl);
		rb, Repulsion (rm,ra,rl);
		ab, Alignment (am,aa,al);
		ib, Inertia
	] in
	rules,(cb,cm,ca,cl),(rb,rm,ra,rl),(ab,am,aa,al),ib

let rules =
	let rules,(cb,_,_,_),(_,rm,ra,rl),_,_ = rules
		0.02 1. 0.5 100.
		10. 1. 2. 20.
		0.5 1. 0.5 100.
		0.45 in
	cb.(0) <- 0.1;
	for i = 1 to n - 1 do
		rl.(i).(0) <- 100.;
		ra.(i).(0) <- 1.;
		rm.(i).(0) <- 10.
	done;
	rules

let boids = Array.init n (fun i -> default_boid ())

let () = boids.(0) <- { boids.(0) with color = Graphics.blue }

let main arg =
	Random.self_init ();
	let s = " " ^ (string_of_int Engine.capxi) ^ "x"
		^ (string_of_int Engine.capyi) in
	open_graph s;
	set_window_title "Boids";
	auto_synchronize false;
	while not (key_pressed () && read_key () = 'q') do
		clear_graph ();
		Array.iter draw_boid boids;
		Engine.step boids rules;
		synchronize ();
		ignore (Unix.system "sleep 0.02");
	done;
	close_graph ();
	exit(0)


let () = Arg.parse
	["--dump", Arg.Set_string dump_file,
	 "dump the data generated by the simulation in the given file."]
	main
	"Usage : display.\n\
	Display a multi-agent boids-based simulation.\n\
	The available options are :"
	;
	main ()





