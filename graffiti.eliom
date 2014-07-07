open Eliom_content.Html5.D (* provides functions to create HTML nodes *)

module My_app =
  Eliom_registration.App (struct
    let application_name = "graffiti"
  end)
  
let main_service =
  My_app.register_service
    ~path:["graff"]
    ~get_params:Eliom_parameter.unit
    (fun () () ->
      Lwt.return
        (html
           (head (title (pcdata "Page title")) [])
           (body [h1 [pcdata "Graffiti"]])))

{client{
  let _ = Eliom_lib.alert "Hello!"
}}
