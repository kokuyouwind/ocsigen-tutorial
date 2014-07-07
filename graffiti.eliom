open Eliom_content.Html5.D (* provides functions to create HTML nodes *)

let main_service =
  Eliom_registration.Html5.register_service
    ~path:["graff"]
    ~get_params:Eliom_parameter.unit
    (fun () () ->
      Lwt.return
        (html
           (head (title (pcdata "Page title")) [])
           (body [h1 [pcdata "Graffiti"]])))