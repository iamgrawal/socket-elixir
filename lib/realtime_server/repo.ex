defmodule RealtimeServer.Repo do
  use Ecto.Repo,
    otp_app: :realtime_server,
    adapter: Ecto.Adapters.MyXQL

  @doc """
  Dynamically chooses which database connection to use.
  Uses primary for writes and randomly selects a replica for reads.
  """
  def choose_connection(operation) do
    case operation do
      :write ->
        :primary
      :read ->
        case get_replicas() do
          [] ->
            :primary
          replicas ->
            Enum.random(replicas)
        end
    end
  end

  @doc """
  Gets a list of available read replicas
  """
  def get_replicas do
    Application.get_env(:realtime_server, __MODULE__)[:replicas] || []
  end

  @doc """
  Override for read operations to use replicas
  """
  def all(queryable, opts \\ []) do
    super(queryable, Keyword.put(opts, :connection, choose_connection(:read)))
  end

  def get(queryable, id, opts \\ []) do
    super(queryable, id, Keyword.put(opts, :connection, choose_connection(:read)))
  end

  def get_by(queryable, clauses, opts \\ []) do
    super(queryable, clauses, Keyword.put(opts, :connection, choose_connection(:read)))
  end

  @doc """
  Override for write operations to always use primary
  """
  def insert(struct, opts \\ []) do
    super(struct, Keyword.put(opts, :connection, :primary))
  end

  def update(struct, opts \\ []) do
    super(struct, Keyword.put(opts, :connection, :primary))
  end

  def delete(struct, opts \\ []) do
    super(struct, Keyword.put(opts, :connection, :primary))
  end
end
