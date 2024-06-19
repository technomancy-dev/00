defmodule Phoenix00.ContactsTest do
  use Phoenix00.DataCase

  alias Phoenix00.Contacts

  describe "recipients" do
    alias Phoenix00.Contacts.Recipient

    import Phoenix00.ContactsFixtures

    @invalid_attrs %{destination: nil}

    test "list_recipients/0 returns all recipients" do
      recipient = recipient_fixture()
      assert Contacts.list_recipients() == [recipient]
    end

    test "get_recipient!/1 returns the recipient with given id" do
      recipient = recipient_fixture()
      assert Contacts.get_recipient!(recipient.id) == recipient
    end

    test "create_recipient/1 with valid data creates a recipient" do
      valid_attrs = %{destination: "some destination"}

      assert {:ok, %Recipient{} = recipient} = Contacts.create_recipient(valid_attrs)
      assert recipient.destination == "some destination"
    end

    test "create_recipient/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contacts.create_recipient(@invalid_attrs)
    end

    test "update_recipient/2 with valid data updates the recipient" do
      recipient = recipient_fixture()
      update_attrs = %{destination: "some updated destination"}

      assert {:ok, %Recipient{} = recipient} = Contacts.update_recipient(recipient, update_attrs)
      assert recipient.destination == "some updated destination"
    end

    test "update_recipient/2 with invalid data returns error changeset" do
      recipient = recipient_fixture()
      assert {:error, %Ecto.Changeset{}} = Contacts.update_recipient(recipient, @invalid_attrs)
      assert recipient == Contacts.get_recipient!(recipient.id)
    end

    test "delete_recipient/1 deletes the recipient" do
      recipient = recipient_fixture()
      assert {:ok, %Recipient{}} = Contacts.delete_recipient(recipient)
      assert_raise Ecto.NoResultsError, fn -> Contacts.get_recipient!(recipient.id) end
    end

    test "change_recipient/1 returns a recipient changeset" do
      recipient = recipient_fixture()
      assert %Ecto.Changeset{} = Contacts.change_recipient(recipient)
    end
  end
end
