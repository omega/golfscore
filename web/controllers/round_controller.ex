defmodule Golf.RoundController do
  use Golf.Web, :controller
  require Logger

  alias Golf.Round
  alias Golf.Course
  alias Golf.RoundUser
  alias Golf.User
  alias Golf.RoundHoleUserScore

  plug :scrub_params, "round" when action in [:create, :update]

  plug :assign_round when action in [:new_player, :create_player, :record_score, :save_score]
  plug :assign_hole when action in [:record_score, :save_score]

  def new(conn, params) do
    {course_id, params} = Map.pop(params, "course")
    course = Course
      |> Repo.get!(course_id)

    changeset =
      course
      |> build_assoc(:rounds)
      |> Round.changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"round" => round_params}) do
    changeset = Round.changeset(%Round{}, round_params)

    case Repo.insert(changeset) do
      {:ok, round} ->
        conn
        |> put_flash(:info, "Round created successfully.")
        |> redirect(to: round_path(conn, :show, round))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    round = Repo.get!(Round, id)
      |> Repo.preload([{:course, :holes}])
      |> Repo.preload(:players)
    scores = Repo.all(
      from rhus in RoundHoleUserScore,
      where: rhus.round_id == ^round.id,
      select: rhus
    )
    |> Repo.preload([:user, :hole, :round])
    # Need to build some sort of index here now..? need to look up by hole
    # first, and then player, so a nested structure?
    temp = Enum.group_by(scores,
     fn(rhus) -> rhus.hole.id end,
     fn(rhus) -> id = rhus.user_id; {id, rhus.score } end
    )
    sums = Enum.into(Enum.map(temp, fn {hole, scores} -> {hole, Enum.into(scores, %{})} end), %{})

    render(conn, "show.html", round: round, scores: sums)
  end

  def edit(conn, %{"id" => id}) do
    round = Repo.get!(Round, id)
    changeset = Round.changeset(round)
    render(conn, "edit.html", round: round, changeset: changeset)
  end

  def update(conn, %{"id" => id, "round" => round_params}) do
    round = Repo.get!(Round, id)
    changeset = Round.changeset(round, round_params)

    case Repo.update(changeset) do
      {:ok, round} ->
        conn
        |> put_flash(:info, "Round updated successfully.")
        |> redirect(to: round_path(conn, :show, round))
      {:error, changeset} ->
        render(conn, "edit.html", round: round, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    round = Repo.get!(Round, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(round)

    conn
    |> put_flash(:info, "Round deleted successfully.")
    |> redirect(to: round_path(conn, :index))
  end


  # XXX: RoundUser / players methods, might be better in a different controller?
  def new_player(conn, _params) do
    Logger.debug inspect(conn.assigns)
    round = conn.assigns[:round]
      |> Repo.preload(:course)
    users = Repo.all(User)
    Logger.debug inspect(round)
    changeset = round
    render(conn, "new_player.html", users: users, round: round)
  end

  def create_player(conn, params) do
    {user_id, _} = Integer.parse(params["user"])
    Repo.insert! %RoundUser{user_id: user_id, round: conn.assigns[:round]}
    conn
    |> put_flash(:info, "User #{params["user"]} added to the round")
    |> redirect(to: round_round_path(conn, :new_player, conn.assigns[:round]))
  end

  # XXX: Round Score methods! Might also be better in a different controller?

  def record_score(conn, _params) do
    # Load the hole!
    round = conn.assigns[:round]
      |> Repo.preload(:course)
      |> Repo.preload(:players)
    hole = conn.assigns[:hole]
    |> Repo.preload(:course)
    Logger.debug inspect hole
    render(conn, "score.html", hole: hole, round: round)
  end

  def save_score(conn, params) do
    scores = params["score"]

    for player_id <- Map.keys(scores) do

      Logger.debug "#{player_id}: #{ scores[player_id] }"
      {score, _} = Integer.parse(scores[player_id])
      {player_id, _} = Integer.parse(player_id)

      Repo.insert! %RoundHoleUserScore{
        user_id: player_id,
        round: conn.assigns[:round],
        hole: conn.assigns[:hole],
        score: score
      }
    end

    # XXX: Need to find NEXT HOLE, to avoid going back to the main screen?
    redirect(conn, to: round_path(conn, :show, conn.assigns[:round]))
  end

  defp assign_hole(conn, _opts) do
    case conn.params do
      %{"hole_id"  => hole_id} ->
        # XXX: Should check that the hole belongs to the course!
        case Repo.get(Golf.Hole, hole_id) do
          nil -> invalid_hole(conn)
          hole -> assign(conn, :hole, hole)
        end
      _ -> invalid_hole(conn)
    end
  end


  defp assign_round(conn, _opts) do
    case conn.params do
      %{"round_id" => round_id} ->
        case Repo.get(Golf.Round, round_id) do
          nil -> invalid_round(conn)
          round -> assign(conn, :round, round)
        end
      _ -> invalid_round(conn)
    end
  end

  defp invalid_hole(conn) do
    conn
    |> put_flash(:error, "Invalid hole!")
    |> redirect(to: round_path(conn, :show, conn.assigns[:round]))
    |> halt
  end

  defp invalid_round(conn) do
    conn
    |> put_flash(:error, "Invalid round")
    |> redirect(to: page_path(conn, :index))
    |> halt
  end
end
