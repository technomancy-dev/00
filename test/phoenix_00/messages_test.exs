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
end
