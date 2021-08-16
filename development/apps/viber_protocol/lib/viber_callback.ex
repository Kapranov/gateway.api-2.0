defmodule ViberCallback do
  @moduledoc false

  use Plug.Router

  plug(Plug.Logger)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  get "/ping" do
    send_resp(conn, 200, "pong!")
  end

  post "/viber" do
    ViberProtocol.callback_response(conn)
    response(conn)
  end

  post "/" do
    ViberProtocol.callback_response(conn)
    response(conn)
  end

  match _ do
    send_resp(conn, 404, "oops... Nothing here :(")
  end

  defp response(conn) do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, "")
  end
end
