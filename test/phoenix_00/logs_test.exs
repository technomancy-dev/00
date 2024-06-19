defmodule Phoenix00.LogsTest do
  use Phoenix00.DataCase

  alias Phoenix00.Logs

  describe "logs" do
    alias Phoenix00.Logs.Log

    import Phoenix00.LogsFixtures

    @invalid_attrs %{status: nil, request: nil, response: nil, endpoint: nil, method: nil, ke_name: nil}

    test "list_logs/0 returns all logs" do
      log = log_fixture()
      assert Logs.list_logs() == [log]
    end

    test "get_log!/1 returns the log with given id" do
      log = log_fixture()
      assert Logs.get_log!(log.id) == log
    end

    test "create_log/1 with valid data creates a log" do
      valid_attrs = %{status: 42, request: %{}, response: %{}, endpoint: "some endpoint", method: :get, ke_name: "some ke_name"}

      assert {:ok, %Log{} = log} = Logs.create_log(valid_attrs)
      assert log.status == 42
      assert log.request == %{}
      assert log.response == %{}
      assert log.endpoint == "some endpoint"
      assert log.method == :get
      assert log.ke_name == "some ke_name"
    end

    test "create_log/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Logs.create_log(@invalid_attrs)
    end

    test "update_log/2 with valid data updates the log" do
      log = log_fixture()
      update_attrs = %{status: 43, request: %{}, response: %{}, endpoint: "some updated endpoint", method: :head, ke_name: "some updated ke_name"}

      assert {:ok, %Log{} = log} = Logs.update_log(log, update_attrs)
      assert log.status == 43
      assert log.request == %{}
      assert log.response == %{}
      assert log.endpoint == "some updated endpoint"
      assert log.method == :head
      assert log.ke_name == "some updated ke_name"
    end

    test "update_log/2 with invalid data returns error changeset" do
      log = log_fixture()
      assert {:error, %Ecto.Changeset{}} = Logs.update_log(log, @invalid_attrs)
      assert log == Logs.get_log!(log.id)
    end

    test "delete_log/1 deletes the log" do
      log = log_fixture()
      assert {:ok, %Log{}} = Logs.delete_log(log)
      assert_raise Ecto.NoResultsError, fn -> Logs.get_log!(log.id) end
    end

    test "change_log/1 returns a log changeset" do
      log = log_fixture()
      assert %Ecto.Changeset{} = Logs.change_log(log)
    end
  end
end
