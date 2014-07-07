open Eliom_content.Html5.D (* provides functions to create HTML nodes *)

module My_app =
  Eliom_registration.App (struct
    let application_name = "graffiti"
  end)

let count = ref 0
  
let main_service =
  My_app.register_service
    ~path:["graff"]
    ~get_params:Eliom_parameter.unit
    (fun () () ->
      ignore {unit{
        Eliom_lib.alert "Hello!"
      }};
      Lwt.return
        (html
           (head (title (pcdata "Page title")) [])
           (body [h1 [pcdata "Graffiti"]])));
  My_app.register_service
     ~path:["count"]
     ~get_params:Eliom_parameter.unit
    (fun () () ->
      let c = incr count; !count in
      ignore {unit{
        Dom_html.window##alert(Js.string
                                   (Printf.sprintf "You came %i times to this page" %c))
      }};
      Lwt.return
        (html
           (head (title (pcdata "Graffiti")) [])
           (body [h1 [pcdata "Graffiti"]]) ) )

