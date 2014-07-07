{shared{
  (* Modules opened in the shared-section are available in client-
     and server-code *)
  open Eliom_content.Html5.D
  open Lwt
}}

module My_app =
  Eliom_registration.App (struct
    let application_name = "graffiti"
  end)

{shared{
  let width = 700
  let height = 400
}}

let canvas_elt =
  canvas ~a:[a_width width; a_height height]
    [pcdata "your browser doesn't support canvas"]

let page =
  (html
    (head (title (pcdata "Graffiti")) [])
    (body [h1 [pcdata "Graffiti"];
           canvas_elt]))

 {client{
  let draw ctx ((r, g, b), size, (x1, y1), (x2, y2)) =
    let color = CSS.Color.string_of_t (CSS.Color.rgb r g b) in
    ctx##strokeStyle <- (Js.string color);
    ctx##lineWidth <- float size;
    ctx##beginPath();
    ctx##moveTo(float x1, float y1);
    ctx##lineTo(float x2, float y2);
    ctx##stroke()
}}

{client{
  let init_client () =

    let canvas = Eliom_content.Html5.To_dom.of_canvas %canvas_elt in
    let ctx = canvas##getContext (Dom_html._2d_) in
    ctx##lineCap <- Js.string "round";

    let x = ref 0 and y = ref 0 in

    let set_coord ev =
      let x0, y0 = Dom_html.elementClientPosition canvas in
      x := ev##clientX - x0; y := ev##clientY - y0
    in

    let compute_line ev =
      let oldx = !x and oldy = !y in
      set_coord ev;
      ((0, 0, 0), 5, (oldx, oldy), (!x, !y))
    in

    let line ev = draw ctx (compute_line ev); Lwt.return () in

    Lwt.async
      (fun () ->
        let open Lwt_js_events in
        mousedowns canvas
          (fun ev _ ->
            set_coord ev; line ev >>= fun () ->
            Lwt.pick [mousemoves Dom_html.document (fun x _ -> line x);
                      mouseup Dom_html.document >>= line]))
}}

let main_service =
  My_app.register_service ~path:[""] ~get_params:Eliom_parameter.unit
    (fun () () ->
      (* Cf. the box "Client side side-effects on the server" *)
      let _ = {unit{ init_client () }} in
      Lwt.return page)
