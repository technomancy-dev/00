defmodule Phoenix00.MessagesTest do
  use Phoenix00.DataCase

  alias Phoenix00.Messages

  describe "emails" do
    alias Phoenix00.Messages.Email

    import Phoenix00.MessagesFixtures

    @invalid_attrs %{status: nil, to: nil, from: nil, aws_message_id: nil, email_id: nil}

    test "list_emails/0 returns all emails" do
      email = email_fixture()
      assert Messages.list_emails() == [email]
    end

    test "get_email!/1 returns the email with given id" do
      email = email_fixture()
      assert Messages.get_email!(email.id) == email
    end

    test "create_email/1 with valid data creates a email" do
      valid_attrs = %{status: :pending, to: "some to", from: "some from", aws_message_id: "some aws_message_id", email_id: "some email_id"}

      assert {:ok, %Email{} = email} = Messages.create_email(valid_attrs)
      assert email.status == :pending
      assert email.to == "some to"
      assert email.from == "some from"
      assert email.aws_message_id == "some aws_message_id"
      assert email.email_id == "some email_id"
    end

    test "create_email/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messages.create_email(@invalid_attrs)
    end

    test "update_email/2 with valid data updates the email" do
      email = email_fixture()
      update_attrs = %{status: :sent, to: "some updated to", from: "some updated from", aws_message_id: "some updated aws_message_id", email_id: "some updated email_id"}

      assert {:ok, %Email{} = email} = Messages.update_email(email, update_attrs)
      assert email.status == :sent
      assert email.to == "some updated to"
      assert email.from == "some updated from"
      assert email.aws_message_id == "some updated aws_message_id"
      assert email.email_id == "some updated email_id"
    end

    test "update_email/2 with invalid data returns error changeset" do
      email = email_fixture()
      assert {:error, %Ecto.Changeset{}} = Messages.update_email(email, @invalid_attrs)
      assert email == Messages.get_email!(email.id)
    end

    test "delete_email/1 deletes the email" do
      email = email_fixture()
      assert {:ok, %Email{}} = Messages.delete_email(email)
      assert_raise Ecto.NoResultsError, fn -> Messages.get_email!(email.id) end
    end

    test "change_email/1 returns a email changeset" do
      email = email_fixture()
      assert %Ecto.Changeset{} = Messages.change_email(email)
    end
  end

  describe "messages" do
    alias Phoenix00.Messages.Message

    import Phoenix00.MessagesFixtures

    @invalid_attrs %{status: nil}

    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert Messages.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert Messages.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      valid_attrs = %{status: :pending}

      assert {:ok, %Message{} = message} = Messages.create_message(valid_attrs)
      assert message.status == :pending
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messages.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      update_attrs = %{status: :sent}

      assert {:ok, %Message{} = message} = Messages.update_message(message, update_attrs)
      assert message.status == :sent
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = Messages.update_message(message, @invalid_attrs)
      assert message == Messages.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = Messages.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Messages.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Messages.change_message(message)
    end
  end
end
