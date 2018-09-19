(* This file is part of Learn-OCaml.
 *
 * Copyright (C) 2018 OCamlPro.
 *
 * Learn-OCaml is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * Learn-OCaml is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>. *)

open Learnocaml_server_args

let main o =
  Printf.printf "Learnocaml server v.%s starting on port %d\n%!"
    Learnocaml_api.version o.port;
  let r = Lwt_main.run (Learnocaml_server.launch ()) in
  exit (if r then 0 else 10)

let man = [
  `S "DESCRIPTION";
  `P "This is the server for learn-ocaml. It is equivalent to running \
      $(b,learn-ocaml serve), but may be faster if compiled to native code. It \
      requires the learn-ocaml app to have been built using $(b,learn-ocaml \
      build) beforehand.";
  `S "SERVER OPTIONS";
  `S "AUTHORS";
  `P "Learn OCaml is written by OCamlPro. Its main authors are Benjamin Canou, \
      Çağdaş Bozman and Grégoire Henry. It is licensed under the GNU Affero \
      General Public License version 3: any instance of the app must provide \
      its source code to its users.";
  `S "BUGS";
  `P "Bugs should be reported to \
      $(i,https://github.com/ocaml-sf/learn-ocaml/issues)";
]

let app_dir =
  let open Cmdliner.Arg in
  value & opt string "./www" & info ["app-dir"; "o"] ~docv:"DIR" ~doc:
    "Directory where the app has been generated by the $(b,learn-ocaml build) \
     command, and from where it will be served."


let main_cmd =
  Cmdliner.Term.(const main $ Learnocaml_server_args.term app_dir),
  Cmdliner.Term.info
    ~man
    ~doc:"Learn-ocaml web-app manager"
    ~version:Learnocaml_api.version
    "learn-ocaml"

let () =
  match
    Cmdliner.Term.eval ~catch:false main_cmd
  with
  | exception Failure msg ->
      Printf.eprintf "[ERROR] %s\n" msg;
      exit 1
  | `Error _ -> exit 2
  | _ -> exit 0