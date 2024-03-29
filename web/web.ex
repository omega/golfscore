defmodule Golf.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use Golf.Web, :controller
      use Golf.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      use Ecto.Schema

      import Ecto
      import Ecto.Changeset
      import Ecto.Query, only: [from: 1, from: 2]
    end
  end

  def controller do
    quote do
      use Phoenix.Controller

      alias Golf.Repo
      import Ecto
      import Ecto.Query, only: [from: 1, from: 2]

      import Golf.Router.Helpers
      import Golf.Gettext
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "web/templates"

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1, get_flash: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import Golf.Router.Helpers
      import Golf.ErrorHelpers
      import Golf.Gettext
      import Exgravatar
      import Logger

      # XXX: NEed to move these somewhere, make our own helper maybe, and
      # import it here?

      def score_class(score) when not is_nil(score) do
        case score do
          -2 -> "is-eagle"
          -1 -> "is-birdie"
          0  -> "is-par"
          1  -> "is-bogey"
          2  -> "is-double-bogey"
          _  -> "is-crap"
        end
      end
      def score_class(par, score) when not is_nil(score) do
        score_class(score - par)
      end

      def score_class(score) do "" end
      def score_class(par, score) do "" end

      def short_name(name) do
        # Get all capital letters?
        Enum.map_join(String.split(name), &String.first/1)
      end

      def gravatar(conn, email) do
        # lookup "x-forwarded-proto", and return based on that
        conn
        |> get_forwarded_proto
        |> log_proto
        |> get_gravatar(email)
      end

      defp log_proto(proto) do
        Logger.info "Proto: #{proto}"
        proto
      end

      defp get_forwarded_proto(conn) do
        Plug.Conn.get_req_header(conn, "x-forwarded-proto")
        |> List.first
      end


      defp get_gravatar(proto, email) when is_nil(proto) do
        Logger.debug "http gravatar"
        gravatar_url email, secure: false
      end

      defp get_gravatar(_proto, email) do
        gravatar_url email, secure: true
      end

      def current_user(conn) do
        Plug.Conn.get_session(conn, :current_user)
      end

      def iconic(conn, opts) do
        {size, opts} = Keyword.pop(opts, :size, "sm")
        {icon, opts} = Keyword.pop(opts, :icon)
        {state, opts} = Keyword.pop(opts, :state)
        unless icon do
          raise ArgumentError, "expected non-nil icon, got #{inspect icon}"
        end

        path = static_path(conn, "/iconic/#{icon}.svg")
        data = [src: path]
        if state do
          Keyword.put_new(data, :state, state)
        end
        tag(:img, [class: "iconic iconic-#{size}", data: data])
      end


      def render_flash(conn) do
        get_flash(conn)
        |> flash_message
      end

      defp flash_message(%{"info" => msg}) do
        body = content_tag(:div, msg, [class: "message-body"])
        content_tag(:article, body, [class: "message is-info"])
        |> container
      end

      defp flash_message(%{"error" => msg}) do
        body = content_tag(:div, msg, [class: "message-body"])
        content_tag(:article, body, [class: "message is-danger"])
        |> container
      end

      defp flash_message(_) do
        nil
      end

      defp container(body) do
        container = content_tag(:div, body, [class: "container"])
        content_tag(:section, container, [class: "section"])
      end


      def nav_item(conn, text, opts) do
        # TODO: add is-active class if we are active one, check conn perhaps?
        opts = Keyword.put_new(opts, :class, "nav-item")
        link(text, opts)
      end
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias Golf.Repo
      import Ecto
      import Ecto.Query, only: [from: 1, from: 2]
      import Golf.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
